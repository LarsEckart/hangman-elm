module View exposing
    ( viewCategorySelection
    , viewGameOver
    , viewGameScreen
    , viewLanguageSelection
    , viewStartScreen
    )

import GameLogic exposing (getMaskedWord)
import Html exposing (Html, button, div, h1, h2, p, text)
import Html.Events exposing (onClick)
import Styles exposing (..)
import Translations as T
import Types exposing (..)
import ViewHelpers exposing (formatGuessedLetters, formatMaskedWord, getCategoryName, viewErrorMessage, viewLetterButtons)



-- VIEW FUNCTIONS
-- Start screen view


viewStartScreen : Language -> Html Msg
viewStartScreen uiLanguage =
    div (applyStyles screenStyles)
        [ h1 (applyStyles gameTitleStyles) [ text (T.translate uiLanguage T.GameTitle) ]
        , p (applyStyles gameDescriptionStyles) [ text (T.translate uiLanguage T.GameDescription) ]
        , button (applyStyles buttonBaseStyles ++ [ onClick StartGame ]) [ text (T.translate uiLanguage T.StartGame) ]
        ]



-- Language selection screen view


viewLanguageSelection : Language -> Html Msg
viewLanguageSelection uiLanguage =
    div (applyStyles screenStyles)
        [ h2 (applyStyles screenTitleStyles) [ text (T.translate uiLanguage T.ChooseLanguage) ]
        , div (applyStyles buttonContainerStyles)
            [ button (applyStyles buttonBaseStyles ++ [ onClick (SelectLanguage English) ]) [ text (T.translate uiLanguage T.EnglishLanguage) ]
            , button (applyStyles buttonBaseStyles ++ [ onClick (SelectLanguage German) ]) [ text (T.translate uiLanguage T.GermanLanguage) ]
            , button (applyStyles buttonBaseStyles ++ [ onClick (SelectLanguage Estonian) ]) [ text (T.translate uiLanguage T.EstonianLanguage) ]
            ]
        ]



-- Category selection screen view


viewCategorySelection : Language -> Html Msg
viewCategorySelection uiLanguage =
    div (applyStyles screenStyles)
        [ h2 (applyStyles screenTitleStyles) [ text (T.translate uiLanguage T.ChooseCategory) ]
        , div (applyStyles buttonContainerStyles)
            [ button (applyStyles buttonBaseStyles ++ [ onClick (SelectCategory Animals) ]) [ text (T.translate uiLanguage T.Animals) ]
            , button (applyStyles buttonBaseStyles ++ [ onClick (SelectCategory Food) ]) [ text (T.translate uiLanguage T.Food) ]
            , button (applyStyles buttonBaseStyles ++ [ onClick (SelectCategory Sport) ]) [ text (T.translate uiLanguage T.Sport) ]
            ]
        ]



-- Game screen view


viewGameScreen : Model -> Html Msg
viewGameScreen model =
    div (applyStyles screenStyles)
        [ h2 (applyStyles screenTitleStyles) [ text (T.translate model.uiLanguage T.Hangman) ]
        , div (applyStyles gameInfoStyles)
            [ p []
                [ text (getCategoryName model.uiLanguage model.selectedCategory) ]
            , p []
                [ text (T.translate model.uiLanguage T.RemainingGuesses ++ String.fromInt model.remainingGuesses) ]
            ]
        , div (applyStyles wordDisplayStyles)
            [ h1 (applyStyles maskedWordStyles) [ text (formatMaskedWord (getMaskedWord model.currentWord model.guessedLetters)) ]
            ]
        , div (applyStyles letterButtonsContainerStyles)
            (viewLetterButtons (Maybe.withDefault English model.selectedLanguage) model.currentWord model.guessedLetters model.gameState)
        , viewErrorMessage model.uiLanguage model.errorMessage
        ]



-- Game over screen view


viewGameOver : Model -> Html Msg
viewGameOver model =
    div (applyStyles screenStyles)
        [ h2 (applyStyles screenTitleStyles) [ text (T.translate model.uiLanguage T.GameOver) ]
        , div (applyStyles gameResultStyles)
            [ h1
                (applyStyles resultMessageStyles
                    ++ applyStyles
                        (if model.gameState == Won then
                            wonStyles

                         else
                            lostStyles
                        )
                )
                [ text
                    (if model.gameState == Won then
                        T.translate model.uiLanguage T.YouWon

                     else
                        T.translate model.uiLanguage T.YouLost
                    )
                ]
            , div (applyStyles wordRevealStyles)
                [ p (applyStyles wordLabelStyles) [ text (T.translate model.uiLanguage T.WordWas) ]
                , h2 (applyStyles revealedWordStyles) [ text (wordToString model.currentWord) ]
                ]
            , div (applyStyles gameStatsStyles)
                [ p [] [ text (T.translate model.uiLanguage T.GuessedLettersStats ++ formatGuessedLetters model.uiLanguage model.guessedLetters) ]
                , p [] [ text (T.translate model.uiLanguage T.RemainingGuessesStats ++ String.fromInt model.remainingGuesses) ]
                ]
            ]
        , div (applyStyles gameOverButtonsStyles)
            [ button (applyStyles buttonBaseStyles ++ [ onClick PlayAgain ]) [ text (T.translate model.uiLanguage T.PlayAgain) ]
            , button (applyStyles buttonBaseStyles ++ [ onClick BackToStart ]) [ text (T.translate model.uiLanguage T.BackToStart) ]
            ]
        ]
