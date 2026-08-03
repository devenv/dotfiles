# Sigma Tabs - Hierarchical Tab Manager

A Chrome extension for managing tabs hierarchically with Catppuccin theming, auto-unload, locking, pinning, and intuitive drag-and-drop organization.

## ✨ Features

### Core Functionality
- **Hierarchical Tabs** - Parent-child tab relationships (1-level nesting)
- **Auto-Nesting** - Tabs opened from links automatically nest under their parent
- **Drag & Drop** - Reorder and reorganize tabs with visual zone detection
- **Collapse/Expand** - Hide children of parent tabs with toggle arrows (▶/▼)

### Tab Management
- **Pinning** (📌) - Pin important tabs to keep them locked and at the top of their siblings
- **Locking** (🔒) - Locked tabs cannot be closed and show revert arrows (←) when navigated away
- **Smart Close** - Close button (✕) automatically disabled for locked tabs
- **Auto-Unload** - Automatically unload inactive tabs after a configurable time (30s to 1 week)

### UI/UX
- **Catppuccin Theming** - Beautiful Latte (light) and Mocha (dark) themes that match your system
- **Inline Actions** - Lock, pin, and close buttons appear on hover
- **Header Controls** - Collapse All and Expand All buttons for quick organization
- **Auto-Unload Slider** - Elegant slider with 10 time options: 30s, 5m, 15m, 30m, 1h, 6h, 1d, 3d, 1w, Never

### Keyboard Shortcuts
- **Cmd+Shift+E** (Ctrl+Shift+E) - Open Sigma Tabs sidebar
- **Cmd+Shift+L** (Ctrl+Shift+L) - Lock/unlock current tab
- **Cmd+Shift+P** (Ctrl+Shift+P) - Pin/unpin current tab
- **Cmd+Shift+D** (Ctrl+Shift+D) - Close tab (or discard if locked)

## 🎨 Design

- **Catppuccin Latte** for light mode - Soft, warm pastels
- **Catppuccin Mocha** for dark mode - Deep, cozy colors
- Auto-detects system theme with `prefers-color-scheme`
- Accent colors: Blue (active tabs), Peach (locked), Pink (pinned), Red (close)

## 🚀 Quick Start

```bash
# Install dependencies
npm install

# Build the extension
npm run build

# Run tests
npm test                    # Unit + E2E sanity tests
npm run test:unit           # Just unit tests
npm run test:e2e            # Just sanity E2E tests
npm run test:e2e:full       # All E2E tests (45+ tests)
```

### Load in Chrome

1. Open `chrome://extensions`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select the `dist/` folder

## 🏗️ Project Structure

```
sigma-tabs/
├── src/
│   ├── background/
│   │   ├── index.js           # Service worker with auto-unload alarm
│   │   └── tab-manager.js     # Tab hierarchy, locking, pinning logic
│   │
│   ├── sidepanel/
│   │   ├── index.html         # Header with buttons + slider
│   │   ├── index.js           # Controller + button handlers
│   │   ├── tree.js            # Tree rendering + inline buttons
│   │   └── styles.css         # Catppuccin theming
│   │
│   ├── shared/
│   │   ├── constants.js       # MSG_TYPES, SETTINGS
│   │   └── storage.js         # Chrome storage helpers
│   │
│   └── lib/
│       └── sortable.min.js    # SortableJS for drag-drop
│
├── tests/
│   ├── e2e/
│   │   ├── sanity.spec.js     # 7 critical path tests (default)
│   │   ├── sidebar.spec.js    # Full sidebar tests
│   │   ├── locked-tabs.spec.js
│   │   ├── dragdrop.spec.js
│   │   └── context-menu.spec.js
│   │
│   └── unit/
│       └── tab-manager.test.js # 14 unit tests (Node test runner)
│
└── manifest.json              # MV3 with commands, alarms
```

## 🧪 Testing

The project has a lean testing strategy:

**Unit Tests** (14 tests) - Core logic only
```bash
npm run test:unit
```
- Cycle detection (`hasAncestor`)
- Tree flattening (`flattenTreeForReorder`)
- Chrome tab index calculation

**E2E Sanity Tests** (7 tests) - Critical path only
```bash
npm run test:e2e
```
- Sidebar loads
- Tabs appear and are clickable
- Lock/unlock works
- Hierarchy works

**Full E2E Suite** (45+ tests) - All functionality
```bash
npm run test:e2e:full
```
- Drag-drop with zone detection
- Context menus
- All locked tab edge cases

## 🎯 How It Works

### Tab Hierarchy
- Tabs opened via links auto-nest under the opener tab (`openerTabId`)
- Drag tabs to **left zone** → root level
- Drag tabs to **right zone** → child of tab above

### Pinning
- Pinning a tab **locks it** and **prioritizes it**
- Pinned tabs appear first among siblings (parents and children sorted separately)
- Pinned tabs show 📌 icon (pink/mauve) and cannot be closed

### Locking
- Locked tabs cannot be closed (close button disabled)
- If navigated away, shows ← revert arrow (blue)
- Clicking revert arrow navigates back to locked URL

### Auto-Unload
- Background alarm checks every minute
- Discards tabs inactive beyond threshold
- **Exceptions**: Active tabs, locked tabs, pinned tabs
- Tracks `lastVisited` timestamp on tab activation

## 📋 State Management

All state stored in `chrome.storage.local`:

```javascript
{
  tabs: {
    [tabId]: {
      id, parentId, url, title, favicon,
      isLocked, isPinned, lockUrl,
      lastVisited, createdAt, windowId
    }
  },
  order: {
    root: [tabId1, tabId2, ...],
    [parentId]: [childId1, childId2, ...]
  },
  collapsed: {
    [tabId]: true  // if parent is collapsed
  },
  settings: {
    autoUnloadThreshold: 0.5,  // minutes (0 = Never)
    enableAutoNesting: true,
    ...
  }
}
```

## 🎹 Keyboard Shortcuts

Configurable in `chrome://extensions/shortcuts`:

| Shortcut | Action |
|----------|--------|
| **Cmd+Shift+E** | Open sidebar |
| **Cmd+Shift+L** | Lock/unlock current tab |
| **Cmd+Shift+P** | Pin/unpin current tab |
| **Cmd+Shift+D** | Close tab (respects locks) |

## 🔧 Development

### Scripts
- `npm run build` - Build extension to `dist/`
- `npm run build:watch` - Rebuild on file changes
- `npm test` - Run unit + sanity E2E tests
- `npm run test:unit` - Node test runner (fast)
- `npm run test:e2e` - Playwright sanity suite
- `npm run test:e2e:full` - All E2E tests

### Key Files to Modify

**Adding a new tab action:**
1. Add message type to `src/shared/constants.js`
2. Add handler in `src/background/index.js`
3. Add function in `src/background/tab-manager.js`
4. Add UI in `src/sidepanel/tree.js`

**Changing theme colors:**
- Edit Catppuccin variables in `src/sidepanel/styles.css`

## 🌐 Browser Support

- Chrome 114+ (Manifest V3)
- Edge 114+ (Chromium-based)

Requires:
- `chrome.alarms` for auto-unload
- `chrome.sidePanel` for sidebar UI
- `chrome.commands` for keyboard shortcuts

## 📄 License

MIT - See [LICENSE](LICENSE) for details.

## 🔒 Privacy

Sigma Tabs does not collect or transmit any user data. All data is stored locally. See [PRIVACY.md](PRIVACY.md) for details.
