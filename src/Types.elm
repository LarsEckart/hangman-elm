module Types exposing (..)

-- Type aliases for clarity and readability
type alias Word = String
type alias GuessedLetters = List Char
type alias RemainingGuesses = Int
type alias UserInput = String


-- Structured error type for better error categorization and type safety
type AppError
    = NoWordsAvailable Language Category Difficulty
    | SelectionIncomplete { missingLanguage : Bool, missingCategory : Bool }
    | InvalidGuess GuessError
    | GameStateError String


-- Specific guess validation errors
type GuessError
    = EmptyInput
    | MultipleCharacters String
    | NonAlphabetic String
    | AlreadyGuessed Char


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
    , errorMessage : Maybe AppError
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


-- Helper functions for error handling
errorToString : AppError -> String
errorToString error =
    case error of
        NoWordsAvailable language category difficulty ->
            "No words available for " ++ languageToString language ++ " " ++ categoryToString category ++ " " ++ difficultyToString difficulty
        
        SelectionIncomplete { missingLanguage, missingCategory } ->
            if missingLanguage && missingCategory then
                "Please select language and category first"
            else if missingLanguage then
                "Please select a language first"
            else
                "Please select a category first"
        
        InvalidGuess guessError ->
            case guessError of
                EmptyInput ->
                    "Please enter a letter"
                
                MultipleCharacters input ->
                    "Please enter only one letter"
                
                NonAlphabetic input ->
                    "Please enter only letters"
                
                AlreadyGuessed char ->
                    "You already guessed that letter"
        
        GameStateError message ->
            "Game error: " ++ message


-- Helper function to validate user input and return appropriate error
validateUserInput : String -> List Char -> Result AppError Char
validateUserInput input guessedLetters =
    case String.toList input of
        [] ->
            Err (InvalidGuess EmptyInput)
        
        [char] ->
            if not (Char.isAlpha char) then
                Err (InvalidGuess (NonAlphabetic input))
            else if List.member (Char.toLower char) guessedLetters then
                Err (InvalidGuess (AlreadyGuessed char))
            else
                Ok char
        
        _ ->
            Err (InvalidGuess (MultipleCharacters input))


-- Reset game-specific fields while preserving user selections
resetGame : Model -> Model
resetGame model =
    { model
    | currentWord = ""
    , guessedLetters = []
    , remainingGuesses = maxGuesses
    , gameState = Playing
    , userInput = ""
    , errorMessage = Nothing
    , wordList = []
    }


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