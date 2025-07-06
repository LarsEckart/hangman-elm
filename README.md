# Hangman Game - Elm Implementation

[![Netlify Status](https://api.netlify.com/api/v1/badges/c7779d1b-b353-48bd-94ca-337c7c19fc92/deploy-status)](https://app.netlify.com/sites/hangman-claudecode/deploys)

A classic word-guessing game built with Elm 

**🌐 Play Online (and offline)**: https://hangman-claudecode.netlify.app/

## Features

- **🌍 Full Internationalization**: Play in English, German, or Estonian with complete UI translation
- **📂 Categories**: Choose from Animals, Food, or Sport
- **🎯 Multiple Difficulty Levels**: Easy (3-5 letters), Medium (6-8 letters), Hard (9+ letters)

## Game Rules

1. **Start the Game**: Click "Start Game" to begin
2. **Select Language**: Choose English, German, or Estonian (UI automatically adapts)
3. **Select Category**: Pick Animals, Food & Drinks, or Sport
4. **Select Difficulty**: Choose your preferred difficulty level
5. **Make Guesses**: Choose one letter at a time to guess the word
6. **Win Condition**: Guess all letters in the word before running out of attempts
7. **Loss Condition**: Use all 6 attempts without guessing the complete word
8. **Play Again**: After each game, you can play again with the same settings or return to the start screen

## Development

### Prerequisites

- [Elm](https://guide.elm-lang.org/install/elm.html) (version 0.19.1)
- [Node.js](https://nodejs.org/) (for build system and testing)

### Running the Application

#### Development Server (Recommended)
```bash
npm run dev
```
This builds the embedded word lists and starts elm reactor at http://localhost:8000

#### Production Build
```bash
npm run build
# or use the build script:
./build_project.sh
```
Creates `dist/index.html`.

#### Build Word Lists Only
```bash
npm run build-wordlists
```
Generates `src/Generated/WordLists.elm` from CSV files

### Running Tests

Run all tests:
```bash
npm test
```
Or directly:
```bash
elm-test
```
```

## Deployment

**Automatic Deployment**: Every commit to the main branch automatically deploys to:
**🌐 https://hangman-claudecode.netlify.app/**
