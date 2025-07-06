#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Build Service Worker with automatic version injection
// This script reads the template and injects the version from package.json

function buildServiceWorker() {
  try {
    // Read package.json to get version
    const packageJsonPath = path.join(__dirname, '..', 'package.json');
    const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
    const version = packageJson.version;

    // Read service worker template
    const templatePath = path.join(__dirname, '..', 'sw-template.js');
    const template = fs.readFileSync(templatePath, 'utf8');

    // Replace version placeholder
    const serviceWorker = template.replace('{{VERSION}}', version);

    // Ensure dist directory exists
    const distPath = path.join(__dirname, '..', 'dist');
    if (!fs.existsSync(distPath)) {
      fs.mkdirSync(distPath, { recursive: true });
    }

    // Write service worker to dist directory
    const outputPath = path.join(distPath, 'sw.js');
    fs.writeFileSync(outputPath, serviceWorker);

    console.log(`✓ Service Worker generated with version ${version}`);
    console.log(`✓ Output: ${outputPath}`);
    
    return true;
  } catch (error) {
    console.error('❌ Error building Service Worker:', error.message);
    return false;
  }
}

// Run the build if called directly
if (require.main === module) {
  const success = buildServiceWorker();
  process.exit(success ? 0 : 1);
}

module.exports = buildServiceWorker;