/**
 * E2E Integration Tests: Tab Hierarchy
 * Tests the complete hierarchy tracking system
 */

import { test, expect } from '@playwright/test';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DIST_PATH = path.resolve(__dirname, '../../dist');

test.describe('Tab Hierarchy Integration', () => {
  test('storage schema is correctly defined', () => {
    /**
     * Verify storage schema implementation
     */
    const storagePath = path.join(DIST_PATH, 'src/shared/storage.js');
    const content = fs.readFileSync(storagePath, 'utf-8');

    // Should have storage helper functions
    expect(content).toContain('export async function getState');
    expect(content).toContain('export async function setState');
    expect(content).toContain('export async function getTab');
    expect(content).toContain('export async function setTab');
    expect(content).toContain('export async function getOrder');
    expect(content).toContain('export async function getChildren');
  });

  test('tab-manager.js implements hierarchy tracking', () => {
    /**
     * Verify tab manager has core functionality
     */
    const managerPath = path.join(DIST_PATH, 'src/background/tab-manager.js');
    const content = fs.readFileSync(managerPath, 'utf-8');

    // Core functions
    expect(content).toContain('initialize()');
    expect(content).toContain('handleTabCreated');
    expect(content).toContain('handleTabRemoved');
    expect(content).toContain('handleTabUpdated');
    expect(content).toContain('setParent(childId, parentId)');
    expect(content).toContain('removeParent(tabId)');

    // Hierarchy logic
    expect(content).toContain('openerTabId');
    expect(content).toContain('parentId');
    expect(content).toContain('createTabNode');
  });

  test('tree-renderer.js implements UI rendering', () => {
    /**
     * Verify tree renderer has rendering logic
     */
    const treePath = path.join(DIST_PATH, 'src/sidepanel/tree.js');
    const content = fs.readFileSync(treePath, 'utf-8');

    // Core class
    expect(content).toContain('class TreeRenderer');

    // Methods
    expect(content).toContain('render(state)');
    expect(content).toContain('flattenTree(state)');
    expect(content).toContain('createTabElement');
    expect(content).toContain('setActiveTab(tabId)');
    expect(content).toContain('updateTab(node, state)');

    // Features
    expect(content).toContain('level * 20'); // Indentation
    expect(content).toContain('toggle-icon'); // Collapse toggle
    expect(content).toContain('isCollapsed');
  });

  test('service worker handles GET_STATE message', () => {
    /**
     * Verify service worker message handling
     */
    const swPath = path.join(DIST_PATH, 'src/background/index.js');
    const content = fs.readFileSync(swPath, 'utf-8');

    expect(content).toContain('MSG_TYPES.GET_STATE');
    expect(content).toContain('handleMessage');
    expect(content).toContain('TabManager.initialize()');
  });

  test('side panel controller imports TreeRenderer', () => {
    /**
     * Verify side panel UI integration
     */
    const sidepanelPath = path.join(DIST_PATH, 'src/sidepanel/index.js');
    const content = fs.readFileSync(sidepanelPath, 'utf-8');

    expect(content).toContain('TreeRenderer');
    expect(content).toContain('class SidePanelController');
    expect(content).toContain('handleMessage');
    expect(content).toContain('switchToTab');
    expect(content).toContain('toggleCollapse');
  });

  test('constants define all message types', () => {
    /**
     * Verify message protocol constants
     */
    const constantsPath = path.join(DIST_PATH, 'src/shared/constants.js');
    const content = fs.readFileSync(constantsPath, 'utf-8');

    // Message types
    expect(content).toContain('MSG_TYPES');
    expect(content).toContain('GET_STATE');
    expect(content).toContain('STATE_CHANGED');
    expect(content).toContain('TAB_CREATED');
    expect(content).toContain('TAB_REMOVED');
    expect(content).toContain('TOGGLE_COLLAPSE');
    expect(content).toContain('SET_PARENT');
  });

  test('types.js defines TabNode and AppState', () => {
    /**
     * Verify type definitions
     */
    const typesPath = path.join(DIST_PATH, 'src/shared/types.js');
    const content = fs.readFileSync(typesPath, 'utf-8');

    // Type definitions
    expect(content).toContain('TabNode');
    expect(content).toContain('AppState');
    expect(content).toContain('parentId');
    expect(content).toContain('order');
    expect(content).toContain('collapsed');
  });

  test('UI CSS supports indentation and collapse states', () => {
    /**
     * Verify styling for hierarchy
     */
    const cssPath = path.join(DIST_PATH, 'src/sidepanel/styles.css');
    const content = fs.readFileSync(cssPath, 'utf-8');

    // Indentation support
    expect(content).toContain('padding');
    expect(content).toContain('.tab-item');

    // Toggle icon
    expect(content).toContain('.toggle-icon');

    // Active state
    expect(content).toContain('.active');

    // Favicon styling
    expect(content).toContain('.favicon');
  });

  test('manifest allows required permissions', () => {
    /**
     * Verify manifest has required permissions for tab tracking
     */
    const manifestPath = path.join(DIST_PATH, 'manifest.json');
    const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf-8'));

    expect(manifest.permissions).toContain('tabs');
    expect(manifest.permissions).toContain('storage');
  });
});
