/**
 * Side Panel Controller
 * Manages UI and communication with service worker
 */

import { TreeRenderer } from './tree.js';
import { MSG_TYPES } from '../shared/constants.js';

class SidePanelController {
  constructor() {
    this.state = {
      tabs: {},
      order: { root: [] },
      collapsed: {},
      settings: {},
    };
    this.containerEl = document.getElementById('tab-tree');
    this.treeRenderer = new TreeRenderer(
      this.containerEl,
      (tabId) => this.switchToTab(tabId),
      (tabId) => this.toggleCollapse(tabId),
      (tabId, newParentId, newIndex) => this.moveTab(tabId, newParentId, newIndex)
    );
    this.activeTabId = null;
  }

  async initialize() {
    console.log('Side Panel: Initializing...');

    // Fetch initial state
    await this.refreshState();

    // Listen for messages from service worker
    chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
      console.log('Side Panel: Received message:', message.type);
      this.handleMessage(message);
    });

    // Listen for active tab changes
    chrome.tabs.onActivated.addListener(({ tabId, windowId }) => {
      this.onTabActivated(tabId);
    });

    // Get current active tab
    const activeTabs = await chrome.tabs.query({ active: true });
    if (activeTabs.length > 0) {
      this.activeTabId = activeTabs[0].id;
      this.treeRenderer.setActiveTab(this.activeTabId);
    }

    // Periodically refresh state to catch updates from service worker
    // This ensures tabs created/removed show up immediately
    setInterval(() => this.refreshState(), 500);

    console.log('Side Panel: Ready');
  }

  /**
   * Fetch and render current state from service worker
   */
  async refreshState() {
    try {
      const response = await chrome.runtime.sendMessage({
        type: MSG_TYPES.GET_STATE,
      });

      if (response.success) {
        console.log('Side Panel: Got state with', Object.keys(response.state.tabs || {}).length, 'tabs');

        // Compare state by checking if anything changed
        const newStateStr = JSON.stringify(response.state);
        const oldStateStr = JSON.stringify(this.state);

        if (newStateStr !== oldStateStr) {
          this.state = response.state;
          console.log('Side Panel: State updated, re-rendering');
          await this.treeRenderer.render(this.state);

          // Update active tab highlight
          if (this.activeTabId) {
            this.treeRenderer.setActiveTab(this.activeTabId);
          }
        }
      }
    } catch (error) {
      console.error('Side Panel: Error refreshing state:', error);
    }
  }

  /**
   * Handle messages from service worker
   * @param {Object} message - Message object with type and payload
   */
  async handleMessage(message) {
    console.log('Side Panel: Message received:', message.type);

    switch (message.type) {
      case MSG_TYPES.STATE_CHANGED:
        this.state = message.payload;
        await this.treeRenderer.render(this.state);
        break;

      case MSG_TYPES.TAB_CREATED:
        // Refresh state and re-render
        await this.refreshState();
        break;

      case MSG_TYPES.TAB_REMOVED:
        // Refresh state and re-render
        console.log('Side Panel: Tab removed, refreshing state');
        await this.refreshState();
        break;

      case MSG_TYPES.TAB_UPDATED:
        // Update just this tab's info
        const node = message.payload;
        this.treeRenderer.updateTab(node, this.state);
        break;
    }
  }

  /**
   * Switch to a specific tab (or recreate if it's a ghost)
   * @param {number} tabId - Tab ID to switch to
   */
  async switchToTab(tabId) {
    try {
      // Try to activate the tab
      await chrome.tabs.update(tabId, { active: true });
    } catch (error) {
      // Tab doesn't exist - check if it's a locked ghost tab
      const response = await chrome.runtime.sendMessage({
        type: MSG_TYPES.GET_STATE,
      });

      if (response.success) {
        const node = response.state.tabs[tabId];

        if (node && node.isLocked) {
          // Recreate locked tab
          console.log('Recreating locked tab:', node.title);
          const newTab = await chrome.tabs.create({
            url: node.lockUrl || node.url,
            active: true,
          });

          // Send message to update tab ID in state
          await chrome.runtime.sendMessage({
            type: MSG_TYPES.RECREATE_TAB,
            payload: { oldId: tabId, newId: newTab.id },
          });
        } else {
          console.error('Failed to switch to tab:', error);
        }
      }
    }
  }

  /**
   * Toggle collapse state of a parent tab
   * @param {number} tabId - Parent tab ID
   */
  async toggleCollapse(tabId) {
    try {
      const response = await chrome.runtime.sendMessage({
        type: MSG_TYPES.TOGGLE_COLLAPSE,
        payload: { tabId },
      });

      if (response.success) {
        this.state = response.state;
        await this.treeRenderer.render(this.state);
      }
    } catch (error) {
      console.error('Error toggling collapse:', error);
    }
  }

  /**
   * Move a tab via drag-drop
   * @param {number} tabId - Tab ID being moved
   * @param {string|number} newParentId - New parent ('root' or tab ID)
   * @param {number} newIndex - New position in the flat list
   */
  async moveTab(tabId, newParentId, newIndex) {
    console.log('Side Panel: Moving tab', { tabId, newParentId, newIndex });
    try {
      const response = await chrome.runtime.sendMessage({
        type: MSG_TYPES.MOVE_TAB,
        payload: { tabId, newParentId, newIndex },
      });

      if (response.success) {
        this.state = response.state;
        await this.treeRenderer.render(this.state);
      }
    } catch (error) {
      console.error('Error moving tab:', error);
    }
  }

  /**
   * Handle active tab change
   * @param {number} tabId - Newly active tab ID
   */
  onTabActivated(tabId) {
    this.activeTabId = tabId;
    this.treeRenderer.setActiveTab(tabId);
  }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  const controller = new SidePanelController();
  controller.initialize();

  // Collapse All button
  document.getElementById('collapse-all-btn')?.addEventListener('click', async () => {
    try {
      await chrome.runtime.sendMessage({ type: MSG_TYPES.COLLAPSE_ALL });
    } catch (error) {
      console.error('Failed to collapse all:', error);
    }
  });

  // Expand All button
  document.getElementById('expand-all-btn')?.addEventListener('click', async () => {
    try {
      await chrome.runtime.sendMessage({ type: MSG_TYPES.EXPAND_ALL });
    } catch (error) {
      console.error('Failed to expand all:', error);
    }
  });

  // Auto-unload slider
  const slider = document.getElementById('auto-unload-slider');
  const valueLabel = document.getElementById('auto-unload-value');

  const thresholdLabels = ['30 sec', '5 min', '15 min', '30 min', '1 hour', '6 hours', '1 day', '3 days', '1 week', 'Never'];
  const thresholdValues = [0.5, 5, 15, 30, 60, 360, 1440, 4320, 10080, 0]; // Minutes (0 = Never, 0.5 = 30 seconds)

  if (slider && valueLabel) {
    // Update label on change
    slider.addEventListener('input', (e) => {
      const index = parseInt(e.target.value);
      valueLabel.textContent = thresholdLabels[index];
    });

    // Save to storage on change
    slider.addEventListener('change', async (e) => {
      const index = parseInt(e.target.value);
      const threshold = thresholdValues[index];
      try {
        await chrome.runtime.sendMessage({
          type: MSG_TYPES.SET_AUTO_UNLOAD,
          payload: { threshold },
        });
        console.log(`Auto-unload threshold set to ${threshold} minutes`);
      } catch (error) {
        console.error('Failed to set auto-unload threshold:', error);
      }
    });

    // Load saved value (don't await, run async)
    chrome.runtime.sendMessage({ type: MSG_TYPES.GET_STATE })
      .then((state) => {
        if (state.success && state.state.settings) {
          const threshold = state.state.settings.autoUnloadThreshold ?? 0;
          const index = thresholdValues.indexOf(threshold);
          if (index !== -1) {
            slider.value = index;
            valueLabel.textContent = thresholdLabels[index];
          }
        }
      })
      .catch((error) => {
        console.error('Failed to load auto-unload setting:', error);
      });
  }
});
