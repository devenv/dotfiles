/**
 * Unit Tests: Tab Manager Core Logic
 * Tests pure functions and state management logic
 */

import { test, describe } from 'node:test';
import assert from 'node:assert';

// Mock Chrome API
global.chrome = {
  tabs: {
    move: async () => {},
    query: async () => [],
    get: async () => ({ id: 1, url: 'https://example.com' }),
    update: async () => {},
    remove: async () => {},
  },
  runtime: {
    sendMessage: async () => {},
  },
};

// Mock storage
const mockStorage = {
  state: null,
  getState: async function() {
    return this.state || { tabs: {}, order: { root: [] }, collapsed: {} };
  },
  setState: async function(state) {
    this.state = state;
  },
};

// Helper: Create test state
function createTestState(tabs, order) {
  return {
    tabs,
    order: order || { root: Object.keys(tabs).map(Number) },
    collapsed: {},
  };
}

// Helper: Flatten tree (copy of the function from tab-manager.js)
function flattenTreeForReorder(state) {
  const result = [];

  function traverse(parentKey, level = 0) {
    const tabIds = state.order[parentKey] || [];

    for (const tabId of tabIds) {
      const node = state.tabs[tabId];
      if (!node) continue;

      result.push({ id: tabId, level });
      traverse(tabId, level + 1);
    }
  }

  traverse('root', 0);
  return result;
}

// Helper: Cycle detection (copy of hasAncestor from tab-manager.js)
function hasAncestor(tabId, potentialAncestorId, state) {
  let current = state.tabs[tabId];
  const visited = new Set();

  while (current && current.parentId !== null) {
    if (visited.has(current.id)) {
      console.warn(`Detected existing cycle at tab ${current.id}`);
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

describe('flattenTreeForReorder', () => {
  test('flattens simple list of root tabs', () => {
    const state = createTestState({
      1: { id: 1, parentId: null },
      2: { id: 2, parentId: null },
      3: { id: 3, parentId: null },
    }, { root: [1, 2, 3] });

    const flattened = flattenTreeForReorder(state);

    assert.strictEqual(flattened.length, 3);
    assert.deepStrictEqual(flattened, [
      { id: 1, level: 0 },
      { id: 2, level: 0 },
      { id: 3, level: 0 },
    ]);
  });

  test('flattens tree with one level of children', () => {
    const state = createTestState({
      1: { id: 1, parentId: null },
      2: { id: 2, parentId: 1 },
      3: { id: 3, parentId: 1 },
      4: { id: 4, parentId: null },
    }, { root: [1, 4], 1: [2, 3] });

    const flattened = flattenTreeForReorder(state);

    assert.strictEqual(flattened.length, 4);
    assert.deepStrictEqual(flattened, [
      { id: 1, level: 0 },
      { id: 2, level: 1 },
      { id: 3, level: 1 },
      { id: 4, level: 0 },
    ]);
  });

  test('flattens nested tree structure', () => {
    const state = createTestState({
      1: { id: 1, parentId: null },
      2: { id: 2, parentId: 1 },
      3: { id: 3, parentId: 2 },
      4: { id: 4, parentId: null },
    }, { root: [1, 4], 1: [2], 2: [3] });

    const flattened = flattenTreeForReorder(state);

    assert.strictEqual(flattened.length, 4);
    assert.deepStrictEqual(flattened, [
      { id: 1, level: 0 },
      { id: 2, level: 1 },
      { id: 3, level: 2 },
      { id: 4, level: 0 },
    ]);
  });

  test('handles empty state', () => {
    const state = createTestState({}, { root: [] });
    const flattened = flattenTreeForReorder(state);
    assert.strictEqual(flattened.length, 0);
  });

  test('ignores missing tabs in order array', () => {
    const state = createTestState({
      1: { id: 1, parentId: null },
      3: { id: 3, parentId: null },
    }, { root: [1, 2, 3] }); // Tab 2 is missing

    const flattened = flattenTreeForReorder(state);

    assert.strictEqual(flattened.length, 2);
    assert.deepStrictEqual(flattened, [
      { id: 1, level: 0 },
      { id: 3, level: 0 },
    ]);
  });
});

describe('hasAncestor (cycle detection)', () => {
  test('detects direct parent as ancestor', () => {
    const state = createTestState({
      1: { id: 1, parentId: null },
      2: { id: 2, parentId: 1 },
    }, { root: [1], 1: [2] });

    assert.strictEqual(hasAncestor(2, 1, state), true);
  });

  test('detects grandparent as ancestor', () => {
    const state = createTestState({
      1: { id: 1, parentId: null },
      2: { id: 2, parentId: 1 },
      3: { id: 3, parentId: 2 },
    }, { root: [1], 1: [2], 2: [3] });

    assert.strictEqual(hasAncestor(3, 1, state), true);
  });

  test('returns false when no ancestor relationship', () => {
    const state = createTestState({
      1: { id: 1, parentId: null },
      2: { id: 2, parentId: null },
      3: { id: 3, parentId: 2 },
    }, { root: [1, 2], 2: [3] });

    assert.strictEqual(hasAncestor(3, 1, state), false);
  });

  test('returns false for root tabs', () => {
    const state = createTestState({
      1: { id: 1, parentId: null },
      2: { id: 2, parentId: null },
    }, { root: [1, 2] });

    assert.strictEqual(hasAncestor(1, 2, state), false);
  });

  test('detects circular reference cycle', () => {
    const state = createTestState({
      1: { id: 1, parentId: 2 },
      2: { id: 2, parentId: 1 },
    }, { 1: [2], 2: [1] });

    // Should detect cycle and return true to prevent further corruption
    assert.strictEqual(hasAncestor(1, 2, state), true);
  });

  test('handles self-referential cycle', () => {
    const state = createTestState({
      1: { id: 1, parentId: 1 },
    }, { 1: [1] });

    // Should detect cycle immediately
    assert.strictEqual(hasAncestor(1, 1, state), true);
  });

  test('handles missing parent in chain gracefully', () => {
    const state = createTestState({
      1: { id: 1, parentId: null },
      2: { id: 2, parentId: 999 }, // Parent doesn't exist
    }, { root: [1] });

    // Should not crash, should return false
    assert.strictEqual(hasAncestor(2, 1, state), false);
  });
});

describe('Chrome tab index calculation', () => {
  test('calculates correct indices for flat list', () => {
    const state = createTestState({
      10: { id: 10, parentId: null },
      20: { id: 20, parentId: null },
      30: { id: 30, parentId: null },
    }, { root: [10, 20, 30] });

    const flattened = flattenTreeForReorder(state);

    // Tab 10 should be at index 0
    assert.strictEqual(flattened.findIndex(t => t.id === 10), 0);
    // Tab 20 should be at index 1
    assert.strictEqual(flattened.findIndex(t => t.id === 20), 1);
    // Tab 30 should be at index 2
    assert.strictEqual(flattened.findIndex(t => t.id === 30), 2);
  });

  test('calculates correct indices with hierarchy', () => {
    const state = createTestState({
      10: { id: 10, parentId: null },
      20: { id: 20, parentId: 10 },
      30: { id: 30, parentId: 10 },
      40: { id: 40, parentId: null },
    }, { root: [10, 40], 10: [20, 30] });

    const flattened = flattenTreeForReorder(state);

    // Tab 10 at index 0 (parent)
    assert.strictEqual(flattened.findIndex(t => t.id === 10), 0);
    // Tab 20 at index 1 (first child)
    assert.strictEqual(flattened.findIndex(t => t.id === 20), 1);
    // Tab 30 at index 2 (second child)
    assert.strictEqual(flattened.findIndex(t => t.id === 30), 2);
    // Tab 40 at index 3 (next root)
    assert.strictEqual(flattened.findIndex(t => t.id === 40), 3);
  });
});
