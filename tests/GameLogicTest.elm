module GameLogicTest exposing (..)

import Expect
import GameLogic exposing (..)
import Test exposing (..)
import Types exposing (guessedLettersFromList, guessedLettersToList, wordFromString)


suite : Test
suite =
    describe "GameLogic"
        [ describe "isLetterInWord"
            [ test "returns True when letter is in word" <|
                \_ ->
                    isLetterInWord 'a' (wordFromString "cat")
                        |> Expect.equal True
            , test "returns False when letter is not in word" <|
                \_ ->
                    isLetterInWord 'z' (wordFromString "cat")
                        |> Expect.equal False
            , test "is case insensitive" <|
                \_ ->
                    isLetterInWord 'A' (wordFromString "cat")
                        |> Expect.equal True
            , test "handles empty word" <|
                \_ ->
                    isLetterInWord 'a' (wordFromString "")
                        |> Expect.equal False
            ]
        , describe "updateGuessedLetters"
            [ test "adds new letter to empty list" <|
                \_ ->
                    updateGuessedLetters 'a' (guessedLettersFromList [])
                        |> guessedLettersToList
                        |> Expect.equal [ 'A' ]
            , test "adds new letter to existing list" <|
                \_ ->
                    updateGuessedLetters 'b' (guessedLettersFromList [ 'A' ])
                        |> guessedLettersToList
                        |> Expect.equal [ 'A', 'B' ]
            , test "does not add duplicate letter" <|
                \_ ->
                    updateGuessedLetters 'a' (guessedLettersFromList [ 'A' ])
                        |> guessedLettersToList
                        |> Expect.equal [ 'A' ]
            , test "converts to uppercase" <|
                \_ ->
                    updateGuessedLetters 'A' (guessedLettersFromList [])
                        |> guessedLettersToList
                        |> Expect.equal [ 'A' ]
            ]
        , describe "getMaskedWord"
            [ test "shows all underscores when no letters guessed" <|
                \_ ->
                    getMaskedWord (wordFromString "cat") (guessedLettersFromList [])
                        |> Expect.equal "___"
            , test "shows guessed letters in correct positions" <|
                \_ ->
                    getMaskedWord (wordFromString "CAT") (guessedLettersFromList [ 'A' ])
                        |> Expect.equal "_A_"
            , test "shows all letters when all are guessed" <|
                \_ ->
                    getMaskedWord (wordFromString "CAT") (guessedLettersFromList [ 'C', 'A', 'T' ])
                        |> Expect.equal "CAT"
            , test "handles empty word" <|
                \_ ->
                    getMaskedWord (wordFromString "") (guessedLettersFromList [])
                        |> Expect.equal ""
            , test "is case insensitive" <|
                \_ ->
                    getMaskedWord (wordFromString "CAT") (guessedLettersFromList [ 'A' ])
                        |> Expect.equal "_A_"
            ]
        , describe "isGameWon"
            [ test "returns True when all letters are guessed" <|
                \_ ->
                    isGameWon (wordFromString "CAT") (guessedLettersFromList [ 'C', 'A', 'T' ])
                        |> Expect.equal True
            , test "returns False when some letters are missing" <|
                \_ ->
                    isGameWon (wordFromString "CAT") (guessedLettersFromList [ 'C', 'A' ])
                        |> Expect.equal False
            , test "returns False when no letters are guessed" <|
                \_ ->
                    isGameWon (wordFromString "CAT") (guessedLettersFromList [])
                        |> Expect.equal False
            , test "returns True for empty word" <|
                \_ ->
                    isGameWon (wordFromString "") (guessedLettersFromList [])
                        |> Expect.equal True
            , test "handles duplicate letters in word" <|
                \_ ->
                    isGameWon (wordFromString "BOOK") (guessedLettersFromList [ 'B', 'O', 'K' ])
                        |> Expect.equal True
            ]
        , describe "isGameLost"
            [ test "returns True when no guesses remaining" <|
                \_ ->
                    isGameLost 0
                        |> Expect.equal True
            , test "returns False when guesses remaining" <|
                \_ ->
                    isGameLost 1
                        |> Expect.equal False
            , test "returns False when many guesses remaining" <|
                \_ ->
                    isGameLost 6
                        |> Expect.equal False
            ]
        , describe "isValidGuess"
            [ test "returns True for single letter" <|
                \_ ->
                    isValidGuess 'a' (guessedLettersFromList [ 'B' ])
                        |> Expect.equal True
            , test "returns False for already guessed letter" <|
                \_ ->
                    isValidGuess 'a' (guessedLettersFromList [ 'A' ])
                        |> Expect.equal False
            , test "is case insensitive for already guessed check" <|
                \_ ->
                    isValidGuess 'A' (guessedLettersFromList [ 'A' ])
                        |> Expect.equal False
            , test "returns False for non-alphabetic character" <|
                \_ ->
                    isValidGuess '1' (guessedLettersFromList [])
                        |> Expect.equal False
            , test "returns False for special character" <|
                \_ ->
                    isValidGuess '!' (guessedLettersFromList [])
                        |> Expect.equal False
            , test "returns True for uppercase letter not already guessed" <|
                \_ ->
                    isValidGuess 'B' (guessedLettersFromList [ 'A' ])
                        |> Expect.equal True
            ]
        , describe "calculateRemainingGuesses"
            [ test "returns same count when correct guess is made" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") (guessedLettersFromList [ 'C' ]) 6
                        |> Expect.equal 6
            , test "decrements count when wrong guess is made" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") (guessedLettersFromList [ 'Z' ]) 6
                        |> Expect.equal 5
            , test "handles multiple correct guesses" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") (guessedLettersFromList [ 'C', 'A' ]) 6
                        |> Expect.equal 6
            , test "handles multiple wrong guesses" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") (guessedLettersFromList [ 'Z', 'X' ]) 6
                        |> Expect.equal 4
            , test "handles mixed correct and wrong guesses" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") (guessedLettersFromList [ 'C', 'Z', 'A', 'X' ]) 6
                        |> Expect.equal 4
            , test "handles empty guessed letters list" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") (guessedLettersFromList []) 6
                        |> Expect.equal 6
            ]
        ]
