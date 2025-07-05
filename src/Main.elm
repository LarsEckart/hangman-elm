module Main exposing (update, init)

import Types exposing (..)
import GameLogic exposing (..)
import Words exposing (getRandomWord)


-- Initialize the application model
init : Model
init =
    initialModel


-- Update function to handle all messages and state transitions
update : Msg -> Model -> Model
update msg model =
    case msg of
        StartGame ->
            { model 
            | currentScreen = DifficultySelection
            , errorMessage = Nothing
            }
        
        SelectDifficulty difficulty ->
            let
                -- Use a simple seed based on the difficulty for deterministic testing
                seed = case difficulty of
                    Easy -> 0
                    Medium -> 1
                    Hard -> 2
                
                selectedWord = getRandomWord difficulty seed
            in
            { model 
            | currentScreen = Game
            , selectedDifficulty = Just difficulty
            , currentWord = selectedWord
            , guessedLetters = []
            , remainingGuesses = maxGuesses
            , gameState = Playing
            , userInput = ""
            , errorMessage = Nothing
            }
        
        UpdateInput input ->
            { model 
            | userInput = input
            , errorMessage = Nothing
            }
        
        MakeGuess ->
            if model.gameState /= Playing then
                -- Don't process guesses if game is already over
                model
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
                        { model 
                        | guessedLetters = newGuessedLetters
                        , remainingGuesses = newRemainingGuesses
                        , gameState = newGameState
                        , currentScreen = newScreen
                        , userInput = ""
                        , errorMessage = Nothing
                        }
                    
                    Err errorMsg ->
                        { model 
                        | userInput = ""
                        , errorMessage = Just errorMsg
                        }
        
        PlayAgain ->
            { model 
            | currentScreen = DifficultySelection
            , selectedDifficulty = Nothing
            , currentWord = ""
            , guessedLetters = []
            , remainingGuesses = maxGuesses
            , gameState = Playing
            , userInput = ""
            , errorMessage = Nothing
            }
        
        BackToStart ->
            init
        
        ClearError ->
            { model | errorMessage = Nothing }


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