module Main exposing (main, update, init)

import Browser
import Html exposing (Html, div, h1, h2, p, button, input, text, span)
import Html.Attributes exposing (class, type_, value, placeholder, disabled, style)
import Html.Events exposing (onClick, onInput)
import Random
import Types exposing (..)
import GameLogic exposing (..)
import Generated.WordLists as EmbeddedWordLists
import Translations as T


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
      , uiLanguage = language  -- Update UI language to match selected game language
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
    case (model.selectedLanguage, model.selectedCategory, model.selectedDifficulty) of
        (Just language, Just category, Just difficulty) ->
            let
                availableWords = EmbeddedWordLists.getWordList language category difficulty
                resetModel = resetGame model
            in
            if List.isEmpty availableWords then
                -- This shouldn't happen since we already played a game, but handle it gracefully
                ( { resetModel | errorMessage = Just (NoWordsAvailable language category difficulty) }
                , Cmd.none
                )
            else
                ( { resetModel 
                  | wordList = availableWords
                  , errorMessage = Nothing
                  }
                , Random.generate (WordSelected difficulty) (Random.int 0 (List.length availableWords - 1))
                )
        _ ->
            -- If somehow selections are missing, fall back to starting over
            handleBackToStart model


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


-- Handle letter button click
handleGuessLetter : Char -> Model -> (Model, Cmd Msg)
handleGuessLetter letter model =
    if model.gameState /= Playing then
        -- Don't process guesses if game is already over
        (model, Cmd.none)
    else if List.member letter model.guessedLetters then
        -- Letter already guessed, ignore
        (model, Cmd.none)
    else
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
viewStartScreen : Language -> Html Msg
viewStartScreen uiLanguage =
    div (applyStyles screenStyles)
        [ h1 (applyStyles gameTitleStyles) [ text (T.translate uiLanguage T.GameTitle) ]
        , p (applyStyles gameDescriptionStyles) [ text (T.translate uiLanguage T.GameDescription) ]
        , button (applyStyles buttonBaseStyles ++ [onClick StartGame]) [ text (T.translate uiLanguage T.StartGame) ]
        ]


-- Language selection screen view
viewLanguageSelection : Language -> Html Msg
viewLanguageSelection uiLanguage =
    div (applyStyles screenStyles)
        [ h2 (applyStyles screenTitleStyles) [ text (T.translate uiLanguage T.ChooseLanguage) ]
        , div (applyStyles buttonContainerStyles)
            [ button (applyStyles buttonBaseStyles ++ [onClick (SelectLanguage English)]) [ text (T.translate uiLanguage T.EnglishLanguage) ]
            , button (applyStyles buttonBaseStyles ++ [onClick (SelectLanguage German)]) [ text (T.translate uiLanguage T.GermanLanguage) ]
            , button (applyStyles buttonBaseStyles ++ [onClick (SelectLanguage Estonian)]) [ text (T.translate uiLanguage T.EstonianLanguage) ]
            ]
        ]


-- Category selection screen view
viewCategorySelection : Language -> Html Msg
viewCategorySelection uiLanguage =
    div (applyStyles screenStyles)
        [ h2 (applyStyles screenTitleStyles) [ text (T.translate uiLanguage T.ChooseCategory) ]
        , div (applyStyles buttonContainerStyles)
            [ button (applyStyles buttonBaseStyles ++ [onClick (SelectCategory Animals)]) [ text (T.translate uiLanguage T.Animals) ]
            , button (applyStyles buttonBaseStyles ++ [onClick (SelectCategory Food)]) [ text (T.translate uiLanguage T.Food) ]
            , button (applyStyles buttonBaseStyles ++ [onClick (SelectCategory Sport)]) [ text (T.translate uiLanguage T.Sport) ]
            ]
        ]


-- Difficulty selection screen view
viewDifficultySelection : Model -> Html Msg
viewDifficultySelection model =
    div (applyStyles screenStyles)
        [ h2 (applyStyles screenTitleStyles) [ text (T.translate model.uiLanguage T.ChooseDifficulty) ]
        , div (applyStyles buttonContainerStyles)
            [ button (applyStyles easyButtonStyles ++ [onClick (SelectDifficulty Easy)])
                [ text (T.translate model.uiLanguage T.Easy)
                , p (applyStyles difficultyDescriptionStyles) [ text (T.translate model.uiLanguage T.EasyDescription) ]
                ]
            , button (applyStyles mediumButtonStyles ++ [onClick (SelectDifficulty Medium)])
                [ text (T.translate model.uiLanguage T.Medium)
                , p (applyStyles difficultyDescriptionStyles) [ text (T.translate model.uiLanguage T.MediumDescription) ]
                ]
            , button (applyStyles hardButtonStyles ++ [onClick (SelectDifficulty Hard)])
                [ text (T.translate model.uiLanguage T.Hard)
                , p (applyStyles difficultyDescriptionStyles) [ text (T.translate model.uiLanguage T.HardDescription) ]
                ]
            ]
        , viewErrorMessage model.uiLanguage model.errorMessage
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
            [ h1 (applyStyles resultMessageStyles ++ applyStyles (if model.gameState == Won then wonStyles else lostStyles))
                [ text (if model.gameState == Won then T.translate model.uiLanguage T.YouWon else T.translate model.uiLanguage T.YouLost) ]
            , div (applyStyles wordRevealStyles)
                [ p (applyStyles wordLabelStyles) [ text (T.translate model.uiLanguage T.WordWas) ]
                , h2 (applyStyles revealedWordStyles) [ text model.currentWord ]
                ]
            , div (applyStyles gameStatsStyles)
                [ p [] [ text (T.translate model.uiLanguage T.GuessedLettersStats ++ formatGuessedLetters model.uiLanguage model.guessedLetters) ]
                , p [] [ text (T.translate model.uiLanguage T.RemainingGuessesStats ++ String.fromInt model.remainingGuesses) ]
                ]
            ]
        , div (applyStyles gameOverButtonsStyles)
            [ button (applyStyles buttonBaseStyles ++ [onClick PlayAgain]) [ text (T.translate model.uiLanguage T.PlayAgain) ]
            , button (applyStyles buttonBaseStyles ++ [onClick BackToStart]) [ text (T.translate model.uiLanguage T.BackToStart) ]
            ]
        ]


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


-- INLINE STYLES FOR MOBILE RESPONSIVENESS

-- App container styles (mobile-first responsive)
appStyles : List (String, String)
appStyles = 
    [ ("width", "100%")
    , ("min-height", "100vh")
    , ("display", "flex")
    , ("flex-direction", "column")
    , ("justify-content", "center")
    , ("align-items", "center")
    , ("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
    , ("padding", "5px")
    , ("box-sizing", "border-box")
    , ("font-family", "-apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif")
    , ("-webkit-font-smoothing", "antialiased")
    , ("-moz-osx-font-smoothing", "grayscale")
    ]

-- Screen container styles (mobile-first responsive)
screenStyles : List (String, String)
screenStyles = 
    [ ("background", "white")
    , ("border-radius", "8px")
    , ("box-shadow", "0 10px 30px rgba(0, 0, 0, 0.2)")
    , ("padding", "15px")
    , ("max-width", "400px")
    , ("width", "100%")
    , ("margin", "5px")
    , ("box-sizing", "border-box")
    , ("text-align", "center")
    ]

-- Title styles (mobile-first responsive)
gameTitleStyles : List (String, String)
gameTitleStyles = 
    [ ("font-size", "clamp(1.5rem, 4vw, 2rem)")
    , ("font-weight", "bold")
    , ("color", "#333")
    , ("margin", "0 0 10px 0")
    , ("text-shadow", "2px 2px 4px rgba(0, 0, 0, 0.1)")
    ]

-- Description styles
gameDescriptionStyles : List (String, String)
gameDescriptionStyles = 
    [ ("font-size", "1rem")
    , ("color", "#666")
    , ("margin", "0 0 20px 0")
    ]

-- Screen title styles (mobile-first responsive)
screenTitleStyles : List (String, String)
screenTitleStyles = 
    [ ("font-size", "clamp(1.2rem, 3vw, 1.5rem)")
    , ("font-weight", "bold")
    , ("color", "#333")
    , ("margin", "0 0 20px 0")
    ]

-- Button base styles
buttonBaseStyles : List (String, String)
buttonBaseStyles = 
    [ ("background", "#667eea")
    , ("color", "white")
    , ("border", "none")
    , ("border-radius", "8px")
    , ("padding", "12px 24px")
    , ("font-size", "1rem")
    , ("font-weight", "500")
    , ("cursor", "pointer")
    , ("transition", "all 0.3s ease")
    , ("margin", "5px")
    , ("min-height", "48px")
    , ("min-width", "120px")
    ]

-- Button container styles
buttonContainerStyles : List (String, String)
buttonContainerStyles = 
    [ ("display", "flex")
    , ("flex-direction", "column")
    , ("gap", "10px")
    , ("margin", "20px 0")
    ]

-- Difficulty button styles
difficultyButtonStyles : List (String, String)
difficultyButtonStyles = 
    buttonBaseStyles ++ 
    [ ("display", "flex")
    , ("flex-direction", "column")
    , ("align-items", "center")
    , ("padding", "16px")
    , ("text-align", "center")
    ]

-- Easy button styles
easyButtonStyles : List (String, String)
easyButtonStyles = 
    difficultyButtonStyles ++
    [ ("background", "#4CAF50")
    ]

-- Medium button styles
mediumButtonStyles : List (String, String)
mediumButtonStyles = 
    difficultyButtonStyles ++
    [ ("background", "#FF9800")
    ]

-- Hard button styles
hardButtonStyles : List (String, String)
hardButtonStyles = 
    difficultyButtonStyles ++
    [ ("background", "#f44336")
    ]

-- Difficulty description styles
difficultyDescriptionStyles : List (String, String)
difficultyDescriptionStyles = 
    [ ("font-size", "0.8rem")
    , ("margin", "4px 0 0 0")
    , ("opacity", "0.9")
    ]

-- Game info styles (mobile-first responsive)
gameInfoStyles : List (String, String)
gameInfoStyles = 
    [ ("display", "flex")
    , ("flex-direction", "column")
    , ("gap", "5px")
    , ("text-align", "center")
    , ("margin", "20px 0")
    , ("font-size", "0.9rem")
    , ("color", "#666")
    ]

-- Word display styles
wordDisplayStyles : List (String, String)
wordDisplayStyles = 
    [ ("margin", "20px 0")
    ]

-- Masked word styles (mobile-first responsive)
maskedWordStyles : List (String, String)
maskedWordStyles = 
    [ ("font-size", "clamp(1.5rem, 5vw, 2rem)")
    , ("font-weight", "bold")
    , ("color", "#333")
    , ("letter-spacing", "0.1em")
    , ("margin", "0")
    , ("font-family", "'Courier New', monospace")
    ]

-- Guessed letters container styles
guessedLettersStyles : List (String, String)
guessedLettersStyles = 
    [ ("margin", "20px 0")
    , ("padding", "15px")
    , ("background", "#f8f9fa")
    , ("border-radius", "8px")
    , ("border", "1px solid #e9ecef")
    ]

-- Guessed letters title styles
guessedTitleStyles : List (String, String)
guessedTitleStyles = 
    [ ("font-size", "0.9rem")
    , ("color", "#666")
    , ("margin", "0 0 5px 0")
    ]

-- Guessed letters list styles
guessedListStyles : List (String, String)
guessedListStyles = 
    [ ("font-size", "1rem")
    , ("color", "#333")
    , ("margin", "0")
    , ("font-family", "'Courier New', monospace")
    ]

-- Guess input container styles
guessInputStyles : List (String, String)
guessInputStyles = 
    [ ("display", "flex")
    , ("flex-direction", "column")
    , ("gap", "10px")
    , ("margin", "20px 0")
    ]

-- Letter input styles
letterInputStyles : List (String, String)
letterInputStyles = 
    [ ("padding", "12px")
    , ("border", "2px solid #ddd")
    , ("border-radius", "8px")
    , ("font-size", "1rem")
    , ("text-align", "center")
    , ("outline", "none")
    , ("transition", "border-color 0.3s ease")
    ]

-- Game result styles
gameResultStyles : List (String, String)
gameResultStyles = 
    [ ("margin", "20px 0")
    ]

-- Result message styles (mobile-first responsive)
resultMessageStyles : List (String, String)
resultMessageStyles = 
    [ ("font-size", "clamp(1.2rem, 3vw, 1.5rem)")
    , ("font-weight", "bold")
    , ("margin", "0 0 20px 0")
    ]

-- Won styles
wonStyles : List (String, String)
wonStyles = 
    [ ("color", "#4CAF50")
    ]

-- Lost styles
lostStyles : List (String, String)
lostStyles = 
    [ ("color", "#f44336")
    ]

-- Word reveal styles
wordRevealStyles : List (String, String)
wordRevealStyles = 
    [ ("margin", "20px 0")
    , ("padding", "15px")
    , ("background", "#f8f9fa")
    , ("border-radius", "8px")
    , ("border", "1px solid #e9ecef")
    ]

-- Word label styles
wordLabelStyles : List (String, String)
wordLabelStyles = 
    [ ("font-size", "0.9rem")
    , ("color", "#666")
    , ("margin", "0 0 5px 0")
    ]

-- Revealed word styles (mobile-first responsive)
revealedWordStyles : List (String, String)
revealedWordStyles = 
    [ ("font-size", "clamp(1.2rem, 4vw, 1.5rem)")
    , ("font-weight", "bold")
    , ("color", "#333")
    , ("margin", "0")
    , ("font-family", "'Courier New', monospace")
    ]

-- Game stats styles
gameStatsStyles : List (String, String)
gameStatsStyles = 
    [ ("margin", "20px 0")
    , ("font-size", "0.9rem")
    , ("color", "#666")
    ]

-- Game over buttons styles (mobile-first responsive)
gameOverButtonsStyles : List (String, String)
gameOverButtonsStyles = 
    buttonContainerStyles ++
    [ ("flex-direction", "column")
    , ("gap", "10px")
    ]

-- Error message styles
errorMessageStyles : List (String, String)
errorMessageStyles = 
    [ ("background", "#ffebee")
    , ("color", "#c62828")
    , ("padding", "10px")
    , ("border-radius", "8px")
    , ("margin", "15px 0")
    , ("border", "1px solid #ffcdd2")
    , ("display", "flex")
    , ("justify-content", "space-between")
    , ("align-items", "center")
    ]

-- Clear error button styles
clearErrorButtonStyles : List (String, String)
clearErrorButtonStyles = 
    [ ("background", "transparent")
    , ("border", "none")
    , ("color", "#c62828")
    , ("font-size", "1.2rem")
    , ("cursor", "pointer")
    , ("padding", "0")
    , ("margin", "0")
    , ("min-height", "auto")
    , ("min-width", "auto")
    ]

-- Letter buttons container styles
letterButtonsContainerStyles : List (String, String)
letterButtonsContainerStyles = 
    [ ("display", "grid")
    , ("grid-template-columns", "repeat(auto-fill, minmax(38px, 1fr))")
    , ("gap", "6px")
    , ("margin", "20px 0")
    , ("padding", "12px")
    , ("background", "#f8f9fa")
    , ("border-radius", "8px")
    , ("border", "1px solid #e9ecef")
    , ("max-width", "100%")
    ]

-- Letter button base styles
letterButtonStyles : List (String, String)
letterButtonStyles = 
    [ ("background", "white")
    , ("color", "#333")
    , ("border", "2px solid #ddd")
    , ("border-radius", "6px")
    , ("padding", "6px")
    , ("font-size", "0.95rem")
    , ("font-weight", "600")
    , ("cursor", "pointer")
    , ("transition", "all 0.2s ease")
    , ("min-width", "38px")
    , ("min-height", "38px")
    , ("display", "flex")
    , ("align-items", "center")
    , ("justify-content", "center")
    ]

-- Letter button correct guess styles
letterButtonCorrectStyles : List (String, String)
letterButtonCorrectStyles = 
    letterButtonStyles ++
    [ ("background", "#4CAF50")
    , ("color", "white")
    , ("border-color", "#4CAF50")
    , ("cursor", "not-allowed")
    , ("opacity", "0.8")
    ]

-- Letter button wrong guess styles
letterButtonWrongStyles : List (String, String)
letterButtonWrongStyles = 
    letterButtonStyles ++
    [ ("background", "#ffebee")
    , ("color", "#f44336")
    , ("border-color", "#f44336")
    , ("cursor", "not-allowed")
    , ("opacity", "0.6")
    ]

-- Helper function to apply styles
applyStyles : List (String, String) -> List (Html.Attribute msg)
applyStyles styles =
    List.map (\(prop, val) -> style prop val) styles

-- REUSABLE VIEW COMPONENTS (no longer needed with inline styles)


-- HELPER FUNCTIONS FOR VIEW

-- Format masked word with spaces between letters
formatMaskedWord : String -> String
formatMaskedWord word =
    String.toList word
        |> List.map String.fromChar
        |> String.join " "


-- Format guessed letters as a comma-separated list
formatGuessedLetters : Language -> List Char -> String
formatGuessedLetters uiLanguage letters =
    if List.isEmpty letters then
        T.translate uiLanguage T.None
    else
        letters
            |> List.map (String.fromChar >> String.toUpper)
            |> String.join ", "


-- Get difficulty name for display
getDifficultyName : Language -> Maybe Difficulty -> String
getDifficultyName uiLanguage maybeDifficulty =
    case maybeDifficulty of
        Just Easy -> T.translate uiLanguage T.Easy
        Just Medium -> T.translate uiLanguage T.Medium
        Just Hard -> T.translate uiLanguage T.Hard
        Nothing -> T.translate uiLanguage T.Unknown


-- Get category name for display
getCategoryName : Language -> Maybe Category -> String
getCategoryName uiLanguage maybeCategory =
    case maybeCategory of
        Just Animals -> T.translate uiLanguage T.Animals
        Just Food -> T.translate uiLanguage T.Food
        Just Sport -> T.translate uiLanguage T.Sport
        Nothing -> T.translate uiLanguage T.Unknown


-- View error message if present
viewErrorMessage : Language -> Maybe AppError -> Html Msg
viewErrorMessage uiLanguage maybeError =
    case maybeError of
        Just error ->
            div (applyStyles errorMessageStyles)
                [ p [] [ text (errorToString uiLanguage error) ]
                , button (applyStyles clearErrorButtonStyles ++ [onClick ClearError]) [ text (T.translate uiLanguage T.ClearError) ]
                ]
        
        Nothing ->
            text ""


-- Helper function to validate user input for making a guess
validateGuess : String -> List Char -> Result AppError Char
validateGuess input guessedLetters =
    validateUserInput input guessedLetters


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
viewLetterButtons : Language -> String -> List Char -> GameState -> List (Html Msg)
viewLetterButtons language currentWord guessedLetters gameState =
    let
        alphabet = getAlphabetForLanguage language
            |> String.toList
        
        makeButton : Char -> Html Msg
        makeButton letter =
            let
                isGuessed = List.member (Char.toUpper letter) guessedLetters
                isInWord = isLetterInWord (Char.toUpper letter) currentWord
                isDisabled = gameState /= Playing || isGuessed
                
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
                (applyStyles buttonStyle ++ 
                [ onClick (GuessLetter (Char.toUpper letter))
                , disabled isDisabled
                ])
                [ text (String.fromChar letter) ]
    in
    List.map makeButton alphabet