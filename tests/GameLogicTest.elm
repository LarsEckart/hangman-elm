module GameLogicTest exposing (..)

import Expect
import Test exposing (..)
import GameLogic exposing (..)


suite : Test
suite =
    describe "GameLogic"
        [ describe "isLetterInWord"
            [ test "returns True when letter is in word" <|
                \_ ->
                    isLetterInWord 'a' "cat"
                        |> Expect.equal True
            , test "returns False when letter is not in word" <|
                \_ ->
                    isLetterInWord 'z' "cat"
                        |> Expect.equal False
            , test "is case insensitive" <|
                \_ ->
                    isLetterInWord 'A' "cat"
                        |> Expect.equal True
            , test "handles empty word" <|
                \_ ->
                    isLetterInWord 'a' ""
                        |> Expect.equal False
            ]
        , describe "updateGuessedLetters"
            [ test "adds new letter to empty list" <|
                \_ ->
                    updateGuessedLetters 'a' []
                        |> Expect.equal ['a']
            , test "adds new letter to existing list" <|
                \_ ->
                    updateGuessedLetters 'b' ['a']
                        |> Expect.equal ['a', 'b']
            , test "does not add duplicate letter" <|
                \_ ->
                    updateGuessedLetters 'a' ['a']
                        |> Expect.equal ['a']
            , test "converts to lowercase" <|
                \_ ->
                    updateGuessedLetters 'A' []
                        |> Expect.equal ['a']
            ]
        , describe "getMaskedWord"
            [ test "shows all underscores when no letters guessed" <|
                \_ ->
                    getMaskedWord "cat" []
                        |> Expect.equal "___"
            , test "shows guessed letters in correct positions" <|
                \_ ->
                    getMaskedWord "cat" ['a']
                        |> Expect.equal "_a_"
            , test "shows all letters when all are guessed" <|
                \_ ->
                    getMaskedWord "cat" ['c', 'a', 't']
                        |> Expect.equal "cat"
            , test "handles empty word" <|
                \_ ->
                    getMaskedWord "" []
                        |> Expect.equal ""
            , test "is case insensitive" <|
                \_ ->
                    getMaskedWord "Cat" ['a']
                        |> Expect.equal "_a_"
            ]
        , describe "isGameWon"
            [ test "returns True when all letters are guessed" <|
                \_ ->
                    isGameWon "cat" ['c', 'a', 't']
                        |> Expect.equal True
            , test "returns False when some letters are missing" <|
                \_ ->
                    isGameWon "cat" ['c', 'a']
                        |> Expect.equal False
            , test "returns False when no letters are guessed" <|
                \_ ->
                    isGameWon "cat" []
                        |> Expect.equal False
            , test "returns True for empty word" <|
                \_ ->
                    isGameWon "" []
                        |> Expect.equal True
            , test "handles duplicate letters in word" <|
                \_ ->
                    isGameWon "book" ['b', 'o', 'k']
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
                    isValidGuess "a" ['b']
                        |> Expect.equal True
            , test "returns False for empty string" <|
                \_ ->
                    isValidGuess "" []
                        |> Expect.equal False
            , test "returns False for multiple letters" <|
                \_ ->
                    isValidGuess "ab" []
                        |> Expect.equal False
            , test "returns False for number" <|
                \_ ->
                    isValidGuess "1" []
                        |> Expect.equal False
            , test "returns False for special character" <|
                \_ ->
                    isValidGuess "!" []
                        |> Expect.equal False
            , test "returns False for already guessed letter" <|
                \_ ->
                    isValidGuess "a" ['a']
                        |> Expect.equal False
            , test "is case insensitive for already guessed check" <|
                \_ ->
                    isValidGuess "A" ['a']
                        |> Expect.equal False
            ]
        ]