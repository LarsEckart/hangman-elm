module UpdateTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Types exposing (..)
import Main exposing (update, init)


-- Helper function to get the initial model from init
initialModel : Model
initialModel =
    Tuple.first (init ())


-- Helper function to extract model from update result
updateModel : Msg -> Model -> Model
updateModel msg model =
    Tuple.first (update msg model)


-- Test suite for update function and model initialization
suite : Test
suite =
    describe "Update function and model initialization"
        [ describe "Model initialization"
            [ test "init returns correct initial model" <|
                \_ ->
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Start
                        , \m -> Expect.equal m.selectedDifficulty Nothing
                        , \m -> Expect.equal m.currentWord ""
                        , \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.gameState Playing
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        , \m -> Expect.equal m.uiLanguage English  -- Default UI language
                        ]
                        initialModel
            ]
        , describe "StartGame message"
            [ test "transitions from Start to LanguageSelection screen" <|
                \_ ->
                    let
                        updatedModel = updateModel StartGame initialModel
                    in
                    Expect.equal updatedModel.currentScreen LanguageSelection
            
            , test "clears error message when starting game" <|
                \_ ->
                    let
                        modelWithError = { initialModel | errorMessage = Just (GameStateError "Previous error") }
                        updatedModel = updateModel StartGame modelWithError
                    in
                    Expect.equal updatedModel.errorMessage Nothing
            ]
        , describe "SelectDifficulty message"
            [ test "selects difficulty and loads embedded words when language and category are selected" <|
                \_ ->
                    let
                        modelWithSelections = 
                            { initialModel 
                            | currentScreen = DifficultySelection
                            , selectedLanguage = Just English
                            , selectedCategory = Just Animals
                            }
                        updatedModel = updateModel (SelectDifficulty Easy) modelWithSelections
                    in
                    Expect.all
                        [ \m -> Expect.equal m.selectedDifficulty (Just Easy)
                        , \m -> Expect.equal m.errorMessage Nothing
                        , \m -> Expect.notEqual m.wordList []
                        ]
                        updatedModel
            
            , test "shows error when language not selected" <|
                \_ ->
                    let
                        modelWithoutLanguage = 
                            { initialModel 
                            | currentScreen = DifficultySelection
                            , selectedCategory = Just Animals
                            }
                        updatedModel = updateModel (SelectDifficulty Easy) modelWithoutLanguage
                    in
                    Expect.equal updatedModel.errorMessage (Just (SelectionIncomplete { missingLanguage = True, missingCategory = False }))
            
            , test "shows error when category not selected" <|
                \_ ->
                    let
                        modelWithoutCategory = 
                            { initialModel 
                            | currentScreen = DifficultySelection
                            , selectedLanguage = Just English
                            }
                        updatedModel = updateModel (SelectDifficulty Easy) modelWithoutCategory
                    in
                    Expect.equal updatedModel.errorMessage (Just (SelectionIncomplete { missingLanguage = False, missingCategory = True }))
            ]
        , describe "UpdateInput message"
            [ test "updates user input field" <|
                \_ ->
                    let
                        updatedModel = updateModel (UpdateInput "a") initialModel
                    in
                    Expect.equal updatedModel.userInput "a"
            
            , test "clears error message when updating input" <|
                \_ ->
                    let
                        modelWithError = { initialModel | errorMessage = Just (GameStateError "Previous error") }
                        updatedModel = updateModel (UpdateInput "b") modelWithError
                    in
                    Expect.equal updatedModel.errorMessage Nothing
            ]
        , describe "MakeGuess message"
            [ test "handles valid guess - correct letter" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "c"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
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
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "x"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
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
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = ""
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
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
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "abc"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
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
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "c"
                            , guessedLetters = ['c', 'a']
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
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
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "1"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
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
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "t"
                            , guessedLetters = ['c', 'a']
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
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
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , userInput = "z"
                            , guessedLetters = ['x', 'y', 'w', 'v', 'u']
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
                            , currentWord = "cat"
                            , userInput = "c"
                            , gameState = Won
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.currentScreen GameOver
                        , \m -> Expect.equal m.gameState Won
                        ]
                        updatedModel
            ]
        , describe "PlayAgain message"
            [ test "falls back to BackToStart when selections are missing" <|
                \_ ->
                    let
                        gameOverModel = 
                            { initialModel 
                            | currentScreen = GameOver
                            , currentWord = "cat"
                            , guessedLetters = ['c', 'a', 't']
                            , remainingGuesses = 3
                            , gameState = Won
                            , selectedDifficulty = Just Easy
                            }
                        updatedModel = updateModel PlayAgain gameOverModel
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
                            , currentWord = "cat"
                            , guessedLetters = ['c', 'a', 't']
                            , remainingGuesses = 3
                            , gameState = Won
                            , selectedLanguage = Just English
                            , selectedCategory = Just Animals
                            , selectedDifficulty = Just Easy
                            }
                        updatedModel = updateModel PlayAgain gameOverModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentWord ""
                        , \m -> Expect.equal m.guessedLetters []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.gameState Playing
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        , \m -> Expect.equal m.selectedDifficulty (Just Easy)
                        , \m -> Expect.equal m.selectedLanguage (Just English)
                        , \m -> Expect.equal m.selectedCategory (Just Animals)
                        ]
                        updatedModel
            ]
        , describe "BackToStart message"
            [ test "resets to initial state and transitions to Start screen" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "cat"
                            , guessedLetters = ['c', 'a']
                            , remainingGuesses = 4
                            , selectedDifficulty = Just Medium
                            , userInput = "test"
                            }
                        updatedModel = updateModel BackToStart gameModel
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
                            { initialModel 
                            | errorMessage = Just (GameStateError "Test error")
                            , currentScreen = Game
                            , currentWord = "cat"
                            }
                        updatedModel = updateModel ClearError modelWithError
                    in
                    Expect.all
                        [ \m -> Expect.equal m.errorMessage Nothing
                        , \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal m.currentWord "cat"
                        ]
                        updatedModel
            ]
        , describe "SelectLanguage message"
            [ test "transitions from LanguageSelection to CategorySelection" <|
                \_ ->
                    let
                        modelOnLanguageScreen = { initialModel | currentScreen = LanguageSelection }
                        updatedModel = updateModel (SelectLanguage English) modelOnLanguageScreen
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen CategorySelection
                        , \m -> Expect.equal m.selectedLanguage (Just English)
                        , \m -> Expect.equal m.uiLanguage English
                        ]
                        updatedModel
            
            , test "selects German language correctly" <|
                \_ ->
                    let
                        modelOnLanguageScreen = { initialModel | currentScreen = LanguageSelection }
                        updatedModel = updateModel (SelectLanguage German) modelOnLanguageScreen
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen CategorySelection
                        , \m -> Expect.equal m.selectedLanguage (Just German)
                        , \m -> Expect.equal m.uiLanguage German
                        ]
                        updatedModel
            
            , test "selects Estonian language correctly" <|
                \_ ->
                    let
                        modelOnLanguageScreen = { initialModel | currentScreen = LanguageSelection }
                        updatedModel = updateModel (SelectLanguage Estonian) modelOnLanguageScreen
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen CategorySelection
                        , \m -> Expect.equal m.selectedLanguage (Just Estonian)
                        , \m -> Expect.equal m.uiLanguage Estonian
                        ]
                        updatedModel
            
            , test "UI language updates to match selected game language" <|
                \_ ->
                    let
                        modelOnLanguageScreen = { initialModel | currentScreen = LanguageSelection }
                        englishModel = updateModel (SelectLanguage English) modelOnLanguageScreen
                        germanModel = updateModel (SelectLanguage German) modelOnLanguageScreen
                        estonianModel = updateModel (SelectLanguage Estonian) modelOnLanguageScreen
                    in
                    Expect.all
                        [ \_ -> Expect.equal englishModel.uiLanguage English
                        , \_ -> Expect.equal germanModel.uiLanguage German
                        , \_ -> Expect.equal estonianModel.uiLanguage Estonian
                        ]
                        ()
            ]
        , describe "SelectCategory message"
            [ test "transitions from CategorySelection to DifficultySelection" <|
                \_ ->
                    let
                        modelOnCategoryScreen = 
                            { initialModel 
                            | currentScreen = CategorySelection
                            , selectedLanguage = Just English
                            }
                        updatedModel = updateModel (SelectCategory Animals) modelOnCategoryScreen
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen DifficultySelection
                        , \m -> Expect.equal m.selectedCategory (Just Animals)
                        ]
                        updatedModel
            
            , test "selects Food category correctly" <|
                \_ ->
                    let
                        modelOnCategoryScreen = 
                            { initialModel 
                            | currentScreen = CategorySelection
                            , selectedLanguage = Just English
                            }
                        updatedModel = updateModel (SelectCategory Food) modelOnCategoryScreen
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen DifficultySelection
                        , \m -> Expect.equal m.selectedCategory (Just Food)
                        ]
                        updatedModel
            
            , test "selects Sport category correctly" <|
                \_ ->
                    let
                        modelOnCategoryScreen = 
                            { initialModel 
                            | currentScreen = CategorySelection
                            , selectedLanguage = Just English
                            }
                        updatedModel = updateModel (SelectCategory Sport) modelOnCategoryScreen
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen DifficultySelection
                        , \m -> Expect.equal m.selectedCategory (Just Sport)
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
                            , wordList = ["cat", "dog", "bird"]
                            }
                        updatedModel = updateModel (WordSelected Easy 1) modelWithWordList
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal m.currentWord "dog"
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
                            , wordList = ["cat", "dog", "bird"]
                            }
                        updatedModel = updateModel (WordSelected Easy 0) modelWithWordList
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal m.currentWord "cat"
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
                            , wordList = ["cat", "dog", "bird"]
                            }
                        updatedModel = updateModel (WordSelected Easy 10) modelWithWordList
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal m.currentWord ""  -- Should default to empty string
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
                        , \m -> Expect.equal m.currentWord ""  -- Should default to empty string
                        ]
                        updatedModel
            ]
        , describe "Edge cases and error conditions"
            [ test "SelectDifficulty handles no words available scenario" <|
                \_ ->
                    let
                        modelWithSelections = 
                            { initialModel 
                            | currentScreen = DifficultySelection
                            , selectedLanguage = Just Estonian  -- Might have limited words
                            , selectedCategory = Just Sport
                            }
                        updatedModel = updateModel (SelectDifficulty Hard) modelWithSelections
                    in
                    -- Should either generate a random word or show error - depends on word availability
                    Expect.notEqual updatedModel.currentScreen Start  -- Should not crash
            
            , test "SelectDifficulty with both language and category missing" <|
                \_ ->
                    let
                        modelWithoutSelections = 
                            { initialModel 
                            | currentScreen = DifficultySelection
                            }
                        updatedModel = updateModel (SelectDifficulty Easy) modelWithoutSelections
                    in
                    Expect.equal updatedModel.errorMessage (Just (SelectionIncomplete { missingLanguage = True, missingCategory = True }))
            
            , test "MakeGuess with winning guess on single letter word" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "a"
                            , userInput = "a"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen GameOver
                        , \m -> Expect.equal m.gameState Won
                        , \m -> Expect.equal m.guessedLetters ['a']
                        ]
                        updatedModel
            
            , test "MakeGuess with case-insensitive input" <|
                \_ ->
                    let
                        gameModel = 
                            { initialModel 
                            | currentScreen = Game
                            , currentWord = "Cat"
                            , userInput = "C"
                            , gameState = Playing
                            }
                        updatedModel = updateModel MakeGuess gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.guessedLetters ['c']  -- Should be lowercase
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
                            , currentWord = "a"
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
                        , \m -> Expect.equal m.currentWord ""
                        , \m -> Expect.equal m.gameState Playing
                        ]
                        thirdUpdate
            ]
        ]