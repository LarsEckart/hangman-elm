module GameplayTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Types exposing (..)
import Types exposing (wordFromString, wordToString, guessedLettersFromList, guessedLettersToList)
import Main exposing (init, update)


-- Helper function to get the initial model from init
initialModel : Model
initialModel =
    Tuple.first (init ())


-- Helper function to extract model from update result
updateModel : Msg -> Model -> Model
updateModel msg model =
    Tuple.first (update msg model)


-- Test suite for gameplay functionality
suite : Test
suite =
    describe "Gameplay functionality"
        [ describe "MakeGuess message"
            [ test "handles valid guess - correct letter" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "CAT"
                            , userInput = "c"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal (guessedLettersToList m.guessedLetters) ['C']
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "handles valid guess - incorrect letter" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "CAT"
                            , userInput = "x"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal (guessedLettersToList m.guessedLetters) ['X']
                        , \m -> Expect.equal m.remainingGuesses (maxGuesses - 1)
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "handles invalid guess - empty input" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "CAT"
                            , userInput = ""
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal (guessedLettersToList m.guessedLetters) []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.notEqual m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "handles invalid guess - multiple characters" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "CAT"
                            , userInput = "abc"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal (guessedLettersToList m.guessedLetters) []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.notEqual m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "handles invalid guess - already guessed letter" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "CAT"
                            , userInput = "c"
                            , guessedLetters = guessedLettersFromList ['C', 'A']
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal (guessedLettersToList m.guessedLetters) ['C', 'A']
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.notEqual m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "handles invalid guess - non-alphabetic character" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "CAT"
                            , userInput = "1"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal (guessedLettersToList m.guessedLetters) []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.notEqual m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "transitions to GameOver screen when game is won" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "CAT"
                            , userInput = "t"
                            , guessedLetters = guessedLettersFromList ['C', 'A']
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen GameOver
                        , \m -> Expect.equal m.gameState Won
                        , \m -> Expect.equal (guessedLettersToList m.guessedLetters) ['C', 'A', 'T']
                        ]
                        updatedModel
            
            , test "transitions to GameOver screen when game is lost" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "CAT"
                            , userInput = "z"
                            , guessedLetters = guessedLettersFromList ['X', 'Y', 'W', 'V', 'U']
                            , remainingGuesses = 1
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen GameOver
                        , \m -> Expect.equal m.gameState Lost
                        , \m -> Expect.equal m.remainingGuesses 0
                        ]
                        updatedModel
            
            , test "does not process guess when game is already over" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = GameOver
                            , currentWord = wordFromString "CAT"
                            , userInput = "c"
                            , gameState = Won
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal (guessedLettersToList m.guessedLetters) []
                        , \m -> Expect.equal m.currentScreen GameOver
                        , \m -> Expect.equal m.gameState Won
                        ]
                        updatedModel
            ]
        , describe "WordSelected message"
            [ test "transitions to Game screen with selected word" <|
                \_ ->
                    let
                        modelWithWordList = 
                            { initialModel 
                            | currentScreen = DifficultySelection
                            , selectedLanguage = Just English
                            , selectedCategory = Just Animals
                            , selectedDifficulty = Just Easy
                            , wordList = ["CAT", "DOG", "BIRD"]
                            }
                        updatedModel = updateModel (WordSelected Easy 1) modelWithWordList
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal (wordToString m.currentWord) "DOG"
                        ]
                        updatedModel
            
            , test "handles word selection with index 0" <|
                \_ ->
                    let
                        modelWithWordList = 
                            { initialModel 
                            | currentScreen = DifficultySelection
                            , selectedLanguage = Just English
                            , selectedCategory = Just Animals
                            , selectedDifficulty = Just Easy
                            , wordList = ["CAT", "DOG", "BIRD"]
                            }
                        updatedModel = updateModel (WordSelected Easy 0) modelWithWordList
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal (wordToString m.currentWord) "CAT"
                        ]
                        updatedModel
            
            , test "handles word selection with out-of-bounds index" <|
                \_ ->
                    let
                        modelWithWordList = 
                            { initialModel 
                            | currentScreen = DifficultySelection
                            , selectedLanguage = Just English
                            , selectedCategory = Just Animals
                            , selectedDifficulty = Just Easy
                            , wordList = ["CAT", "DOG", "BIRD"]
                            }
                        updatedModel = updateModel (WordSelected Easy 10) modelWithWordList
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal (wordToString m.currentWord) ""  -- Should default to empty string
                        ]
                        updatedModel
            
            , test "handles word selection with empty word list" <|
                \_ ->
                    let
                        modelWithEmptyWordList = 
                            { initialModel 
                            | currentScreen = DifficultySelection
                            , selectedLanguage = Just English
                            , selectedCategory = Just Animals
                            , selectedDifficulty = Just Easy
                            , wordList = []
                            }
                        updatedModel = updateModel (WordSelected Easy 0) modelWithEmptyWordList
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal (wordToString m.currentWord) ""  -- Should default to empty string
                        ]
                        updatedModel
            ]
        ]