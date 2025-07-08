module NavigationTest exposing (..)

import Expect exposing (Expectation)
import Main exposing (init, update)
import Test exposing (..)
import Types exposing (..)



-- Helper function to get the initial model from init


initialModel : Model
initialModel =
    Tuple.first (init ())



-- Helper function to extract model from update result


updateModel : Msg -> Model -> Model
updateModel msg model =
    Tuple.first (update msg model)



-- Test suite for navigation between screens


suite : Test
suite =
    describe "Navigation between screens"
        [ describe "StartGame message"
            [ test "transitions from Start to LanguageSelection screen" <|
                \_ ->
                    let
                        updatedModel =
                            updateModel StartGame initialModel
                    in
                    Expect.equal updatedModel.currentScreen LanguageSelection
            , test "clears error message when starting game" <|
                \_ ->
                    let
                        modelWithError =
                            { initialModel | errorMessage = Just (GameStateError "Previous error") }

                        updatedModel =
                            updateModel StartGame modelWithError
                    in
                    Expect.equal updatedModel.errorMessage Nothing
            ]
        , describe "SelectLanguage message"
            [ test "transitions from LanguageSelection to CategorySelection" <|
                \_ ->
                    let
                        modelOnLanguageScreen =
                            { initialModel | currentScreen = LanguageSelection }

                        updatedModel =
                            updateModel (SelectLanguage English) modelOnLanguageScreen
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
                        modelOnLanguageScreen =
                            { initialModel | currentScreen = LanguageSelection }

                        updatedModel =
                            updateModel (SelectLanguage German) modelOnLanguageScreen
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
                        modelOnLanguageScreen =
                            { initialModel | currentScreen = LanguageSelection }

                        updatedModel =
                            updateModel (SelectLanguage Estonian) modelOnLanguageScreen
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
                        modelOnLanguageScreen =
                            { initialModel | currentScreen = LanguageSelection }

                        englishModel =
                            updateModel (SelectLanguage English) modelOnLanguageScreen

                        germanModel =
                            updateModel (SelectLanguage German) modelOnLanguageScreen

                        estonianModel =
                            updateModel (SelectLanguage Estonian) modelOnLanguageScreen
                    in
                    Expect.all
                        [ \_ -> Expect.equal englishModel.uiLanguage English
                        , \_ -> Expect.equal germanModel.uiLanguage German
                        , \_ -> Expect.equal estonianModel.uiLanguage Estonian
                        ]
                        ()
            ]
        , describe "SelectCategory message"
            [ test "loads word list and stays on CategorySelection until word is selected" <|
                \_ ->
                    let
                        modelOnCategoryScreen =
                            { initialModel
                                | currentScreen = CategorySelection
                                , selectedLanguage = Just English
                            }

                        updatedModel =
                            updateModel (SelectCategory Animals) modelOnCategoryScreen
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen CategorySelection
                        , \m -> Expect.equal m.selectedCategory (Just Animals)
                        , \m -> Expect.notEqual m.wordList []
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

                        updatedModel =
                            updateModel (SelectCategory Food) modelOnCategoryScreen
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen CategorySelection
                        , \m -> Expect.equal m.selectedCategory (Just Food)
                        , \m -> Expect.notEqual m.wordList []
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

                        updatedModel =
                            updateModel (SelectCategory Sport) modelOnCategoryScreen
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen CategorySelection
                        , \m -> Expect.equal m.selectedCategory (Just Sport)
                        , \m -> Expect.notEqual m.wordList []
                        ]
                        updatedModel
            ]
        , describe "WordSelected message"
            [ test "transitions from CategorySelection to Game screen" <|
                \_ ->
                    let
                        modelWithWordList =
                            { initialModel
                                | currentScreen = CategorySelection
                                , selectedLanguage = Just English
                                , selectedCategory = Just Animals
                                , wordList = [ "CAT", "DOG", "BIRD" ]
                            }

                        updatedModel =
                            updateModel (WordSelected 1) modelWithWordList
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal (wordToString m.currentWord) "DOG"
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
                                , currentWord = wordFromString "CAT"
                                , guessedLetters = guessedLettersFromList [ 'C', 'A' ]
                                , remainingGuesses = 4
                                , userInput = "test"
                            }

                        updatedModel =
                            updateModel BackToStart gameModel
                    in
                    Expect.all
                        [ \m -> Expect.equal m.currentScreen Start
                        , \m -> Expect.equal (wordToString m.currentWord) ""
                        , \m -> Expect.equal (guessedLettersToList m.guessedLetters) []
                        , \m -> Expect.equal m.remainingGuesses maxGuesses
                        , \m -> Expect.equal m.gameState Playing
                        , \m -> Expect.equal m.userInput ""
                        , \m -> Expect.equal m.errorMessage Nothing
                        ]
                        updatedModel
            ]
        ]
