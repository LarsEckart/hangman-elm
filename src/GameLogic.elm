module GameLogic exposing (..)


isLetterInWord : Char -> String -> Bool
isLetterInWord letter word =
    String.contains (String.fromChar (Char.toUpper letter)) (String.toUpper word)


updateGuessedLetters : Char -> List Char -> List Char
updateGuessedLetters letter guessedLetters =
    let
        upperLetter = Char.toUpper letter
    in
    if List.member upperLetter guessedLetters then
        guessedLetters
    else
        guessedLetters ++ [upperLetter]


getMaskedWord : String -> List Char -> String
getMaskedWord word guessedLetters =
    let
        upperWord = String.toUpper word
        -- guessedLetters are already in uppercase format
    in
    String.map (\char ->
        if List.member (Char.toUpper char) guessedLetters then
            Char.toUpper char
        else
            '_'
    ) upperWord


isGameWon : String -> List Char -> Bool
isGameWon word guessedLetters =
    let
        upperWord = String.toUpper word
        -- guessedLetters are already in uppercase format
        uniqueLetters = String.toList upperWord |> List.foldr (\char acc -> if List.member char acc then acc else char :: acc) []
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


calculateRemainingGuesses : String -> List Char -> Int -> Int
calculateRemainingGuesses word guessedLetters initialGuesses =
    let
        upperWord = String.toUpper word
        -- guessedLetters are already in uppercase format
        wrongGuesses = List.filter (\letter -> not (String.contains (String.fromChar letter) upperWord)) guessedLetters
        wrongGuessCount = List.length wrongGuesses
    in
    initialGuesses - wrongGuessCount