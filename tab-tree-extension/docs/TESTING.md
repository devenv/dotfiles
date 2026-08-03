# Testing Guide

Tab Tree uses **Playwright** for end-to-end testing.

## Running Tests

```bash
# Run all tests
npm test

# Run with browser visible
npm test -- --headed

# Watch mode (re-run on file changes)
npm run test:watch

# Debug mode (interactive)
npm test -- --debug

# Run specific test file
npm test -- tests/e2e/hierarchy.spec.js

# View test results
npx playwright show-report
```

## Test Structure

Tests are located in `tests/e2e/`:

```
tests/e2e/
  setup.js           # Utilities for extension loading
  hierarchy.spec.js  # Tab hierarchy tests
  locking.spec.js    # Locked tabs tests
  dragdrop.spec.js   # Drag-drop tests
  pinned.spec.js     # Pinned tabs tests
```

## Writing Tests

### Simple File-Based Tests (MVP Phase)

```javascript
import { test, expect } from '@playwright/test';
import fs from 'fs';
import path from 'path';

test('manifest has correct version', () => {
  const manifest = JSON.parse(
    fs.readFileSync('./dist/manifest.json', 'utf-8')
  );
  expect(manifest.manifest_version).toBe(3);
});
```

### Full Browser Tests (Phase 2+)

```javascript
import { test, expect } from '@playwright/test';
import { launchWithExtension } from './setup.js';

test('clicking tab switches to it', async () => {
  const { context, sidePanelUrl } = await launchWithExtension();

  // Open side panel
  const panel = await context.newPage();
  await panel.goto(sidePanelUrl);

  // Test interaction
  await panel.click('.tab-item');

  // Verify result
  const active = await panel.locator('.tab-item.active');
  await expect(active).toBeVisible();

  await context.close();
});
```

## Test Utilities

### `launchWithExtension()`

Launches Chrome with extension loaded:

```javascript
const { context, extensionId, sidePanelUrl } = await launchWithExtension();

// Open side panel
const panel = await context.newPage();
await panel.goto(sidePanelUrl);

// Use like normal Playwright page
await panel.click('.button');
const text = await panel.textContent('.title');

await context.close();
```

### `createTestTabs(context, urls)`

Creates multiple test tabs:

```javascript
const [tab1, tab2] = await createTestTabs(context, [
  'https://example.com',
  'https://google.com'
]);

// Interact with tabs
await tab1.click('a');
```

### `waitForNewTab(context, options, timeout)`

Wait for a new tab to open:

```javascript
const newTab = await waitForNewTab(context, { url: 'example.com' });
```

## Test Patterns

### Verifying Storage

```javascript
// In service worker tests
const { tabs, order } = await chrome.storage.local.get(['tabs', 'order']);
expect(Object.keys(tabs).length).toBeGreaterThan(0);
```

### Verifying UI Updates

```javascript
// Wait for element to appear
await expect(panel.locator('.tab-item')).toBeVisible();

// Check element count
const items = panel.locator('.tab-item');
await expect(items).toHaveCount(3);

// Check attributes
const element = panel.locator('[data-tab-id="123"]');
await expect(element).toHaveAttribute('data-locked', 'true');
```

### Testing User Interactions

```javascript
// Click
await panel.click('.tab-item');

// Type
await panel.fill('input[type="text"]', 'search term');

// Drag and drop
const source = panel.locator('[data-tab-id="1"]');
const target = panel.locator('[data-tab-id="2"]');
await source.dragTo(target);

// Right-click context menu
await panel.click('.tab-item', { button: 'right' });
await panel.click('text=Lock Tab');
```

## Debugging Tests

### View Test Report

```bash
npx playwright show-report
```

### Run with Debug UI

```bash
npm test -- --debug
```

### Slow Down Tests

```bash
PWDEBUG=1 npm test
```

### Take Screenshots

```javascript
test('feature works', async () => {
  const panel = await context.newPage();
  await panel.goto(sidePanelUrl);

  // Test code

  // Save screenshot
  await panel.screenshot({ path: './screenshots/feature.png' });
});
```

Screenshots are saved to `test-results/` automatically on failure.

### View Traces

Tests record traces which can be viewed:

```bash
npx playwright show-trace ./test-results/trace.zip
```

## Adding a New Test File

1. Create file: `tests/e2e/feature-name.spec.js`
2. Import test and expect: `import { test, expect } from '@playwright/test'`
3. Import setup helpers: `import { launchWithExtension } from './setup.js'`
4. Write tests using `test()` and `expect()`
5. Run: `npm test -- tests/e2e/feature-name.spec.js`

## Common Assertions

```javascript
// Visibility
await expect(element).toBeVisible();
await expect(element).toBeHidden();

// Text
await expect(element).toContainText('hello');
await expect(element).toHaveText('exact text');

// Attributes
await expect(element).toHaveAttribute('disabled');
await expect(element).toHaveAttribute('data-id', '123');

// Classes
await expect(element).toHaveClass('active');

// Count
await expect(locator).toHaveCount(5);

// Enabled/disabled
await expect(button).toBeEnabled();
await expect(button).toBeDisabled();
```

## Test Performance

- Keep individual tests < 10 seconds
- Use `waitForTimeout` sparingly (prefer observable changes)
- Close contexts/pages to avoid memory leaks
- Run tests in series (not parallel) for extension testing

## CI/CD

When tests run in CI:

```bash
npm run build
npm test
```

All tests must pass before merging.

## Troubleshooting

**Tests timeout**: Increase timeout in `playwright.config.js`
**Browser won't launch**: Check Chrome is installed, run `npx playwright install`
**Service worker not found**: Extension loading is WIP, use file-based tests for MVP
**Screenshot issues**: Check `test-results/` directory exists and is writable
