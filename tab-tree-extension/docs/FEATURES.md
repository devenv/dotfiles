# Tab Tree Features

## MVP Feature Set

Tab Tree is being built in 7 phases. This document describes all features in the final MVP.

## Phase 1: Foundation ✅
**Status**: Complete (Dec 29, 2025)

- Project structure and build system
- Service worker and side panel UI
- Testing infrastructure
- Documentation

## Phase 2: Tab Display & Hierarchy
**Status**: Pending

### Feature: Automatic Tab Hierarchy

Tabs opened from links automatically nest under their parent tab.

```
┌─ GitHub (ID: 123)
│  └─ Issue #456 (ID: 124)  ← opened from GitHub link
│  └─ PR #789 (ID: 125)     ← opened from GitHub link
├─ Stack Overflow (ID: 126)
└─ Documentation (ID: 127)
```

**How it works:**
1. User clicks link in Tab A
2. Browser opens new Tab B
3. Tab B's `openerTabId` = Tab A's ID
4. Service worker captures this relationship
5. Side panel displays Tab B indented under Tab A

**UI Behavior:**
- Click on parent tab → switch to it
- Parent appears with indentation
- Child inherits indentation level
- Visual indicator shows parent-child

**Tests:**
- `displays all open tabs`
- `new tab from link becomes child`
- `tab updates reflect in sidebar`

**Implementation:**
- `src/background/tab-manager.js` - Track openerTabId
- `src/sidepanel/tree.js` - Render with indentation
- `src/shared/constants.js` - Message types

## Phase 3: Collapse/Expand
**Status**: Pending

### Feature: Collapsible Parent Tabs

Parent tabs can be collapsed to hide all children.

```
▼ GitHub (expanded)
  └─ Issue #456
  └─ PR #789
▶ Stack Overflow (collapsed, children hidden)
```

**Behavior:**
- Click arrow (▼/▶) to toggle collapse
- Children hidden when parent collapsed
- Collapse state persists across browser restart
- Visual indicator: ▼ = expanded, ▶ = collapsed

**UI:**
- Toggle icon appears next to parent tabs
- Toggle icon not visible for tabs with no children
- Smooth animation (optional, Phase 7)

**Tests:**
- `collapse hides children`
- `expand shows children`
- `collapse state persists on reload`

**Implementation:**
- Update `TabNode` with `isCollapsed` flag
- Tree renderer respects collapse state
- Storage layer persists state

## Phase 4: Locked Tabs
**Status**: Pending

### Feature: Lock Tab (SigmaOS-style)

Important tabs can be locked to prevent accidental closure and navigation.

**Behavior:**
1. **Can't Close**: If user closes locked tab, it automatically recreates at original URL
2. **URL Reset**: If user navigates away, URL reverts to original
3. **Visual Indicator**: Shows 🔒 icon next to locked tabs
4. **Auto-Pin**: Locked tabs move to pinned section at top
5. **Survive Restart**: Locked tabs reopen when browser starts

**How to use:**
```
1. Right-click tab → "Lock Tab"
2. Tab gets 🔒 icon and moves to pinned section
3. Tab is now protected
4. User tries to close → tab recreates
5. User navigates away → URL resets
6. Right-click → "Unlock Tab" to remove
```

**Use Cases:**
- Gmail/Outlook stays open during work session
- Documentation page locked while coding
- Monitoring dashboard pinned
- Daily standups/calendar

**Tests:**
- `locked tab recreates when closed`
- `locked tab reverts URL when navigated`
- `unlock removes protection`
- `locked tabs appear in pinned section`

**Implementation:**
- `src/background/lock-manager.js` - Enforcement
- Listen to `chrome.tabs.onRemoved` → recreate
- Listen to `chrome.tabs.onUpdated` → revert URL
- Update TabNode with `isLocked`, `lockUrl`

## Phase 5: Pinned Tabs
**Status**: Pending

### Feature: Pinned Tabs Section

Important tabs can be pinned to stay at top of sidebar.

```
[PINNED SECTION]
📌 Gmail
📌 Calendar

[REGULAR TABS]
▼ GitHub
  └─ Issue #456
```

**Behavior:**
- Pinned tabs always appear at top
- Separated visually from regular tabs
- Can be locked or unlocked
- Can have children (if not locked)
- Survive browser restart

**Interactions:**
- Right-click tab → "Pin Tab" / "Unpin Tab"
- Pin icon (📌) shows next to pinned tabs
- Drag within pinned section to reorder

**Tests:**
- `pinned tabs appear at top`
- `pin/unpin moves between sections`
- `pinned section has visual separator`

**Implementation:**
- Filter tabs by `isPinned` flag
- Render pinned section first
- Sync with Chrome's native pinned state

## Phase 6: Drag & Drop
**Status**: Pending

### Feature: Reorder and Reorganize Tabs

Full drag-and-drop support for managing tab hierarchy and order.

**Drag Actions:**

1. **Reorder at same level**
   - Drag tab between siblings
   - Changes position in `order` array

2. **Make child**
   - Drag tab onto another tab
   - Tab becomes child of target
   - Visual feedback (drop zone highlight)

3. **Remove from parent**
   - Drag child to root level
   - Tab becomes standalone

4. **Move parent with children**
   - Drag parent tab
   - All children move with it
   - Maintains hierarchy

**Visual Feedback:**
- Dragged tab becomes semi-transparent
- Drop zones highlighted when hovering
- Parent tab shows "drop here" indicator
- Smooth animations

**Tests:**
- `reorder tabs at same level`
- `drag onto tab makes it child`
- `drag to root removes parent`
- `drag parent moves children too`
- `drop zone visual feedback works`

**Implementation:**
- Integrate SortableJS library (8KB)
- Handle nested group drops
- Update storage on successful drop
- Emit state change message

**Technical Details:**
```javascript
// Drag initiates
item.dragstart → store tabId

// Drag over
zone.dragover → show drop indicator

// Drop
zone.drop →
  1. Calculate new parent/position
  2. Update storage.order
  3. Send message to update UI
  4. Broadcast STATE_CHANGED
```

## Phase 7: Polish & Documentation
**Status**: Pending

### Polish Tasks
- Smooth animations (collapse, drag-drop)
- Better loading states
- Error handling and user feedback
- Edge case handling (circular refs, rapid operations)
- Performance optimization

### Documentation
- Update README with screenshots
- Create user guide
- Add keyboard shortcuts (future)
- Performance metrics

## Constraint: Max 1 Level Hierarchy

Tab Tree supports only **parent → children**, no grandchildren.

```
✅ VALID
├─ Parent 1
│  ├─ Child 1a
│  └─ Child 1b
└─ Parent 2
   ├─ Child 2a
   └─ Child 2b

❌ INVALID (no grandchildren)
├─ Parent
   └─ Child
      └─ Grandchild ← NOT SUPPORTED
```

**Rationale:**
- Simplifies data structure
- Easier to understand visually
- Covers 95% of real-world use cases
- Can be extended in future versions

**Conversion Rule:**
If user tries to create invalid hierarchy (e.g., drag child onto another child):
- Option A: Move to root level instead
- Option B: Move to parent level
- Option C: Show error "Can't nest more than 1 level"

Decision: TBD in Phase 6

## Future Enhancements (Post-MVP)

Not in current plan, but possible additions:

- Manual hierarchy editing (drag-drop improvements)
- Tab search/filter
- Workspaces (separate tab collections)
- Tab preview on hover
- Sync across devices
- Keyboard shortcuts (Ctrl+Shift+T to lock)
- Dark mode
- Tab grouping integration with Chrome's native groups
- Arbitrary nesting levels (not capped at 1)
- Tab notes and annotations
- Smart grouping by domain
- AI-powered organization

## Browser Support

- Chrome 114+
- Edge 114+ (Chromium-based)
- Brave 1.75+
- Opera 100+

(Any Chromium-based browser with Manifest V3 support)

## Performance Targets

- Side panel render: < 100ms for 50 tabs
- Storage read: < 50ms
- Message latency: < 50ms
- Memory usage: < 50MB for 100 tabs
- No memory leaks in 1+ hour session

## Security Model

- All data stored locally (no cloud sync)
- No external API calls
- No tracking or analytics
- No content script injection
- Minimal permissions: `tabs`, `storage`, `sidePanel`

## Accessibility

- Keyboard navigation (future phase)
- Screen reader support (future phase)
- High contrast mode (future phase)
- Focus indicators
