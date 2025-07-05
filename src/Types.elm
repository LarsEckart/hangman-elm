module Types exposing (..)

-- Type aliases for clarity and readability
type alias Word = String
type alias GuessedLetters = List Char
type alias RemainingGuesses = Int
type alias UserInput = String


-- Screen/UI state management
type GameScreen
    = Start
    | DifficultySelection  
    | Game
    | GameOver


-- Difficulty levels with corresponding word length ranges
type Difficulty
    = Easy      -- 3-5 letter words
    | Medium    -- 6-8 letter words
    | Hard      -- 9+ letter words


-- Game state during gameplay
type GameState
    = Playing
    | Won
    | Lost


-- Main application model
type alias Model =
    { currentScreen : GameScreen
    , selectedDifficulty : Maybe Difficulty
    , currentWord : Word
    , guessedLetters : GuessedLetters
    , remainingGuesses : RemainingGuesses
    , gameState : GameState
    , userInput : UserInput
    , errorMessage : Maybe String
    }


-- Messages for user interactions and state updates
type Msg
    = StartGame
    | SelectDifficulty Difficulty
    | UpdateInput String
    | MakeGuess
    | PlayAgain
    | BackToStart
    | ClearError


-- Constants for game configuration
maxGuesses : Int
maxGuesses = 6


-- Helper functions for difficulty word length validation
getDifficultyWordLength : Difficulty -> { min : Int, max : Int }
getDifficultyWordLength difficulty =
    case difficulty of
        Easy ->
            { min = 3, max = 5 }
        
        Medium ->
            { min = 6, max = 8 }
        
        Hard ->
            { min = 9, max = 15 }


-- Helper function to check if a word matches difficulty requirements
isValidWordForDifficulty : Word -> Difficulty -> Bool
isValidWordForDifficulty word difficulty =
    let
        wordLength = String.length word
        { min, max } = getDifficultyWordLength difficulty
    in
    wordLength >= min && wordLength <= max


-- Initial model state
initialModel : Model
initialModel =
    { currentScreen = Start
    , selectedDifficulty = Nothing
    , currentWord = ""
    , guessedLetters = []
    , remainingGuesses = maxGuesses
    , gameState = Playing
    , userInput = ""
    , errorMessage = Nothing
    }