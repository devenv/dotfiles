#!/usr/bin/env node
/**
 * Screenshot Generator for Tab Tree Extension
 * Captures the extension sidebar in various states
 * Output: screenshots/ directory with PNG files
 */

import { chromium } from 'playwright';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const EXTENSION_PATH = path.resolve(__dirname, '../dist');
const SCREENSHOTS_DIR = path.resolve(__dirname, '../screenshots');

/**
 * Ensure screenshots directory exists
 */
function setupScreenshotDir() {
  if (!fs.existsSync(SCREENSHOTS_DIR)) {
    fs.mkdirSync(SCREENSHOTS_DIR, { recursive: true });
    console.log(`✓ Created ${SCREENSHOTS_DIR}`);
  }
}

/**
 * Launch Chrome with the extension loaded
 */
async function launchWithExtension() {
  console.log('Launching extension from:', EXTENSION_PATH);

  const context = await chromium.launchPersistentContext('', {
    headless: false,
    args: [
      `--disable-extensions-except=${EXTENSION_PATH}`,
      `--load-extension=${EXTENSION_PATH}`,
      '--no-default-browser-check',
      '--no-first-run',
    ],
  });

  const extensionId = await discoverExtensionId(context);
  console.log('Extension ID:', extensionId);

  const sidePanelUrl = `chrome-extension://${extensionId}/src/sidepanel/index.html`;

  return { context, extensionId, sidePanelUrl };
}

/**
 * Discover extension ID from service worker
 */
async function discoverExtensionId(context) {
  const testPage = await context.newPage();

  for (let i = 0; i < 15; i++) {
    const workers = context.serviceWorkers();

    if (workers.length > 0) {
      for (const worker of workers) {
        const url = worker.url();
        if (url.startsWith('chrome-extension://')) {
          const id = url.split('/')[2];
          if (id) {
            await testPage.close();
            return id;
          }
        }
      }
    }

    if (i === 5) {
      try {
        await testPage.goto('chrome://newtab', { waitUntil: 'domcontentloaded' }).catch(() => {});
      } catch (e) {
        // Ignore errors
      }
    }

    console.log(`Waiting for extension... (${i + 1}/15)`);
    await new Promise(r => setTimeout(r, 1000));
  }

  await testPage.close();
  throw new Error('Could not discover extension ID');
}

/**
 * Capture screenshot and save to file
 */
async function captureScreenshot(page, filename, description) {
  const filepath = path.join(SCREENSHOTS_DIR, filename);
  await page.screenshot({ path: filepath, fullPage: true });
  console.log(`✓ Captured: ${filename} - ${description}`);
  return filepath;
}

/**
 * Main screenshot generation process
 */
async function generateScreenshots() {
  let context = null;

  try {
    setupScreenshotDir();

    const { context: ctx, sidePanelUrl } = await launchWithExtension();
    context = ctx;

    // Open side panel
    console.log('\nOpening side panel...');
    const sidePanel = await context.newPage();
    await sidePanel.goto(sidePanelUrl, { waitUntil: 'domcontentloaded' });
    await sidePanel.waitForTimeout(500); // Let UI initialize

    // Screenshot 1: Empty sidebar
    console.log('\n📸 Capturing screenshots...');
    await captureScreenshot(sidePanel, '01-empty-sidebar.png', 'Empty sidebar on startup');

    // Create some test tabs to show hierarchy
    console.log('\nCreating test tabs...');
    const testUrls = [
      'https://github.com',
      'https://github.com/search?q=chrome+extension',
      'https://docs.chrome.com',
      'https://docs.chrome.com/webstore',
      'https://twitter.com',
    ];

    const pages = [];
    for (const url of testUrls) {
      const page = await context.newPage();
      await page.goto(url, { waitUntil: 'domcontentloaded' });
      pages.push(page);
      console.log(`  ✓ Opened: ${url}`);
    }

    // Wait for tabs to appear in sidebar
    await sidePanel.waitForTimeout(1000);
    await sidePanel.reload({ waitUntil: 'domcontentloaded' });
    await sidePanel.waitForTimeout(500);

    // Screenshot 2: Populated sidebar
    await captureScreenshot(sidePanel, '02-populated-sidebar.png', 'Sidebar with 5 tabs and auto-hierarchy');

    // Try to collapse a parent tab if one exists
    console.log('\nTesting collapse functionality...');
    const toggleButtons = await sidePanel.$$('.toggle-icon');
    if (toggleButtons.length > 0) {
      console.log(`  Found ${toggleButtons.length} collapsible tabs`);
      // Click first toggle button
      await toggleButtons[0].click();
      await sidePanel.waitForTimeout(300);
      await captureScreenshot(sidePanel, '03-collapsed-parent.png', 'Parent tab collapsed, children hidden');

      // Expand it again
      await toggleButtons[0].click();
      await sidePanel.waitForTimeout(300);
      await captureScreenshot(sidePanel, '04-expanded-parent.png', 'Parent tab expanded, children visible');
    } else {
      console.log('  No collapsible parents yet (single-level depth)');
    }

    // Screenshot 5: Click on a tab to show active state
    console.log('\nTesting tab switching...');
    const tabItems = await sidePanel.$$('.tab-item');
    if (tabItems.length > 1) {
      // Click second tab
      await tabItems[1].click();
      await sidePanel.waitForTimeout(300);
      await captureScreenshot(sidePanel, '05-active-tab.png', 'Tab switching - different tab active');
    }

    // Screenshot 6: Full page for documentation
    await captureScreenshot(sidePanel, '06-full-sidebar.png', 'Complete sidebar view');

    console.log('\n✅ All screenshots captured successfully!');
    console.log(`📁 Location: ${SCREENSHOTS_DIR}`);

    // List generated files
    const files = fs.readdirSync(SCREENSHOTS_DIR).filter(f => f.endsWith('.png'));
    console.log('\nGenerated files:');
    files.forEach(f => console.log(`  • ${f}`));

    // Close test pages
    for (const page of pages) {
      await page.close();
    }
    await sidePanel.close();

  } catch (error) {
    console.error('❌ Error generating screenshots:', error.message);
    process.exit(1);
  } finally {
    if (context) {
      await context.close();
      console.log('\n✓ Browser closed');
    }
  }
}

// Run
generateScreenshots();
