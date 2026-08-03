/**
 * TabHierarchy Unit Tests
 */

import { describe, it } from 'node:test';
import assert from 'node:assert';
import { TabHierarchy } from '../../src/background/TabHierarchy.js';
import { TabNode } from '../../src/background/TabNode.js';

describe('TabHierarchy', () => {
  describe('flatten', () => {
    it('should flatten simple root-level tabs', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: null },
          3: { id: 3, parentId: null },
        },
        order: {
          root: [1, 2, 3],
        },
        collapsed: {},
      };

      const result = TabHierarchy.flatten(state);

      assert.strictEqual(result.length, 3);
      assert.strictEqual(result[0].id, 1);
      assert.strictEqual(result[0].level, 0);
      assert.strictEqual(result[1].id, 2);
      assert.strictEqual(result[2].id, 3);
    });

    it('should flatten tree with parent and children', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: 1 },
          3: { id: 3, parentId: 1 },
        },
        order: {
          root: [1],
          1: [2, 3],
        },
        collapsed: {},
      };

      const result = TabHierarchy.flatten(state);

      assert.strictEqual(result.length, 3);
      assert.strictEqual(result[0].id, 1);
      assert.strictEqual(result[0].level, 0);
      assert.strictEqual(result[1].id, 2);
      assert.strictEqual(result[1].level, 1);
      assert.strictEqual(result[2].id, 3);
      assert.strictEqual(result[2].level, 1);
    });

    it('should skip collapsed children when respectCollapse=true', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: 1 },
          3: { id: 3, parentId: 1 },
        },
        order: {
          root: [1],
          1: [2, 3],
        },
        collapsed: { 1: true },
      };

      const result = TabHierarchy.flatten(state, true);

      assert.strictEqual(result.length, 1);
      assert.strictEqual(result[0].id, 1);
    });

    it('should include collapsed children when respectCollapse=false', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: 1 },
        },
        order: {
          root: [1],
          1: [2],
        },
        collapsed: { 1: true },
      };

      const result = TabHierarchy.flatten(state, false);

      assert.strictEqual(result.length, 2);
      assert.strictEqual(result[0].id, 1);
      assert.strictEqual(result[1].id, 2);
    });
  });

  describe('hasAncestor', () => {
    it('should return true if direct parent', () => {
      const tabs = {
        1: { id: 1, parentId: null },
        2: { id: 2, parentId: 1 },
      };

      const result = TabHierarchy.hasAncestor(1, 2, tabs);

      assert.strictEqual(result, true);
    });

    it('should return true if indirect ancestor', () => {
      const tabs = {
        1: { id: 1, parentId: null },
        2: { id: 2, parentId: 1 },
        3: { id: 3, parentId: 2 },
      };

      const result = TabHierarchy.hasAncestor(1, 3, tabs);

      assert.strictEqual(result, true);
    });

    it('should return false if not ancestor', () => {
      const tabs = {
        1: { id: 1, parentId: null },
        2: { id: 2, parentId: null },
      };

      const result = TabHierarchy.hasAncestor(1, 2, tabs);

      assert.strictEqual(result, false);
    });

    it('should return false for same tab', () => {
      const tabs = {
        1: { id: 1, parentId: null },
      };

      const result = TabHierarchy.hasAncestor(1, 1, tabs);

      assert.strictEqual(result, false);
    });

    it('should handle cycles correctly', () => {
      const tabs = {
        1: { id: 1, parentId: 2 },
        2: { id: 2, parentId: 1 },
      };

      // In a cycle where 1→2→1, asking if 1 is ancestor of 2:
      // 2's parent is 1, so YES, 1 is an ancestor of 2
      const result1 = TabHierarchy.hasAncestor(1, 2, tabs);
      assert.strictEqual(result1, true);

      // Similarly, 2 is an ancestor of 1
      const result2 = TabHierarchy.hasAncestor(2, 1, tabs);
      assert.strictEqual(result2, true);

      // The visited set prevents infinite loops
    });
  });

  describe('sortByPriority', () => {
    it('should sort pinned tabs before unpinned', () => {
      const state = {
        tabs: {
          1: { id: 1, isPinned: false },
          2: { id: 2, isPinned: true },
          3: { id: 3, isPinned: false },
        },
        order: {
          root: [1, 2, 3],
        },
      };

      TabHierarchy.sortByPriority(state);

      assert.deepStrictEqual(state.order.root, [2, 1, 3]);
    });

    it('should sort within each parent group', () => {
      const state = {
        tabs: {
          1: { id: 1, isPinned: false },
          2: { id: 2, isPinned: true, parentId: 1 },
          3: { id: 3, isPinned: false, parentId: 1 },
        },
        order: {
          root: [1],
          1: [2, 3],
        },
      };

      TabHierarchy.sortByPriority(state);

      assert.deepStrictEqual(state.order[1], [2, 3]); // Pinned first
    });
  });

  describe('getChildren', () => {
    it('should return children array', () => {
      const order = {
        root: [1],
        1: [2, 3],
      };

      const children = TabHierarchy.getChildren(1, order);

      assert.deepStrictEqual(children, [2, 3]);
    });

    it('should return empty array if no children', () => {
      const order = {
        root: [1],
      };

      const children = TabHierarchy.getChildren(1, order);

      assert.deepStrictEqual(children, []);
    });
  });

  describe('getDescendants', () => {
    it('should return all descendants recursively', () => {
      const order = {
        root: [1],
        1: [2, 3],
        2: [4],
      };

      const descendants = TabHierarchy.getDescendants(1, order);

      assert.deepStrictEqual(descendants, [2, 4, 3]); // DFS order
    });

    it('should return empty array if no descendants', () => {
      const order = {
        root: [1],
      };

      const descendants = TabHierarchy.getDescendants(1, order);

      assert.deepStrictEqual(descendants, []);
    });
  });

  describe('moveTab', () => {
    it('should move tab to new parent', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: null },
          3: { id: 3, parentId: null },
        },
        order: {
          root: [1, 2, 3],
        },
      };

      TabHierarchy.moveTab(3, 1, null, state);

      assert.strictEqual(state.tabs[3].parentId, 1);
      assert.deepStrictEqual(state.order.root, [1, 2]);
      assert.deepStrictEqual(state.order[1], [3]);
    });

    it('should move tab to specific position', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: null },
          3: { id: 3, parentId: null },
        },
        order: {
          root: [1, 2, 3],
        },
      };

      TabHierarchy.moveTab(3, 'root', 1, state);

      assert.deepStrictEqual(state.order.root, [1, 3, 2]); // Inserted at position 1
    });

    it('should throw error on cycle creation', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: 1 },
        },
        order: {
          root: [1],
          1: [2],
        },
      };

      assert.throws(() => {
        TabHierarchy.moveTab(1, 2, null, state); // Try to make 1 child of 2
      }, /cycle/i);
    });
  });

  describe('deduplicateOrder', () => {
    it('should remove duplicates from order arrays', () => {
      const order = {
        root: [1, 2, 1, 3, 2],
        1: [4, 5, 4],
      };

      TabHierarchy.deduplicateOrder(order);

      assert.deepStrictEqual(order.root, [1, 2, 3]);
      assert.deepStrictEqual(order[1], [4, 5]);
    });
  });
});
