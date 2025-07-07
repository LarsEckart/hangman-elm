module InitializationTest exposing (..)

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


-- Test suite for model initialization
suite : Test
suite =
    describe "Model initialization"
        [ test "init returns correct initial model" <|
            \_ ->
                Expect.all
                    [ \m -> Expect.equal m.currentScreen Start
                    , \m -> Expect.equal (wordToString m.currentWord) ""
                    , \m -> Expect.equal (guessedLettersToList m.guessedLetters) []
                    , \m -> Expect.equal m.remainingGuesses maxGuesses
                    , \m -> Expect.equal m.gameState Playing
                    , \m -> Expect.equal m.userInput ""
                    , \m -> Expect.equal m.errorMessage Nothing
                    , \m -> Expect.equal m.uiLanguage English  -- Default UI language
                    ]
                    initialModel
        ]