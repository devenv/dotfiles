/**
 * Storage Helpers - Persistent State Management
 * Wraps chrome.storage.local with useful utilities
 */

import { STORAGE_KEYS, DEFAULT_STATE } from './constants.js';

/**
 * Get the full application state
 * @returns {Promise<AppState>} - Complete app state
 */
export async function getState() {
  return new Promise((resolve) => {
    chrome.storage.local.get(
      [STORAGE_KEYS.TABS, STORAGE_KEYS.ORDER, STORAGE_KEYS.COLLAPSED, STORAGE_KEYS.SETTINGS],
      (data) => {
        resolve({
          tabs: data[STORAGE_KEYS.TABS] || DEFAULT_STATE.tabs,
          order: data[STORAGE_KEYS.ORDER] || DEFAULT_STATE.order,
          collapsed: data[STORAGE_KEYS.COLLAPSED] || DEFAULT_STATE.collapsed,
          settings: data[STORAGE_KEYS.SETTINGS] || DEFAULT_STATE.settings,
        });
      }
    );
  });
}

/**
 * Save the full application state
 * @param {AppState} state - Complete app state
 * @returns {Promise<void>}
 */
export async function setState(state) {
  return new Promise((resolve) => {
    chrome.storage.local.set(
      {
        [STORAGE_KEYS.TABS]: state.tabs,
        [STORAGE_KEYS.ORDER]: state.order,
        [STORAGE_KEYS.COLLAPSED]: state.collapsed,
        [STORAGE_KEYS.SETTINGS]: state.settings,
      },
      resolve
    );
  });
}

/**
 * Get a specific tab node
 * @param {number} tabId - Tab ID
 * @returns {Promise<TabNode|null>} - Tab node or null if not found
 */
export async function getTab(tabId) {
  const state = await getState();
  return state.tabs[tabId] || null;
}

/**
 * Add or update a tab node
 * @param {TabNode} node - Tab node to save
 * @returns {Promise<void>}
 */
export async function setTab(node) {
  const state = await getState();
  state.tabs[node.id] = node;
  await setState(state);
}

/**
 * Remove a tab node
 * @param {number} tabId - Tab ID to remove
 * @returns {Promise<void>}
 */
export async function removeTab(tabId) {
  const state = await getState();
  delete state.tabs[tabId];

  // Remove from order arrays
  for (const key in state.order) {
    state.order[key] = state.order[key].filter((id) => id !== tabId);
    // Remove empty parent entries (except 'root')
    if (key !== 'root' && state.order[key].length === 0) {
      delete state.order[key];
    }
  }

  // Remove from collapsed state
  delete state.collapsed[tabId];

  await setState(state);
}

/**
 * Get the order of tabs at a specific level
 * @param {string|number} parentId - Parent ID (use 'root' for root level)
 * @returns {Promise<number[]>} - Array of tab IDs in order
 */
export async function getOrder(parentId = 'root') {
  const state = await getState();
  return state.order[parentId] || [];
}

/**
 * Set the order of tabs at a specific level
 * @param {string|number} parentId - Parent ID
 * @param {number[]} tabIds - Array of tab IDs
 * @returns {Promise<void>}
 */
export async function setOrder(parentId, tabIds) {
  const state = await getState();
  if (tabIds.length === 0) {
    delete state.order[parentId];
  } else {
    state.order[parentId] = tabIds;
  }
  await setState(state);
}

/**
 * Get children of a parent tab
 * @param {number} parentId - Parent tab ID
 * @returns {Promise<TabNode[]>} - Array of child tab nodes
 */
export async function getChildren(parentId) {
  const state = await getState();
  const childIds = state.order[parentId] || [];
  return childIds
    .map((id) => state.tabs[id])
    .filter((tab) => tab !== undefined);
}

/**
 * Check if a tab is collapsed
 * @param {number} tabId - Tab ID
 * @returns {Promise<boolean>} - True if collapsed
 */
export async function isCollapsed(tabId) {
  const state = await getState();
  return state.collapsed[tabId] || false;
}

/**
 * Set collapse state of a tab
 * @param {number} tabId - Tab ID
 * @param {boolean} collapsed - Collapse state
 * @returns {Promise<void>}
 */
export async function setCollapsed(tabId, collapsed) {
  const state = await getState();
  if (collapsed) {
    state.collapsed[tabId] = true;
  } else {
    delete state.collapsed[tabId];
  }
  await setState(state);
}

/**
 * Get a specific setting value
 * @param {string} key - Setting key
 * @returns {Promise<any>} - Setting value
 */
export async function getSetting(key) {
  const state = await getState();
  return state.settings[key];
}

/**
 * Set a specific setting value
 * @param {string} key - Setting key
 * @param {any} value - Setting value
 * @returns {Promise<void>}
 */
export async function setSetting(key, value) {
  const state = await getState();
  state.settings[key] = value;
  await setState(state);
}
