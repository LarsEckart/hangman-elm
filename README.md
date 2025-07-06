# Hangman Game - Elm Implementation

A classic Hangman word-guessing game built with Elm featuring **build-time embedded word lists** for zero-dependency, self-contained gameplay. Built using Test-Driven Development (TDD) principles with 53 comprehensive tests.

**🌐 Play Online**: https://hangman-claudecode.netlify.app/

## Features

- **🌍 Full Internationalization**: Play in English, German, or Estonian with complete UI translation
- **📂 Categories**: Choose from Animals, Food, or Sport
- **🎯 Multiple Difficulty Levels**: Easy (3-5 letters), Medium (6-8 letters), Hard (9+ letters)
- **⚡ Zero Network Dependencies**: 109 words embedded at build time - no HTTP requests
- **🚀 Instant Loading**: Self-contained HTML file with embedded word lists
- **✅ Input Validation**: Prevents invalid guesses and duplicate letters
- **🎮 Game State Management**: Tracks progress, remaining guesses, and win/loss conditions
- **🎨 Multilingual UI**: Intuitive 6-screen interface with complete language localization
- **📱 Self-Contained**: Works offline, no server required

## Game Rules

1. **Start the Game**: Click "Start Game" to begin
2. **Select Language**: Choose English, German, or Estonian (UI automatically adapts)
3. **Select Category**: Pick Animals, Food & Drinks, or Sport
4. **Select Difficulty**: Choose your preferred difficulty level
5. **Make Guesses**: Enter one letter at a time to guess the word
6. **Win Condition**: Guess all letters in the word before running out of attempts
7. **Loss Condition**: Use all 6 attempts without guessing the complete word
8. **Play Again**: After each game, you can play again or return to the start screen

## Development

### Prerequisites

- [Elm](https://guide.elm-lang.org/install/elm.html) (version 0.19.1)
- [Node.js](https://nodejs.org/) (for build system and testing)

### Installation

1. Clone this repository
2. Navigate to the project directory:
   ```bash
   cd hangman-elm
   ```

### Running the Application

#### Development Server (Recommended)
```bash
npm run dev
```
This builds the embedded word lists and starts elm reactor at http://localhost:8000

#### Production Build
```bash
npm run build
```
Creates `dist/index.html` with embedded word lists - fully self-contained!

#### Build Word Lists Only
```bash
npm run build-wordlists
```
Generates `src/Generated/WordLists.elm` from CSV files

### Running Tests

Run all 53 tests:
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

**Netlify Configuration**:
- Build command: `npm run build`
- Publish directory: `dist`
- Builds embedded word lists and creates self-contained HTML

## Project Structure

```
hangman-elm/
├── src/
│   ├── Main.elm              # Complete 6-screen Elm app
│   ├── Types.elm             # Type definitions and model
│   ├── GameLogic.elm         # Pure game logic functions
│   ├── Translations.elm      # Internationalization system (47 translation keys)
│   ├── Generated/            # Auto-generated (gitignored)
│   │   └── WordLists.elm     # Embedded 3D word structure
│   └── wordlists/            # Source CSV files (12 files)
│       ├── english-animals-easy.csv
│       ├── german-animals-easy.csv
│       ├── estonian-animals-easy.csv
│       └── ... (9 more combinations)
├── scripts/
│   └── build-wordlists.js    # CSV → Elm code generator
├── tests/
│   ├── GameLogicTest.elm     # Core game logic tests (46 tests)
│   └── UpdateTest.elm        # Update function tests (23 tests)
├── dist/                     # Build output
│   └── index.html           # Self-contained game
├── package.json              # Build scripts and dependencies
├── elm.json                  # Elm project configuration
└── README.md                 # This file
```

## Architecture

**Build-Time Embedded System**:
- **Build Script**: `scripts/build-wordlists.js` transforms CSV files → Elm code
- **Generated Module**: `src/Generated/WordLists.elm` with 3D Dict structure
- **Zero Dependencies**: No HTTP requests, fully self-contained
- **Instant Loading**: Words available immediately via embedded lookup

**Elm Architecture Pattern**:
- **Model**: Immutable state management in `Types.elm`
- **Update**: Pure state transitions in `Main.elm`
- **View**: Declarative 6-screen UI in `Main.elm`
- **Game Logic**: Pure functions in `GameLogic.elm`
- **Internationalization**: Type-safe translations in `Translations.elm`

## Core Game Logic

All game logic implemented as pure functions:
- `isLetterInWord`: Case-insensitive letter detection
- `updateGuessedLetters`: Duplicate-safe letter management
- `getMaskedWord`: Masked display generation
- `isGameWon`/`isGameLost`: Win/loss condition checks
- `isValidGuess`: Input validation for single letters

## Testing

**69 comprehensive tests** using Test-Driven Development:
- **GameLogicTest.elm**: Core game mechanics and edge cases (46 tests)
- **UpdateTest.elm**: State transitions, message handling, and UI language functionality (23 tests)

**Coverage includes**:
- Input validation (empty, non-letters, duplicates)
- Case sensitivity and special characters
- Win/loss detection and state transitions
- Embedded word list behavior
- UI language synchronization with game language

## Build-Time Word List System

**109 words embedded** from 12 CSV files at build time:

### CSV File Organization
- **Format**: `{language}-{category}-{difficulty}.csv`
- **Structure**: One word per line
- **Example**: `english-animals-easy.csv`, `german-food-easy.csv`

### Available Combinations
- **Languages**: English, German, Estonian (3)
- **Categories**: Animals, Food, Sport (3)  
- **Difficulties**: Easy (3-5), Medium (6-8), Hard (9+) (3)
- **Total**: 27 possible combinations (12 currently available)

### Build Process
1. `scripts/build-wordlists.js` scans `src/wordlists/*.csv`
2. Validates word lengths against difficulty requirements
3. Generates `src/Generated/WordLists.elm` with 3D Dict structure
4. Handles missing files gracefully with warnings
5. Creates type-safe, optimized lookup functions

### Adding New Words
1. Add CSV files to `src/wordlists/` following naming convention
2. Run `npm run build-wordlists` to regenerate embedded lists
3. Words automatically available in next build

## Browser Compatibility

Works in all modern browsers - no server required:
- Chrome/Chromium, Firefox, Safari, Edge
- Self-contained HTML with embedded assets
- No external dependencies or network requests

## License

MIT License - Open source and contributions welcome!

## Contributing

1. Follow TDD principles - write tests first
2. Run `npm test` to ensure all 69 tests pass
3. Add new CSV word lists in `src/wordlists/`
4. Maintain pure function architecture
5. For UI changes, ensure translations are added to `Translations.elm`