module Update exposing 
    ( handleStartGame
    , handleSelectLanguage
    , handleSelectCategory
    , handleSelectDifficulty
    , handleUpdateInput
    , handleMakeGuess
    , handleGuessLetter
    , handlePlayAgain
    , handleBackToStart
    , handleClearError
    , handleWordSelected
    )

import Random
import Types exposing (..)
import GameLogic exposing (..)
import Generated.WordLists as EmbeddedWordLists


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
    ( initialModel, Cmd.none )


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
    else if isLetterGuessed letter model.guessedLetters then
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
      , currentWord = wordFromString selectedWord
      }
    , Cmd.none
    )