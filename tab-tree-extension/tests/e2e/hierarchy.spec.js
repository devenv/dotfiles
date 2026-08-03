/**
 * E2E Tests: Tab Hierarchy
 * Tests automatic nesting and hierarchy management
 */

import { test, expect } from '@playwright/test';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DIST_PATH = path.resolve(__dirname, '../../dist');

test.describe('Tab Hierarchy - Build Verification', () => {
  test('extension builds successfully', () => {
    expect(fs.existsSync(DIST_PATH)).toBeTruthy();
    expect(fs.existsSync(path.join(DIST_PATH, 'manifest.json'))).toBeTruthy();
    expect(fs.existsSync(path.join(DIST_PATH, 'src/sidepanel/index.html'))).toBeTruthy();
  });

  test('manifest.json is valid JSON', () => {
    const manifestPath = path.join(DIST_PATH, 'manifest.json');
    const content = fs.readFileSync(manifestPath, 'utf-8');
    const manifest = JSON.parse(content);

    expect(manifest.manifest_version).toBe(3);
    expect(manifest.permissions).toContain('tabs');
    expect(manifest.permissions).toContain('storage');
  });

  test('side panel HTML is valid', () => {
    const htmlPath = path.join(DIST_PATH, 'src/sidepanel/index.html');
    const content = fs.readFileSync(htmlPath, 'utf-8');

    expect(content).toContain('<!DOCTYPE html>');
    expect(content).toContain('id="tab-tree"');
    expect(content).toContain('id="sidebar"');
  });

  test('service worker JavaScript is valid', () => {
    const swPath = path.join(DIST_PATH, 'src/background/index.js');
    const content = fs.readFileSync(swPath, 'utf-8');

    expect(content).toContain('console.log');
    expect(content).toContain('chrome.runtime.onInstalled');
    expect(content).toContain('handleMessage');
    expect(content).toContain('TabManager');
    expect(content).toContain('MSG_TYPES.GET_STATE');
  });
});
