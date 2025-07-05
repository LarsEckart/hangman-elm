# Hangman Game Implementation Plan

## Overview
Implement a complete Hangman game in Elm using Test-Driven Development (TDD). The game will feature multiple difficulty levels, proper state management, and comprehensive test coverage.

## Project Structure
```
hangman-elm/
├── src/
│   ├── Main.elm          # Entry point and main view
│   ├── Types.elm         # Type definitions
│   ├── Game.elm          # Core game logic (pure functions)
│   └── Words.elm         # Word lists by difficulty
├── tests/
│   ├── GameTest.elm      # Core logic tests
│   └── UpdateTest.elm    # Update function tests
├── elm.json             # Project configuration
└── README.md            # Usage instructions
```

## Implementation Phases

### Phase 1: Project Setup
- [x] Initialize Elm project with `elm init`
- [x] Install elm-test: `npm install -g elm-test`
- [x] Configure elm.json for testing
- [x] Create initial directory structure

### Phase 2: Type Definitions (Types.elm)
- [x] Define `GameScreen` type (Start, DifficultySelection, Game, GameOver)
- [x] Define `Difficulty` type (Easy, Medium, Hard)
- [x] Define `GameState` type (Playing, Won, Lost)
- [x] Define `Model` type with all necessary fields
- [x] Define `Msg` type for all user interactions
- [x] Create type aliases for clarity

### Phase 3: Core Game Logic (Game.elm) - TDD Approach

#### 3.1: Letter Validation Functions
- [x] **Write tests first** for `isLetterInWord`
  - Test letter exists in word
  - Test letter doesn't exist
  - Test case insensitivity
- [x] **Implement** `isLetterInWord : Char -> String -> Bool`
- [x] **Write tests first** for `isValidGuess`
  - Test single letter input
  - Test already guessed letters
  - Test invalid characters
- [x] **Implement** `isValidGuess : Char -> List Char -> Bool`

#### 3.2: Word Display Functions
- [x] **Write tests first** for `getMaskedWord`
  - Test no letters guessed (all underscores)
  - Test some letters guessed
  - Test all letters guessed
  - Test case insensitivity
- [x] **Implement** `getMaskedWord : String -> List Char -> String`

#### 3.3: Game State Management
- [x] **Write tests first** for `updateGuessedLetters`
  - Test adding new letter
  - Test not adding duplicate
- [x] **Implement** `updateGuessedLetters : Char -> List Char -> List Char`
- [x] **Write tests first** for `calculateRemainingGuesses`
  - Test correct guesses don't decrement
  - Test wrong guesses decrement
- [x] **Implement** `calculateRemainingGuesses : String -> List Char -> Int -> Int`

#### 3.4: Win/Loss Conditions
- [x] **Write tests first** for `isGameWon`
  - Test all letters guessed
  - Test missing letters
- [x] **Implement** `isGameWon : String -> List Char -> Bool`
- [x] **Write tests first** for `isGameLost`
  - Test remaining guesses > 0
  - Test remaining guesses = 0
- [x] **Implement** `isGameLost : Int -> Bool`

### Phase 4: Word Lists (Words.elm)
- [ ] Create word lists for each difficulty
  - Easy: 3-5 letter words (20+ words)
  - Medium: 6-8 letter words (20+ words)
  - Hard: 9+ letter words (20+ words)
- [ ] **Write tests first** for `getRandomWord`
  - Test returns word from correct difficulty
  - Test word length matches difficulty
- [ ] **Implement** `getRandomWord : Difficulty -> Int -> String`
- [ ] **Write tests first** for `getWordsByDifficulty`
- [ ] **Implement** `getWordsByDifficulty : Difficulty -> List String`

### Phase 5: Update Logic (Main.elm) - TDD Approach
- [ ] **Write tests first** for update function
  - Test StartGame message
  - Test SelectDifficulty message
  - Test GuessLetter message (valid/invalid)
  - Test PlayAgain message
  - Test screen transitions
- [ ] **Implement** `update : Msg -> Model -> Model`
- [ ] **Write tests first** for model initialization
- [ ] **Implement** `init : Model`

### Phase 6: View Implementation (Main.elm)
- [ ] **Implement** `viewStartScreen : Html Msg`
  - Game title
  - Start button
- [ ] **Implement** `viewDifficultySelection : Html Msg`
  - Three difficulty buttons
  - Clear descriptions
- [ ] **Implement** `viewGameScreen : Model -> Html Msg`
  - Masked word display
  - Guessed letters display
  - Remaining guesses counter
  - Letter input field
  - Guess button
  - Game status messages
- [ ] **Implement** `viewGameOver : Model -> Html Msg`
  - Win/loss message
  - Reveal word if lost
  - Play again button
- [ ] **Implement** main `view : Model -> Html Msg`

### Phase 7: Integration and Testing
- [ ] Run all tests and ensure they pass
- [ ] Manual testing of complete game flow
- [ ] Test all edge cases
- [ ] Verify proper error handling

### Phase 8: Documentation and Polish
- [ ] Update README.md with:
  - How to run the game
  - How to run tests
  - Game rules and features
- [ ] Code cleanup and refactoring
- [ ] Final test run

## Test Cases Checklist

### Core Logic Tests (GameTest.elm)
- [ ] `isLetterInWord` tests (3+ test cases)
- [ ] `isValidGuess` tests (3+ test cases)
- [ ] `getMaskedWord` tests (4+ test cases)
- [ ] `updateGuessedLetters` tests (2+ test cases)
- [ ] `calculateRemainingGuesses` tests (2+ test cases)
- [ ] `isGameWon` tests (2+ test cases)
- [ ] `isGameLost` tests (2+ test cases)

### Update Function Tests (UpdateTest.elm)
- [ ] Screen transition tests (4+ test cases)
- [ ] Game state update tests (3+ test cases)
- [ ] Input validation tests (2+ test cases)
- [ ] Win/loss condition tests (2+ test cases)

### Word Management Tests
- [ ] `getRandomWord` tests (3+ test cases)
- [ ] `getWordsByDifficulty` tests (3+ test cases)
- [ ] Word length validation tests (3+ test cases)

## Commands to Remember
```bash
# Initialize project
elm init

# Install elm-test
npm install -g elm-test

# Run tests
elm-test

# Run application
elm reactor
```

## Success Criteria
- [ ] All tests pass
- [ ] Game functions correctly through all screens
- [ ] Proper input validation
- [ ] Win/loss conditions work correctly
- [ ] Clean, testable code architecture
- [ ] Complete documentation

## Notes
- Follow TDD strictly: Write tests first, then implement
- Keep pure functions separate from view logic
- Use descriptive test names
- Test both happy path and edge cases
- Ensure all user interactions are properly handled