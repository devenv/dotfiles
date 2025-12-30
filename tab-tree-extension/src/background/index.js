/**
 * Service Worker - Tab Tree Extension
 * Handles tab tracking, hierarchy, and locking
 */

import * as TabManager from './tab-manager.js';
import * as storage from '../shared/storage.js';
import { MSG_TYPES } from '../shared/constants.js';

console.log('Service Worker loaded');

// Initialize managers when service worker starts
chrome.runtime.onInstalled.addListener(async () => {
  console.log('Extension installed/updated');
  await TabManager.initialize();

  // Open sidebar on install
  try {
    const tabs = await chrome.tabs.query({ active: true, currentWindow: true });
    if (tabs[0]) {
      await chrome.sidePanel.open({ tabId: tabs[0].id });
    }
  } catch (error) {
    console.error('Failed to open sidebar on install:', error);
  }
});

// Also initialize on service worker startup (in case it was running before)
// Use a small delay to ensure Chrome has registered listeners
setTimeout(async () => {
  const state = await storage.getState();
  if (Object.keys(state.tabs).length === 0) {
    console.log('Service Worker: Cold start, initializing Tab Manager');
    await TabManager.initialize();
  } else {
    console.log('Service Worker: Warm start, resuming Tab Manager');
  }
}, 100);

// Set up auto-unload alarm (runs every minute)
chrome.alarms.create('auto-unload-check', { periodInMinutes: 1 });

chrome.alarms.onAlarm.addListener(async (alarm) => {
  if (alarm.name === 'auto-unload-check') {
    await checkAndUnloadTabs();
  }
});

/**
 * Check tabs and unload inactive ones based on threshold
 */
async function checkAndUnloadTabs() {
  try {
    const state = await storage.getState();
    const threshold = state.settings.autoUnloadThreshold || 0;

    // If threshold is 0 (Never), skip
    if (threshold === 0) return;

    const now = Date.now();
    const thresholdMs = threshold * 60 * 1000; // Convert minutes to milliseconds

    const allTabs = await chrome.tabs.query({});
    const activeTabs = allTabs.filter(t => t.active);
    const activeTabIds = new Set(activeTabs.map(t => t.id));

    for (const tabId in state.tabs) {
      const node = state.tabs[tabId];

      // Skip active tabs, locked tabs, and pinned tabs
      if (activeTabIds.has(node.id) || node.isLocked || node.isPinned) {
        continue;
      }

      // Check if tab hasn't been visited within threshold
      const timeSinceVisit = now - (node.lastVisited || node.createdAt);

      if (timeSinceVisit > thresholdMs) {
        try {
          // Check if tab is already discarded
          const chromeTab = await chrome.tabs.get(node.id);
          if (!chromeTab.discarded) {
            await chrome.tabs.discard(node.id);
            console.log(`Auto-unload: Discarded tab ${node.id} (inactive for ${Math.round(timeSinceVisit / 60000)} minutes)`);
          }
        } catch (error) {
          // Tab might have been closed, ignore
        }
      }
    }
  } catch (error) {
    console.error('Auto-unload check failed:', error);
  }
}

/**
 * Handle extension icon click - open side panel
 */
chrome.action.onClicked.addListener(async (tab) => {
  console.log('Extension icon clicked, opening side panel');
  try {
    await chrome.sidePanel.open({ tabId: tab.id });
  } catch (error) {
    console.error('Error opening side panel:', error);
  }
});

/**
 * Handle keyboard commands
 */
chrome.commands.onCommand.addListener(async (command) => {
  console.log('Command received:', command);

  try {
    const tabs = await chrome.tabs.query({ active: true, currentWindow: true });
    if (tabs.length === 0) return;

    const tabId = tabs[0].id;
    const state = await storage.getState();
    const node = state.tabs[tabId];

    switch (command) {
      case 'lock-tab':
        if (node && node.isLocked) {
          await TabManager.unlockTab(tabId);
        } else if (node) {
          await TabManager.lockTab(tabId);
        }
        break;

      case 'pin-tab':
        if (node && node.isPinned) {
          await TabManager.unpinTab(tabId);
        } else if (node) {
          await TabManager.pinTab(tabId);
        }
        break;

      case 'close-or-discard-tab':
        if (node) {
          await TabManager.closeTab(tabId);
        }
        break;
    }
  } catch (error) {
    console.error('Error handling command:', error);
  }
});

/**
 * Create context menu for tab operations
 */
chrome.runtime.onInstalled.addListener(() => {
  // Remove existing menus if any
  chrome.contextMenus.removeAll(() => {
    // Create context menu for page/link/selection
    chrome.contextMenus.create({
      id: 'lock-current-tab',
      title: 'Lock this tab',
      contexts: ['page', 'selection', 'link'],
    });

    chrome.contextMenus.create({
      id: 'unlock-current-tab',
      title: 'Unlock this tab',
      contexts: ['page', 'selection', 'link'],
    });
  });
});

/**
 * Handle context menu clicks
 */
chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  if (info.menuItemId === 'lock-current-tab') {
    console.log('Locking tab', tab.id);
    try {
      await TabManager.lockTab(tab.id);
    } catch (error) {
      console.error('Error locking tab:', error);
    }
  } else if (info.menuItemId === 'unlock-current-tab') {
    console.log('Unlocking tab', tab.id);
    try {
      await TabManager.unlockTab(tab.id);
    } catch (error) {
      console.error('Error unlocking tab:', error);
    }
  }
});

/**
 * Listen for messages from side panel
 */
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  console.log('Service Worker received:', message.type);

  handleMessage(message, sender, sendResponse);
  return true; // Keep channel open for async response
});

/**
 * Handle incoming messages
 * @param {Object} message - Message from side panel
 * @param {Object} sender - Message sender info
 * @param {Function} sendResponse - Callback to send response
 */
async function handleMessage(message, sender, sendResponse) {
  try {
    switch (message.type) {
      case MSG_TYPES.GET_STATE: {
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.SET_PARENT: {
        const { childId, parentId } = message.payload;
        await TabManager.setParent(childId, parentId);
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.REMOVE_PARENT: {
        const { tabId } = message.payload;
        await TabManager.removeParent(tabId);
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.TOGGLE_COLLAPSE: {
        const { tabId } = message.payload;
        const isCurrentlyCollapsed = await storage.isCollapsed(tabId);
        await storage.setCollapsed(tabId, !isCurrentlyCollapsed);
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.MOVE_TAB: {
        const { tabId, newParentId, newIndex } = message.payload;
        await TabManager.moveTab(tabId, newParentId, newIndex);
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.LOCK_TAB: {
        const { tabId } = message.payload;
        await TabManager.lockTab(tabId);
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.UNLOCK_TAB: {
        const { tabId } = message.payload;
        await TabManager.unlockTab(tabId);
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.COLLAPSE_ALL: {
        await TabManager.collapseAll();
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.EXPAND_ALL: {
        await TabManager.expandAll();
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.PIN_TAB: {
        const { tabId } = message.payload;
        await TabManager.pinTab(tabId);
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.UNPIN_TAB: {
        const { tabId } = message.payload;
        await TabManager.unpinTab(tabId);
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.SET_AUTO_UNLOAD: {
        const { threshold } = message.payload;
        await storage.setSetting('autoUnloadThreshold', threshold);
        sendResponse({ success: true });
        break;
      }

      case MSG_TYPES.CLOSE_TAB: {
        const { tabId } = message.payload;
        await TabManager.closeTab(tabId);
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      default:
        sendResponse({ success: false, error: 'Unknown message type' });
    }
  } catch (error) {
    console.error('Error handling message:', error);
    sendResponse({ success: false, error: error.message });
  }
}
