# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**Sigma Tabs** - A Chrome extension for hierarchical tab management.

## Quick Start Commands

```bash
# Build extension to dist/
npm run build

# Watch mode (rebuild on file changes)
npm run build:watch

# Run tests (unit + E2E sanity)
npm test

# Unit tests only (fast, Node.js)
npm run test:unit

# E2E sanity tests (7 critical tests, Playwright)
npm run test:e2e

# All E2E tests (45+, includes drag-drop, context menus)
npm run test:e2e:full

# Watch E2E tests during development
npm run test:watch

# E2E tests with visible browser
npm run test:headed

# Interactive debug mode for E2E
npm run test:debug

# Generate screenshots for documentation
npm screenshot
```

Before claiming a feature is complete:
- **Always run** `npm run build && npm test` - both must succeed
- **Check logs** for any console errors or warnings
- **Verify the feature** works in Chrome by loading the dist/ folder

## Project Architecture

Sigma Tabs is a **Chrome Manifest V3 extension** with two main components that communicate via `chrome.runtime.sendMessage`:

### Service Worker (`src/background/`)
- **Entry point**: `src/background/index.js`
- Runs in background, handles Chrome tab events
- Maintains hierarchy, locking, pinning, and auto-unload logic
- Persists state to `chrome.storage.local`
- Notifies side panel of state changes

### Side Panel UI (`src/sidepanel/`)
- **Entry point**: `src/sidepanel/index.js`
- Renders the tab tree in a sidebar
- Handles user interactions (click, drag-drop, collapse/expand)
- Sends requests to service worker via messages
- Updates UI when service worker broadcasts state changes

### Shared Code (`src/shared/`)
- **constants.js**: Message types (MSG_TYPES) and config
- **storage.js**: Chrome storage helpers and state access
- **types.js**: JSDoc type definitions

## Data Flow

```
User Action (sidebar)
    ↓
Side Panel sends message to Service Worker
    ↓
Service Worker updates storage & Chrome tabs
    ↓
Service Worker broadcasts state change to Side Panel
    ↓
Side Panel re-renders tree
```

## State Management

All state lives in `chrome.storage.local` with this schema:

```javascript
{
  // Map of all tabs by ID
  tabs: {
    "123": {
      id: 123,
      parentId: null,       // null = root, number = parent ID
      title: "GitHub",
      url: "https://github.com",
      favicon: "...",
      isLocked: false,
      isPinned: false,
      lockUrl: null,        // URL to revert to if navigated away while locked
      lastVisited: 1234567890000
    }
  },

  // Order of tabs at each level (determines render order)
  order: {
    "root": [123, 125, 126],   // Root-level tabs
    "123": [124, 127]          // Children of tab 123
  },

  // Collapse state (which parents are collapsed)
  collapsed: {
    "123": true    // Tab 123 has children hidden
  },

  // User settings
  settings: {
    autoUnloadThreshold: 0.5,  // minutes (0 = Never)
    enableAutoNesting: true
  }
}
```

## Messaging Pattern

All communication between Side Panel and Service Worker uses `chrome.runtime.sendMessage`:

```javascript
// Side Panel → Service Worker
chrome.runtime.sendMessage({
  type: 'ACTION_NAME',
  payload: { /* action data */ }
}, response => {
  // Handle response
});

// Service Worker → Side Panel (broadcasts)
chrome.runtime.sendMessage(tabId, {
  type: 'STATE_CHANGED',
  payload: { tabs, order, collapsed }
});
```

Message types are defined in `src/shared/constants.js`. Common types:
- `GET_STATE` - Request full state
- `LOCK_TAB`, `UNLOCK_TAB` - Lock/unlock a tab
- `PIN_TAB`, `UNPIN_TAB` - Pin/unpin a tab
- `SET_PARENT` - Make one tab a child of another
- `CLOSE_TAB` - Close/discard a tab
- `TOGGLE_COLLAPSE` - Show/hide children
- `SET_AUTO_UNLOAD_THRESHOLD` - Change unload time

## Key Constraints & Limitations

1. **Max Hierarchy**: 1 level only (parent → children, no grandchildren)
2. **openerTabId**: Only available when tab opened from a link; not reliable for direct clicks
3. **Storage Limit**: ~5MB (sufficient for ~1000 tabs)
4. **Side Panel**: Cannot be opened programmatically; only by user clicking the extension icon
5. **Chrome Events**: Some listeners (onUpdated, onRemoved) fire frequently; debounce writes
6. **Auto-Nesting**: Relies on `openerTabId` which may be undefined

## Testing Strategy

The project uses **Playwright for E2E tests** (Chromium browser automation):

**Unit Tests** (14 tests, Node.js)
- Located: `tests/unit/tab-manager.test.js`
- Run: `npm run test:unit`
- Tests core logic: cycle detection, tree flattening, calculations
- Fast, no browser needed

**E2E Sanity Tests** (7 tests, default)
- Located: `tests/e2e/sanity.spec.js`
- Run: `npm run test:e2e`
- Tests critical paths: sidebar loads, tabs clickable, lock/unlock works

**Full E2E Suite** (45+ tests, comprehensive)
- Located: `tests/e2e/*.spec.js` (multiple files)
- Run: `npm run test:e2e:full`
- Tests all features: drag-drop, context menus, pinning, auto-unload, edge cases

### Writing E2E Tests

All E2E tests:
1. Call `launchWithExtension()` from `tests/e2e/setup.js`
2. Launch Chrome with the extension loaded
3. Create test pages and navigate to them
4. Interact with the side panel HTML directly
5. Check storage state via `chrome.storage.local`

Example:
```javascript
test('feature works', async () => {
  const { context, sidePanelUrl } = await launchWithExtension();

  // Create a test page and navigate
  const page = await context.newPage();
  await page.goto('data:text/html,<a href="...">link</a>');

  // Open sidebar
  const sidePanel = await context.newPage();
  await sidePanel.goto(sidePanelUrl);

  // Interact and verify
  await sidePanel.click('button.lock-btn');

  await context.close();
});
```

## Codebase Layout

```
src/
  background/
    index.js              # Service worker entry, Chrome listeners
    tab-manager.js        # Tab hierarchy, reordering, cycle detection
    lock-manager.js       # Locked tab enforcement, revert logic

  sidepanel/
    index.html            # Header (buttons, slider), tab list container
    index.js              # UI controller, message handlers
    tree.js               # Tree rendering, collapse/expand, inline buttons
    styles.css            # Catppuccin theming, responsive layout

  shared/
    constants.js          # MSG_TYPES, STORAGE_KEYS, defaults
    storage.js            # chrome.storage.local helpers
    types.js              # JSDoc type definitions (@typedef)

  lib/
    sortable.min.js       # SortableJS library for drag-drop

  content/
    (content scripts, if any - currently minimal)

tests/
  e2e/
    setup.js              # launchWithExtension() helper
    sanity.spec.js        # 7 critical tests (default)
    sidebar.spec.js       # Full sidebar interaction
    locked-tabs.spec.js   # Locking edge cases
    dragdrop.spec.js      # Drag-drop with zones
    context-menu.spec.js  # Context menu actions

  unit/
    tab-manager.test.js   # Node.js unit tests

docs/
  ARCHITECTURE.md         # System design, data flow, message protocol
  TESTING.md              # How to write tests, E2E patterns
  API.md                  # Data structures and message formats
  FEATURES.md             # Feature specifications
```

## Working on a Feature

**Workflow:**
1. Read `docs/ARCHITECTURE.md` to understand data flow
2. Check `src/shared/constants.js` for message types
3. Examine existing tests in `tests/e2e/` for patterns
4. Update storage schema if needed (src/shared/storage.js)
5. Implement backend logic in `src/background/` (listen to events, update storage)
6. Implement UI in `src/sidepanel/` (render, handle interactions, send messages)
7. Add E2E test in `tests/e2e/`
8. Run `npm run build && npm test` - **all must pass**
9. Update `README.md` if user-facing

**Adding a Tab Action:**
1. Define message type in `src/shared/constants.js`
2. Add message handler in `src/background/index.js`
3. Implement logic in `src/background/tab-manager.js` (or separate file)
4. Add UI in `src/sidepanel/tree.js` or `src/sidepanel/index.js`
5. Send message when user interacts with UI
6. Update tests

**Changing Theme Colors:**
- Edit Catppuccin variables in `src/sidepanel/styles.css`
- Two themes: Catppuccin Latte (light) and Mocha (dark)
- Auto-detects system preference with `prefers-color-scheme`

## Common Issues & Debugging

**Sidebar doesn't load:**
- Check `dist/src/sidepanel/index.html` exists
- Run `npm run build`
- Check extension ID in chrome://extensions (loaded correctly?)

**Tabs not appearing:**
- Verify `chrome.storage.local` has the right data
- Check service worker console (right-click extension → Inspect)
- Look for errors in service worker background script

**Drag-drop not working:**
- Ensure SortableJS is loaded (`src/lib/sortable.min.js`)
- Check zone detection in `src/sidepanel/tree.js` (left/right zones)
- Verify order state is being saved to storage

**Tests fail:**
- Run `npm run build` first (required for E2E)
- Use `npm run test:headed` to see the browser
- Check `playwright-report/` for test videos/traces
- Run `npm run test:debug` for step-through debugging

**Storage not persisting:**
- Ensure `chrome.storage.local.set()` is called, not just read
- Check for async issues - await the promise
- Verify no quota exceeded (check extension storage usage)

## Rules from .cursor/rules.md

- **Test-First**: Every feature must have passing E2E tests before merging
- **JSDoc Comments**: All functions must have documentation
- **Minimal Dependencies**: Only vanilla JS + browser APIs + Playwright
- **Always Verify**: Build and test must both succeed before claiming done
- **No External Deps**: Don't add npm packages without discussion

## Before Finishing a Task

Verify:
- [ ] All E2E tests pass (`npm test`)
- [ ] Build succeeds (`npm run build`)
- [ ] All functions have JSDoc comments (for new code)
- [ ] New message types defined in `src/shared/constants.js`
- [ ] Storage schema documented in comments
- [ ] `README.md` updated if user-facing
- [ ] No console errors/warnings in service worker or sidebar
- [ ] Tested in actual Chrome (if possible)

## Documentation Files

Read these to understand different aspects:
- **ARCHITECTURE.md** - System design, data flow, message protocol
- **TESTING.md** - How to write E2E tests
- **API.md** - Complete message types and data structures
- **FEATURES.md** - Feature specifications and user requirements
- **README.md** - User-facing features and quick start
