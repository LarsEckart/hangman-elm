# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hangman game implementation in Elm.

**🌐 Live Demo**: https://hangman-claudecode.netlify.app/

### ⚠️ **IMPORTANT: VERSION MANAGEMENT**
**Any change you make, think about if it is minor or patch level and bump the version in `package.json` - we don't want to forget this, ever!**

- **Patch** (`1.0.0` → `1.0.1`): Bug fixes, small UI tweaks
- **Minor** (`1.0.1` → `1.1.0`): New features, significant improvements  
- **Major** (`1.1.0` → `2.0.0`): Breaking changes, major redesign

Use: `npm version patch` or `npm version minor` or `npm version major`

## Architecture

- **`src/Main.elm`**: Complete application with Model-View-Update pattern
- **`src/Types.elm`**: All type definitions for the 6-screen application flow
- **`src/GameLogic.elm`**: Core game logic as pure functions (no side effects)
- **`src/Translations.elm`**: Internationalization system with 47 translation keys
- **`src/Generated/WordLists.elm`**: Auto-generated embedded word lists (gitignored)
- **`scripts/build-wordlists.js`**: Build-time CSV processor and Elm code generator
- **Tests**:
  - `tests/GameLogicTest.elm`: Comprehensive game logic tests (46 tests)
  - `tests/UpdateTest.elm`: Update function and state transition tests (23 tests)

## Development Commands

### Running Tests
```bash
# Run all tests (70 tests total)
elm-test

### Running the Application
```bash
# Development server (builds word lists + starts elm reactor)
npm run dev
# ⚠️ IMPORTANT: Do NOT run this in automated contexts - it starts a persistent server

# Production build (builds word lists + creates self-contained HTML)
npm run build

# Build word lists only
npm run build-wordlists

# Watch CSV files for changes (development)
npm run watch

# Alternative build script (does same as npm run build)
./build_project.sh
```

### Deployment
- **Automatic**: Every commit to main branch deploys to https://hangman-claudecode.netlify.app/
- **PR preview**: All pull requests also get automatically deployed, netlify adds a comment about it
- **Build command**: `npm run build`
- **Publish directory**: `dist`

### Development Workflow
The project strictly follows TDD:
1. Write failing tests first
2. Implement minimum code to make tests pass
3. Refactor while keeping tests green
4. Never implement features without tests
5. Create a Pull Request using GitHub CLI

## Game Architecture

The game follows a 6-screen architecture with complete internationalization:
- **Start Screen**: Game title and start button (fully translated)
- **Language Selection**: English, German, Estonian (UI adapts immediately)
- **Category Selection**: Animals, Food, Sport (localized category names)
- **Difficulty Selection**: Easy (3-5 letters), Medium (6-8 letters), Hard (9+ letters) (translated descriptions)
- **Game Screen**: Main gameplay with masked word, guessed letters, and input (all UI elements translated)
- **Game Over Screen**: Win/loss state with play again option (localized messages)

### Word List System
- **109 words** embedded from 12 CSV files at build time
- **Zero HTTP requests** - fully self-contained
- **Instant word loading** with Random module selection
- **3-dimensional structure**: Language → Category → Difficulty

## Core Game Logic

All game logic is implemented as pure functions in `GameLogic.elm`:
- `isLetterInWord`: Case-insensitive letter detection
- `updateGuessedLetters`: Manages guessed letters with duplicate prevention
- `getMaskedWord`: Creates masked word display
- `isGameWon`/`isGameLost`: Win/loss condition checks
- `isValidGuess`: Input validation for single letters

## Build System

**Node.js Build Script** (`scripts/build-wordlists.js`):
- Discovers CSV files in `src/wordlists/` (12 files found)
- Validates word lengths against difficulty requirements
- Generates optimized 3D Dict structure in `src/Generated/WordLists.elm`
- Handles missing files gracefully with warnings
- Creates type-safe Elm code with proper imports

**NPM Scripts**:
- `npm run build-wordlists`: Generate embedded word lists
- `npm run build-sw`: Generate service worker with automatic versioning
- `npm run dev`: Build + start elm reactor
- `npm run build`: Build + create production HTML with offline support
- `npm run test`: Run elm-test suite

## Offline Functionality

The game includes full offline support via Service Worker:

- **Service Worker**: Minimal JavaScript for offline caching (`sw-template.js`)
- **Automatic Versioning**: Version injected from `package.json` at build time
- **Cache Management**: Automatic cleanup of old cached versions
- **Offline Play**: Complete game functionality without internet after first visit

### Build System Files
- **`sw-template.js`**: Service Worker template with version placeholder
- **`scripts/build-sw.js`**: Build script that injects version from package.json
- **`scripts/add-viewport.js`**: Enhanced to add Service Worker registration to HTML

## Key Design Principles

- **Pure Functions**: All game logic is implemented as pure functions for testability
- **Immutable State**: Following Elm's immutable data principles
- **Type Safety**: Leveraging Elm's type system for robust code
- **Test Coverage**: Every function has comprehensive test coverage before implementation
- **Separation of Concerns**: Clear boundaries between logic, state, and view layers
- **Internationalization**: Type-safe translation system with complete UI localization
- **Offline First**: Service Worker caching for reliable offline functionality
