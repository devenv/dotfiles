/**
 * Type Definitions (JSDoc)
 * Shared between Service Worker and Side Panel
 */

/**
 * Represents a single tab in the hierarchy
 * @typedef {Object} TabNode
 * @property {number} id - Chrome tab ID (unique)
 * @property {number|null} parentId - Parent tab ID (null = root level)
 * @property {string} url - Current tab URL
 * @property {string} title - Tab title (shown in sidebar)
 * @property {string} favicon - Favicon URL (empty string if not available)
 * @property {boolean} isLocked - Is this tab locked? (can't close, URL resets)
 * @property {string|null} lockUrl - Original URL to revert to if locked
 * @property {boolean} isPinned - Is this tab pinned? (appears at top)
 * @property {boolean} isCollapsed - Is this parent tab collapsed? (children hidden)
 * @property {number} createdAt - Timestamp of tab creation (milliseconds)
 * @property {number} windowId - Chrome window ID this tab belongs to
 */

/**
 * Application state stored in chrome.storage.local
 * @typedef {Object} AppState
 * @property {Object<string, TabNode>} tabs - Map of all tabs by ID
 * @property {Object<string, number[]>} order - Tab order at each level
 * @property {Object<string, boolean>} collapsed - Collapse state of parent tabs
 * @property {Object} settings - Extension settings
 */

/**
 * Message sent between Service Worker and Side Panel
 * @typedef {Object} Message
 * @property {string} type - Message type from MSG_TYPES
 * @property {Object} payload - Message-specific data
 */

export const types = {};
