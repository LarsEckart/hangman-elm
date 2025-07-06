#!/bin/bash

# Build script for Hangman Elm project
# This script performs the complete build process including:
# 1. Building word lists from CSV files
# 2. Generating Service Worker with automatic versioning
# 3. Compiling Elm to HTML
# 4. Adding viewport meta tag and Service Worker registration to HTML

set -e  # Exit on error

echo "🚀 Starting Hangman Elm build process..."
echo ""

# Step 1: Build word lists
echo "📝 Building embedded word lists..."
npm run build-wordlists

# Check if word lists were generated successfully
if [ ! -f "src/Generated/WordLists.elm" ]; then
    echo "❌ Error: WordLists.elm was not generated!"
    exit 1
fi

echo ""
echo "⚙️ Generating Service Worker with automatic versioning..."

# Step 2: Build Service Worker
npm run build-sw

# Check if Service Worker was generated successfully
if [ ! -f "dist/sw.js" ]; then
    echo "❌ Error: Service Worker was not generated!"
    exit 1
fi

echo ""
echo "🔨 Compiling Elm application..."

# Step 3: Compile Elm to HTML
elm make src/Main.elm --output=dist/index.html

# Check if Elm compilation was successful
if [ ! -f "dist/index.html" ]; then
    echo "❌ Error: Elm compilation failed!"
    exit 1
fi

echo ""
echo "🎨 Adding viewport meta tag and Service Worker registration..."

# Step 4: Add viewport meta tag and Service Worker registration
node scripts/add-viewport.js

echo ""
echo "✅ Build completed successfully!"
echo "📦 Output: dist/index.html + dist/sw.js"
echo "🔧 Features: Offline support via Service Worker"
echo ""
echo "🌐 To deploy: Push to main branch for automatic Netlify deployment"
echo "🎮 Live demo: https://hangman-claudecode.netlify.app/"