module GameLogic exposing (..)


isLetterInWord : Char -> String -> Bool
isLetterInWord letter word =
    String.contains (String.fromChar (Char.toLower letter)) (String.toLower word)


updateGuessedLetters : Char -> List Char -> List Char
updateGuessedLetters letter guessedLetters =
    let
        lowerLetter = Char.toLower letter
    in
    if List.member lowerLetter guessedLetters then
        guessedLetters
    else
        guessedLetters ++ [lowerLetter]


getMaskedWord : String -> List Char -> String
getMaskedWord word guessedLetters =
    let
        lowerWord = String.toLower word
        lowerGuessed = List.map Char.toLower guessedLetters
    in
    String.map (\char ->
        if List.member (Char.toLower char) lowerGuessed then
            Char.toLower char
        else
            '_'
    ) lowerWord


isGameWon : String -> List Char -> Bool
isGameWon word guessedLetters =
    let
        lowerWord = String.toLower word
        lowerGuessed = List.map Char.toLower guessedLetters
        uniqueLetters = String.toList lowerWord |> List.foldr (\char acc -> if List.member char acc then acc else char :: acc) []
    in
    List.all (\char -> List.member char lowerGuessed) uniqueLetters


isGameLost : Int -> Bool
isGameLost remainingGuesses =
    remainingGuesses <= 0


isValidGuess : Char -> List Char -> Bool
isValidGuess char guessedLetters =
    let
        lowerChar = Char.toLower char
        lowerGuessed = List.map Char.toLower guessedLetters
    in
    Char.isAlpha char && not (List.member lowerChar lowerGuessed)


calculateRemainingGuesses : String -> List Char -> Int -> Int
calculateRemainingGuesses word guessedLetters initialGuesses =
    let
        lowerWord = String.toLower word
        lowerGuessed = List.map Char.toLower guessedLetters
        wrongGuesses = List.filter (\letter -> not (String.contains (String.fromChar letter) lowerWord)) lowerGuessed
        wrongGuessCount = List.length wrongGuesses
    in
    initialGuesses - wrongGuessCount