module UpdateTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Types exposing (..)
import Main exposing (update, init)


-- Test suite for update function and model initialization
suite : Test
suite =
    describe "Update function and model initialization"
        [ describe "Model initialization"
            [ test "init returns correct initial model" <|
                \_ ->
                    let
                        model = init
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Start
                        , \m -> Expect.equal m.selectedDifficulty Nothing
                        , \m -> Expect.equal m.currentWord ""
                        , \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.gameState Playing
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        ]
                        model
            ]
        , describe "StartGame message"
            [ test "transitions from Start to DifficultySelection screen" <|
                \_ ->
                    let
                        initialModel = init
                        updatedModel = update StartGame initialModel
                    in
                    Expect.equal updatedModel.currentScreen DifficultySelection
            
            , test "clears error message when starting game" <|
                \_ ->
                    let
                        modelWithError = { init | errorMessage = Just "Previous error" }
                        updatedModel = update StartGame modelWithError
                    in
                    Expect.equal updatedModel.errorMessage Nothing
            ]
        , describe "SelectDifficulty message"
            [ test "transitions from DifficultySelection to Game screen with Easy difficulty" <|
                \_ ->
                    let
                        initialModel = { init | currentScreen = DifficultySelection }
                        updatedModel = update (SelectDifficulty Easy) initialModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal m.selectedDifficulty (Just Easy)
                        , \m -> Expect.notEqual m.currentWord ""
                        , \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.gameState Playing
                        ]
                        updatedModel
            
            , test "transitions from DifficultySelection to Game screen with Medium difficulty" <|
                \_ ->
                    let
                        initialModel = { init | currentScreen = DifficultySelection }
                        updatedModel = update (SelectDifficulty Medium) initialModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal m.selectedDifficulty (Just Medium)
                        , \m -> Expect.notEqual m.currentWord ""
                        ]
                        updatedModel
            
            , test "transitions from DifficultySelection to Game screen with Hard difficulty" <|
                \_ ->
                    let
                        initialModel = { init | currentScreen = DifficultySelection }
                        updatedModel = update (SelectDifficulty Hard) initialModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal m.selectedDifficulty (Just Hard)
                        , \m -> Expect.notEqual m.currentWord ""
                        ]
                        updatedModel
            
            , test "selected word length matches Easy difficulty requirements" <|
                \_ ->
                    let
                        initialModel = { init | currentScreen = DifficultySelection }
                        updatedModel = update (SelectDifficulty Easy) initialModel
                        wordLength = String.length updatedModel.currentWord
                    in
                    Expect.equal True (wordLength >= 3 && wordLength <= 5)
            
            , test "selected word length matches Medium difficulty requirements" <|
                \_ ->
                    let
                        initialModel = { init | currentScreen = DifficultySelection }
                        updatedModel = update (SelectDifficulty Medium) initialModel
                        wordLength = String.length updatedModel.currentWord
                    in
                    Expect.equal True (wordLength >= 6 && wordLength <= 8)
            
            , test "selected word length matches Hard difficulty requirements" <|
                \_ ->
                    let
                        initialModel = { init | currentScreen = DifficultySelection }
                        updatedModel = update (SelectDifficulty Hard) initialModel
                        wordLength = String.length updatedModel.currentWord
                    in
                    Expect.equal True (wordLength >= 9)
            ]
        , describe "UpdateInput message"
            [ test "updates user input field" <|
                \_ ->
                    let
                        initialModel = init
                        updatedModel = update (UpdateInput "a") initialModel
                    in
                    Expect.equal updatedModel.userInput "a"
            
            , test "clears error message when updating input" <|
                \_ ->
                    let
                        modelWithError = { init | errorMessage = Just "Previous error" }
                        updatedModel = update (UpdateInput "b") modelWithError
                    in
                    Expect.equal updatedModel.errorMessage Nothing
            ]
        , describe "MakeGuess message"
            [ test "handles valid guess - correct letter" <|
                \_ ->
                    let
                        gameModel = 
                            { init 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "c"
                            , gameState = Playing
                            }
                        updatedModel = update MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.guessedLetters ['c']
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "handles valid guess - incorrect letter" <|
                \_ ->
                    let
                        gameModel = 
                            { init 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "x"
                            , gameState = Playing
                            }
                        updatedModel = update MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.guessedLetters ['x']
                        , \m -> Expect.equal m.remainingGuesses (maxGuesses - 1)
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "handles invalid guess - empty input" <|
                \_ ->
                    let
                        gameModel = 
                            { init 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = ""
                            , gameState = Playing
                            }
                        updatedModel = update MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.notEqual m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "handles invalid guess - multiple characters" <|
                \_ ->
                    let
                        gameModel = 
                            { init 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "abc"
                            , gameState = Playing
                            }
                        updatedModel = update MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.notEqual m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "handles invalid guess - already guessed letter" <|
                \_ ->
                    let
                        gameModel = 
                            { init 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "c"
                            , guessedLetters = ['c', 'a']
                            , gameState = Playing
                            }
                        updatedModel = update MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.guessedLetters ['c', 'a']
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.notEqual m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "handles invalid guess - non-alphabetic character" <|
                \_ ->
                    let
                        gameModel = 
                            { init 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "1"
                            , gameState = Playing
                            }
                        updatedModel = update MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.notEqual m.errorMessage Nothing
                        ]
                        updatedModel
            
            , test "transitions to GameOver screen when game is won" <|
                \_ ->
                    let
                        gameModel = 
                            { init 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "t"
                            , guessedLetters = ['c', 'a']
                            , gameState = Playing
                            }
                        updatedModel = update MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen GameOver
                        , \m -> Expect.equal m.gameState Won
                        , \m -> Expect.equal m.guessedLetters ['c', 'a', 't']
                        ]
                        updatedModel
            
            , test "transitions to GameOver screen when game is lost" <|
                \_ ->
                    let
                        gameModel = 
                            { init 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "z"
                            , guessedLetters = ['x', 'y', 'w', 'v', 'u']
                            , remainingGuesses = 1
                            , gameState = Playing
                            }
                        updatedModel = update MakeGuess gameModel
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
                            { init 
                            | currentScreen = GameOver
                            , currentWord = "cat"
                            , userInput = "c"
                            , gameState = Won
                            }
                        updatedModel = update MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.currentScreen GameOver
                        , \m -> Expect.equal m.gameState Won
                        ]
                        updatedModel
            ]
        , describe "PlayAgain message"
            [ test "resets game state and transitions to DifficultySelection" <|
                \_ ->
                    let
                        gameOverModel = 
                            { init 
                            | currentScreen = GameOver
                            , currentWord = "cat"
                            , guessedLetters = ['c', 'a', 't']
                            , remainingGuesses = 3
                            , gameState = Won
                            , selectedDifficulty = Just Easy
                            }
                        updatedModel = update PlayAgain gameOverModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen DifficultySelection
                        , \m -> Expect.equal m.currentWord ""
                        , \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.gameState Playing
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        , \m -> Expect.equal m.selectedDifficulty Nothing
                        ]
                        updatedModel
            ]
        , describe "BackToStart message"
            [ test "resets to initial state and transitions to Start screen" <|
                \_ ->
                    let
                        gameModel = 
                            { init 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , guessedLetters = ['c', 'a']
                            , remainingGuesses = 4
                            , selectedDifficulty = Just Medium
                            , userInput = "test"
                            }
                        updatedModel = update BackToStart gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Start
                        , \m -> Expect.equal m.currentWord ""
                        , \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.gameState Playing
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        , \m -> Expect.equal m.selectedDifficulty Nothing
                        ]
                        updatedModel
            ]
        , describe "ClearError message"
            [ test "clears error message without changing other state" <|
                \_ ->
                    let
                        modelWithError = 
                            { init 
                            | errorMessage = Just "Test error"
                            , currentScreen = Game
                            , currentWord = "cat"
                            }
                        updatedModel = update ClearError modelWithError
                    in
                    Expect.all
                        [ \m -> Expect.equal m.errorMessage Nothing
                        , \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal m.currentWord "cat"
                        ]
                        updatedModel
            ]
        ]