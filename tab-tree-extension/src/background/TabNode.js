/**
 * TabNode - Represents a tab in the hierarchy
 */
export class TabNode {
  /**
   * Create a tab node
   * @param {Object} chromeTab - Chrome tab object
   * @param {number|null} parentId - Parent tab ID (null for root)
   */
  constructor(chromeTab, parentId = null) {
    this.id = chromeTab.id;
    this.parentId = parentId;
    this.url = chromeTab.url || '';
    this.title = chromeTab.title || 'New Tab';
    this.favicon = chromeTab.favIconUrl || '';
    this.windowId = chromeTab.windowId;
    this.isLocked = false;
    this.isPinned = false;
    this.lockUrl = null;
    this.lastVisited = Date.now();
    this.createdAt = Date.now();
  }

  /**
   * Update node from Chrome tab
   * @param {Object} chromeTab - Chrome tab object
   * @param {Object} changeInfo - What changed
   * @returns {boolean} - Whether any updates were made
   */
  update(chromeTab, changeInfo = {}) {
    let updated = false;

    if (changeInfo.title && chromeTab.title) {
      this.title = chromeTab.title;
      updated = true;
    }

    if (changeInfo.favIconUrl && chromeTab.favIconUrl) {
      this.favicon = chromeTab.favIconUrl;
      updated = true;
    }

    if (changeInfo.url && !this.isLocked) {
      this.url = chromeTab.url;
      updated = true;
    }

    return updated;
  }

  /**
   * Lock this tab at current URL
   * @param {string} url - URL to lock to
   */
  lock(url) {
    this.isLocked = true;
    this.lockUrl = url || this.url;
  }

  /**
   * Unlock this tab
   */
  unlock() {
    this.isLocked = false;
    this.lockUrl = null;
  }

  /**
   * Pin this tab (also locks it)
   * @param {string} url - URL to lock to
   */
  pin(url) {
    this.isPinned = true;
    this.lock(url);
  }

  /**
   * Unpin this tab
   */
  unpin() {
    this.isPinned = false;
    this.unlock();
  }

  /**
   * Mark tab as visited
   */
  visit() {
    this.lastVisited = Date.now();
  }

  /**
   * Convert to plain object for storage
   * @returns {Object}
   */
  toJSON() {
    return {
      id: this.id,
      parentId: this.parentId,
      url: this.url,
      title: this.title,
      favicon: this.favicon,
      windowId: this.windowId,
      isLocked: this.isLocked,
      isPinned: this.isPinned,
      lockUrl: this.lockUrl,
      lastVisited: this.lastVisited,
      createdAt: this.createdAt,
    };
  }

  /**
   * Create node from stored object
   * @param {Object} data - Stored node data
   * @returns {TabNode}
   */
  static fromJSON(data) {
    const node = Object.create(TabNode.prototype);
    Object.assign(node, data);
    return node;
  }
}
