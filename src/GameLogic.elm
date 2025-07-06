module GameLogic exposing (..)

import Types exposing (Word, wordToString, wordContains, wordToList, GuessedLetters, addGuessedLetter, isLetterGuessed, guessedLettersToList)


isLetterInWord : Char -> Word -> Bool
isLetterInWord letter word =
    wordContains (String.fromChar (Char.toUpper letter)) word


updateGuessedLetters : Char -> GuessedLetters -> GuessedLetters
updateGuessedLetters letter guessedLetters =
    addGuessedLetter letter guessedLetters


getMaskedWord : Word -> GuessedLetters -> String
getMaskedWord word guessedLetters =
    -- word is already in uppercase format from build script
    -- guessedLetters are already in uppercase format
    wordToList word
        |> List.map (\char ->
            if isLetterGuessed char guessedLetters then
                char
            else
                '_'
        )
        |> String.fromList


isGameWon : Word -> GuessedLetters -> Bool
isGameWon word guessedLetters =
    -- word is already in uppercase format from build script
    -- guessedLetters are already in uppercase format
    let
        uniqueLetters = wordToList word |> List.foldr (\char acc -> if List.member char acc then acc else char :: acc) []
    in
    List.all (\char -> isLetterGuessed char guessedLetters) uniqueLetters


isGameLost : Int -> Bool
isGameLost remainingGuesses =
    remainingGuesses <= 0


isValidGuess : Char -> GuessedLetters -> Bool
isValidGuess char guessedLetters =
    Char.isAlpha char && not (isLetterGuessed char guessedLetters)


calculateRemainingGuesses : Word -> GuessedLetters -> Int -> Int
calculateRemainingGuesses word guessedLetters initialGuesses =
    -- word is already in uppercase format from build script
    -- guessedLetters are already in uppercase format
    let
        guessedList = guessedLettersToList guessedLetters
        wrongGuesses = List.filter (\letter -> not (wordContains (String.fromChar letter) word)) guessedList
        wrongGuessCount = List.length wrongGuesses
    in
    initialGuesses - wrongGuessCount