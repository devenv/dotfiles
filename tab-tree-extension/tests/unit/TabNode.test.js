/**
 * TabNode Unit Tests
 */

import { describe, it } from 'node:test';
import assert from 'node:assert';
import { TabNode } from '../../src/background/TabNode.js';

describe('TabNode', () => {
  describe('constructor', () => {
    it('should create node from Chrome tab', () => {
      const chromeTab = {
        id: 1,
        url: 'https://example.com',
        title: 'Example',
        favIconUrl: 'https://example.com/favicon.ico',
        windowId: 100,
      };

      const node = new TabNode(chromeTab);

      assert.strictEqual(node.id, 1);
      assert.strictEqual(node.url, 'https://example.com');
      assert.strictEqual(node.title, 'Example');
      assert.strictEqual(node.favicon, 'https://example.com/favicon.ico');
      assert.strictEqual(node.windowId, 100);
      assert.strictEqual(node.parentId, null);
      assert.strictEqual(node.isLocked, false);
      assert.strictEqual(node.isPinned, false);
    });

    it('should set parent ID if provided', () => {
      const chromeTab = { id: 2, url: 'https://example.com' };
      const node = new TabNode(chromeTab, 1);

      assert.strictEqual(node.parentId, 1);
    });

    it('should handle missing optional fields', () => {
      const chromeTab = { id: 3 };
      const node = new TabNode(chromeTab);

      assert.strictEqual(node.url, '');
      assert.strictEqual(node.title, 'New Tab');
      assert.strictEqual(node.favicon, '');
    });
  });

  describe('update', () => {
    it('should update title and return true', () => {
      const node = new TabNode({ id: 1, title: 'Old Title' });
      const updated = node.update(
        { title: 'New Title' },
        { title: true }
      );

      assert.strictEqual(updated, true);
      assert.strictEqual(node.title, 'New Title');
    });

    it('should update favicon and return true', () => {
      const node = new TabNode({ id: 1 });
      const updated = node.update(
        { favIconUrl: 'https://example.com/new.ico' },
        { favIconUrl: true }
      );

      assert.strictEqual(updated, true);
      assert.strictEqual(node.favicon, 'https://example.com/new.ico');
    });

    it('should update URL if not locked', () => {
      const node = new TabNode({ id: 1, url: 'https://old.com' });
      const updated = node.update(
        { url: 'https://new.com' },
        { url: true }
      );

      assert.strictEqual(updated, true);
      assert.strictEqual(node.url, 'https://new.com');
    });

    it('should not update URL if locked', () => {
      const node = new TabNode({ id: 1, url: 'https://old.com' });
      node.lock('https://old.com');

      const updated = node.update(
        { url: 'https://new.com' },
        { url: true }
      );

      assert.strictEqual(updated, false);
      assert.strictEqual(node.url, 'https://old.com');
    });

    it('should return false if nothing changed', () => {
      const node = new TabNode({ id: 1 });
      const updated = node.update({}, {});

      assert.strictEqual(updated, false);
    });
  });

  describe('lock/unlock', () => {
    it('should lock tab with URL', () => {
      const node = new TabNode({ id: 1, url: 'https://example.com' });
      node.lock('https://example.com');

      assert.strictEqual(node.isLocked, true);
      assert.strictEqual(node.lockUrl, 'https://example.com');
    });

    it('should use current URL if not provided', () => {
      const node = new TabNode({ id: 1, url: 'https://example.com' });
      node.lock();

      assert.strictEqual(node.isLocked, true);
      assert.strictEqual(node.lockUrl, 'https://example.com');
    });

    it('should unlock tab', () => {
      const node = new TabNode({ id: 1 });
      node.lock('https://example.com');
      node.unlock();

      assert.strictEqual(node.isLocked, false);
      assert.strictEqual(node.lockUrl, null);
    });
  });

  describe('pin/unpin', () => {
    it('should pin tab and lock it', () => {
      const node = new TabNode({ id: 1, url: 'https://example.com' });
      node.pin('https://example.com');

      assert.strictEqual(node.isPinned, true);
      assert.strictEqual(node.isLocked, true);
      assert.strictEqual(node.lockUrl, 'https://example.com');
    });

    it('should unpin tab and unlock it', () => {
      const node = new TabNode({ id: 1 });
      node.pin('https://example.com');
      node.unpin();

      assert.strictEqual(node.isPinned, false);
      assert.strictEqual(node.isLocked, false);
      assert.strictEqual(node.lockUrl, null);
    });
  });

  describe('visit', () => {
    it('should update lastVisited timestamp', () => {
      const node = new TabNode({ id: 1 });
      const oldTime = node.lastVisited;

      // Wait a bit
      setTimeout(() => {
        node.visit();
        assert.ok(node.lastVisited > oldTime);
      }, 10);
    });
  });

  describe('toJSON/fromJSON', () => {
    it('should serialize to plain object', () => {
      const node = new TabNode({ id: 1, url: 'https://example.com', title: 'Test' });
      node.lock('https://example.com');

      const json = node.toJSON();

      assert.strictEqual(json.id, 1);
      assert.strictEqual(json.url, 'https://example.com');
      assert.strictEqual(json.title, 'Test');
      assert.strictEqual(json.isLocked, true);
      assert.strictEqual(json.lockUrl, 'https://example.com');
    });

    it('should deserialize from plain object', () => {
      const data = {
        id: 2,
        url: 'https://test.com',
        title: 'Test Tab',
        isLocked: true,
        lockUrl: 'https://test.com',
        parentId: 1,
      };

      const node = TabNode.fromJSON(data);

      assert.strictEqual(node.id, 2);
      assert.strictEqual(node.url, 'https://test.com');
      assert.strictEqual(node.title, 'Test Tab');
      assert.strictEqual(node.isLocked, true);
      assert.strictEqual(node.lockUrl, 'https://test.com');
      assert.strictEqual(node.parentId, 1);
    });
  });
});
