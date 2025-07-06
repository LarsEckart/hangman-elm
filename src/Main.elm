module Main exposing (main, update, init)

import Browser
import Html exposing (Html, div, h1, h2, p, button, input, text, span)
import Html.Attributes exposing (class, type_, value, placeholder, disabled)
import Html.Events exposing (onClick, onInput)
import Random
import Types exposing (..)
import GameLogic exposing (..)
import Generated.WordLists as EmbeddedWordLists
import ViewConstants exposing (..)


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
        
        PlayAgain ->
            handlePlayAgain model
        
        BackToStart ->
            handleBackToStart model
        
        ClearError ->
            handleClearError model
        
        WordSelected difficulty index ->
            handleWordSelected difficulty index model


-- MESSAGE HANDLERS

-- Handle starting the game
handleStartGame : Model -> (Model, Cmd Msg)
handleStartGame model =
    ( { model 
      | currentScreen = LanguageSelection
      , errorMessage = Nothing
      }
    , Cmd.none
    )


-- Handle language selection
handleSelectLanguage : Language -> Model -> (Model, Cmd Msg)
handleSelectLanguage language model =
    ( { model 
      | selectedLanguage = Just language
      , currentScreen = CategorySelection
      }
    , Cmd.none
    )


-- Handle category selection
handleSelectCategory : Category -> Model -> (Model, Cmd Msg)
handleSelectCategory category model =
    ( { model 
      | selectedCategory = Just category
      , currentScreen = DifficultySelection
      }
    , Cmd.none
    )


-- Handle difficulty selection
handleSelectDifficulty : Difficulty -> Model -> (Model, Cmd Msg)
handleSelectDifficulty difficulty model =
    case (model.selectedLanguage, model.selectedCategory) of
        (Just language, Just category) ->
            let
                availableWords = EmbeddedWordLists.getWordList language category difficulty
            in
            if List.isEmpty availableWords then
                ( { model | errorMessage = Just (NoWordsAvailable language category difficulty) }
                , Cmd.none
                )
            else
                ( { model 
                  | selectedDifficulty = Just difficulty
                  , wordList = availableWords
                  , errorMessage = Nothing
                  }
                , Random.generate (WordSelected difficulty) (Random.int 0 (List.length availableWords - 1))
                )
        _ ->
            -- This shouldn't happen in normal flow
            let
                missingLanguage = model.selectedLanguage == Nothing
                missingCategory = model.selectedCategory == Nothing
            in
            ( { model | errorMessage = Just (SelectionIncomplete { missingLanguage = missingLanguage, missingCategory = missingCategory }) }
            , Cmd.none 
            )


-- Handle input updates
handleUpdateInput : String -> Model -> (Model, Cmd Msg)
handleUpdateInput input model =
    ( { model 
      | userInput = input
      , errorMessage = Nothing
      }
    , Cmd.none
    )


-- Handle making a guess
handleMakeGuess : Model -> (Model, Cmd Msg)
handleMakeGuess model =
    if model.gameState /= Playing then
        -- Don't process guesses if game is already over
        (model, Cmd.none)
    else
        case validateUserInput model.userInput model.guessedLetters of
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
            
            Err error ->
                ( { model 
                  | userInput = ""
                  , errorMessage = Just error
                  }
                , Cmd.none
                )


-- Handle playing again
handlePlayAgain : Model -> (Model, Cmd Msg)
handlePlayAgain model =
    ( resetGame model
    |> (\resetModel -> { resetModel 
        | currentScreen = LanguageSelection
        , selectedLanguage = Nothing
        , selectedCategory = Nothing
        , selectedDifficulty = Nothing
        })
    , Cmd.none
    )


-- Handle back to start
handleBackToStart : Model -> (Model, Cmd Msg)
handleBackToStart model =
    init ()


-- Handle clearing error
handleClearError : Model -> (Model, Cmd Msg)
handleClearError model =
    ( { model | errorMessage = Nothing }
    , Cmd.none
    )


-- Handle word selection
handleWordSelected : Difficulty -> Int -> Model -> (Model, Cmd Msg)
handleWordSelected difficulty index model =
    let
        selectedWord = 
            model.wordList
                |> List.drop index
                |> List.head
                |> Maybe.withDefault ""
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
    screenContainer startScreenClass
        [ h1 [ class gameTitleClass ] [ text gameTitleText ]
        , p [ class gameDescriptionClass ] [ text gameDescriptionText ]
        , button [ class startButtonClass, onClick StartGame ] [ text startGameText ]
        ]


-- Language selection screen view
viewLanguageSelection : Html Msg
viewLanguageSelection =
    screenContainer languageScreenClass
        [ titleHeader chooseLanguageText
        , selectionButtonContainer selectionButtonsClass
            [ selectionButton selectionButtonClass englishText (SelectLanguage English)
            , selectionButton selectionButtonClass germanText (SelectLanguage German)
            , selectionButton selectionButtonClass estonianText (SelectLanguage Estonian)
            ]
        ]


-- Category selection screen view
viewCategorySelection : Html Msg
viewCategorySelection =
    screenContainer categoryScreenClass
        [ titleHeader chooseCategoryText
        , selectionButtonContainer selectionButtonsClass
            [ selectionButton selectionButtonClass animalsText (SelectCategory Animals)
            , selectionButton selectionButtonClass foodText (SelectCategory Food)
            , selectionButton selectionButtonClass sportText (SelectCategory Sport)
            ]
        ]


-- Difficulty selection screen view
viewDifficultySelection : Model -> Html Msg
viewDifficultySelection model =
    screenContainer difficultyScreenClass
        [ titleHeader chooseDifficultyText
        , selectionButtonContainer difficultyButtonsClass
            [ difficultyButton difficultyButtonClass easyClass easyText easyDescriptionText (SelectDifficulty Easy)
            , difficultyButton difficultyButtonClass mediumClass mediumText mediumDescriptionText (SelectDifficulty Medium)
            , difficultyButton difficultyButtonClass hardClass hardText hardDescriptionText (SelectDifficulty Hard)
            ]
        , viewErrorMessage model.errorMessage
        ]


-- Game screen view
viewGameScreen : Model -> Html Msg
viewGameScreen model =
    screenContainer gameScreenClass
        [ titleHeader hangmanText
        , div [ class gameInfoClass ]
            [ p [ class difficultyDisplayClass ] 
                [ text (difficultyLabelText ++ (getDifficultyName model.selectedDifficulty)) ]
            , p [ class remainingGuessesClass ] 
                [ text (remainingGuessesText ++ String.fromInt model.remainingGuesses) ]
            ]
        , div [ class wordDisplayClass ]
            [ h1 [ class maskedWordClass ] [ text (formatMaskedWord (getMaskedWord model.currentWord model.guessedLetters)) ]
            ]
        , div [ class guessedLettersClass ]
            [ p [ class guessedTitleClass ] [ text guessedLettersText ]
            , p [ class guessedListClass ] [ text (formatGuessedLetters model.guessedLetters) ]
            ]
        , div [ class guessInputClass ]
            [ input 
                [ type_ "text"
                , value model.userInput
                , onInput UpdateInput
                , placeholder enterLetterPlaceholder
                , class letterInputClass
                , disabled (model.gameState /= Playing)
                ] []
            , button 
                [ onClick MakeGuess
                , class guessButtonClass
                , disabled (model.gameState /= Playing || String.isEmpty model.userInput)
                ] [ text guessText ]
            ]
        , viewErrorMessage model.errorMessage
        ]


-- Game over screen view
viewGameOver : Model -> Html Msg
viewGameOver model =
    screenContainer gameOverScreenClass
        [ titleHeader gameOverText
        , div [ class gameResultClass ]
            [ h1 [ class (resultMessageClass ++ " " ++ (if model.gameState == Won then wonClass else lostClass)) ]
                [ text (if model.gameState == Won then youWonText else youLostText) ]
            , div [ class wordRevealClass ]
                [ p [ class wordLabelClass ] [ text wordWasText ]
                , h2 [ class revealedWordClass ] [ text (String.toUpper model.currentWord) ]
                ]
            , div [ class gameStatsClass ]
                [ p [] [ text (guessedLettersStatsText ++ formatGuessedLetters model.guessedLetters) ]
                , p [] [ text (remainingGuessesStatsText ++ String.fromInt model.remainingGuesses) ]
                ]
            ]
        , div [ class gameOverButtonsClass ]
            [ button [ class playAgainButtonClass, onClick PlayAgain ] [ text playAgainText ]
            , button [ class backToStartButtonClass, onClick BackToStart ] [ text backToStartText ]
            ]
        ]


-- Main view function
view : Model -> Html Msg
view model =
    div [ class appClass ]
        [ case model.currentScreen of
            Start ->
                viewStartScreen
            
            LanguageSelection ->
                viewLanguageSelection
            
            CategorySelection ->
                viewCategorySelection
            
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


-- REUSABLE VIEW COMPONENTS

-- Screen container with specific class
screenContainer : String -> List (Html msg) -> Html msg
screenContainer specificClass content =
    div [ class (screenClass ++ " " ++ specificClass) ] content


-- Title header for screens
titleHeader : String -> Html msg
titleHeader title =
    h2 [ class screenTitleClass ] [ text title ]


-- Standard selection button
selectionButton : String -> String -> msg -> Html msg
selectionButton className label clickMsg =
    button [ class className, onClick clickMsg ] [ text label ]


-- Container for selection buttons
selectionButtonContainer : String -> List (Html msg) -> Html msg
selectionButtonContainer className buttons =
    div [ class className ] buttons


-- Difficulty button with description
difficultyButton : String -> String -> String -> String -> msg -> Html msg
difficultyButton baseClass extraClass label description clickMsg =
    button [ class (baseClass ++ " " ++ extraClass), onClick clickMsg ]
        [ text label
        , p [ class difficultyDescriptionClass ] [ text description ]
        ]


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
        noneText
    else
        letters
            |> List.map (String.fromChar >> String.toUpper)
            |> String.join ", "


-- Get difficulty name for display
getDifficultyName : Maybe Difficulty -> String
getDifficultyName maybeDifficulty =
    case maybeDifficulty of
        Just Easy -> easyText
        Just Medium -> mediumText
        Just Hard -> hardText
        Nothing -> unknownText


-- View error message if present
viewErrorMessage : Maybe AppError -> Html Msg
viewErrorMessage maybeError =
    case maybeError of
        Just error ->
            div [ class errorMessageClass ]
                [ p [] [ text (errorToString error) ]
                , button [ class clearErrorButtonClass, onClick ClearError ] [ text clearErrorText ]
                ]
        
        Nothing ->
            text ""


-- Helper function to validate user input for making a guess
validateGuess : String -> List Char -> Result AppError Char
validateGuess input guessedLetters =
    validateUserInput input guessedLetters