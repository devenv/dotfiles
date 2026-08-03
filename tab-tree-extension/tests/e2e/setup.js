/**
 * Playwright + Chrome Extension Test Setup
 * Handles extension loading and side panel access
 */

import { chromium } from 'playwright';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const EXTENSION_PATH = path.resolve(__dirname, '../../dist');

/**
 * Launch Chrome with the extension loaded
 * @returns {Promise<{context, extensionId, sidePanelUrl}>}
 */
export async function launchWithExtension() {
  console.log('Extension path:', EXTENSION_PATH);

  const context = await chromium.launchPersistentContext('', {
    headless: false, // Extensions require visible browser
    args: [
      `--disable-extensions-except=${EXTENSION_PATH}`,
      `--load-extension=${EXTENSION_PATH}`,
      '--no-default-browser-check',
      '--no-first-run',
    ],
  });

  // For MVP: Use a placeholder extension ID
  // In real usage, this would be discovered dynamically
  // For testing, we'll try a few common patterns
  const extensionId = await discoverExtensionId(context);

  const sidePanelUrl = `chrome-extension://${extensionId}/src/sidepanel/index.html`;

  return { context, extensionId, sidePanelUrl };
}

/**
 * Try to discover the extension ID
 * @param {BrowserContext} context
 * @returns {Promise<string>}
 */
async function discoverExtensionId(context) {
  // Try opening new page and checking URLs in the background
  const testPage = await context.newPage();

  // Try to find service worker with retry
  for (let i = 0; i < 15; i++) {
    const workers = context.serviceWorkers();
    console.log(`Service workers available: ${workers.length}`);

    if (workers.length > 0) {
      for (const worker of workers) {
        const url = worker.url();
        console.log('Worker URL:', url);
        if (url.startsWith('chrome-extension://')) {
          const id = url.split('/')[2];
          if (id) {
            await testPage.close();
            return id;
          }
        }
      }
    }

    // Also try opening the new tab page which might trigger extension detection
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

  // Fallback: Try common extension ID pattern
  // This is a workaround for testing - in real usage we'd get the actual ID
  throw new Error('Could not discover extension ID. Service workers: ' + context.serviceWorkers().length);
}

/**
 * Get the tab ID from a page
 * Note: This requires special handling via service worker
 * @param {Page} page - Playwright page object
 * @returns {Promise<number>} - Chrome tab ID
 */
export async function getTabId(page) {
  // Retrieve current tab ID by querying tabs
  const currentUrl = page.url();
  const tabs = await chrome.tabs.query({ url: currentUrl });
  return tabs[0]?.id;
}

/**
 * Wait for a tab to be created with specific properties
 * @param {BrowserContext} context - Playwright context
 * @param {Object} options - Search options (url, title, etc.)
 * @param {number} timeout - Timeout in ms
 * @returns {Promise<Page>} - The created page
 */
export async function waitForNewTab(context, options = {}, timeout = 5000) {
  const startTime = Date.now();

  while (Date.now() - startTime < timeout) {
    const pages = context.pages();
    for (const page of pages) {
      const url = page.url();
      if (options.url && url.includes(options.url)) {
        return page;
      }
    }
    await new Promise(r => setTimeout(r, 100));
  }

  throw new Error(`Tab not found with options: ${JSON.stringify(options)}`);
}

/**
 * Helper: Create test tabs in Chrome
 * @param {BrowserContext} context - Browser context
 * @param {string[]} urls - URLs to open
 * @returns {Promise<Page[]>} - Array of opened pages
 */
export async function createTestTabs(context, urls) {
  const pages = [];
  for (const url of urls) {
    const page = await context.newPage();
    await page.goto(url, { waitUntil: 'domcontentloaded' });
    pages.push(page);
  }
  return pages;
}

/**
 * Wait for element to have specific text
 * @param {Page} page - Page object
 * @param {string} selector - CSS selector
 * @param {string} text - Expected text content
 * @param {number} timeout - Timeout in ms
 */
export async function waitForText(page, selector, text, timeout = 5000) {
  const startTime = Date.now();

  while (Date.now() - startTime < timeout) {
    const element = await page.$(selector);
    if (element) {
      const content = await element.textContent();
      if (content.includes(text)) {
        return;
      }
    }
    await new Promise(r => setTimeout(r, 100));
  }

  throw new Error(`Text "${text}" not found in selector "${selector}"`);
}
