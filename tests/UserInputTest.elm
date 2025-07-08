module UserInputTest exposing (..)

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



-- Test suite for user input related functionality


suite : Test
suite =
    describe "User Input Tests"
        [ describe "UpdateInput message"
            [ test "updates user input field" <|
                \_ ->
                    let
                        updatedModel =
                            updateModel (UpdateInput "a") initialModel
                    in
                    Expect.equal updatedModel.userInput "a"
            , test "clears error message when updating input" <|
                \_ ->
                    let
                        modelWithError =
                            { initialModel | errorMessage = Just (GameStateError "Previous error") }

                        updatedModel =
                            updateModel (UpdateInput "b") modelWithError
                    in
                    Expect.equal updatedModel.errorMessage Nothing
            ]
        , describe "ClearError message"
            [ test "clears error message without changing other state" <|
                \_ ->
                    let
                        modelWithError =
                            { initialModel
                                | errorMessage = Just (GameStateError "Test error")
                                , currentScreen = Game
                                , currentWord = wordFromString "CAT"
                            }

                        updatedModel =
                            updateModel ClearError modelWithError
                    in
                    Expect.all
                        [ \m -> Expect.equal m.errorMessage Nothing
                        , \m -> Expect.equal m.currentScreen Game
                        , \m -> Expect.equal (wordToString m.currentWord) "CAT"
                        ]
                        updatedModel
            ]
        ]
