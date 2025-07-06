#!/bin/bash
# Simple script to serve the Hangman game with proper file serving

echo "Starting Elm reactor..."
echo "Navigate to http://localhost:8000/main.html to play the game"
echo ""
echo "NOTE: If word lists don't load, try using the Python server instead:"
echo "  python3 server.py"
echo ""
echo "The word lists are in src/wordlists/"
elm reactor