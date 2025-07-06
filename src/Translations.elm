module Translations exposing (..)

import Types exposing (Language(..))

-- Translation keys for UI text
type TranslationKey
    = GameTitle
    | GameDescription
    | StartGame
    | ChooseLanguage
    | EnglishLanguage
    | GermanLanguage
    | EstonianLanguage
    | ChooseCategory
    | Animals
    | Food
    | Sport
    | ChooseDifficulty
    | Easy
    | EasyDescription
    | Medium
    | MediumDescription
    | Hard
    | HardDescription
    | Hangman
    | CategoryLabel
    | DifficultyLabel
    | RemainingGuesses
    | GuessedLetters
    | Guess
    | GameOver
    | YouWon
    | YouLost
    | WordWas
    | GuessedLettersStats
    | RemainingGuessesStats
    | PlayAgain
    | BackToStart
    | ClearError
    | EnterLetterPlaceholder
    | None
    | Unknown
    | NoWordsAvailable
    | SelectLanguageCategory
    | EnterLetter
    | LettersOnly
    | AlreadyGuessed
    | OneLetterOnly

-- Get translation for a key in the specified language
translate : Language -> TranslationKey -> String
translate language key =
    case language of
        English ->
            translateEnglish key
        
        German ->
            translateGerman key
        
        Estonian ->
            translateEstonian key

-- English translations
translateEnglish : TranslationKey -> String
translateEnglish key =
    case key of
        GameTitle -> "🎯 HANGMAN GAME"
        GameDescription -> "Guess the word letter by letter!"
        StartGame -> "Start Game"
        ChooseLanguage -> "Choose Language"
        EnglishLanguage -> "🇬🇧 English"
        GermanLanguage -> "🇩🇪 German"
        EstonianLanguage -> "🇪🇪 Estonian"
        ChooseCategory -> "Choose Category"
        Animals -> "🐾 Animals"
        Food -> "🍔 Food & Drinks"
        Sport -> "⚽ Sport"
        ChooseDifficulty -> "Choose Difficulty"
        Easy -> "Easy"
        EasyDescription -> "3-5 letter words"
        Medium -> "Medium"
        MediumDescription -> "6-8 letter words"
        Hard -> "Hard"
        HardDescription -> "9+ letter words"
        Hangman -> "Hangman"
        CategoryLabel -> "Category: "
        DifficultyLabel -> "Difficulty: "
        RemainingGuesses -> "Remaining guesses: "
        GuessedLetters -> "Guessed letters:"
        Guess -> "Guess"
        GameOver -> "Game Over"
        YouWon -> "🎉 You Won!"
        YouLost -> "💀 You Lost!"
        WordWas -> "The word was:"
        GuessedLettersStats -> "Guessed letters: "
        RemainingGuessesStats -> "Remaining guesses: "
        PlayAgain -> "Play Again"
        BackToStart -> "Back to Start"
        ClearError -> "×"
        EnterLetterPlaceholder -> "Enter a letter..."
        None -> "None"
        Unknown -> "Unknown"
        NoWordsAvailable -> "No words available for this combination"
        SelectLanguageCategory -> "Please select language and category first"
        EnterLetter -> "Please enter a letter"
        LettersOnly -> "Please enter only letters"
        AlreadyGuessed -> "You already guessed that letter"
        OneLetterOnly -> "Please enter only one letter"

-- German translations
translateGerman : TranslationKey -> String
translateGerman key =
    case key of
        GameTitle -> "🎯 GALGENMÄNNCHEN"
        GameDescription -> "Errate das Wort Buchstabe für Buchstabe!"
        StartGame -> "Spiel starten"
        ChooseLanguage -> "Sprache wählen"
        EnglishLanguage -> "🇬🇧 Englisch"
        GermanLanguage -> "🇩🇪 Deutsch"
        EstonianLanguage -> "🇪🇪 Estnisch"
        ChooseCategory -> "Kategorie wählen"
        Animals -> "🐾 Tiere"
        Food -> "🍔 Essen & Trinken"
        Sport -> "⚽ Sport"
        ChooseDifficulty -> "Schwierigkeit wählen"
        Easy -> "Leicht"
        EasyDescription -> "3-5 Buchstaben"
        Medium -> "Mittel"
        MediumDescription -> "6-8 Buchstaben"
        Hard -> "Schwer"
        HardDescription -> "9+ Buchstaben"
        Hangman -> "Galgenmännchen"
        CategoryLabel -> "Kategorie: "
        DifficultyLabel -> "Schwierigkeit: "
        RemainingGuesses -> "Verbleibende Versuche: "
        GuessedLetters -> "Geratene Buchstaben:"
        Guess -> "Raten"
        GameOver -> "Spiel beendet"
        YouWon -> "🎉 Du hast gewonnen!"
        YouLost -> "💀 Du hast verloren!"
        WordWas -> "Das Wort war:"
        GuessedLettersStats -> "Geratene Buchstaben: "
        RemainingGuessesStats -> "Verbleibende Versuche: "
        PlayAgain -> "Nochmal spielen"
        BackToStart -> "Zurück zum Start"
        ClearError -> "×"
        EnterLetterPlaceholder -> "Buchstabe eingeben..."
        None -> "Keine"
        Unknown -> "Unbekannt"
        NoWordsAvailable -> "Keine Wörter für diese Kombination verfügbar"
        SelectLanguageCategory -> "Bitte wählen Sie zuerst Sprache und Kategorie"
        EnterLetter -> "Bitte geben Sie einen Buchstaben ein"
        LettersOnly -> "Bitte geben Sie nur Buchstaben ein"
        AlreadyGuessed -> "Sie haben diesen Buchstaben bereits geraten"
        OneLetterOnly -> "Bitte geben Sie nur einen Buchstaben ein"

-- Estonian translations
translateEstonian : TranslationKey -> String
translateEstonian key =
    case key of
        GameTitle -> "🎯 POOMISMÄNG"
        GameDescription -> "Arva sõna täht tähelt!"
        StartGame -> "Alusta mängu"
        ChooseLanguage -> "Vali keel"
        EnglishLanguage -> "🇬🇧 Inglise"
        GermanLanguage -> "🇩🇪 Saksa"
        EstonianLanguage -> "🇪🇪 Eesti"
        ChooseCategory -> "Vali kategooria"
        Animals -> "🐾 Loomad"
        Food -> "🍔 Toit ja joogid"
        Sport -> "⚽ Sport"
        ChooseDifficulty -> "Vali raskusaste"
        Easy -> "Kerge"
        EasyDescription -> "3-5 tähte"
        Medium -> "Keskmine"
        MediumDescription -> "6-8 tähte"
        Hard -> "Raske"
        HardDescription -> "9+ tähte"
        Hangman -> "Poomismäng"
        CategoryLabel -> "Kategooria: "
        DifficultyLabel -> "Raskusaste: "
        RemainingGuesses -> "Järelejäänud katsed: "
        GuessedLetters -> "Arvatud tähed:"
        Guess -> "Arva"
        GameOver -> "Mäng läbi"
        YouWon -> "🎉 Sa võitsid!"
        YouLost -> "💀 Sa kaotasid!"
        WordWas -> "Sõna oli:"
        GuessedLettersStats -> "Arvatud tähed: "
        RemainingGuessesStats -> "Järelejäänud katsed: "
        PlayAgain -> "Mängi uuesti"
        BackToStart -> "Tagasi algusesse"
        ClearError -> "×"
        EnterLetterPlaceholder -> "Sisesta täht..."
        None -> "Puudub"
        Unknown -> "Teadmata"
        NoWordsAvailable -> "Selle kombinatsiooni jaoks pole sõnu saadaval"
        SelectLanguageCategory -> "Palun valige esmalt keel ja kategooria"
        EnterLetter -> "Palun sisestage täht"
        LettersOnly -> "Palun sisestage ainult tähti"
        AlreadyGuessed -> "Te olete selle tähe juba arvanud"
        OneLetterOnly -> "Palun sisestage ainult üks täht"