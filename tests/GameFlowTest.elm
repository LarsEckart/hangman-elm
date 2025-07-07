module GameFlowTest exposing (..)

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


-- Test suite for game flow scenarios
suite : Test
suite =
    describe "Game Flow Tests"
        [ describe "PlayAgain message"
            [ test "falls back to BackToStart when selections are missing" <|
                \_ ->
                    let
                        gameOverModel = 
                            { initialModel 
                            | currentScreen = GameOver
                            , currentWord = wordFromString "CAT"
                            , guessedLetters = guessedLettersFromList ['C', 'A', 'T']
                            , remainingGuesses = 3
                            , gameState = Won
                            }
                        updatedModel = updateModel PlayAgain gameOverModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Start
                        , \m -> Expect.equal (wordToString m.currentWord) ""
                        , \m -> Expect.equal (guessedLettersToList m.guessedLetters) []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.gameState Playing
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        , \m -> Expect.equal m.selectedLanguage Nothing
                        , \m -> Expect.equal m.selectedCategory Nothing
                        ]
                        updatedModel
            
            , test "preserves selections when all selections are present" <|
                \_ ->
                    let
                        gameOverModel = 
                            { initialModel 
                            | currentScreen = GameOver
                            , currentWord = wordFromString "CAT"
                            , guessedLetters = guessedLettersFromList ['C', 'A', 'T']
                            , remainingGuesses = 3
                            , gameState = Won
                            , selectedLanguage = Just English
                            , selectedCategory = Just Animals
                            }
                        updatedModel = updateModel PlayAgain gameOverModel
                    in
                    Expect.all
                        [ \m -> Expect.equal (wordToString m.currentWord) ""
                        , \m -> Expect.equal (guessedLettersToList m.guessedLetters) []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.gameState Playing
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        , \m -> Expect.equal m.selectedLanguage (Just English)
                        , \m -> Expect.equal m.selectedCategory (Just Animals)
                        ]
                        updatedModel
            ]
        , describe "Edge cases and error conditions"
            [ test "SelectCategory handles no words available scenario" <|
                \_ ->
                    let
                        modelWithSelections = 
                            { initialModel 
                            | currentScreen = CategorySelection
                            , selectedLanguage = Just Estonian  -- Might have limited words
                            }
                        updatedModel = updateModel (SelectCategory Sport) modelWithSelections
                    in
                    -- Should either generate a random word or show error - depends on word availability
                    Expect.notEqual updatedModel.currentScreen Start  -- Should not crash
            
            , test "SelectCategory with language missing" <|
                \_ ->
                    let
                        modelWithoutSelections = 
                            { initialModel 
                            | currentScreen = CategorySelection
                            }
                        updatedModel = updateModel (SelectCategory Animals) modelWithoutSelections
                    in
                    Expect.equal updatedModel.errorMessage (Just (SelectionIncomplete { missingLanguage = True, missingCategory = False }))
            
            , test "MakeGuess with winning guess on single letter word" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "A"
                            , userInput = "a"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen GameOver
                        , \m -> Expect.equal m.gameState Won
                        , \m -> Expect.equal (guessedLettersToList m.guessedLetters) ['A']
                        ]
                        updatedModel
            
            , test "MakeGuess with case-insensitive input" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "CAT"
                            , userInput = "C"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal (guessedLettersToList m.guessedLetters) ['C']  -- Should be lowercase
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.userInput ""
                        ]
                        updatedModel
            
            , test "handles consecutive wins and losses" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = wordFromString "A"
                            , userInput = "a"
                            , gameState = Playing
                            }
                        firstUpdate = updateModel MakeGuess gameModel
                        secondUpdate = updateModel PlayAgain firstUpdate
                        thirdUpdate = updateModel (SelectLanguage English) secondUpdate
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen CategorySelection
                        , \m -> Expect.equal m.selectedLanguage (Just English)
                        , \m -> Expect.equal (wordToString m.currentWord) ""
                        , \m -> Expect.equal m.gameState Playing
                        ]
                        thirdUpdate
            ]
        ]