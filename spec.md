# Task: Implement a Hangman Game in Elm using Test-Driven Development

Create a complete Hangman game application in Elm following a test-first development approach. Write tests before implementing each feature.

## Development Workflow

1. For each feature, write failing tests first
2. Implement the minimum code to make tests pass
3. Refactor while keeping tests green
4. Use `elm-test` for all testing

## Application Structure

1. **Start Screen**: Display the game title "Hangman" and a "Start" button
2. **Difficulty Selection Screen**: After clicking start, show three difficulty options:
  - Easy (words 3-5 letters)
  - Medium (words 6-8 letters)
  - Hard (words 9+ letters)
3. **Game Screen**: The main gameplay interface

## Testing Requirements

### 1. Core Logic Tests (implement these first)

- `isLetterInWord`: Test if a letter exists in the target word
- `updateGuessedLetters`: Test adding letters to guessed list
- `getMaskedWord`: Test displaying word with guessed letters revealed
- `isGameWon`: Test win condition (all letters guessed)
- `isGameLost`: Test loss condition (no remaining guesses)
- `isValidGuess`: Test input validation (single letters only, not already guessed)

### 2. Game State Tests

- Test state transitions between screens
- Test difficulty selection updates
- Test game initialization with correct word lengths per difficulty
- Test remaining guesses decrement on wrong guess
- Test no decrement on correct guess

### 3. Update Function Tes### 4. Game Mechanics

- Allow letter input (handle both uppercase and lowercase)
- Validate that only single letters are accepted
- Prevent guessing the same letter twice
- Track game state (playing, won, lost)
- Show appropriate messages for win/loss conditions
- Include a "Play Again" button that returns to difficulty selection

### 5. Elm Architecture

- Use proper Model-View-Update pattern
- Define clear types for game states and screens
- Handle all user interactions through messages
- Ensure immutable state updates

## Code Structure Guidelines

- Separate pure functions from view logic for better testability
- Use type aliases for clarity
- Create separate modules:
  - `Main.elm` - Application entry point and view
  - `Game.elm` - Core game logic (pure functions)
  - `Types.elm` - Type definitions
  - `Words.elm` - Word lists by difficulty
- Write tests in `tests/` directory:
  - `GameTest.elm` - Core logic tests
  - `UpdateTest.elm` - Update function tests

## Example Test Structure

```elm
-- tests/GameTest.elm
module GameTest exposing (..)

import Expect
import Test exposing (..)
import Game exposing (..)

suite : Test
suite =
    describe "Game Logic"
        [ describe "isLetterInWord"
            [ test "returns True when letter exists" <|
                \_ ->
                    isLetterInWord 'a' "cat"
                        |> Expect.equal True
            , test "returns False when letter doesn't exist" <|
                \_ ->
                    isLetterInWord 'z' "cat"
                        |> Expect.equal False
            , test "is case insensitive" <|
                \_ ->
                    isLetterInWord 'A' "cat"
                        |> Expect.equal True
            ]
        , describe "getMaskedWord"
            [ test "shows all underscores when no letters guessed" <|
                \_ ->
                    getMaskedWord "cat" []
                        |> Expect.equal "_ _ _"
            , test "reveals guessed letters" <|
                \_ ->
                    getMaskedWord "cat" ['c', 'a']
                        |> Expect.equal "c a _"
            ]
        -- Add more test cases...
        ]

Deliverables

Complete test suite covering all game logic
Fully implemented game passing all tests
Instructions for running tests (elm-test) and the application
Clean separation of concerns with testable pure functions

Please provide the complete implementation following TDD principles. Start with the test file(s), then provide the implementation that makes all tests pass.
