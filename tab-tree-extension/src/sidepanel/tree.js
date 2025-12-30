/**
 * Tree Renderer - Renders hierarchical tabs in sidebar
 * Handles indentation, collapse/expand, drag-drop, and user interactions
 */

import { MSG_TYPES } from '../shared/constants.js';

/**
 * Tree Renderer class
 */
export class TreeRenderer {
  /**
   * Create a new tree renderer
   * @param {Element} containerElement - DOM element to render into
   * @param {Function} onTabClick - Callback when tab is clicked
   * @param {Function} onToggleCollapse - Callback to toggle collapse
   * @param {Function} onMoveTab - Callback when tab is moved via drag-drop
   */
  constructor(containerElement, onTabClick, onToggleCollapse, onMoveTab = null) {
    this.container = containerElement;
    this.onTabClick = onTabClick;
    this.onToggleCollapse = onToggleCollapse;
    this.onMoveTab = onMoveTab;
    this.activeTabId = null;
    this.flattenedTabs = [];
    this.sortable = null;
  }

  /**
   * Render the entire tree
   * @param {AppState} state - Current application state
   * @returns {Promise<void>}
   */
  async render(state) {
    console.log('TreeRenderer: Rendering', Object.keys(state.tabs).length, 'tabs');

    // Store current state for drag-drop handlers
    this.currentState = state;

    // Clear container
    this.container.innerHTML = '';

    if (Object.keys(state.tabs).length === 0) {
      this.container.innerHTML =
        '<div class="empty-state">No tabs open. Open some tabs to get started!</div>';
      return;
    }

    // Flatten tree respecting collapse state
    this.flattenedTabs = this.flattenTree(state);

    // Render flattened list - now async
    for (const item of this.flattenedTabs) {
      const element = await this.createTabElement(item, state);
      this.container.appendChild(element);
    }

    // Initialize drag-drop
    this.initSortable();
  }

  /**
   * Initialize SortableJS for drag-drop
   */
  initSortable() {
    // Destroy previous instance if exists
    if (this.sortable) {
      this.sortable.destroy();
    }

    // Check if Sortable is available
    if (typeof Sortable === 'undefined') {
      console.log('TreeRenderer: SortableJS not loaded');
      return;
    }

    // Track drag zone for visual feedback
    this.dragZone = null; // 'left' = root, 'right' = child

    this.sortable = new Sortable(this.container, {
      animation: 150,
      ghostClass: 'sortable-ghost',
      chosenClass: 'tab-item-chosen',
      dragClass: 'tab-item-drag',
      handle: '.tab-item', // Drag from anywhere on the tab
      draggable: '.tab-item',

      onStart: (evt) => {
        this.container.classList.add('drag-active');
        this.dragZone = null;
      },

      onMove: (evt) => {
        // Detect which zone cursor is in
        const rect = this.container.getBoundingClientRect();
        const dragEvent = evt.originalEvent;
        const cursorX = dragEvent.clientX;
        const containerMidpoint = rect.left + rect.width / 2;

        if (cursorX < containerMidpoint) {
          // Left zone - root level
          if (this.dragZone !== 'left') {
            this.container.classList.remove('zone-right');
            this.container.classList.add('zone-left');
            this.dragZone = 'left';
          }
        } else {
          // Right zone - child of parent
          if (this.dragZone !== 'right') {
            this.container.classList.remove('zone-left');
            this.container.classList.add('zone-right');
            this.dragZone = 'right';
          }
        }
      },

      onEnd: (evt) => {
        // Clear drag state
        this.container.classList.remove('drag-active', 'zone-left', 'zone-right');
        this.handleDragEnd(evt);
        this.dragZone = null;
      },
    });
  }

  /**
   * Handle drag end event
   * @param {Event} evt - SortableJS end event
   */
  handleDragEnd(evt) {
    const tabId = parseInt(evt.item.dataset.tabId, 10);
    const oldIndex = evt.oldIndex;
    const newIndex = evt.newIndex;

    if (oldIndex === newIndex && !this.dragZone) return; // No change

    console.log('TreeRenderer: Drag end', { tabId, oldIndex, newIndex, zone: this.dragZone });

    // Determine new parent based on which zone the drag ended in
    let newParentId = 'root'; // Default to root

    const items = Array.from(this.container.querySelectorAll('.tab-item'));

    if (this.dragZone === 'right') {
      // Right zone: make this a child of the item above (or its parent if it's already a child)
      // When dropped at the end, use the last item (newIndex - 1)
      // When dropped in the middle, use the item before the drop position
      const referenceIndex = newIndex > 0 ? newIndex - 1 : 0;
      const prevItem = items[referenceIndex];

      if (prevItem) {
        const prevTabId = parseInt(prevItem.dataset.tabId, 10);
        const prevLevel = this.getTabLevel(prevTabId);

        if (prevLevel === 0) {
          // Previous item is at root level - make it the parent
          newParentId = prevTabId;
        } else if (prevLevel === 1) {
          // Previous item is already a child - use its parent as the new parent
          // This allows dragging to become a sibling of existing children
          const prevParentId = prevItem.dataset.parentId;
          if (prevParentId && prevParentId !== 'root') {
            newParentId = parseInt(prevParentId, 10);
          }
        }
        // If prevLevel > 1, we don't support deeper nesting, so stay at root
      }
    }
    // else: dragZone === 'left' means root level, newParentId stays 'root'

    // Notify callback
    if (this.onMoveTab) {
      this.onMoveTab(tabId, newParentId, newIndex);
    }
  }

  /**
   * Get the level of a tab from current state
   * @param {number} tabId - Tab ID
   * @returns {number} - Level (0 = root)
   */
  getTabLevel(tabId) {
    const item = this.flattenedTabs.find(i => i.node.id === tabId);
    return item ? item.level : 0;
  }

  /**
   * Flatten tree structure into array, respecting collapse state
   * @param {AppState} state - Current state
   * @returns {Array} - Flattened array of {node, level}
   */
  flattenTree(state) {
    const result = [];

    const traverse = (parentKey, level = 0) => {
      const tabIds = state.order[parentKey] || [];

      for (const tabId of tabIds) {
        const node = state.tabs[tabId];
        if (!node) continue;

        // Add this tab
        result.push({ node, level });

        // Add children if not collapsed
        if (!state.collapsed[tabId]) {
          traverse(tabId, level + 1);
        }
      }
    };

    // Start from root
    traverse('root', 0);

    return result;
  }

  /**
   * Create a DOM element for a single tab
   * @param {Object} item - Item {node, level}
   * @param {AppState} state - Current state
   * @returns {Promise<Element>} - Tab item DOM element
   */
  async createTabElement(item, state) {
    const { node, level } = item;
    const hasChildren = (state.order[node.id] || []).length > 0;
    const isCollapsed = state.collapsed[node.id] || false;

    const div = document.createElement('div');
    div.className = 'tab-item';
    div.dataset.tabId = node.id;
    div.dataset.parentId = node.parentId || 'root';
    if (this.activeTabId === node.id) {
      div.classList.add('active');
    }

    // Indentation
    div.style.paddingLeft = `${8 + level * 20}px`;

    // Collapse/expand toggle (if has children)
    if (hasChildren) {
      const toggle = document.createElement('span');
      toggle.className = 'toggle-icon';
      toggle.textContent = isCollapsed ? '▶' : '▼';
      toggle.title = isCollapsed ? 'Expand' : 'Collapse';
      toggle.onclick = (e) => {
        e.stopPropagation();
        this.onToggleCollapse(node.id);
      };
      div.appendChild(toggle);
    } else {
      // Spacer for alignment
      const spacer = document.createElement('span');
      spacer.className = 'toggle-icon';
      spacer.style.visibility = 'hidden';
      div.appendChild(spacer);
    }

    // Favicon
    const favicon = document.createElement('img');
    favicon.className = 'favicon';
    favicon.src = node.favicon || this.getDefaultFavicon();
    favicon.alt = '';
    favicon.onerror = () => {
      favicon.src = this.getDefaultFavicon();
    };
    div.appendChild(favicon);

    // Title
    const title = document.createElement('span');
    title.className = 'tab-title';
    title.textContent = node.title || 'Untitled';
    title.title = node.title; // Tooltip
    div.appendChild(title);

    // Icons on the right
    const icons = document.createElement('div');
    icons.className = 'tab-icons';

    // Lock/Unlock button (always visible)
    const lockBtn = document.createElement('button');
    lockBtn.className = 'tab-action-btn lock-btn';

    if (node.isLocked) {
      // Query current URL from Chrome API for accuracy
      let currentUrl = node.url;
      try {
        const chromeTab = await chrome.tabs.get(node.id);
        if (chromeTab) {
          currentUrl = chromeTab.url || node.url;
        }
      } catch (error) {
        console.warn(`Tab Manager: Could not query tab ${node.id} URL:`, error);
      }

      // Check if locked tab has drifted from its original URL
      const hasDrifted = node.lockUrl && currentUrl !== node.lockUrl;

      if (hasDrifted) {
        // Show revert arrow if tab drifted
        lockBtn.textContent = '←';
        lockBtn.title = 'Revert to locked URL';
        lockBtn.classList.add('drifted');
        lockBtn.onclick = (e) => {
          e.stopPropagation();
          chrome.runtime.sendMessage({
            type: 'revert_locked_tab',
            payload: { tabId: node.id, url: node.lockUrl },
          });
        };
      } else {
        // Locked state - solid lock icon
        lockBtn.textContent = '🔒';
        lockBtn.title = 'Unlock tab';
        lockBtn.classList.add('locked');
        lockBtn.onclick = (e) => {
          e.stopPropagation();
          chrome.runtime.sendMessage({
            type: MSG_TYPES.UNLOCK_TAB,
            payload: { tabId: node.id },
          });
        };
      }
    } else {
      // Unlocked state - greyed out lock icon
      lockBtn.textContent = '🔓';
      lockBtn.title = 'Lock tab';
      lockBtn.classList.add('unlocked');
      lockBtn.onclick = (e) => {
        e.stopPropagation();
        chrome.runtime.sendMessage({
          type: MSG_TYPES.LOCK_TAB,
          payload: { tabId: node.id },
        });
      };
    }
    icons.appendChild(lockBtn);

    // Close button (disabled if locked)
    const closeBtn = document.createElement('button');
    closeBtn.className = 'tab-action-btn close-btn';
    closeBtn.textContent = '✕';
    closeBtn.title = node.isLocked ? 'Cannot close locked tab' : 'Close tab';
    if (node.isLocked) {
      closeBtn.disabled = true;
      closeBtn.classList.add('disabled');
    }
    closeBtn.onclick = (e) => {
      if (node.isLocked) return;
      e.stopPropagation();
      chrome.runtime.sendMessage({
        type: MSG_TYPES.CLOSE_TAB,
        payload: { tabId: node.id },
      });
    };
    icons.appendChild(closeBtn);

    div.appendChild(icons);

    // Click handler - switch to tab
    div.onclick = () => this.onTabClick(node.id);

    // Context menu (lock, pin, close, move to root)
    div.oncontextmenu = (e) => {
      e.preventDefault();
      console.log('Context menu on tab', node.id);
      this.showContextMenu(e.clientX, e.clientY, node, state);
    };

    return div;
  }

  /**
   * Get default favicon URL (grey square)
   * @returns {string}
   */
  getDefaultFavicon() {
    return 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"><rect fill="%23d0d0d0" width="16" height="16" rx="2"/></svg>';
  }

  /**
   * Highlight the active tab
   * @param {number} tabId - Active tab ID
   */
  setActiveTab(tabId) {
    this.activeTabId = tabId;

    // Remove active class from all
    this.container.querySelectorAll('.tab-item.active').forEach((el) => {
      el.classList.remove('active');
    });

    // Add to current
    const activeEl = this.container.querySelector(
      `[data-tab-id="${tabId}"]`
    );
    if (activeEl) {
      activeEl.classList.add('active');
    }
  }

  /**
   * Update a single tab (e.g., title or favicon changed)
   * @param {TabNode} node - Updated tab node
   * @param {AppState} state - Current state
   */
  updateTab(node, state) {
    const el = this.container.querySelector(`[data-tab-id="${node.id}"]`);
    if (!el) return;

    // Update title
    const titleEl = el.querySelector('.tab-title');
    if (titleEl) {
      titleEl.textContent = node.title || 'Untitled';
      titleEl.title = node.title;
    }

    // Update favicon
    const faviconEl = el.querySelector('.favicon');
    if (faviconEl && node.favicon) {
      faviconEl.src = node.favicon;
    }
  }

  /**
   * Get the current state of visible tabs
   * Useful for debugging
   * @returns {Array}
   */
  getVisibleTabs() {
    return this.flattenedTabs.map((item) => ({
      id: item.node.id,
      title: item.node.title,
      level: item.level,
    }));
  }

  /**
   * Show context menu for a tab
   * @param {number} x - Mouse X position
   * @param {number} y - Mouse Y position
   * @param {TabNode} node - Tab node
   * @param {AppState} state - Current state
   */
  showContextMenu(x, y, node, state) {
    // Remove any existing context menu
    this.hideContextMenu();

    const menu = document.createElement('div');
    menu.className = 'context-menu';
    menu.style.left = `${x}px`;
    menu.style.top = `${y}px`;

    // Lock/Unlock option
    const lockItem = document.createElement('div');
    lockItem.className = 'context-menu-item';
    lockItem.textContent = node.isLocked ? 'Unlock' : 'Lock';
    lockItem.onclick = () => {
      this.hideContextMenu();
      const msgType = node.isLocked ? MSG_TYPES.UNLOCK_TAB : MSG_TYPES.LOCK_TAB;
      chrome.runtime.sendMessage({
        type: msgType,
        payload: { tabId: node.id },
      });
    };
    menu.appendChild(lockItem);

    // Move to root option (only if has parent)
    if (node.parentId !== null) {
      const moveItem = document.createElement('div');
      moveItem.className = 'context-menu-item';
      moveItem.textContent = 'Move to root';
      moveItem.onclick = () => {
        this.hideContextMenu();
        chrome.runtime.sendMessage({
          type: MSG_TYPES.REMOVE_PARENT,
          payload: { tabId: node.id },
        });
      };
      menu.appendChild(moveItem);
    }

    // Close tab option (disabled if locked)
    const closeItem = document.createElement('div');
    closeItem.className = 'context-menu-item';
    if (node.isLocked) {
      closeItem.classList.add('disabled');
    }
    closeItem.textContent = 'Close tab';
    closeItem.onclick = () => {
      if (node.isLocked) return; // Don't close locked tabs
      this.hideContextMenu();
      chrome.runtime.sendMessage({
        type: MSG_TYPES.CLOSE_TAB,
        payload: { tabId: node.id },
      });
    };
    menu.appendChild(closeItem);

    document.body.appendChild(menu);
    this.currentContextMenu = menu;

    // Adjust position if menu goes off-screen
    const menuRect = menu.getBoundingClientRect();
    const viewportWidth = window.innerWidth;
    const viewportHeight = window.innerHeight;

    if (menuRect.right > viewportWidth) {
      menu.style.left = `${viewportWidth - menuRect.width - 5}px`;
    }
    if (menuRect.bottom > viewportHeight) {
      menu.style.top = `${viewportHeight - menuRect.height - 5}px`;
    }

    // Close menu when clicking outside
    this.contextMenuClickHandler = (e) => {
      if (!menu.contains(e.target)) {
        this.hideContextMenu();
      }
    };
    // Use setTimeout to avoid the context menu click event triggering this handler
    setTimeout(() => {
      document.addEventListener('click', this.contextMenuClickHandler);
      document.addEventListener('contextmenu', this.contextMenuClickHandler);
    }, 0);
  }

  /**
   * Hide the context menu
   */
  hideContextMenu() {
    if (this.currentContextMenu) {
      this.currentContextMenu.remove();
      this.currentContextMenu = null;
    }
    if (this.contextMenuClickHandler) {
      document.removeEventListener('click', this.contextMenuClickHandler);
      document.removeEventListener('contextmenu', this.contextMenuClickHandler);
      this.contextMenuClickHandler = null;
    }
  }
}
