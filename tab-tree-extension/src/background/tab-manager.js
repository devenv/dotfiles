/**
 * Tab Manager - Core Hierarchy Tracking Logic
 * Listens to Chrome tab events and maintains parent-child relationships
 */

import * as storage from '../shared/storage.js';
import { MSG_TYPES, SETTINGS } from '../shared/constants.js';

// Track initialization to prevent duplicate listeners
let isInitialized = false;

/**
 * Initialize tab manager
 * Set up Chrome event listeners
 * @returns {Promise<void>}
 */
export async function initialize() {
  if (isInitialized) {
    console.log('Tab Manager: Already initialized, skipping');
    return;
  }

  console.log('Tab Manager: Initializing');

  // Load all existing tabs and build initial hierarchy
  await loadAllTabs();

  // Listen for new tab creation
  chrome.tabs.onCreated.addListener(handleTabCreated);

  // Listen for tab removal (and prevent closing locked tabs)
  chrome.tabs.onRemoved.addListener(handleTabRemoved);

  // Listen for tab updates (title, favicon)
  chrome.tabs.onUpdated.addListener(handleTabUpdated);

  // Listen for tab activation to update lastVisited
  chrome.tabs.onActivated.addListener(handleTabActivated);

  isInitialized = true;
  console.log('Tab Manager: Ready');
}

/**
 * Load all currently open tabs into hierarchy
 * Called on startup to populate storage
 * @returns {Promise<void>}
 */
async function loadAllTabs() {
  const allTabs = await chrome.tabs.query({});
  console.log(`Tab Manager: Found ${allTabs.length} open tabs`);

  const state = await storage.getState();

  // Clean up state: remove tabs that no longer exist in Chrome
  const chromeTabIds = new Set(allTabs.map(t => t.id));
  const stateTabIds = Object.keys(state.tabs).map(Number);

  for (const tabId of stateTabIds) {
    if (!chromeTabIds.has(tabId)) {
      console.log(`Tab Manager: Cleaning up orphaned tab ${tabId}`);
      delete state.tabs[tabId];

      // Remove from order arrays
      for (const key in state.order) {
        state.order[key] = state.order[key].filter(id => id !== tabId);
      }
    }
  }

  // Deduplicate order arrays
  for (const key in state.order) {
    state.order[key] = [...new Set(state.order[key])];
  }

  for (const chromeTab of allTabs) {
    const existingNode = state.tabs[chromeTab.id];

    if (existingNode) {
      // Tab is tracked, but ensure it's in order arrays
      const parentKey = existingNode.parentId || 'root';
      if (!state.order[parentKey]) {
        state.order[parentKey] = [];
      }

      if (!state.order[parentKey].includes(chromeTab.id)) {
        console.log(`Tab Manager: Tab ${chromeTab.id} was tracked but not in order, adding`);
        state.order[parentKey].push(chromeTab.id);
      }

      // Update tab properties in case they changed
      existingNode.title = chromeTab.title || existingNode.title;
      existingNode.url = chromeTab.url || existingNode.url;
      existingNode.favicon = chromeTab.favIconUrl || existingNode.favicon;
      existingNode.windowId = chromeTab.windowId;

      continue;
    }

    // Determine parent from openerTabId
    let parentId = null;
    if (chromeTab.openerTabId && state.tabs[chromeTab.openerTabId]) {
      parentId = chromeTab.openerTabId;
    }

    // Create tab node
    const node = createTabNode(chromeTab, parentId);
    state.tabs[node.id] = node;

    // Add to order
    const parentKey = parentId || 'root';
    if (!state.order[parentKey]) {
      state.order[parentKey] = [];
    }

    // Check if already in order (prevent duplicates)
    if (!state.order[parentKey].includes(node.id)) {
      state.order[parentKey].push(node.id);
    }

    console.log(`Tab Manager: Added new tab ${chromeTab.id} - ${chromeTab.title}`);
  }

  await storage.setState(state);
}

/**
 * Handle new tab creation
 * Establish parent-child relationship via openerTabId
 * @param {Tab} chromeTab - Chrome tab object
 * @returns {Promise<void>}
 */
async function handleTabCreated(chromeTab) {
  console.log(`Tab Manager: Tab created ${chromeTab.id}`, chromeTab.title);

  const state = await storage.getState();

  // Skip if tab already exists (prevent duplicates)
  if (state.tabs[chromeTab.id]) {
    console.log(`Tab Manager: Tab ${chromeTab.id} already exists, skipping creation`);
    return;
  }

  // Determine parent from openerTabId
  let parentId = null;
  if (chromeTab.openerTabId && SETTINGS.enableAutoNesting) {
    if (state.tabs[chromeTab.openerTabId]) {
      parentId = chromeTab.openerTabId;
      console.log(
        `Tab Manager: Auto-nesting tab ${chromeTab.id} under ${parentId}`
      );
    }
  }

  // Create tab node
  const node = createTabNode(chromeTab, parentId);
  state.tabs[node.id] = node;

  // Add to order
  const parentKey = parentId || 'root';
  if (!state.order[parentKey]) {
    state.order[parentKey] = [];
  }
  state.order[parentKey].push(node.id);

  await storage.setState(state);

  // Notify UI of new tab
  broadcastMessage({
    type: MSG_TYPES.TAB_CREATED,
    payload: node,
  });
}

/**
 * Handle tab removal
 * Clean up from hierarchy
 * @param {number} tabId - Removed tab ID
 * @returns {Promise<void>}
 */
async function handleTabRemoved(tabId, removeInfo) {
  console.log(`Tab Manager: Tab removed ${tabId}`, removeInfo);

  const state = await storage.getState();
  const node = state.tabs[tabId];

  if (!node) {
    console.log(`Tab Manager: Tab ${tabId} not in hierarchy`);
    return;
  }

  // Note: Locked tabs can be closed via keyboard/context menu
  // We don't recreate them - the close button in UI is already disabled
  if (node.isLocked) {
    console.log(`Tab Manager: Locked tab ${tabId} was closed (ignoring lock)`);
  }

  // Get children before deletion
  const childIds = state.order[tabId] || [];

  // Strategy: Move children to root level (flatten)
  // Alternative: Move to parent level (preserve nesting)
  for (const childId of childIds) {
    const child = state.tabs[childId];
    if (child) {
      child.parentId = null; // Promote to root
      state.tabs[childId] = child;
    }
  }

  // Add children to root order
  if (childIds.length > 0) {
    if (!state.order.root) {
      state.order.root = [];
    }
    state.order.root.push(...childIds);
  }

  // Remove from order
  const parentKey = node.parentId || 'root';
  if (state.order[parentKey]) {
    state.order[parentKey] = state.order[parentKey].filter((id) => id !== tabId);
  }

  // Remove tab node and its children order
  delete state.tabs[tabId];
  delete state.order[tabId];
  delete state.collapsed[tabId];

  await storage.setState(state);

  // Notify UI
  broadcastMessage({
    type: MSG_TYPES.TAB_REMOVED,
    payload: { tabId, orphanedChildren: childIds },
  });
}

/**
 * Handle tab update (title, favicon, URL)
 * @param {number} tabId - Updated tab ID
 * @param {Object} changeInfo - What changed
 * @param {Tab} chromeTab - Full tab object
 * @returns {Promise<void>}
 */
async function handleTabUpdated(tabId, changeInfo, chromeTab) {
  // Only log on meaningful changes
  if (!changeInfo.title && !changeInfo.favIconUrl && !changeInfo.status) {
    return;
  }

  console.log(`Tab Manager: Tab updated ${tabId}`, {
    title: changeInfo.title,
    favicon: changeInfo.favIconUrl,
    status: changeInfo.status,
  });

  const state = await storage.getState();
  const node = state.tabs[tabId];

  if (!node) {
    console.log(`Tab Manager: Tab ${tabId} not in hierarchy, creating...`);
    // Might be a tab opened before extension loaded
    // Add it now
    const parentId = chromeTab.openerTabId || null;
    const newNode = createTabNode(chromeTab, parentId);
    state.tabs[newNode.id] = newNode;

    const parentKey = parentId || 'root';
    if (!state.order[parentKey]) {
      state.order[parentKey] = [];
    }
    state.order[parentKey].push(newNode.id);

    await storage.setState(state);
    return;
  }

  // Check if tab is locked and URL changed
  if (node.isLocked && changeInfo.url && changeInfo.url !== node.lockUrl) {
    console.log(
      `Tab Manager: Locked tab ${tabId} navigated away. Reverting to ${node.lockUrl}`
    );
    // Revert locked tab back to its original URL
    await chrome.tabs.update(tabId, { url: node.lockUrl });
    // Don't update the stored URL - it stays locked to the original
    state.tabs[tabId] = node;
    await storage.setState(state);
    return; // Exit early, don't process further
  }

  // Update tab properties (only if not locked or URL didn't change)
  let updated = false;

  if (changeInfo.title && chromeTab.title) {
    node.title = chromeTab.title;
    updated = true;
  }
  if (changeInfo.favIconUrl) {
    node.favicon = chromeTab.favIconUrl || '';
    updated = true;
  }
  if (changeInfo.url && !node.isLocked) {
    // Only update URL if tab is not locked
    node.url = chromeTab.url;
    updated = true;
  }

  if (updated) {
    state.tabs[tabId] = node;
    await storage.setState(state);

    // Notify UI of update
    broadcastMessage({
      type: MSG_TYPES.TAB_UPDATED,
      payload: node,
    });
  }
}

/**
 * Handle tab activation (user switches to tab)
 * Updates lastVisited timestamp
 * @param {Object} activeInfo - { tabId, windowId }
 * @returns {Promise<void>}
 */
async function handleTabActivated(activeInfo) {
  const { tabId } = activeInfo;
  console.log(`Tab Manager: Tab activated ${tabId}`);

  const state = await storage.getState();
  const node = state.tabs[tabId];

  if (!node) {
    console.log(`Tab Manager: Activated tab ${tabId} not in hierarchy`);
    return;
  }

  // Update lastVisited timestamp
  node.lastVisited = Date.now();
  state.tabs[tabId] = node;

  await storage.setState(state);
}

/**
 * Create a new TabNode from Chrome tab
 * @param {Tab} chromeTab - Chrome tab object
 * @param {number|null} parentId - Parent tab ID
 * @returns {TabNode} - Created node
 */
function createTabNode(chromeTab, parentId = null) {
  return {
    id: chromeTab.id,
    parentId,
    url: chromeTab.url || chromeTab.pendingUrl || '',
    title: chromeTab.title || 'Loading...',
    favicon: chromeTab.favIconUrl || '',
    isLocked: false,
    isPinned: false,
    lockUrl: null,
    isCollapsed: false,
    createdAt: Date.now(),
    lastVisited: Date.now(),
    windowId: chromeTab.windowId,
  };
}

/**
 * Check if a tab has a given ancestor (for cycle detection)
 * @param {number} tabId - Tab to check
 * @param {number} potentialAncestorId - Potential ancestor
 * @param {Object} state - Current state
 * @returns {boolean} - True if potentialAncestorId is an ancestor of tabId
 */
function hasAncestor(tabId, potentialAncestorId, state) {
  let current = state.tabs[tabId];
  const visited = new Set();

  while (current && current.parentId !== null) {
    // Prevent infinite loops from corrupted state
    if (visited.has(current.id)) {
      console.warn(`Tab Manager: Detected existing cycle at tab ${current.id}`);
      return true;
    }
    visited.add(current.id);

    if (current.parentId === potentialAncestorId) {
      return true;
    }
    current = state.tabs[current.parentId];
  }
  return false;
}

/**
 * Set a tab as the child of another tab
 * @param {number} childId - Tab to become child
 * @param {number} parentId - Tab to become parent
 * @returns {Promise<void>}
 */
export async function setParent(childId, parentId) {
  console.log(`Tab Manager: Setting tab ${childId} as child of ${parentId}`);

  const state = await storage.getState();
  const child = state.tabs[childId];
  const parent = state.tabs[parentId];

  if (!child || !parent) {
    throw new Error('Child or parent tab not found');
  }

  // Cycle detection: Prevent A becoming child of B if B is already descendant of A
  if (hasAncestor(parentId, childId, state)) {
    console.warn(`Tab Manager: Rejected cycle - ${parentId} is descendant of ${childId}`);
    throw new Error('Cannot create circular hierarchy');
  }

  // Check max hierarchy level
  if (parent.parentId !== null && SETTINGS.maxHierarchyLevel <= 1) {
    throw new Error('Cannot nest more than 1 level');
  }

  // Remove from old parent
  const oldParentKey = child.parentId || 'root';
  if (state.order[oldParentKey]) {
    state.order[oldParentKey] = state.order[oldParentKey].filter(
      (id) => id !== childId
    );
  }

  // Update child
  child.parentId = parentId;
  state.tabs[childId] = child;

  // Add to new parent
  const newParentKey = parentId;
  if (!state.order[newParentKey]) {
    state.order[newParentKey] = [];
  }
  state.order[newParentKey].push(childId);

  await storage.setState(state);

  broadcastMessage({
    type: MSG_TYPES.STATE_CHANGED,
    payload: state,
  });
}

/**
 * Remove parent from a tab (make it root level)
 * @param {number} tabId - Tab ID
 * @returns {Promise<void>}
 */
export async function removeParent(tabId) {
  console.log(`Tab Manager: Removing parent from tab ${tabId}`);

  const state = await storage.getState();
  const node = state.tabs[tabId];

  if (!node || node.parentId === null) {
    return; // Already at root or doesn't exist
  }

  // Remove from old parent
  const oldParentKey = node.parentId;
  if (state.order[oldParentKey]) {
    state.order[oldParentKey] = state.order[oldParentKey].filter(
      (id) => id !== tabId
    );
  }

  // Make root
  node.parentId = null;
  state.tabs[tabId] = node;

  // Add to root
  if (!state.order.root) {
    state.order.root = [];
  }
  state.order.root.push(tabId);

  await storage.setState(state);

  broadcastMessage({
    type: MSG_TYPES.STATE_CHANGED,
    payload: state,
  });
}

/**
 * Move a tab via drag-drop
 * Reorders tabs in their parent's child list
 * @param {number} tabId - Tab being moved
 * @param {string|number} newParentId - New parent ('root' or tab ID)
 * @param {number} newIndex - New position in flattened list (for future use)
 * @returns {Promise<void>}
 */
export async function moveTab(tabId, newParentId, newIndex) {
  console.log(`Tab Manager: Moving tab ${tabId} to parent ${newParentId} at index ${newIndex}`);

  const state = await storage.getState();
  const node = state.tabs[tabId];

  if (!node) {
    throw new Error('Tab not found');
  }

  // Remove from old parent
  const oldParentKey = node.parentId || 'root';
  if (state.order[oldParentKey]) {
    state.order[oldParentKey] = state.order[oldParentKey].filter(
      (id) => id !== tabId
    );
  }

  // Add to new parent at the correct position
  const newParentKey = newParentId || 'root';
  if (!state.order[newParentKey]) {
    state.order[newParentKey] = [];
  }

  // Calculate insertion position within parent's children
  // newIndex is the visual position in the flattened tree
  // We need to find the position within the parent's children array
  const flattenedBefore = flattenTreeForReorder(state);
  const visualPosition = flattenedBefore.findIndex(item => item.id === tabId);

  // Insert at the end of parent's children for now
  // TODO: Calculate proper position based on newIndex
  state.order[newParentKey].push(tabId);

  // Update node parent reference
  node.parentId = newParentId === 'root' ? null : newParentId;
  state.tabs[tabId] = node;

  // Calculate Chrome tab index and reorder physical tabs
  const flattenedAfter = flattenTreeForReorder(state);
  const chromeTabIndex = flattenedAfter.findIndex(item => item.id === tabId);

  if (chromeTabIndex >= 0) {
    try {
      await chrome.tabs.move(tabId, { index: chromeTabIndex });
      console.log(`Tab Manager: Moved Chrome tab ${tabId} to index ${chromeTabIndex}`);
    } catch (error) {
      console.error(`Tab Manager: Failed to move Chrome tab ${tabId}:`, error);
    }
  }

  await storage.setState(state);

  broadcastMessage({
    type: MSG_TYPES.STATE_CHANGED,
    payload: state,
  });
}

/**
 * Flatten tree structure to calculate Chrome tab indices
 * @param {Object} state - Current state
 * @returns {Array} - Flattened array of {id, level}
 */
function flattenTreeForReorder(state) {
  const result = [];

  function traverse(parentKey, level = 0) {
    const tabIds = state.order[parentKey] || [];

    for (const tabId of tabIds) {
      const node = state.tabs[tabId];
      if (!node) continue;

      result.push({ id: tabId, level });

      // Always traverse children for reordering (ignore collapse state)
      traverse(tabId, level + 1);
    }
  }

  traverse('root', 0);
  return result;
}

/**
 * Lock a tab - prevents closing and remembers original URL
 * @param {number} tabId - Tab to lock
 * @returns {Promise<void>}
 */
export async function lockTab(tabId) {
  console.log(`Tab Manager: Locking tab ${tabId}`);

  const state = await storage.getState();
  const node = state.tabs[tabId];

  if (!node) {
    throw new Error('Tab not found');
  }

  // Get current tab from Chrome to save its URL
  const chromeTab = (await chrome.tabs.query({})).find(t => t.id === tabId);
  if (!chromeTab) {
    throw new Error('Chrome tab not found');
  }

  // Save current URL as the lock URL
  node.isLocked = true;
  node.lockUrl = chromeTab.url;
  state.tabs[tabId] = node;

  await storage.setState(state);

  broadcastMessage({
    type: MSG_TYPES.STATE_CHANGED,
    payload: state,
  });
}

/**
 * Unlock a tab - allows closing and clears lock URL
 * @param {number} tabId - Tab to unlock
 * @returns {Promise<void>}
 */
export async function unlockTab(tabId) {
  console.log(`Tab Manager: Unlocking tab ${tabId}`);

  const state = await storage.getState();
  const node = state.tabs[tabId];

  if (!node) {
    throw new Error('Tab not found');
  }

  node.isLocked = false;
  node.lockUrl = null;
  state.tabs[tabId] = node;

  await storage.setState(state);

  broadcastMessage({
    type: MSG_TYPES.STATE_CHANGED,
    payload: state,
  });
}

/**
 * Close a tab
 * @param {number} tabId - Tab to close
 * @returns {Promise<void>}
 */
export async function closeTab(tabId) {
  console.log(`Tab Manager: Closing tab ${tabId}`);

  const state = await storage.getState();
  const node = state.tabs[tabId];

  // Don't allow closing locked tabs - just log and return silently
  if (node && node.isLocked) {
    console.log(`Tab Manager: Cannot close locked tab ${tabId} (locked)`);
    return; // Silent return, not an error
  }

  // Close the actual Chrome tab
  await chrome.tabs.remove(tabId);
  // handleTabRemoved will clean up the state
}

/**
 * Pin a tab - locks it and makes it high priority
 * @param {number} tabId - Tab to pin
 * @returns {Promise<void>}
 */
export async function pinTab(tabId) {
  console.log(`Tab Manager: Pinning tab ${tabId}`);

  const state = await storage.getState();
  const node = state.tabs[tabId];

  if (!node) {
    throw new Error('Tab not found');
  }

  // Pin and lock the tab
  node.isPinned = true;
  node.isLocked = true;

  // Save current URL as lock URL if not already locked
  if (!node.lockUrl) {
    const chromeTab = (await chrome.tabs.query({})).find(t => t.id === tabId);
    if (chromeTab) {
      node.lockUrl = chromeTab.url;
    }
  }

  state.tabs[tabId] = node;

  // Sort tabs so pinned ones are first
  sortTabsByPriority(state);

  await storage.setState(state);

  broadcastMessage({
    type: MSG_TYPES.STATE_CHANGED,
    payload: state,
  });
}

/**
 * Unpin a tab - unlocks it and removes priority
 * @param {number} tabId - Tab to unpin
 * @returns {Promise<void>}
 */
export async function unpinTab(tabId) {
  console.log(`Tab Manager: Unpinning tab ${tabId}`);

  const state = await storage.getState();
  const node = state.tabs[tabId];

  if (!node) {
    throw new Error('Tab not found');
  }

  // Unpin and unlock
  node.isPinned = false;
  node.isLocked = false;
  node.lockUrl = null;

  state.tabs[tabId] = node;

  await storage.setState(state);

  broadcastMessage({
    type: MSG_TYPES.STATE_CHANGED,
    payload: state,
  });
}

/**
 * Sort tabs by priority (pinned first, then unpinned)
 * @param {Object} state - Current state
 */
function sortTabsByPriority(state) {
  for (const parentKey in state.order) {
    const tabIds = state.order[parentKey];

    // Sort: pinned tabs first, then unpinned
    tabIds.sort((a, b) => {
      const nodeA = state.tabs[a];
      const nodeB = state.tabs[b];

      if (!nodeA || !nodeB) return 0;

      // Pinned tabs come first
      if (nodeA.isPinned && !nodeB.isPinned) return -1;
      if (!nodeA.isPinned && nodeB.isPinned) return 1;

      // Keep original order for same priority
      return 0;
    });

    state.order[parentKey] = tabIds;
  }
}

/**
 * Collapse all parent tabs
 * @returns {Promise<void>}
 */
export async function collapseAll() {
  console.log('Tab Manager: Collapsing all parent tabs');

  const state = await storage.getState();

  // Find all tabs that have children
  for (const tabId in state.order) {
    if (tabId !== 'root' && state.order[tabId].length > 0) {
      state.collapsed[tabId] = true;
    }
  }

  await storage.setState(state);

  broadcastMessage({
    type: MSG_TYPES.STATE_CHANGED,
    payload: state,
  });
}

/**
 * Expand all parent tabs
 * @returns {Promise<void>}
 */
export async function expandAll() {
  console.log('Tab Manager: Expanding all parent tabs');

  const state = await storage.getState();

  // Clear all collapsed states
  state.collapsed = {};

  await storage.setState(state);

  broadcastMessage({
    type: MSG_TYPES.STATE_CHANGED,
    payload: state,
  });
}

/**
 * Broadcast message to all UI tabs
 * @param {Message} message - Message to send
 */
async function broadcastMessage(message) {
  console.log('Tab Manager: Broadcasting', message.type);

  // Send to all tabs (content scripts would receive this)
  const tabs = await chrome.tabs.query({});
  for (const tab of tabs) {
    chrome.tabs.sendMessage(tab.id, message).catch(() => {
      // Tab might not have content script, ignore
    });
  }

  // Also notify any open side panels by getting current state and sending it
  // The side panel will listen for messages and update
  try {
    const allFrames = await chrome.webNavigation.getAllFrames({allFrames: true});
    // Note: Side panels don't have a direct message target in MV3
    // Instead, we'll have the side panel poll for updates
  } catch (error) {
    // Ignore
  }
}
