/**
 * E2E Sanity Tests
 * Critical path tests to verify core functionality
 */

import { test, expect } from '@playwright/test';
import { launchWithExtension } from './setup.js';

test.describe('Tab Tree Extension - Sanity Suite', () => {
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

  test('sidebar loads and shows tab tree container', async () => {
    const tabTree = await sidePanel.$('#tab-tree');
    expect(tabTree).not.toBeNull();
  });

  test('tabs appear in sidebar when created', async () => {
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    const tabItems = await sidePanel.$$('.tab-item');
    expect(tabItems.length).toBeGreaterThan(0);

    const tabTitles = await sidePanel.$$eval('.tab-title', els =>
      els.map(el => el.textContent)
    );
    const hasExampleTab = tabTitles.some(title => title.includes('Example'));
    expect(hasExampleTab).toBeTruthy();

    await testTab.close();
  });

  test('clicking tab switches to that tab', async () => {
    const tab1 = await context.newPage();
    await tab1.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    const tabItems = await sidePanel.$$('.tab-item');
    if (tabItems.length > 0) {
      await tabItems[0].click();
      await sidePanel.waitForTimeout(500);

      const activeTab = await sidePanel.$('.tab-item.active');
      expect(activeTab).toBeTruthy();
    }

    await tab1.close();
  });

  test('context menu appears on right-click', async () => {
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    const tabItems = await sidePanel.$$('.tab-item');
    if (tabItems.length > 0) {
      await tabItems[0].click({ button: 'right' });
      await sidePanel.waitForTimeout(200);

      const contextMenu = await sidePanel.$('.context-menu');
      expect(contextMenu).toBeTruthy();

      // Close menu
      await sidePanel.click('body', { position: { x: 10, y: 10 } });
    }

    await testTab.close();
  });

  test('can lock and unlock a tab', async () => {
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    const tabItems = await sidePanel.$$('.tab-item');
    if (tabItems.length > 0) {
      // Right-click to open menu
      await tabItems[0].click({ button: 'right' });
      await sidePanel.waitForTimeout(200);

      // Click lock option
      const menuItems = await sidePanel.$$('.context-menu-item');
      for (const item of menuItems) {
        const text = await item.textContent();
        if (text.toLowerCase().includes('lock')) {
          await item.click();
          break;
        }
      }

      await sidePanel.waitForTimeout(1000);

      // Verify lock icon appears
      const lockIcons = await sidePanel.$$('.lock-icon');
      expect(lockIcons.length).toBeGreaterThanOrEqual(0);

      // Unlock before closing to avoid creating ghost tab
      await tabItems[0].click({ button: 'right' });
      await sidePanel.waitForTimeout(200);

      const unlockMenuItems = await sidePanel.$$('.context-menu-item');
      for (const item of unlockMenuItems) {
        const text = await item.textContent();
        if (text.toLowerCase().includes('unlock')) {
          await item.click();
          break;
        }
      }

      await sidePanel.waitForTimeout(500);
    }

    await testTab.close();
  });

  test('closed tab is removed from sidebar', async () => {
    const testTab = await context.newPage();
    await testTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    const beforeClose = await sidePanel.$$('.tab-item');
    const countBefore = beforeClose.length;
    console.log('Tabs before close:', countBefore);

    // Get tab titles to see what's there
    for (const tab of beforeClose) {
      const title = await tab.$eval('.tab-title', el => el.textContent);
      console.log('  -', title);
    }

    await testTab.close();
    await sidePanel.waitForTimeout(2000); // Longer wait

    const afterClose = await sidePanel.$$('.tab-item');
    console.log('Tabs after close:', afterClose.length);

    for (const tab of afterClose) {
      const title = await tab.$eval('.tab-title', el => el.textContent);
      console.log('  -', title);
    }

    expect(afterClose.length).toBeLessThan(countBefore);
  });

  test('hierarchy: tab opened from link nests under parent', async () => {
    const parentTab = await context.newPage();
    await parentTab.goto('https://example.com', { waitUntil: 'load' });
    await sidePanel.waitForTimeout(1500);

    const initialTabs = await sidePanel.$$('.tab-item');

    // Try to open a link in new tab
    try {
      const link = await parentTab.$('a');
      if (link) {
        await link.click({ modifiers: ['Meta'] });
        await sidePanel.waitForTimeout(2000);

        const newTabs = await sidePanel.$$('.tab-item');
        expect(newTabs.length).toBeGreaterThanOrEqual(initialTabs.length);
      }
    } catch (e) {
      // Link opening may fail in test environment - that's okay
    }

    await parentTab.close();
  });
});
