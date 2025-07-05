module Words exposing (getRandomWord, getWordsByDifficulty)

import Types exposing (Difficulty(..))
import Array


-- Easy words (3-5 letters)
easyWords : List String
easyWords =
    [ "cat", "dog", "sun", "moon", "tree", "book", "fish", "bird", "car", "house"
    , "apple", "water", "fire", "wind", "rock", "star", "love", "hope", "time", "life"
    , "green", "blue", "happy", "smile", "peace", "music", "dance", "light", "magic", "dream"
    ]


-- Medium words (6-8 letters)
mediumWords : List String
mediumWords =
    [ "garden", "forest", "window", "rainbow", "thunder", "kitchen", "bedroom", "library", "hospital", "journey"
    , "mystery", "courage", "freedom", "justice", "wisdom", "dolphin", "octopus", "hamster", "chicken", "rabbit"
    , "turtle", "planet", "bridge", "castle", "flower", "silver", "golden", "purple", "orange", "brother"
    ]


-- Hard words (9+ letters)
hardWords : List String
hardWords =
    [ "wonderful", "beautiful", "magnificent", "incredible", "spectacular", "mysterious", "adventurous", "dangerous", "comfortable", "fantastic"
    , "extraordinary", "independent", "responsibility", "organization", "imagination", "conversation", "celebration", "inspiration", "determination", "understanding"
    , "kindergarten", "university", "playground", "neighborhood", "grandmother", "grandfather", "basketball", "volleyball", "automobile", "helicopter"
    ]


-- Get words by difficulty level
getWordsByDifficulty : Difficulty -> List String
getWordsByDifficulty difficulty =
    case difficulty of
        Easy ->
            easyWords
        
        Medium ->
            mediumWords
        
        Hard ->
            hardWords


-- Get a random word from the appropriate difficulty list using a seed
getRandomWord : Difficulty -> Int -> String
getRandomWord difficulty seed =
    let
        words = getWordsByDifficulty difficulty
        wordArray = Array.fromList words
        arrayLength = Array.length wordArray
        -- Use absolute value of seed to handle negative numbers
        -- Use modulo to wrap around the array length
        index = abs seed |> modBy arrayLength
    in
    case Array.get index wordArray of
        Just word ->
            word
        
        Nothing ->
            -- Fallback to first word if somehow index is invalid
            case words of
                first :: _ ->
                    first
                
                [] ->
                    -- This should never happen since we have non-empty lists
                    "error"