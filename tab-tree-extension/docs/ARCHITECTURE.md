# Tab Tree Architecture

## System Overview

Tab Tree is a Chrome Manifest V3 extension with two main components:

1. **Service Worker** (`src/background/index.js`)
   - Runs in the background
   - Listens to Chrome tab events
   - Maintains tab hierarchy and state in `chrome.storage.local`
   - Communicates with side panel via messages

2. **Side Panel UI** (`src/sidepanel/index.js`)
   - Renders the tab tree in a sidebar
   - Handles user interactions (click, drag-drop)
   - Communicates with service worker via messages

## Data Flow

```
User clicks link
    ↓
Chrome creates new tab with openerTabId
    ↓
Service Worker listens (chrome.tabs.onCreated)
    ↓
Service Worker extracts openerTabId
    ↓
Service Worker updates storage (chrome.storage.local)
    ↓
Service Worker notifies Side Panel via message
    ↓
Side Panel updates UI (render tree)
```

## Key Files and Responsibilities

### Background Service Worker

| File | Responsibility |
|------|-----------------|
| `src/background/index.js` | Entry point, message routing, event listeners |
| `src/background/tab-manager.js` | Tab tracking, hierarchy logic |
| `src/background/lock-manager.js` | Locked tab enforcement |

### Side Panel UI

| File | Responsibility |
|------|-----------------|
| `src/sidepanel/index.html` | HTML structure |
| `src/sidepanel/index.js` | UI controller, state management |
| `src/sidepanel/tree.js` | Tree rendering, collapse/expand |
| `src/sidepanel/styles.css` | Styling |

### Shared Code

| File | Responsibility |
|------|-----------------|
| `src/shared/types.js` | JSDoc type definitions |
| `src/shared/constants.js` | Message types, config constants |
| `src/shared/storage.js` | Storage schema and helpers |

## Storage Schema

```javascript
chrome.storage.local = {
  // Flat map of all tabs
  tabs: {
    "123": {
      id: 123,
      parentId: null,      // null = root tab
      title: "GitHub",
      url: "https://github.com",
      favicon: "...",
      isLocked: false,
      lockUrl: null,
      isPinned: false
    },
    "124": {
      id: 124,
      parentId: 123,       // child of tab 123
      title: "Issue #456",
      url: "https://github.com/...",
      ...
    }
  },

  // Order of tabs at each level
  order: {
    "root": [123, 125, 126],    // Root-level tabs
    "123": [124, 127],           // Children of tab 123
  },

  // Collapse states
  collapsed: {
    "123": true,   // Tab 123 is collapsed
    "125": false   // Tab 125 is expanded
  },

  // Settings
  settings: {
    maxHierarchyLevel: 1,
    enableAutoNesting: true
  }
}
```

## Message Protocol

### Service Worker ← → Side Panel

**Side Panel sends requests to Service Worker:**

```javascript
// Get current state
chrome.runtime.sendMessage({
  type: 'GET_STATE'
}, response => {
  // response = { tabs, order, collapsed }
});

// Lock a tab
chrome.runtime.sendMessage({
  type: 'LOCK_TAB',
  payload: { tabId: 123 }
});

// Set parent (make tab a child)
chrome.runtime.sendMessage({
  type: 'SET_PARENT',
  payload: { childId: 124, parentId: 123 }
});

// Collapse/expand
chrome.runtime.sendMessage({
  type: 'TOGGLE_COLLAPSE',
  payload: { tabId: 123 }
});
```

**Service Worker notifies Side Panel:**

```javascript
// Broadcast state change
chrome.runtime.sendMessage(tabId, {
  type: 'STATE_CHANGED',
  payload: { tabs, order, collapsed }
});

// Notify of specific events
chrome.runtime.sendMessage(tabId, {
  type: 'TAB_CREATED',
  payload: { tab, parentId }
});
```

## Adding a New Feature

### Step 1: Update Storage Schema

Edit `src/shared/storage.js`:
```javascript
// Add new fields to tabs or new storage keys
```

### Step 2: Implement Backend Logic

Edit `src/background/index.js` or create new manager:
```javascript
// Handle the message
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'NEW_FEATURE') {
    // Implement logic
    // Update storage
    // Send response
  }
});
```

### Step 3: Add UI for the Feature

Edit `src/sidepanel/index.js`:
```javascript
// Handle the feature in UI
// Send message to service worker
// Update UI on response
```

### Step 4: Add E2E Test

Create test in `tests/e2e/feature-name.spec.js`:
```javascript
test('describes the feature', async () => {
  const { context, sidePanelUrl } = await launchWithExtension();

  // Test the feature

  await context.close();
});
```

### Step 5: Run Tests

```bash
npm test -- tests/e2e/feature-name.spec.js
```

## Constraints and Limitations

1. **Max Hierarchy Level**: 1 level (parent has children, no grandchildren)
2. **openerTabId**: Only available when tab opened from link (not always reliable)
3. **Extension ID**: Changes between builds, detected dynamically in tests
4. **Side Panel**: Can't be programmatically opened (user must click icon)
5. **Storage Limit**: ~5MB per extension (sufficient for ~1000 tabs)

## Performance Considerations

- **Storage Writes**: Debounced to batch updates
- **Rendering**: Avoid re-rendering entire tree; patch updates when possible
- **Virtual Scrolling**: Use for 100+ tabs to avoid performance issues
- **Memory**: Clean up removed tabs from storage periodically

## Testing Strategy

All features are tested end-to-end using Playwright:

1. **Setup**: Build extension, launch Chrome with extension loaded
2. **Test**: Interact with side panel HTML directly via `chrome-extension://[id]/...`
3. **Verify**: Check storage and UI state

See `tests/e2e/setup.js` for helper functions.
