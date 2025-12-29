#!/usr/bin/env node

/**
 * Build script for Tab Tree Extension
 * Copies source files to dist/ directory for testing/packaging
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(__dirname, '..');
const srcDir = path.join(projectRoot, 'src');
const distDir = path.join(projectRoot, 'dist');
const manifestFile = path.join(projectRoot, 'manifest.json');

/**
 * Recursively copy directory
 */
function copyDirSync(src, dest) {
  if (!fs.existsSync(dest)) {
    fs.mkdirSync(dest, { recursive: true });
  }

  const files = fs.readdirSync(src);

  for (const file of files) {
    const srcPath = path.join(src, file);
    const destPath = path.join(dest, file);

    const stats = fs.statSync(srcPath);

    if (stats.isDirectory()) {
      copyDirSync(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

async function build() {
  try {
    console.log('Building extension...');

    // Clean dist directory
    if (fs.existsSync(distDir)) {
      fs.rmSync(distDir, { recursive: true, force: true });
    }

    // Create dist directory
    fs.mkdirSync(distDir, { recursive: true });

    // Copy source files
    copyDirSync(srcDir, path.join(distDir, 'src'));

    // Copy manifest
    fs.copyFileSync(manifestFile, path.join(distDir, 'manifest.json'));

    // Copy icons if they exist
    const iconsDir = path.join(projectRoot, 'icons');
    if (fs.existsSync(iconsDir)) {
      copyDirSync(iconsDir, path.join(distDir, 'icons'));
    }

    console.log('✓ Build complete!');
    console.log(`  Output: ${distDir}`);
  } catch (error) {
    console.error('✗ Build failed:', error.message);
    process.exit(1);
  }
}

build();
