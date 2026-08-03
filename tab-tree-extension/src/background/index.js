/**
 * Service Worker - Tab Tree Extension
 * Handles tab tracking, hierarchy, and locking
 */

import * as TabManager from './tab-manager.js';
import * as storage from '../shared/storage.js';
import { MSG_TYPES } from '../shared/constants.js';

// Initialize managers when service worker starts
chrome.runtime.onInstalled.addListener(async () => {
  await TabManager.initialize();
});

// Also initialize on service worker startup (in case it was running before)
// Use a small delay to ensure Chrome has registered listeners
setTimeout(async () => {
  // Always initialize to register event listeners
  // The initialize function has guards against duplicate initialization
  await TabManager.initialize();
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
          }
        } catch (error) {
          // Tab might have been closed, ignore
        }
      }
    }
  } catch (error) {
    // Auto-unload check failed, will retry on next alarm
  }
}

/**
 * Handle extension icon click - open side panel
 */
chrome.action.onClicked.addListener(async (tab) => {
  try {
    await chrome.sidePanel.open({ tabId: tab.id });
  } catch (error) {
    // Side panel opening failed
  }
});

/**
 * Handle keyboard commands
 */
chrome.commands.onCommand.addListener(async (command) => {
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

      case 'next-tab':
        await TabManager.navigateNext();
        break;

      case 'prev-tab':
        await TabManager.navigatePrev();
        break;
    }
  } catch (error) {
    // Command handling failed
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
    try {
      await TabManager.lockTab(tab.id);
    } catch (error) {
      // Lock failed
    }
  } else if (info.menuItemId === 'unlock-current-tab') {
    try {
      await TabManager.unlockTab(tab.id);
    } catch (error) {
      // Unlock failed
    }
  }
});

/**
 * Listen for messages from side panel
 */
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
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

      case MSG_TYPES.RECREATE_TAB: {
        const { oldId, newId } = message.payload;
        await TabManager.recreateTab(oldId, newId);
        const state = await storage.getState();
        sendResponse({ success: true, state });
        break;
      }

      case MSG_TYPES.REVERT_LOCKED_TAB: {
        const { tabId, url } = message.payload;
        await chrome.tabs.update(tabId, { url });
        sendResponse({ success: true });
        break;
      }

      default:
        sendResponse({ success: false, error: 'Unknown message type' });
    }
  } catch (error) {
    sendResponse({ success: false, error: error.message });
  }
}
