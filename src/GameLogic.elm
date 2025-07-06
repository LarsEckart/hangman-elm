module GameLogic exposing (..)

import Types exposing (Word, wordToString, wordContains, wordToList)


isLetterInWord : Char -> Word -> Bool
isLetterInWord letter word =
    wordContains (String.fromChar (Char.toUpper letter)) word


updateGuessedLetters : Char -> List Char -> List Char
updateGuessedLetters letter guessedLetters =
    let
        upperLetter = Char.toUpper letter
    in
    if List.member upperLetter guessedLetters then
        guessedLetters
    else
        guessedLetters ++ [upperLetter]


getMaskedWord : Word -> List Char -> String
getMaskedWord word guessedLetters =
    -- word is already in uppercase format from build script
    -- guessedLetters are already in uppercase format
    wordToList word
        |> List.map (\char ->
            if List.member char guessedLetters then
                char
            else
                '_'
        )
        |> String.fromList


isGameWon : Word -> List Char -> Bool
isGameWon word guessedLetters =
    -- word is already in uppercase format from build script
    -- guessedLetters are already in uppercase format
    let
        uniqueLetters = wordToList word |> List.foldr (\char acc -> if List.member char acc then acc else char :: acc) []
    in
    List.all (\char -> List.member char guessedLetters) uniqueLetters


isGameLost : Int -> Bool
isGameLost remainingGuesses =
    remainingGuesses <= 0


isValidGuess : Char -> List Char -> Bool
isValidGuess char guessedLetters =
    let
        upperChar = Char.toUpper char
        -- guessedLetters are already in uppercase format
    in
    Char.isAlpha char && not (List.member upperChar guessedLetters)


calculateRemainingGuesses : Word -> List Char -> Int -> Int
calculateRemainingGuesses word guessedLetters initialGuesses =
    -- word is already in uppercase format from build script
    -- guessedLetters are already in uppercase format
    let
        wrongGuesses = List.filter (\letter -> not (wordContains (String.fromChar letter) word)) guessedLetters
        wrongGuessCount = List.length wrongGuesses
    in
    initialGuesses - wrongGuessCount