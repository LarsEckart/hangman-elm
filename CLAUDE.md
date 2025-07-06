# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **completed** Hangman game implementation in Elm with build-time embedded word lists. The project transformed from HTTP-based word loading to a fully self-contained system with zero network dependencies.

**🌐 Live Demo**: https://hangman-claudecode.netlify.app/

## Architecture ✅ **COMPLETED**

The project follows a clean, embedded architecture:

- **`src/Main.elm`**: Complete application with Model-View-Update pattern
- **`src/Types.elm`**: All type definitions for the 6-screen application flow
- **`src/GameLogic.elm`**: Core game logic as pure functions (no side effects)
- **`src/Generated/WordLists.elm`**: Auto-generated embedded word lists (gitignored)
- **`scripts/build-wordlists.js`**: Build-time CSV processor and Elm code generator
- **Tests**:
  - `tests/GameLogicTest.elm`: Comprehensive game logic tests (46 tests)
  - `tests/UpdateTest.elm`: Update function and state transition tests (7 tests)

## Development Commands

### Running Tests
```bash
# Run all tests (53 tests total)
elm-test
```

### Running the Application
```bash
# Development server (builds word lists + starts elm reactor)
npm run dev

# Production build (builds word lists + creates self-contained HTML)
npm run build

# Build word lists only
npm run build-wordlists
```

### Deployment
- **Automatic**: Every commit to main branch deploys to https://hangman-claudecode.netlify.app/
- **Build command**: `npm run build`
- **Publish directory**: `dist`

### Development Workflow
The project strictly follows TDD:
1. Write failing tests first
2. Implement minimum code to make tests pass
3. Refactor while keeping tests green
4. Never implement features without tests

## Game Architecture ✅ **COMPLETED**

The game follows a 6-screen architecture with multi-language support:
- **Start Screen**: Game title and start button
- **Language Selection**: English, German, Estonian
- **Category Selection**: Animals, Food, Sport
- **Difficulty Selection**: Easy (3-5 letters), Medium (6-8 letters), Hard (9+ letters)
- **Game Screen**: Main gameplay with masked word, guessed letters, and input
- **Game Over Screen**: Win/loss state with play again option

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

## Build System ✅ **COMPLETED**

**Node.js Build Script** (`scripts/build-wordlists.js`):
- Discovers CSV files in `src/wordlists/` (12 files found)
- Validates word lengths against difficulty requirements
- Generates optimized 3D Dict structure in `src/Generated/WordLists.elm`
- Handles missing files gracefully with warnings
- Creates type-safe Elm code with proper imports

**NPM Scripts**:
- `npm run build-wordlists`: Generate embedded word lists
- `npm run dev`: Build + start elm reactor
- `npm run build`: Build + create production HTML
- `npm run test`: Run elm-test suite

## Testing Strategy ✅ **COMPLETED**

**53 total tests passing**:
- **GameLogicTest.elm**: All core game logic functions with edge cases
- **UpdateTest.elm**: Message handling and state transitions
- Comprehensive coverage of input validation, win/loss conditions
- Tests updated for embedded word list behavior

## Implementation Status ✅ **ALL PHASES COMPLETED**

- ✅ **Phase 0**: Prerequisites and test fixes
- ✅ **Phase 1**: Build script development and CSV processing
- ✅ **Phase 2**: Feature flag implementation and parallel systems
- ✅ **Phase 3**: Full migration to embedded system and cleanup

See `plan.md` for detailed implementation history.

## Key Design Principles

- **Pure Functions**: All game logic is implemented as pure functions for testability
- **Immutable State**: Following Elm's immutable data principles
- **Type Safety**: Leveraging Elm's type system for robust code
- **Test Coverage**: Every function has comprehensive test coverage before implementation
- **Separation of Concerns**: Clear boundaries between logic, state, and view layers