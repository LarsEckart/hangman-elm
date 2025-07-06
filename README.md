# Hangman Game - Elm Implementation

A classic Hangman word-guessing game built with Elm using Test-Driven Development (TDD) principles. The game features multiple difficulty levels, comprehensive input validation, and a clean, responsive user interface.

## Features

- **Multiple Languages**: Play in English, German, or Estonian
- **Categories**: Choose from Animals, Food & Drinks, or Sport
- **Multiple Difficulty Levels**: Choose from Easy (3-5 letters), Medium (6-8 letters), or Hard (9+ letters)
- **Dynamic Word Loading**: Words are loaded from CSV files based on your selections
- **Comprehensive Word Lists**: Over 20 carefully selected words for each combination
- **Input Validation**: Prevents invalid guesses and duplicate letters
- **Game State Management**: Tracks game progress, remaining guesses, and win/loss conditions
- **Clean UI**: Intuitive interface with clear visual feedback
- **Responsive Design**: Works well on different screen sizes

## Game Rules

1. **Start the Game**: Click "Start Game" to begin
2. **Select Language**: Choose English, German, or Estonian
3. **Select Category**: Pick Animals, Food & Drinks, or Sport
4. **Select Difficulty**: Choose your preferred difficulty level
5. **Make Guesses**: Enter one letter at a time to guess the word
6. **Win Condition**: Guess all letters in the word before running out of attempts
7. **Loss Condition**: Use all 6 attempts without guessing the complete word
8. **Play Again**: After each game, you can play again or return to the start screen

## How to Run the Game

### Prerequisites

- [Elm](https://guide.elm-lang.org/install/elm.html) (version 0.19.1)
- [Node.js](https://nodejs.org/) (for elm-test)

### Installation

1. Clone or download this repository
2. Navigate to the project directory:
   ```bash
   cd hangman-elm
   ```

### Running the Application

#### Option 1: Using Elm Reactor (Recommended)
```bash
./serve.sh
```
Or manually:
```bash
elm reactor
```
Then open your browser and navigate to `http://localhost:8000/main.html`

#### Option 2: Compile to HTML
```bash
elm make src/Main.elm --output=main.html
```
Then open `main.html` in your web browser

**Note**: Word lists are loaded from CSV files in `src/wordlists/`. If serving the compiled HTML directly, ensure the word list files are accessible at the correct path.

### Running Tests

Install elm-test (if not already installed):
```bash
npm install -g elm-test
```

Run all tests:
```bash
elm-test
```

For DNS issues on some systems, you can use the provided script:
```bash
./test-with-dns.sh
```

## Project Structure

```
hangman-elm/
├── src/
│   ├── Main.elm          # Entry point, UI, and update logic
│   ├── Types.elm         # Type definitions and model
│   ├── GameLogic.elm     # Pure game logic functions
│   ├── Words.elm         # Word lists by difficulty (fallback)
│   ├── WordLoader.elm    # CSV file loading functionality
│   └── wordlists/        # CSV word list files
│       ├── english-animals-easy.csv
│       ├── german-animals-easy.csv
│       ├── estonian-animals-easy.csv
│       └── ... (more combinations)
├── tests/
│   ├── GameLogicTest.elm # Tests for core game logic
│   ├── UpdateTest.elm    # Tests for update function
│   └── WordsTest.elm     # Tests for word management
├── elm.json              # Project configuration
├── serve.sh              # Helper script to run the game
└── README.md             # This file
```

## Architecture

The game follows the Elm Architecture pattern with clear separation of concerns:

- **Model**: Immutable state management in `Types.elm`
- **Update**: Pure state transitions in `Main.elm`
- **View**: Declarative UI rendering in `Main.elm`
- **Game Logic**: Pure functions in `GameLogic.elm` for core game mechanics

## Core Game Logic

All game logic is implemented as pure functions for better testability:

- `isLetterInWord`: Checks if a letter exists in the target word (case-insensitive)
- `updateGuessedLetters`: Adds new letters to the guessed letters list
- `getMaskedWord`: Creates the masked word display (e.g., "_ A _")
- `isGameWon`: Determines if all letters have been guessed
- `isGameLost`: Determines if the player has run out of guesses
- `calculateRemainingGuesses`: Calculates remaining attempts based on incorrect guesses

## Testing

The project uses comprehensive Test-Driven Development with 67 test cases covering:

- **Core Logic Tests**: All game mechanics and edge cases
- **Update Function Tests**: State transitions and user interactions
- **Word Management Tests**: Difficulty-based word selection and validation
- **Integration Tests**: Complete game flow scenarios

### Test Coverage

- Input validation (empty input, non-letters, duplicate guesses)
- Case sensitivity handling
- Win/loss condition detection
- State transitions between game screens
- Word length validation for each difficulty

## Word Lists

Words are organized in CSV files by language, category, and difficulty:

### File Format
- **Naming Convention**: `{language}-{category}-{difficulty}.csv`
- **Example**: `english-animals-easy.csv`, `german-food-medium.csv`
- **Structure**: One word per line in CSV files

### Available Combinations
- **Languages**: English, German, Estonian
- **Categories**: Animals, Food & Drinks, Sport
- **Difficulties**: 
  - Easy: 3-5 letter words
  - Medium: 6-8 letter words
  - Hard: 9+ letter words

### Adding New Word Lists
To add new word lists, create a CSV file following the naming convention and place it in `src/wordlists/`. The game will automatically load words from the appropriate file based on user selections.

## Development

This project was built using Test-Driven Development principles:

1. **Write Tests First**: All functionality was tested before implementation
2. **Minimal Implementation**: Code was written to make tests pass
3. **Refactor Safely**: Clean code while maintaining test coverage
4. **Pure Functions**: Game logic separated from UI for better testability

## Browser Compatibility

The game works in all modern browsers that support Elm applications:
- Chrome/Chromium
- Firefox
- Safari
- Edge

## DNS Configuration Note

If you experience issues with Elm package installation on some Linux systems, the project includes a `test-with-dns.sh` script that provides guidance for DNS configuration.

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please ensure all new features include comprehensive tests following the existing TDD approach.