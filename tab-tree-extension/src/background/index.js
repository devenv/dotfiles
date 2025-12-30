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
