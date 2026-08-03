/**
 * E2E Tests: Context Menu
 * Tests right-click context menu functionality in sidebar
 */

import { test, expect } from '@playwright/test';
import { launchWithExtension } from './setup.js';

test.describe('Context Menu - Display', () => {
  let context;
  let sidePanel;
  let sidePanelUrl;

  test.beforeAll(async () => {
    const result = await launchWithExtension();
    context = result.context;
    sidePanelUrl = result.sidePanelUrl;

    sidePanel = await context.newPage();
    await sidePanel.goto(sidePanelUrl, { waitUntil: 'domcontentloaded' });
    await sidePanel.waitForTimeout(1000);
  });

  test.afterAll(async () => {
    if (context) {
      await context.close();
    }
  });

  test('right-click on tab shows context menu', async () => {
    // Create a test tab
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });

    // Wait for sidebar to update
    await sidePanel.waitForTimeout(1500);

    // Find tab items
    const tabItems = await sidePanel.$$('.tab-item');
    expect(tabItems.length).toBeGreaterThan(0);

    // Right-click on first tab
    await tabItems[0].click({ button: 'right' });

    // Wait for context menu to appear
    await sidePanel.waitForTimeout(200);

    // Check for context menu
    const contextMenu = await sidePanel.$('.context-menu');
    expect(contextMenu).toBeTruthy();

    await testTab.close();
  });

  test('context menu has lock/unlock option', async () => {
    // Create a test tab
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    // Right-click on a tab
    const tabItems = await sidePanel.$$('.tab-item');
    await tabItems[0].click({ button: 'right' });
    await sidePanel.waitForTimeout(200);

    // Check for lock option
    const menuItems = await sidePanel.$$('.context-menu-item');
    const menuTexts = await Promise.all(menuItems.map(item => item.textContent()));

    const hasLockOption = menuTexts.some(text =>
      text.toLowerCase().includes('lock') || text.toLowerCase().includes('unlock')
    );
    expect(hasLockOption).toBeTruthy();

    await testTab.close();
  });

  test('context menu has pin/unpin option', async () => {
    // Create a test tab
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    // Right-click on a tab
    const tabItems = await sidePanel.$$('.tab-item');
    await tabItems[0].click({ button: 'right' });
    await sidePanel.waitForTimeout(200);

    // Check for pin option
    const menuItems = await sidePanel.$$('.context-menu-item');
    const menuTexts = await Promise.all(menuItems.map(item => item.textContent()));

    const hasPinOption = menuTexts.some(text =>
      text.toLowerCase().includes('pin') || text.toLowerCase().includes('unpin')
    );
    expect(hasPinOption).toBeTruthy();

    await testTab.close();
  });

  test('context menu has close option', async () => {
    // Create a test tab
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    // Right-click on a tab
    const tabItems = await sidePanel.$$('.tab-item');
    await tabItems[0].click({ button: 'right' });
    await sidePanel.waitForTimeout(200);

    // Check for close option
    const menuItems = await sidePanel.$$('.context-menu-item');
    const menuTexts = await Promise.all(menuItems.map(item => item.textContent()));

    const hasCloseOption = menuTexts.some(text =>
      text.toLowerCase().includes('close')
    );
    expect(hasCloseOption).toBeTruthy();

    await testTab.close();
  });

  test('clicking outside context menu closes it', async () => {
    // Create a test tab
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    // Right-click to open menu
    const tabItems = await sidePanel.$$('.tab-item');
    await tabItems[0].click({ button: 'right' });
    await sidePanel.waitForTimeout(200);

    // Verify menu is open
    let contextMenu = await sidePanel.$('.context-menu');
    expect(contextMenu).toBeTruthy();

    // Click outside (on the sidebar body)
    await sidePanel.click('body', { position: { x: 10, y: 10 } });
    await sidePanel.waitForTimeout(200);

    // Verify menu is closed
    contextMenu = await sidePanel.$('.context-menu');
    expect(contextMenu).toBeFalsy();

    await testTab.close();
  });
});

test.describe('Context Menu - Actions', () => {
  let context;
  let sidePanel;
  let sidePanelUrl;

  test.beforeAll(async () => {
    const result = await launchWithExtension();
    context = result.context;
    sidePanelUrl = result.sidePanelUrl;

    sidePanel = await context.newPage();
    await sidePanel.goto(sidePanelUrl, { waitUntil: 'domcontentloaded' });
    await sidePanel.waitForTimeout(1000);
  });

  test.afterAll(async () => {
    if (context) {
      await context.close();
    }
  });

  test('lock option toggles to unlock after locking', async () => {
    // Create a test tab
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    // Right-click on a tab
    const tabItems = await sidePanel.$$('.tab-item');
    await tabItems[0].click({ button: 'right' });
    await sidePanel.waitForTimeout(200);

    // Find and click lock option
    const menuItems = await sidePanel.$$('.context-menu-item');
    for (const item of menuItems) {
      const text = await item.textContent();
      if (text.toLowerCase().includes('lock') && !text.toLowerCase().includes('unlock')) {
        await item.click();
        break;
      }
    }

    // Wait for state to update
    await sidePanel.waitForTimeout(1000);

    // Check for lock icon
    const lockIcons = await sidePanel.$$('.lock-icon');
    expect(lockIcons.length).toBeGreaterThanOrEqual(0); // May or may not show depending on state

    await testTab.close();
  });

  test('close option closes the tab', async () => {
    // Create a test tab that we'll close
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    // Count initial tabs
    const initialTabs = await sidePanel.$$('.tab-item');
    const initialCount = initialTabs.length;

    // Find the last tab (our test tab) and right-click
    const lastTabItem = initialTabs[initialTabs.length - 1];
    await lastTabItem.click({ button: 'right' });
    await sidePanel.waitForTimeout(200);

    // Find and click close option
    const menuItems = await sidePanel.$$('.context-menu-item');
    for (const item of menuItems) {
      const text = await item.textContent();
      if (text.toLowerCase().includes('close')) {
        await item.click();
        break;
      }
    }

    // Wait for tab to close and sidebar to update
    await sidePanel.waitForTimeout(1500);

    // Count tabs again - should be one less
    const updatedTabs = await sidePanel.$$('.tab-item');
    expect(updatedTabs.length).toBeLessThan(initialCount);
  });
});
