# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hangman game implementation in Elm following strict Test-Driven Development (TDD) principles. The project is structured around the planned phases outlined in `plan.md` and requirements in `spec.md`.

## Architecture

The project follows a clean architecture with clear separation of concerns:

- **`src/GameLogic.elm`**: Core game logic as pure functions (no side effects)
- **`tests/GameLogicTest.elm`**: Comprehensive test suite for game logic
- **Planned modules**:
  - `src/Main.elm`: Application entry point with Model-View-Update pattern
  - `src/Types.elm`: All type definitions for the application
  - `src/Words.elm`: Word lists organized by difficulty levels
  - `tests/UpdateTest.elm`: Tests for the update function and state transitions

## Development Commands

### Running Tests
```bash
# Run all tests
elm-test

# Use the DNS-aware script if having connectivity issues
./test-with-dns.sh
```

### Running the Application
```bash
# Start development server
elm reactor

# Compile the application
elm make src/Main.elm --output=main.html
```

### Development Workflow
The project strictly follows TDD:
1. Write failing tests first
2. Implement minimum code to make tests pass
3. Refactor while keeping tests green
4. Never implement features without tests

## DNS Configuration Issue

Elm 0.19.1 has known DNS resolution issues with systemd-resolved on Arch Linux. The `/etc/resolv.conf` has been configured to use `8.8.8.8` to resolve package registry connectivity issues. The `test-with-dns.sh` script provides guidance for this configuration.

## Game Architecture

The game follows a multi-screen architecture:
- **Start Screen**: Game title and start button
- **Difficulty Selection**: Easy (3-5 letters), Medium (6-8 letters), Hard (9+ letters)
- **Game Screen**: Main gameplay with masked word, guessed letters, and input
- **Game Over Screen**: Win/loss state with play again option

## Core Game Logic

All game logic is implemented as pure functions in `GameLogic.elm`:
- `isLetterInWord`: Case-insensitive letter detection
- `updateGuessedLetters`: Manages guessed letters with duplicate prevention
- `getMaskedWord`: Creates masked word display
- `isGameWon`/`isGameLost`: Win/loss condition checks
- `isValidGuess`: Input validation for single letters

## Testing Strategy

The test suite in `GameLogicTest.elm` covers:
- All core game logic functions
- Edge cases (empty strings, case sensitivity, duplicates)
- Input validation scenarios
- Win/loss condition verification

Each function has comprehensive test coverage with descriptive test names following the pattern: "returns X when Y" or "handles Z case".

## Implementation Status

- ✅ **Phase 1**: Project setup and core game logic complete
- ⏳ **Phase 2**: Type definitions (next phase)
- ⏳ **Phase 3**: Word management system
- ⏳ **Phase 4**: Update function and state management
- ⏳ **Phase 5**: View implementation
- ⏳ **Phase 6**: Integration and testing

## Key Design Principles

- **Pure Functions**: All game logic is implemented as pure functions for testability
- **Immutable State**: Following Elm's immutable data principles
- **Type Safety**: Leveraging Elm's type system for robust code
- **Test Coverage**: Every function has comprehensive test coverage before implementation
- **Separation of Concerns**: Clear boundaries between logic, state, and view layers