module WordsTest exposing (..)

import Test exposing (..)
import Expect
import Words exposing (getRandomWord, getWordsByDifficulty)
import Types exposing (Difficulty(..))


suite : Test
suite =
    describe "Words module"
        [ describe "getWordsByDifficulty"
            [ test "returns easy words with 3-5 letters" <|
                \_ ->
                    let
                        words = getWordsByDifficulty Easy
                    in
                    Expect.all
                        [ \_ -> (List.length words >= 20) |> Expect.equal True
                        , \_ -> (List.all (\word -> String.length word >= 3 && String.length word <= 5) words) |> Expect.equal True
                        , \_ -> (not (List.isEmpty words)) |> Expect.equal True
                        ]
                        ()
            
            , test "returns medium words with 6-8 letters" <|
                \_ ->
                    let
                        words = getWordsByDifficulty Medium
                    in
                    Expect.all
                        [ \_ -> (List.length words >= 20) |> Expect.equal True
                        , \_ -> (List.all (\word -> String.length word >= 6 && String.length word <= 8) words) |> Expect.equal True
                        , \_ -> (not (List.isEmpty words)) |> Expect.equal True
                        ]
                        ()
            
            , test "returns hard words with 9+ letters" <|
                \_ ->
                    let
                        words = getWordsByDifficulty Hard
                    in
                    Expect.all
                        [ \_ -> (List.length words >= 20) |> Expect.equal True
                        , \_ -> (List.all (\word -> String.length word >= 9) words) |> Expect.equal True
                        , \_ -> (not (List.isEmpty words)) |> Expect.equal True
                        ]
                        ()
            
            , test "each difficulty returns different word lists" <|
                \_ ->
                    let
                        easyWords = getWordsByDifficulty Easy
                        mediumWords = getWordsByDifficulty Medium
                        hardWords = getWordsByDifficulty Hard
                    in
                    Expect.all
                        [ \_ -> Expect.notEqual easyWords mediumWords
                        , \_ -> Expect.notEqual mediumWords hardWords
                        , \_ -> Expect.notEqual easyWords hardWords
                        ]
                        ()
            ]
        
        , describe "getRandomWord"
            [ test "returns a word from easy difficulty list" <|
                \_ ->
                    let
                        word = getRandomWord Easy 0
                        easyWords = getWordsByDifficulty Easy
                    in
                    (List.member word easyWords) |> Expect.equal True
            
            , test "returns a word from medium difficulty list" <|
                \_ ->
                    let
                        word = getRandomWord Medium 0
                        mediumWords = getWordsByDifficulty Medium
                    in
                    (List.member word mediumWords) |> Expect.equal True
            
            , test "returns a word from hard difficulty list" <|
                \_ ->
                    let
                        word = getRandomWord Hard 0
                        hardWords = getWordsByDifficulty Hard
                    in
                    (List.member word hardWords) |> Expect.equal True
            
            , test "returns different words for different seed values" <|
                \_ ->
                    let
                        word1 = getRandomWord Easy 0
                        word2 = getRandomWord Easy 1
                        word3 = getRandomWord Easy 2
                        word4 = getRandomWord Easy 3
                        word5 = getRandomWord Easy 4
                        -- Test with multiple seeds to increase chance of different results
                        words = [word1, word2, word3, word4, word5]
                        uniqueWords = List.length (List.foldl (\word acc -> if List.member word acc then acc else word :: acc) [] words)
                    in
                    (uniqueWords > 1) |> Expect.equal True
            
            , test "returns same word for same seed value" <|
                \_ ->
                    let
                        word1 = getRandomWord Easy 42
                        word2 = getRandomWord Easy 42
                    in
                    Expect.equal word1 word2
            
            , test "handles negative seed values" <|
                \_ ->
                    let
                        word = getRandomWord Easy -1
                        easyWords = getWordsByDifficulty Easy
                    in
                    (List.member word easyWords) |> Expect.equal True
            
            , test "handles large seed values" <|
                \_ ->
                    let
                        word = getRandomWord Easy 999999
                        easyWords = getWordsByDifficulty Easy
                    in
                    (List.member word easyWords) |> Expect.equal True
            ]
        ]