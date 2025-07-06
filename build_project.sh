#!/bin/bash

# Build script for Hangman Elm project
# This script performs the complete build process including:
# 1. Building word lists from CSV files
# 2. Compiling Elm to HTML
# 3. Adding viewport meta tag to the generated HTML

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
echo "🔨 Compiling Elm application..."

# Step 2: Compile Elm to HTML
elm make src/Main.elm --output=dist/index.html

# Check if Elm compilation was successful
if [ ! -f "dist/index.html" ]; then
    echo "❌ Error: Elm compilation failed!"
    exit 1
fi

echo ""
echo "🎨 Adding viewport meta tag..."

# Step 3: Add viewport meta tag
node scripts/add-viewport.js

echo ""
echo "✅ Build completed successfully!"
echo "📦 Output: dist/index.html"
echo ""
echo "🌐 To deploy: Push to main branch for automatic Netlify deployment"
echo "🎮 Live demo: https://hangman-claudecode.netlify.app/"