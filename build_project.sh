#!/bin/bash

# Build script for Hangman Elm project
# This script proxies to npm run build for consistency

set -e  # Exit on error

echo "🚀 Starting Hangman Elm build process..."
echo ""

# Run the complete build process via npm
npm run build

echo ""
echo "✅ Build completed successfully!"
echo "📦 Output: dist/index.html + dist/sw.js"
echo "🔧 Features: Offline support via Service Worker"
echo ""
echo "🌐 To deploy: Push to main branch for automatic Netlify deployment"
echo "🎮 Live demo: https://hangman-claudecode.netlify.app/"