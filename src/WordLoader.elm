module WordLoader exposing (loadWordList, parseWordList)

import Http
import Types exposing (Category, Difficulty, Language, Msg(..), categoryToString, difficultyToString, languageToString)


-- Load word list from CSV file based on language, category, and difficulty
loadWordList : Language -> Category -> Difficulty -> Cmd Msg
loadWordList language category difficulty =
    let
        filename =
            languageToString language
                ++ "-"
                ++ categoryToString category
                ++ "-"
                ++ difficultyToString difficulty
                ++ ".csv"
        
        url = "src/wordlists/" ++ filename
    in
    Http.get
        { url = url
        , expect = Http.expectString LoadWordList
        }


-- Parse CSV content into a list of words
parseWordList : String -> List String
parseWordList csvContent =
    csvContent
        |> String.trim
        |> String.split "\n"
        |> List.map String.trim
        |> List.filter (not << String.isEmpty)