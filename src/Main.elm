module Main exposing (main, update, init)

import Browser
import Html exposing (Html, div, h1, h2, p, button, input, text, span)
import Html.Attributes exposing (class, type_, value, placeholder, disabled)
import Html.Events exposing (onClick, onInput)
import Random
import Types exposing (..)
import GameLogic exposing (..)
import Words exposing (getRandomWord, getWordsByDifficulty)


-- Initialize the application model
init : () -> (Model, Cmd Msg)
init _ =
    (initialModel, Cmd.none)


-- Update function to handle all messages and state transitions
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        StartGame ->
            ( { model 
            | currentScreen = DifficultySelection
            , errorMessage = Nothing
            }
            , Cmd.none
            )
        
        SelectDifficulty difficulty ->
            let
                words = getWordsByDifficulty difficulty
                wordCount = List.length words
                generator = Random.int 0 (wordCount - 1)
            in
            ( { model 
            | selectedDifficulty = Just difficulty
            , guessedLetters = []
            , remainingGuesses = maxGuesses
            , gameState = Playing
            , userInput = ""
            , errorMessage = Nothing
            }
            , Random.generate (WordSelected difficulty) generator
            )
        
        UpdateInput input ->
            ( { model 
            | userInput = input
            , errorMessage = Nothing
            }
            , Cmd.none
            )
        
        MakeGuess ->
            if model.gameState /= Playing then
                -- Don't process guesses if game is already over
                (model, Cmd.none)
            else
                case validateGuess model.userInput model.guessedLetters of
                    Ok letter ->
                        let
                            -- Update guessed letters
                            newGuessedLetters = updateGuessedLetters letter model.guessedLetters
                            
                            -- Calculate remaining guesses
                            newRemainingGuesses = calculateRemainingGuesses model.currentWord newGuessedLetters maxGuesses
                            
                            -- Determine new game state
                            newGameState = 
                                if isGameWon model.currentWord newGuessedLetters then
                                    Won
                                else if isGameLost newRemainingGuesses then
                                    Lost
                                else
                                    Playing
                            
                            -- Determine new screen
                            newScreen = 
                                if newGameState == Won || newGameState == Lost then
                                    GameOver
                                else
                                    Game
                        in
                        ( { model 
                        | guessedLetters = newGuessedLetters
                        , remainingGuesses = newRemainingGuesses
                        , gameState = newGameState
                        , currentScreen = newScreen
                        , userInput = ""
                        , errorMessage = Nothing
                        }
                        , Cmd.none
                        )
                    
                    Err errorMsg ->
                        ( { model 
                        | userInput = ""
                        , errorMessage = Just errorMsg
                        }
                        , Cmd.none
                        )
        
        PlayAgain ->
            ( { model 
            | currentScreen = DifficultySelection
            , selectedDifficulty = Nothing
            , currentWord = ""
            , guessedLetters = []
            , remainingGuesses = maxGuesses
            , gameState = Playing
            , userInput = ""
            , errorMessage = Nothing
            }
            , Cmd.none
            )
        
        BackToStart ->
            init ()
        
        ClearError ->
            ( { model | errorMessage = Nothing }
            , Cmd.none
            )
        
        WordSelected difficulty index ->
            let
                selectedWord = getRandomWord difficulty index
            in
            ( { model 
            | currentScreen = Game
            , currentWord = selectedWord
            }
            , Cmd.none
            )


-- VIEW FUNCTIONS

-- Start screen view
viewStartScreen : Html Msg
viewStartScreen =
    div [ class "screen start-screen" ]
        [ h1 [ class "game-title" ] [ text "🎯 HANGMAN GAME" ]
        , p [ class "game-description" ] [ text "Guess the word letter by letter!" ]
        , button [ class "start-button", onClick StartGame ] [ text "Start Game" ]
        ]


-- Difficulty selection screen view
viewDifficultySelection : Html Msg
viewDifficultySelection =
    div [ class "screen difficulty-screen" ]
        [ h2 [ class "screen-title" ] [ text "Choose Difficulty" ]
        , div [ class "difficulty-buttons" ]
            [ button [ class "difficulty-button easy", onClick (SelectDifficulty Easy) ]
                [ text "Easy"
                , p [ class "difficulty-description" ] [ text "3-5 letter words" ]
                ]
            , button [ class "difficulty-button medium", onClick (SelectDifficulty Medium) ]
                [ text "Medium"
                , p [ class "difficulty-description" ] [ text "6-8 letter words" ]
                ]
            , button [ class "difficulty-button hard", onClick (SelectDifficulty Hard) ]
                [ text "Hard"
                , p [ class "difficulty-description" ] [ text "9+ letter words" ]
                ]
            ]
        ]


-- Game screen view
viewGameScreen : Model -> Html Msg
viewGameScreen model =
    div [ class "screen game-screen" ]
        [ h2 [ class "screen-title" ] [ text "Hangman" ]
        , div [ class "game-info" ]
            [ p [ class "difficulty-display" ] 
                [ text ("Difficulty: " ++ (getDifficultyName model.selectedDifficulty)) ]
            , p [ class "remaining-guesses" ] 
                [ text ("Remaining guesses: " ++ String.fromInt model.remainingGuesses) ]
            ]
        , div [ class "word-display" ]
            [ h1 [ class "masked-word" ] [ text (formatMaskedWord (getMaskedWord model.currentWord model.guessedLetters)) ]
            ]
        , div [ class "guessed-letters" ]
            [ p [ class "guessed-title" ] [ text "Guessed letters:" ]
            , p [ class "guessed-list" ] [ text (formatGuessedLetters model.guessedLetters) ]
            ]
        , div [ class "guess-input" ]
            [ input 
                [ type_ "text"
                , value model.userInput
                , onInput UpdateInput
                , placeholder "Enter a letter..."
                , class "letter-input"
                , disabled (model.gameState /= Playing)
                ] []
            , button 
                [ onClick MakeGuess
                , class "guess-button"
                , disabled (model.gameState /= Playing || String.isEmpty model.userInput)
                ] [ text "Guess" ]
            ]
        , viewErrorMessage model.errorMessage
        ]


-- Game over screen view
viewGameOver : Model -> Html Msg
viewGameOver model =
    div [ class "screen game-over-screen" ]
        [ h2 [ class "screen-title" ] [ text "Game Over" ]
        , div [ class "game-result" ]
            [ h1 [ class ("result-message " ++ (if model.gameState == Won then "won" else "lost")) ]
                [ text (if model.gameState == Won then "🎉 You Won!" else "💀 You Lost!") ]
            , div [ class "word-reveal" ]
                [ p [ class "word-label" ] [ text "The word was:" ]
                , h2 [ class "revealed-word" ] [ text (String.toUpper model.currentWord) ]
                ]
            , div [ class "game-stats" ]
                [ p [] [ text ("Guessed letters: " ++ formatGuessedLetters model.guessedLetters) ]
                , p [] [ text ("Remaining guesses: " ++ String.fromInt model.remainingGuesses) ]
                ]
            ]
        , div [ class "game-over-buttons" ]
            [ button [ class "play-again-button", onClick PlayAgain ] [ text "Play Again" ]
            , button [ class "back-to-start-button", onClick BackToStart ] [ text "Back to Start" ]
            ]
        ]


-- Main view function
view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ case model.currentScreen of
            Start ->
                viewStartScreen
            
            DifficultySelection ->
                viewDifficultySelection
            
            Game ->
                viewGameScreen model
            
            GameOver ->
                viewGameOver model
        ]


-- Main program definition
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


-- HELPER FUNCTIONS FOR VIEW

-- Format masked word with spaces between letters
formatMaskedWord : String -> String
formatMaskedWord word =
    String.toList word
        |> List.map String.fromChar
        |> String.join " "


-- Format guessed letters as a comma-separated list
formatGuessedLetters : List Char -> String
formatGuessedLetters letters =
    if List.isEmpty letters then
        "None"
    else
        letters
            |> List.map (String.fromChar >> String.toUpper)
            |> String.join ", "


-- Get difficulty name for display
getDifficultyName : Maybe Difficulty -> String
getDifficultyName maybeDifficulty =
    case maybeDifficulty of
        Just Easy -> "Easy"
        Just Medium -> "Medium"
        Just Hard -> "Hard"
        Nothing -> "Unknown"


-- View error message if present
viewErrorMessage : Maybe String -> Html Msg
viewErrorMessage maybeError =
    case maybeError of
        Just errorMsg ->
            div [ class "error-message" ]
                [ p [] [ text errorMsg ]
                , button [ class "clear-error-button", onClick ClearError ] [ text "×" ]
                ]
        
        Nothing ->
            text ""


-- Helper function to validate user input for making a guess
validateGuess : String -> List Char -> Result String Char
validateGuess input guessedLetters =
    case String.toList input of
        [] ->
            Err "Please enter a letter"
        
        [char] ->
            if not (Char.isAlpha char) then
                Err "Please enter only letters"
            else if List.member (Char.toLower char) (List.map Char.toLower guessedLetters) then
                Err "You already guessed that letter"
            else
                Ok char
        
        _ ->
            Err "Please enter only one letter"