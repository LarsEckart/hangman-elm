module Types exposing (..)

-- Opaque type for Word to ensure type safety and guarantee uppercase
type Word = Word String

-- Helper functions for Word opaque type
wordFromString : String -> Word
wordFromString str =
    Word (String.toUpper str)

wordToString : Word -> String
wordToString (Word str) =
    str

wordContains : String -> Word -> Bool
wordContains substring (Word str) =
    String.contains substring str

wordToList : Word -> List Char
wordToList (Word str) =
    String.toList str

wordLength : Word -> Int
wordLength (Word str) =
    String.length str

-- Opaque type for GuessedLetters to ensure type safety and guarantee uppercase
type GuessedLetters = GuessedLetters (List Char)

-- Helper functions for GuessedLetters opaque type
emptyGuessedLetters : GuessedLetters
emptyGuessedLetters =
    GuessedLetters []

guessedLettersFromList : List Char -> GuessedLetters
guessedLettersFromList chars =
    GuessedLetters (List.map Char.toUpper chars)

guessedLettersToList : GuessedLetters -> List Char
guessedLettersToList (GuessedLetters chars) =
    chars

addGuessedLetter : Char -> GuessedLetters -> GuessedLetters
addGuessedLetter letter (GuessedLetters chars) =
    let
        upperLetter = Char.toUpper letter
    in
    if List.member upperLetter chars then
        GuessedLetters chars
    else
        GuessedLetters (chars ++ [upperLetter])

isLetterGuessed : Char -> GuessedLetters -> Bool
isLetterGuessed letter (GuessedLetters chars) =
    List.member (Char.toUpper letter) chars

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
    , uiLanguage : Language  -- UI language that follows selected game language
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
    | GuessLetter Char
    | PlayAgain
    | BackToStart
    | ClearError
    | WordSelected Difficulty Int


-- Constants for game configuration
maxGuesses : Int
maxGuesses = 6





-- Helper functions for error handling
errorToString : Language -> AppError -> String
errorToString uiLanguage error =
    case error of
        NoWordsAvailable language category difficulty ->
            -- Import Translations module functions
            case uiLanguage of
                English -> "No words available for " ++ languageToString language ++ " " ++ categoryToString category ++ " " ++ difficultyToString difficulty
                German -> "Keine Wörter verfügbar für " ++ languageToString language ++ " " ++ categoryToString category ++ " " ++ difficultyToString difficulty
                Estonian -> "Selle kombinatsiooni jaoks pole sõnu saadaval: " ++ languageToString language ++ " " ++ categoryToString category ++ " " ++ difficultyToString difficulty
        
        SelectionIncomplete { missingLanguage, missingCategory } ->
            case uiLanguage of
                English ->
                    if missingLanguage && missingCategory then
                        "Please select language and category first"
                    else if missingLanguage then
                        "Please select a language first"
                    else
                        "Please select a category first"
                German ->
                    if missingLanguage && missingCategory then
                        "Bitte wählen Sie zuerst Sprache und Kategorie"
                    else if missingLanguage then
                        "Bitte wählen Sie zuerst eine Sprache"
                    else
                        "Bitte wählen Sie zuerst eine Kategorie"
                Estonian ->
                    if missingLanguage && missingCategory then
                        "Palun valige esmalt keel ja kategooria"
                    else if missingLanguage then
                        "Palun valige esmalt keel"
                    else
                        "Palun valige esmalt kategooria"
        
        InvalidGuess guessError ->
            case guessError of
                EmptyInput ->
                    case uiLanguage of
                        English -> "Please enter a letter"
                        German -> "Bitte geben Sie einen Buchstaben ein"
                        Estonian -> "Palun sisestage täht"
                
                MultipleCharacters input ->
                    case uiLanguage of
                        English -> "Please enter only one letter"
                        German -> "Bitte geben Sie nur einen Buchstaben ein"
                        Estonian -> "Palun sisestage ainult üks täht"
                
                NonAlphabetic input ->
                    case uiLanguage of
                        English -> "Please enter only letters"
                        German -> "Bitte geben Sie nur Buchstaben ein"
                        Estonian -> "Palun sisestage ainult tähti"
                
                AlreadyGuessed char ->
                    case uiLanguage of
                        English -> "You already guessed that letter"
                        German -> "Sie haben diesen Buchstaben bereits geraten"
                        Estonian -> "Te olete selle tähe juba arvanud"
        
        GameStateError message ->
            case uiLanguage of
                English -> "Game error: " ++ message
                German -> "Spielfehler: " ++ message
                Estonian -> "Mängu viga: " ++ message


-- Helper function to validate user input and return appropriate error
validateUserInput : String -> GuessedLetters -> Result AppError Char
validateUserInput input guessedLetters =
    case String.toList input of
        [] ->
            Err (InvalidGuess EmptyInput)
        
        [char] ->
            if not (Char.isAlpha char) then
                Err (InvalidGuess (NonAlphabetic input))
            else if isLetterGuessed char guessedLetters then
                Err (InvalidGuess (AlreadyGuessed char))
            else
                Ok char
        
        _ ->
            Err (InvalidGuess (MultipleCharacters input))


-- Reset game-specific fields while preserving user selections
resetGame : Model -> Model
resetGame model =
    { model
    | currentWord = wordFromString ""
    , guessedLetters = emptyGuessedLetters
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
    , uiLanguage = English  -- Default UI language
    , selectedCategory = Nothing
    , selectedDifficulty = Nothing
    , currentWord = wordFromString ""
    , guessedLetters = emptyGuessedLetters
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