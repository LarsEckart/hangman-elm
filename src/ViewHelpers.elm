module ViewHelpers exposing
    ( formatGuessedLetters
    , formatMaskedWord
    , getAlphabetForLanguage
    , getCategoryName
    , viewErrorMessage
    , viewLetterButtons
    )

import GameLogic exposing (isLetterInWord)
import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Styles exposing (applyStyles, clearErrorButtonStyles, errorMessageStyles, letterButtonCorrectStyles, letterButtonStyles, letterButtonWrongStyles)
import Translations as T
import Types exposing (..)



-- HELPER FUNCTIONS FOR VIEW
-- Format masked word with spaces between letters


formatMaskedWord : String -> String
formatMaskedWord word =
    String.toList word
        |> List.map String.fromChar
        |> String.join " "



-- Format guessed letters as a comma-separated list


formatGuessedLetters : Language -> GuessedLetters -> String
formatGuessedLetters uiLanguage guessedLetters =
    let
        letters =
            guessedLettersToList guessedLetters
    in
    if List.isEmpty letters then
        T.translate uiLanguage T.None

    else
        letters
            |> List.map String.fromChar
            |> String.join ", "



-- Get category name for display


getCategoryName : Language -> Maybe Category -> String
getCategoryName uiLanguage maybeCategory =
    case maybeCategory of
        Just Animals ->
            T.translate uiLanguage T.Animals

        Just Food ->
            T.translate uiLanguage T.Food

        Just Sport ->
            T.translate uiLanguage T.Sport

        Nothing ->
            T.translate uiLanguage T.Unknown



-- View error message if present


viewErrorMessage : Language -> Maybe AppError -> Html Msg
viewErrorMessage uiLanguage maybeError =
    case maybeError of
        Just error ->
            div (applyStyles errorMessageStyles)
                [ p [] [ text (errorToString uiLanguage error) ]
                , button (applyStyles clearErrorButtonStyles ++ [ onClick ClearError ]) [ text (T.translate uiLanguage T.ClearError) ]
                ]

        Nothing ->
            text ""



-- Get alphabet for specific language


getAlphabetForLanguage : Language -> String
getAlphabetForLanguage language =
    case language of
        English ->
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        German ->
            "ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß"

        Estonian ->
            "ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜÕŠŽ"



-- Generate letter buttons for the alphabet


viewLetterButtons : Language -> Word -> GuessedLetters -> GameState -> List (Html Msg)
viewLetterButtons language currentWord guessedLetters gameState =
    let
        alphabet =
            getAlphabetForLanguage language
                |> String.toList

        makeButton : Char -> Html Msg
        makeButton letter =
            let
                isGuessed =
                    isLetterGuessed letter guessedLetters

                isInWord =
                    isLetterInWord (Char.toUpper letter) currentWord

                isDisabled =
                    gameState /= Playing || isGuessed

                buttonStyle =
                    if isGuessed then
                        if isInWord then
                            letterButtonCorrectStyles

                        else
                            letterButtonWrongStyles

                    else
                        letterButtonStyles
            in
            button
                (applyStyles buttonStyle
                    ++ [ onClick (GuessLetter (Char.toUpper letter))
                       , disabled isDisabled
                       ]
                )
                [ text (String.fromChar letter) ]
    in
    List.map makeButton alphabet
