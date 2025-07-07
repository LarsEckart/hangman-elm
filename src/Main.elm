module Main exposing (main, init, update)

import Browser
import Html exposing (Html, div)
import Types exposing (..)
import Update exposing (..)
import View exposing (..)
import Styles exposing (appStyles, applyStyles)


-- Initialize the application model
init : () -> (Model, Cmd Msg)
init _ =
    (initialModel, Cmd.none)


-- Update function to handle all messages and state transitions
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        StartGame ->
            handleStartGame model
        
        SelectLanguage language ->
            handleSelectLanguage language model
        
        SelectCategory category ->
            handleSelectCategory category model
        
        SelectDifficulty difficulty ->
            handleSelectDifficulty difficulty model
        
        UpdateInput input ->
            handleUpdateInput input model
        
        MakeGuess ->
            handleMakeGuess model
        
        GuessLetter letter ->
            handleGuessLetter letter model
        
        PlayAgain ->
            handlePlayAgain model
        
        BackToStart ->
            handleBackToStart model
        
        ClearError ->
            handleClearError model
        
        WordSelected difficulty index ->
            handleWordSelected difficulty index model


-- Main view function
view : Model -> Html Msg
view model =
    div (applyStyles appStyles)
        [ case model.currentScreen of
            Start ->
                viewStartScreen model.uiLanguage
            
            LanguageSelection ->
                viewLanguageSelection model.uiLanguage
            
            CategorySelection ->
                viewCategorySelection model.uiLanguage
            
            DifficultySelection ->
                viewDifficultySelection model
            
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