/**
 * Shared Constants - Message Types, Config
 * Used by both Service Worker and Side Panel
 */

/**
 * Message types for communication between Service Worker and Side Panel
 * @type {Object}
 */
export const MSG_TYPES = {
  // Side Panel → Service Worker (requests)
  GET_STATE: 'get_state',
  LOCK_TAB: 'lock_tab',
  UNLOCK_TAB: 'unlock_tab',
  SET_PARENT: 'set_parent',
  REMOVE_PARENT: 'remove_parent',
  TOGGLE_COLLAPSE: 'toggle_collapse',
  COLLAPSE_ALL: 'collapse_all',
  EXPAND_ALL: 'expand_all',
  PIN_TAB: 'pin_tab',
  UNPIN_TAB: 'unpin_tab',
  SET_AUTO_UNLOAD: 'set_auto_unload',
  CLOSE_TAB: 'close_tab',
  MOVE_TAB: 'move_tab',
  REORDER_TABS: 'reorder_tabs',

  // Service Worker → Side Panel (broadcasts)
  STATE_CHANGED: 'state_changed',
  TAB_CREATED: 'tab_created',
  TAB_REMOVED: 'tab_removed',
  TAB_UPDATED: 'tab_updated',
};

/**
 * Extension settings
 * @type {Object}
 */
export const SETTINGS = {
  maxHierarchyLevel: 1,
  enableAutoNesting: true,
  confirmCloseWithChildren: true,
  debounceDelayMs: 500,
  autoUnloadThreshold: 0.5, // Minutes (0 = Never, 0.5 = 30 seconds)
};

/**
 * Storage keys
 * @type {Object}
 */
export const STORAGE_KEYS = {
  TABS: 'tabs',
  ORDER: 'order',
  COLLAPSED: 'collapsed',
  SETTINGS: 'settings',
};

/**
 * Default empty state
 * @type {Object}
 */
export const DEFAULT_STATE = {
  tabs: {},
  order: { root: [] },
  collapsed: {},
  settings: SETTINGS,
};
