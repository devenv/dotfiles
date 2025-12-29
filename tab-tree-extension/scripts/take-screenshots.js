#!/usr/bin/env node
/**
 * Screenshot Generator for Tab Tree Extension
 * Uses demo HTML to generate consistent screenshots without full extension loading
 * Output: screenshots/ directory with PNG files
 */

import { chromium } from 'playwright';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DEMO_HTML = path.resolve(__dirname, './demo-screenshot.html');
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
 * Main screenshot generation process
 */
async function generateScreenshots() {
  let browser = null;

  try {
    setupScreenshotDir();

    // Launch browser
    browser = await chromium.launch({ headless: true });
    const context = await browser.newContext({
      viewport: { width: 1400, height: 900 }
    });

    console.log('\n📸 Capturing screenshots...\n');

    // Open demo page
    const page = await context.newPage();
    const demoUrl = `file://${DEMO_HTML}`;
    await page.goto(demoUrl, { waitUntil: 'networkidle' });

    // Screenshot 1: All demos in one view
    const screenshotPath = path.join(SCREENSHOTS_DIR, 'tab-tree-demo.png');
    await page.screenshot({ path: screenshotPath, fullPage: true });
    console.log(`✓ Captured: tab-tree-demo.png`);
    console.log(`  Shows: Empty sidebar, populated hierarchy, collapsed state, deep nesting`);

    // Take individual sidebar screenshots
    console.log('\n✓ Generating individual sidebar views...\n');

    const sidebarSelector = '.sidebar';
    const sidebars = await page.$$('.sidebar');

    for (let i = 0; i < sidebars.length; i++) {
      const sidebar = sidebars[i];
      const boundingBox = await sidebar.boundingBox();

      if (boundingBox) {
        const filename = [
          'sidebar-01-empty.png',
          'sidebar-02-populated.png',
          'sidebar-03-collapsed.png',
          'sidebar-04-deep.png',
        ][i];

        const descriptions = [
          'Empty sidebar on first load',
          'Populated with auto-nested hierarchy',
          'Parent tab collapsed (▶)',
          'Deep nesting showing indentation',
        ];

        await page.screenshot({
          path: path.join(SCREENSHOTS_DIR, filename),
          clip: {
            x: boundingBox.x - 20,
            y: boundingBox.y - 30,
            width: boundingBox.width + 40,
            height: boundingBox.height + 60,
          },
        });

        console.log(`✓ ${filename}`);
        console.log(`  ${descriptions[i]}`);
      }
    }

    await context.close();

    console.log('\n✅ All screenshots generated successfully!');
    console.log(`📁 Location: ${SCREENSHOTS_DIR}`);

    // List generated files
    const files = fs.readdirSync(SCREENSHOTS_DIR).filter(f => f.endsWith('.png'));
    console.log('\nGenerated files:');
    files.forEach(f => console.log(`  • ${f}`));

  } catch (error) {
    console.error('❌ Error generating screenshots:', error.message);
    process.exit(1);
  } finally {
    if (browser) {
      await browser.close();
      console.log('\n✓ Browser closed');
    }
  }
}

// Run
generateScreenshots();
