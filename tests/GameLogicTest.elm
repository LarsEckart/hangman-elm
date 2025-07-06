module GameLogicTest exposing (..)

import Expect
import Test exposing (..)
import GameLogic exposing (..)
import Types exposing (wordFromString)


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
                    updateGuessedLetters 'a' []
                        |> Expect.equal ['A']
            , test "adds new letter to existing list" <|
                \_ ->
                    updateGuessedLetters 'b' ['A']
                        |> Expect.equal ['A', 'B']
            , test "does not add duplicate letter" <|
                \_ ->
                    updateGuessedLetters 'a' ['A']
                        |> Expect.equal ['A']
            , test "converts to uppercase" <|
                \_ ->
                    updateGuessedLetters 'A' []
                        |> Expect.equal ['A']
            ]
        , describe "getMaskedWord"
            [ test "shows all underscores when no letters guessed" <|
                \_ ->
                    getMaskedWord (wordFromString "cat") []
                        |> Expect.equal "___"
            , test "shows guessed letters in correct positions" <|
                \_ ->
                    getMaskedWord (wordFromString "CAT") ['A']
                        |> Expect.equal "_A_"
            , test "shows all letters when all are guessed" <|
                \_ ->
                    getMaskedWord (wordFromString "CAT") ['C', 'A', 'T']
                        |> Expect.equal "CAT"
            , test "handles empty word" <|
                \_ ->
                    getMaskedWord (wordFromString "") []
                        |> Expect.equal ""
            , test "is case insensitive" <|
                \_ ->
                    getMaskedWord (wordFromString "CAT") ['A']
                        |> Expect.equal "_A_"
            ]
        , describe "isGameWon"
            [ test "returns True when all letters are guessed" <|
                \_ ->
                    isGameWon (wordFromString "CAT") ['C', 'A', 'T']
                        |> Expect.equal True
            , test "returns False when some letters are missing" <|
                \_ ->
                    isGameWon (wordFromString "CAT") ['C', 'A']
                        |> Expect.equal False
            , test "returns False when no letters are guessed" <|
                \_ ->
                    isGameWon (wordFromString "CAT") []
                        |> Expect.equal False
            , test "returns True for empty word" <|
                \_ ->
                    isGameWon (wordFromString "") []
                        |> Expect.equal True
            , test "handles duplicate letters in word" <|
                \_ ->
                    isGameWon (wordFromString "BOOK") ['B', 'O', 'K']
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
                    isValidGuess 'a' ['B']
                        |> Expect.equal True
            , test "returns False for already guessed letter" <|
                \_ ->
                    isValidGuess 'a' ['A']
                        |> Expect.equal False
            , test "is case insensitive for already guessed check" <|
                \_ ->
                    isValidGuess 'A' ['A']
                        |> Expect.equal False
            , test "returns False for non-alphabetic character" <|
                \_ ->
                    isValidGuess '1' []
                        |> Expect.equal False
            , test "returns False for special character" <|
                \_ ->
                    isValidGuess '!' []
                        |> Expect.equal False
            , test "returns True for uppercase letter not already guessed" <|
                \_ ->
                    isValidGuess 'B' ['A']
                        |> Expect.equal True
            ]
        , describe "calculateRemainingGuesses"
            [ test "returns same count when correct guess is made" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") ['C'] 6
                        |> Expect.equal 6
            , test "decrements count when wrong guess is made" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") ['Z'] 6
                        |> Expect.equal 5
            , test "handles multiple correct guesses" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") ['C', 'A'] 6
                        |> Expect.equal 6
            , test "handles multiple wrong guesses" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") ['Z', 'X'] 6
                        |> Expect.equal 4
            , test "handles mixed correct and wrong guesses" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") ['C', 'Z', 'A', 'X'] 6
                        |> Expect.equal 4
            , test "handles empty guessed letters list" <|
                \_ ->
                    calculateRemainingGuesses (wordFromString "CAT") [] 6
                        |> Expect.equal 6
            ]
        ]