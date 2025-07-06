module Types exposing (..)

import Http

-- Type aliases for clarity and readability
type alias Word = String
type alias GuessedLetters = List Char
type alias RemainingGuesses = Int
type alias UserInput = String


-- Screen/UI state management
type GameScreen
    = Start
    | LanguageSelection
    | CategorySelection
    | DifficultySelection  
    | Game
    | GameOver


-- Language options
type Language
    = English
    | German
    | Estonian


-- Category options
type Category
    = Animals
    | Food
    | Sport


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
    , selectedLanguage : Maybe Language
    , selectedCategory : Maybe Category
    , selectedDifficulty : Maybe Difficulty
    , currentWord : Word
    , guessedLetters : GuessedLetters
    , remainingGuesses : RemainingGuesses
    , gameState : GameState
    , userInput : UserInput
    , errorMessage : Maybe String
    , wordList : List String
    }


-- Messages for user interactions and state updates
type Msg
    = StartGame
    | SelectLanguage Language
    | SelectCategory Category
    | SelectDifficulty Difficulty
    | UpdateInput String
    | MakeGuess
    | PlayAgain
    | BackToStart
    | ClearError
    | WordSelected Difficulty Int
    | LoadWordList (Result Http.Error String)


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
    , selectedLanguage = Nothing
    , selectedCategory = Nothing
    , selectedDifficulty = Nothing
    , currentWord = ""
    , guessedLetters = []
    , remainingGuesses = maxGuesses
    , gameState = Playing
    , userInput = ""
    , errorMessage = Nothing
    , wordList = []
    }


-- Helper functions for language/category/difficulty conversions
languageToString : Language -> String
languageToString language =
    case language of
        English -> "english"
        German -> "german"
        Estonian -> "estonian"


categoryToString : Category -> String
categoryToString category =
    case category of
        Animals -> "animals"
        Food -> "food"
        Sport -> "sport"


difficultyToString : Difficulty -> String
difficultyToString difficulty =
    case difficulty of
        Easy -> "easy"
        Medium -> "medium"
        Hard -> "hard"