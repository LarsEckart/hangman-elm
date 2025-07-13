# Service Worker Implementation for Elm Projects

This document describes a minimal, reusable Service Worker implementation for adding offline functionality to Elm applications.

## Overview

The Service Worker implementation provides:
- **Offline functionality** - Cache essential files for offline access
- **Automatic versioning** - Version-based cache management
- **Cache cleanup** - Automatic removal of old cached versions
- **Build-time integration** - Version injection from package.json

## Architecture

### 1. Service Worker Template (`sw-template.js`)

A template file with placeholder for automatic version injection:

```javascript
// Service Worker Template - Minimal offline caching for Hangman Game
// Version will be automatically injected at build time

const CACHE_NAME = 'hangman-{{VERSION}}';
const urlsToCache = [
  '/',
  '/index.html',
  '/elm.js'
];

// Install event: Cache the application files
self.addEventListener('install', event => {
  console.log('Service Worker installing with cache:', CACHE_NAME);
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('Caching app files');
        return cache.addAll(urlsToCache);
      })
  );
  // Immediately activate the new service worker
  self.skipWaiting();
});

// Activate event: Clean up old caches
self.addEventListener('activate', event => {
  console.log('Service Worker activating');
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            console.log('Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  // Take control of all pages immediately
  self.clients.claim();
});

// Fetch event: Serve from cache when offline
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // Return cached version if available
        if (response) {
          console.log('Serving from cache:', event.request.url);
          return response;
        }
        // Otherwise try to fetch from network
        return fetch(event.request).catch(() => {
          // If network fails, try to serve the main page for navigation requests
          if (event.request.mode === 'navigate') {
            return caches.match('/index.html');
          }
          console.log('Failed to serve:', event.request.url);
          throw new Error('Network error and no cache available');
        });
      })
  );
});
```

### 2. Build Script (`scripts/build-sw.js`)

Generates versioned Service Worker from template:

```javascript
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

    // Clean and recreate dist directory
    const distPath = path.join(__dirname, '..', 'dist');
    if (fs.existsSync(distPath)) {
      fs.rmSync(distPath, { recursive: true, force: true });
    }
    fs.mkdirSync(distPath, { recursive: true });

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
```

### 3. HTML Enhancement Script (`scripts/add-viewport.js`)

Adds Service Worker registration to the generated HTML:

```javascript
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const htmlPath = path.join(__dirname, '..', 'dist', 'index.html');

console.log('Adding viewport meta tag and service worker to generated HTML...');

try {
  // Read the generated HTML file
  const htmlContent = fs.readFileSync(htmlPath, 'utf8');
  
  // Service Worker registration script
  const serviceWorkerScript = `
<script>
// Register Service Worker for offline functionality
if ('serviceWorker' in navigator) {
  window.addEventListener('load', function() {
    navigator.serviceWorker.register('/sw.js')
      .then(function(registration) {
        console.log('Service Worker registered with scope:', registration.scope);
      })
      .catch(function(error) {
        console.log('Service Worker registration failed:', error);
      });
  });
}
</script>`;
  
  // Find the charset meta tag and add viewport after it
  const updatedContent = htmlContent
    .replace(
      /<meta charset="UTF-8">/,
      '<meta charset="UTF-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
    )
    .replace(
      /<title>Main<\/title>/,
      '<title>Hangman Game</title>'
    )
    .replace(
      /<\/head>/,
      `${serviceWorkerScript}\n</head>`
    );
  
  // Write the updated HTML back
  fs.writeFileSync(htmlPath, updatedContent);
  
  console.log('✓ Viewport meta tag added successfully');
  console.log('✓ Title updated to "Hangman Game"');
  console.log('✓ Service Worker registration added');
  
} catch (error) {
  console.error('Error updating HTML:', error.message);
  process.exit(1);
}
```

## Package.json Integration

Add these scripts to your `package.json`:

```json
{
  "scripts": {
    "build-sw": "node scripts/build-sw.js",
    "build": "npm run build-sw && elm make src/Main.elm --output=dist/index.html --optimize && node scripts/add-viewport.js"
  }
}
```

## Setup Instructions for New Elm Projects

### 1. Create File Structure

```
your-elm-project/
├── sw-template.js          # Service Worker template
├── scripts/
│   ├── build-sw.js        # Service Worker build script
│   └── add-viewport.js    # HTML enhancement script
└── package.json           # With build scripts
```

### 2. Customize the Template

In `sw-template.js`, update:
- **Cache name prefix**: Change `'hangman-{{VERSION}}'` to `'your-app-{{VERSION}}'`
- **URLs to cache**: Add/remove files in `urlsToCache` array
- **App name**: Update comments and console.log messages

### 3. Customize HTML Enhancement

In `scripts/add-viewport.js`, update:
- **Title replacement**: Change `'Hangman Game'` to your app name
- **Additional meta tags**: Add any other meta tags your app needs

### 4. Build Process

Run the build process:
```bash
npm run build
```

This will:
1. Generate `dist/sw.js` with current version from `package.json`
2. Compile your Elm app to `dist/index.html`
3. Add Service Worker registration to the HTML

## Key Features

### Automatic Versioning
- Cache names include version from `package.json`
- Each version update creates new cache
- Old caches automatically cleaned up

### Minimal Overhead
- Only caches essential files (`/` and `/index.html`)
- Simple cache-first strategy
- No unnecessary complexity

### Build-time Integration
- Version injection happens at build time
- No runtime version checks needed
- Clean separation of template and output

### Offline Fallback
- Serves cached content when offline
- Graceful degradation for missing resources
- Console logging for debugging

## Customization Options

### Add More Files to Cache
Update `urlsToCache` in `sw-template.js`:
```javascript
const urlsToCache = [
  '/',
  '/index.html',
  '/elm.js',           // Required for Elm apps
  '/assets/app.css',
  '/assets/icon.png'
];
```

**Important**: Always include `/elm.js` for Elm applications, as the app cannot function offline without the compiled JavaScript.

### Change Cache Strategy
Modify the fetch event listener for different caching strategies:
- **Network first**: Try network, fallback to cache
- **Cache first**: Current implementation
- **Stale while revalidate**: Serve from cache, update in background

### Add Offline Page
1. Create an offline page
2. Add it to `urlsToCache`
3. Update fetch event to serve offline page when both cache and network fail

## Troubleshooting

### Service Worker Not Working Offline

**Problem**: App shows error when going offline instead of cached content.

**Common Causes**:
1. **Missing elm.js in cache** - Add `/elm.js` to `urlsToCache` array
2. **Broken fetch handler** - Ensure fetch event returns proper responses
3. **Build process issues** - Verify Service Worker is being generated correctly

**Solutions**:
```javascript
// 1. Include all essential files
const urlsToCache = [
  '/',
  '/index.html',
  '/elm.js'  // Critical for Elm apps
];

// 2. Fix fetch handler to properly handle failures
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        if (response) {
          return response;
        }
        return fetch(event.request).catch(() => {
          // Handle navigation requests when offline
          if (event.request.mode === 'navigate') {
            return caches.match('/index.html');
          }
          throw new Error('Network error and no cache available');
        });
      })
  );
});
```

### Testing Offline Functionality

1. **Load page online first** - Service Worker needs to cache resources
2. **Check DevTools Application tab** - Verify Service Worker is active
3. **Use offline simulation** - DevTools → Application → Service Workers → check "Offline"
4. **Look for console messages** - Should see "Serving from cache" when offline

### Build Process Issues

**Problem**: CSS/styling missing after adding Service Worker.

**Solution**: Update build process to preserve original HTML with styling:
```bash
# Instead of compiling directly to index.html
elm make src/Main.elm --output=dist/elm.js --optimize
cp index.html dist/
```

**Problem**: Duplicate meta tags or Service Worker scripts.

**Solution**: Update enhancement script to check for existing elements before adding.

## Benefits

- **Zero configuration** - Works out of the box
- **Version-safe** - Automatic cache invalidation on updates
- **Minimal footprint** - Only essential offline functionality
- **Reusable** - Easy to adapt for any Elm project
- **Build-integrated** - Fits standard Elm build workflows

This approach provides reliable offline functionality with minimal complexity, perfect for Elm applications that need basic offline support.