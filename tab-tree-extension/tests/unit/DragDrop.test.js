/**
 * Drag-Drop Logic Unit Tests
 * Tests all drag-drop scenarios to ensure correct parent/position calculation
 */

import { describe, it } from 'node:test';
import assert from 'node:assert';
import { TabHierarchy } from '../../src/background/TabHierarchy.js';

describe('Drag-Drop calculateDropTarget', () => {
  describe('Reordering siblings at root level', () => {
    it('should reorder [1,2,3] to [2,1,3] when dragging 2 to position 0', () => {
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

      const result = TabHierarchy.calculateDropTarget(2, 0, null, state);

      assert.strictEqual(result.parentId, 'root');
      assert.strictEqual(result.insertIndex, 0);
    });

    it('should reorder [1,2,3] to [1,3,2] when dragging 3 to position 1', () => {
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

      const result = TabHierarchy.calculateDropTarget(3, 1, null, state);

      assert.strictEqual(result.parentId, 'root');
      assert.strictEqual(result.insertIndex, 1);
    });

    it('should reorder [1,2,3] to [2,3,1] when dragging 1 to end', () => {
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

      const result = TabHierarchy.calculateDropTarget(1, 2, null, state);

      assert.strictEqual(result.parentId, 'root');
      // When moving down, adjust for removal
      assert.strictEqual(result.insertIndex, 1);
    });
  });

  describe('Reordering children under same parent', () => {
    it('should reorder children [2,3] to [3,2] under parent 1', () => {
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

      // Tab 3 is at visual index 2, moving to visual index 1
      const result = TabHierarchy.calculateDropTarget(3, 1, null, state);

      assert.strictEqual(result.parentId, 1);
      assert.strictEqual(result.insertIndex, 1);
    });
  });

  describe('Moving root tab to become child (zone right)', () => {
    it('should make tab 3 a child of tab 1 when dragging to right zone', () => {
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

      // Dragging tab 3 to right zone, drop after tab 1 (index 1)
      const result = TabHierarchy.calculateDropTarget(3, 1, 'right', state);

      assert.strictEqual(result.parentId, 1); // Becomes child of tab 1
      assert.strictEqual(result.insertIndex, 0); // First child
    });

    it('should make tab 2 sibling of existing children when dropping in right zone', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: null },
          3: { id: 3, parentId: 1 },
        },
        order: {
          root: [1, 2],
          1: [3],
        },
        collapsed: {},
      };

      // Dragging tab 2 to right zone, drop after tab 3 (child of 1)
      const result = TabHierarchy.calculateDropTarget(2, 2, 'right', state);

      assert.strictEqual(result.parentId, 1); // Becomes sibling of tab 3
      assert.strictEqual(result.insertIndex, null); // Append to end
    });
  });

  describe('Moving child to become root (zone left)', () => {
    it('should make child tab root when dragging to left zone', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: 1 },
        },
        order: {
          root: [1],
          1: [2],
        },
        collapsed: {},
      };

      // Dragging tab 2 to left zone, position 0
      const result = TabHierarchy.calculateDropTarget(2, 0, 'left', state);

      assert.strictEqual(result.parentId, 'root');
      assert.strictEqual(result.insertIndex, 0);
    });
  });

  describe('Moving parent with children', () => {
    it('should allow reordering parent tab at root level', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: 1 },
          3: { id: 3, parentId: null },
        },
        order: {
          root: [1, 3],
          1: [2],
        },
        collapsed: {},
      };

      // Dragging parent tab 1 to position 1 (after tab 3)
      const result = TabHierarchy.calculateDropTarget(1, 1, null, state);

      assert.strictEqual(result.parentId, 'root');
      assert.strictEqual(result.insertIndex, 0); // Adjusted for removal
    });
  });

  describe('Complex hierarchies', () => {
    it('should handle mixed root and child tabs correctly', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: 1 },
          3: { id: 3, parentId: 1 },
          4: { id: 4, parentId: null },
          5: { id: 5, parentId: 4 },
        },
        order: {
          root: [1, 4],
          1: [2, 3],
          4: [5],
        },
        collapsed: {},
      };

      // Visual order: 1, 2, 3, 4, 5
      // Move tab 5 to become child of tab 1 (right zone at position 1)
      const result = TabHierarchy.calculateDropTarget(5, 1, 'right', state);

      assert.strictEqual(result.parentId, 1);
      assert.strictEqual(result.insertIndex, 0);
    });

    it('should handle moving to end of siblings correctly', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: 1 },
          3: { id: 3, parentId: 1 },
          4: { id: 4, parentId: 1 },
        },
        order: {
          root: [1],
          1: [2, 3, 4],
        },
        collapsed: {},
      };

      // Move tab 2 to end (position 3)
      const result = TabHierarchy.calculateDropTarget(2, 3, null, state);

      assert.strictEqual(result.parentId, 1);
      assert.strictEqual(result.insertIndex, 2); // Adjusted for removal
    });
  });

  describe('Edge cases', () => {
    it('should handle empty children arrays', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
          2: { id: 2, parentId: null },
        },
        order: {
          root: [1, 2],
        },
        collapsed: {},
      };

      const result = TabHierarchy.calculateDropTarget(2, 0, null, state);

      assert.strictEqual(result.parentId, 'root');
      assert.strictEqual(result.insertIndex, 0);
    });

    it('should handle single tab', () => {
      const state = {
        tabs: {
          1: { id: 1, parentId: null },
        },
        order: {
          root: [1],
        },
        collapsed: {},
      };

      const result = TabHierarchy.calculateDropTarget(1, 0, null, state);

      assert.strictEqual(result.parentId, 'root');
    });
  });
});
