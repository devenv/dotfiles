/**
 * TabHierarchy - Static utility class for tree operations
 */
export class TabHierarchy {
  /**
   * Flatten tree structure for rendering or reordering
   * @param {Object} state - { tabs: {}, order: {}, collapsed: {} }
   * @param {boolean} respectCollapse - Whether to skip collapsed children
   * @returns {Array} - [{id, level}, ...]
   */
  static flatten(state, respectCollapse = true) {
    const result = [];

    function traverse(parentKey, level = 0) {
      const tabIds = state.order[parentKey] || [];

      for (const tabId of tabIds) {
        const node = state.tabs[tabId];
        if (!node) continue;

        result.push({ id: tabId, level, node });

        // Check if parent is collapsed
        const isCollapsed = respectCollapse && state.collapsed[tabId];

        // Traverse children if not collapsed
        if (!isCollapsed) {
          traverse(tabId, level + 1);
        }
      }
    }

    traverse('root', 0);
    return result;
  }

  /**
   * Check if a tab is an ancestor of another (cycle detection)
   * @param {number} potentialAncestorId - Potential ancestor tab ID
   * @param {number} tabId - Tab ID to check
   * @param {Object} tabs - Tabs object
   * @returns {boolean} - True if potentialAncestorId is ancestor of tabId
   */
  static hasAncestor(potentialAncestorId, tabId, tabs) {
    // Same tab is not its own ancestor
    if (potentialAncestorId === tabId) {
      return false;
    }

    let currentId = tabId;
    const visited = new Set();

    while (currentId !== null && currentId !== undefined) {
      if (visited.has(currentId)) {
        // Cycle detected
        return false;
      }

      visited.add(currentId);
      const node = tabs[currentId];
      currentId = node ? node.parentId : null;

      if (currentId === potentialAncestorId) {
        return true;
      }
    }

    return false;
  }

  /**
   * Sort tabs by priority (pinned first)
   * @param {Object} state - { tabs: {}, order: {} }
   */
  static sortByPriority(state) {
    for (const parentKey in state.order) {
      const tabIds = state.order[parentKey];

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
   * Get all children of a tab
   * @param {number} tabId - Parent tab ID
   * @param {Object} order - Order object
   * @returns {Array} - Child tab IDs
   */
  static getChildren(tabId, order) {
    return order[tabId] || [];
  }

  /**
   * Get all descendants of a tab (recursive)
   * @param {number} tabId - Parent tab ID
   * @param {Object} order - Order object
   * @returns {Array} - All descendant tab IDs
   */
  static getDescendants(tabId, order) {
    const descendants = [];
    const children = TabHierarchy.getChildren(tabId, order);

    for (const childId of children) {
      descendants.push(childId);
      descendants.push(...TabHierarchy.getDescendants(childId, order));
    }

    return descendants;
  }

  /**
   * Calculate Chrome tab index for a tab based on tree position
   * @param {number} tabId - Tab ID
   * @param {Object} state - Full state
   * @returns {number} - Chrome tab index
   */
  static calculateChromeIndex(tabId, state) {
    const flattened = TabHierarchy.flatten(state, false); // Don't respect collapse
    const index = flattened.findIndex(item => item.id === tabId);
    return index >= 0 ? index : 0;
  }

  /**
   * Remove tab from order arrays
   * @param {number} tabId - Tab ID to remove
   * @param {Object} order - Order object
   */
  static removeFromOrder(tabId, order) {
    for (const key in order) {
      order[key] = order[key].filter(id => id !== tabId);
    }
  }

  /**
   * Move tab to new parent
   * @param {number} tabId - Tab ID to move
   * @param {string|number} newParentId - New parent ('root' or tab ID)
   * @param {number|null} position - Position in new parent's children (null = end)
   * @param {Object} state - Full state
   */
  static moveTab(tabId, newParentId, position, state) {
    const node = state.tabs[tabId];
    if (!node) return;

    // Check for cycles
    if (newParentId !== 'root' && TabHierarchy.hasAncestor(tabId, newParentId, state.tabs)) {
      throw new Error('Cannot create cycle in hierarchy');
    }

    // Remove from current parent
    const oldParentKey = node.parentId || 'root';
    if (state.order[oldParentKey]) {
      state.order[oldParentKey] = state.order[oldParentKey].filter(id => id !== tabId);
    }

    // Add to new parent
    const newParentKey = newParentId === 'root' ? 'root' : newParentId;
    if (!state.order[newParentKey]) {
      state.order[newParentKey] = [];
    }

    if (position !== null && position >= 0) {
      state.order[newParentKey].splice(position, 0, tabId);
    } else {
      state.order[newParentKey].push(tabId);
    }

    // Update node parent reference
    node.parentId = newParentId === 'root' ? null : newParentId;
  }

  /**
   * Deduplicate order arrays
   * @param {Object} order - Order object
   */
  static deduplicateOrder(order) {
    for (const key in order) {
      order[key] = [...new Set(order[key])];
    }
  }

  /**
   * Calculate target parent for drag-drop operation
   * @param {number} draggedTabId - ID of tab being dragged
   * @param {number} dropIndex - Visual index where tab was dropped (in flattened list)
   * @param {string|null} dragZone - 'left' (root), 'right' (child), or null (no zone change)
   * @param {Object} state - Full state
   * @returns {Object} - { parentId, insertIndex } where to insert the tab
   */
  static calculateDropTarget(draggedTabId, dropIndex, dragZone, state) {
    const flattened = TabHierarchy.flatten(state, false); // Don't respect collapse
    const draggedNode = state.tabs[draggedTabId];
    const currentParentId = draggedNode ? (draggedNode.parentId || 'root') : 'root';

    // Handle explicit zone changes
    if (dragZone === 'left') {
      // Force to root level
      return {
        parentId: 'root',
        insertIndex: dropIndex,
      };
    }

    if (dragZone === 'right') {
      // Make child of item above
      if (dropIndex > 0) {
        const prevItem = flattened[dropIndex - 1];
        if (prevItem) {
          const prevNode = state.tabs[prevItem.id];
          if (prevItem.level === 0) {
            // Previous is root-level parent
            return {
              parentId: prevItem.id,
              insertIndex: 0, // Insert as first child
            };
          } else if (prevItem.level === 1) {
            // Previous is a child - become sibling
            return {
              parentId: prevNode.parentId || 'root',
              insertIndex: null, // Append to end of siblings
            };
          }
        }
      }
      // Fallback to root
      return {
        parentId: 'root',
        insertIndex: dropIndex,
      };
    }

    // No zone change - reordering within same level
    // Calculate position among siblings by looking at flattened view
    const parentKey = currentParentId === 'root' ? 'root' : currentParentId;
    const siblings = state.order[parentKey] || [];

    // Find the item at the drop position in flattened view
    const itemAtDropPos = flattened[dropIndex];

    if (!itemAtDropPos) {
      // Dropped at end
      return {
        parentId: currentParentId,
        insertIndex: siblings.length,
      };
    }

    // If the item at drop position is at the same level and has same parent
    if (itemAtDropPos.node.parentId === draggedNode.parentId) {
      // Find its index among siblings
      const targetSiblingIndex = siblings.indexOf(itemAtDropPos.id);

      // No adjustment needed - when we remove the dragged item and reinsert,
      // the target index remains correct because:
      // - Moving down: removal shifts target down, but we want to be where it was
      // - Moving up: removal hasn't happened yet when we calculate position
      return {
        parentId: currentParentId,
        insertIndex: targetSiblingIndex,
      };
    }

    // Item at drop position is different level
    // Look ahead to find next item at same level
    for (let i = dropIndex + 1; i < flattened.length; i++) {
      const nextItem = flattened[i];
      if (nextItem.node.parentId === draggedNode.parentId) {
        // Found next sibling
        const targetIndex = siblings.indexOf(nextItem.id);
        return {
          parentId: currentParentId,
          insertIndex: targetIndex,
        };
      }
    }

    // No more siblings found - append to end
    return {
      parentId: currentParentId,
      insertIndex: siblings.length,
    };
  }
}
