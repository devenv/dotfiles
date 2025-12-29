# Tab Tree API Reference

## Data Structures

### TabNode

Represents a single tab in the hierarchy.

```javascript
/**
 * @typedef {Object} TabNode
 * @property {number} id - Chrome tab ID (unique)
 * @property {number|null} parentId - Parent tab ID (null = root level)
 * @property {string} url - Current tab URL
 * @property {string} title - Tab title (shown in sidebar)
 * @property {string} favicon - Favicon URL
 * @property {boolean} isLocked - Is this tab locked? (can't close, URL resets)
 * @property {string|null} lockUrl - Original URL to revert to if locked
 * @property {boolean} isPinned - Is this tab pinned? (appears at top)
 * @property {boolean} isCollapsed - Is this parent tab collapsed? (children hidden)
 * @property {number} createdAt - Timestamp of tab creation (milliseconds)
 */

// Example:
const tab = {
  id: 123,
  parentId: null,
  url: 'https://github.com/anthropics/claude-code',
  title: 'claude-code - GitHub',
  favicon: 'https://github.com/favicon.ico',
  isLocked: false,
  lockUrl: null,
  isPinned: false,
  isCollapsed: false,
  createdAt: 1703510400000
};
```

## Storage Schema

All state is stored in `chrome.storage.local`.

```javascript
chrome.storage.local = {
  /**
   * Map of all tabs by ID
   * @type {Object<string, TabNode>}
   */
  tabs: {
    "123": { /* TabNode */ },
    "124": { /* TabNode */ },
    "125": { /* TabNode */ }
  },

  /**
   * Tab order at each level
   * "root" key contains root-level tab IDs
   * Other keys are parent tab IDs containing child IDs
   * @type {Object<string, number[]>}
   */
  order: {
    "root": [123, 125, 126],    // Root tabs in order
    "123": [124, 127],           // Children of tab 123 in order
    "125": [128]                 // Children of tab 125 in order
  },

  /**
   * Collapse/expand state of parent tabs
   * @type {Object<string, boolean>}
   */
  collapsed: {
    "123": true,   // Tab 123 is collapsed
    "125": false   // Tab 125 is expanded
  },

  /**
   * Extension settings
   * @type {Object}
   */
  settings: {
    enableAutoNesting: true,
    maxHierarchyLevel: 1,
    confirmCloseWithChildren: true
  }
}
```

## Message Protocol

Communication between Service Worker and Side Panel.

### Message Types

Defined in `src/shared/constants.js`:

```javascript
const MSG = {
  // Side Panel → Service Worker (requests)
  GET_STATE: 'get_state',
  LOCK_TAB: 'lock_tab',
  UNLOCK_TAB: 'unlock_tab',
  SET_PARENT: 'set_parent',
  TOGGLE_COLLAPSE: 'toggle_collapse',
  PIN_TAB: 'pin_tab',
  UNPIN_TAB: 'unpin_tab',
  REORDER_TABS: 'reorder_tabs',

  // Service Worker → Side Panel (broadcasts)
  STATE_CHANGED: 'state_changed',
  TAB_CREATED: 'tab_created',
  TAB_REMOVED: 'tab_removed',
  TAB_UPDATED: 'tab_updated'
};
```

### Message Format

```javascript
{
  type: 'MESSAGE_TYPE',
  payload: {
    // Type-specific data
  }
}
```

### Message Examples

#### GET_STATE

Side Panel requests current state:

```javascript
// Send
chrome.runtime.sendMessage({ type: 'GET_STATE' });

// Response
{
  tabs: { /* all tabs */ },
  order: { /* tab order */ },
  collapsed: { /* collapse state */ }
}
```

#### LOCK_TAB

Side Panel requests to lock a tab:

```javascript
// Send
chrome.runtime.sendMessage({
  type: 'LOCK_TAB',
  payload: { tabId: 123 }
});

// Response
{ success: true, tab: { /* updated TabNode */ } }
```

#### SET_PARENT

Side Panel requests to make a tab a child:

```javascript
// Send
chrome.runtime.sendMessage({
  type: 'SET_PARENT',
  payload: { childId: 124, parentId: 123 }
});

// Response
{ success: true }
```

#### TOGGLE_COLLAPSE

Side Panel requests to collapse/expand:

```javascript
// Send
chrome.runtime.sendMessage({
  type: 'TOGGLE_COLLAPSE',
  payload: { tabId: 123 }
});

// Response
{ success: true, isCollapsed: true }
```

#### STATE_CHANGED (broadcast)

Service Worker notifies all UI of state change:

```javascript
{
  type: 'STATE_CHANGED',
  payload: {
    tabs: { /* updated tabs */ },
    order: { /* updated order */ },
    collapsed: { /* updated collapse state */ }
  }
}
```

#### TAB_CREATED (event)

Service Worker notifies of new tab:

```javascript
{
  type: 'TAB_CREATED',
  payload: {
    tabId: 128,
    parentId: 123,
    title: 'New Tab',
    url: 'https://example.com'
  }
}
```

## Chrome APIs Used

| API | Purpose | Permission |
|-----|---------|-----------|
| `chrome.tabs.*` | Query, create, update, remove tabs | `tabs` |
| `chrome.storage.local` | Persist hierarchy and settings | `storage` |
| `chrome.sidePanel` | Open/manage side panel | `sidePanel` |
| `chrome.runtime.sendMessage` | Message service worker | implicit |
| `chrome.runtime.onMessage` | Listen for messages | implicit |

## Key Functions

### Service Worker (`src/background/index.js`)

```javascript
/**
 * Handle message from side panel
 * @param {Object} message - Message object
 * @param {string} message.type - Message type
 * @param {Object} message.payload - Message data
 * @param {Object} sender - Message sender info
 * @param {Function} sendResponse - Callback to send response
 * @returns {boolean} - Return true to keep channel open for async response
 */
function onMessage(message, sender, sendResponse) { }

/**
 * Listen for new tab creation
 * Captures openerTabId to establish parent-child relationship
 * @param {Tab} tab - Chrome tab object
 */
function onTabCreated(tab) { }

/**
 * Listen for tab removal
 * Clean up from hierarchy and storage
 * @param {number} tabId - Removed tab ID
 * @param {Object} removeInfo - Removal info
 */
function onTabRemoved(tabId, removeInfo) { }

/**
 * Listen for tab updates (title, favicon, etc)
 * Update stored tab info
 * @param {number} tabId - Updated tab ID
 * @param {Object} changeInfo - What changed
 * @param {Tab} tab - Full tab object
 */
function onTabUpdated(tabId, changeInfo, tab) { }
```

### Side Panel (`src/sidepanel/index.js`)

```javascript
class SidePanelController {
  /**
   * Initialize the side panel
   * Fetch state and set up listeners
   */
  async initialize() { }

  /**
   * Render the entire tab tree
   */
  render() { }

  /**
   * Render a single tab and its children
   * @param {TabNode} tab - Tab to render
   * @param {number} level - Nesting level (0 = root)
   */
  renderTab(tab, level) { }

  /**
   * Switch to a tab (make it active)
   * @param {number} tabId - Tab ID to switch to
   */
  async switchToTab(tabId) { }

  /**
   * Toggle collapse state of parent tab
   * @param {number} tabId - Parent tab ID
   */
  async toggleCollapse(tabId) { }

  /**
   * Highlight the currently active tab
   * @param {number} tabId - Active tab ID
   */
  highlightActiveTab(tabId) { }
}
```

## Constraints

- **Max Hierarchy**: 1 level (parent → children only, no grandchildren)
- **Storage Limit**: ~5MB per extension (sufficient for ~1000 tabs)
- **Tab ID Range**: 1-2147483647 (Chrome's limit)
- **URL Length**: Up to 2MB per URL
- **openerTabId**: Only set when tab opens from link click or `window.open()`

## Error Handling

Messages should include error information:

```javascript
// On error
sendResponse({
  success: false,
  error: 'Error message describing what went wrong'
});

// On success
sendResponse({
  success: true,
  data: { /* result */ }
});
```

## Best Practices

1. **Always include JSDoc** - Type hints for IDE autocomplete
2. **Handle missing data** - Tabs may not be in storage yet
3. **Debounce storage writes** - Batch updates to avoid excessive I/O
4. **Broadcast state changes** - Don't just respond to individual requests
5. **Clean up on removal** - Remove tabs from storage when closed
6. **Validate input** - Check tab IDs exist before operating on them

## Example Usage

### Creating a tab hierarchy

```javascript
// Service Worker receives tab.onCreated
const newTab = {
  id: 124,
  parentId: 123,  // From openerTabId
  url: 'https://github.com/issue',
  title: 'Issue #456',
  isLocked: false,
  isPinned: false,
  isCollapsed: false,
  createdAt: Date.now()
};

// Store it
chrome.storage.local.get(['tabs', 'order'], (data) => {
  data.tabs[124] = newTab;
  data.order[123] = [...(data.order[123] || []), 124];
  chrome.storage.local.set(data);

  // Notify UI
  chrome.runtime.sendMessage({
    type: 'TAB_CREATED',
    payload: newTab
  });
});
```

### Locking a tab

```javascript
// Side Panel sends
chrome.runtime.sendMessage({
  type: 'LOCK_TAB',
  payload: { tabId: 123 }
});

// Service Worker handles
if (message.type === 'LOCK_TAB') {
  const tab = await chrome.tabs.get(message.payload.tabId);
  const node = storage.tabs[tab.id];
  node.isLocked = true;
  node.lockUrl = tab.url;

  // Pin it visually
  await chrome.tabs.update(tab.id, { pinned: true });

  // Persist
  chrome.storage.local.set({ tabs: storage.tabs });
}
```
