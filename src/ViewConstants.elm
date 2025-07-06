module ViewConstants exposing (..)

-- CSS Class Names
appClass : String
appClass = "app"

screenClass : String
screenClass = "screen"

startScreenClass : String
startScreenClass = "start-screen"

languageScreenClass : String
languageScreenClass = "language-screen"

categoryScreenClass : String
categoryScreenClass = "category-screen"

difficultyScreenClass : String
difficultyScreenClass = "difficulty-screen"

gameScreenClass : String
gameScreenClass = "game-screen"

gameOverScreenClass : String
gameOverScreenClass = "game-over-screen"

gameTitleClass : String
gameTitleClass = "game-title"

gameDescriptionClass : String
gameDescriptionClass = "game-description"

startButtonClass : String
startButtonClass = "start-button"

screenTitleClass : String
screenTitleClass = "screen-title"

selectionButtonsClass : String
selectionButtonsClass = "selection-buttons"

selectionButtonClass : String
selectionButtonClass = "selection-button"

difficultyButtonsClass : String
difficultyButtonsClass = "difficulty-buttons"

difficultyButtonClass : String
difficultyButtonClass = "difficulty-button"

difficultyDescriptionClass : String
difficultyDescriptionClass = "difficulty-description"

easyClass : String
easyClass = "easy"

mediumClass : String
mediumClass = "medium"

hardClass : String
hardClass = "hard"

gameInfoClass : String
gameInfoClass = "game-info"

difficultyDisplayClass : String
difficultyDisplayClass = "difficulty-display"

remainingGuessesClass : String
remainingGuessesClass = "remaining-guesses"

wordDisplayClass : String
wordDisplayClass = "word-display"

maskedWordClass : String
maskedWordClass = "masked-word"

guessedLettersClass : String
guessedLettersClass = "guessed-letters"

guessedTitleClass : String
guessedTitleClass = "guessed-title"

guessedListClass : String
guessedListClass = "guessed-list"

guessInputClass : String
guessInputClass = "guess-input"

letterInputClass : String
letterInputClass = "letter-input"

guessButtonClass : String
guessButtonClass = "guess-button"

gameResultClass : String
gameResultClass = "game-result"

resultMessageClass : String
resultMessageClass = "result-message"

wonClass : String
wonClass = "won"

lostClass : String
lostClass = "lost"

wordRevealClass : String
wordRevealClass = "word-reveal"

wordLabelClass : String
wordLabelClass = "word-label"

revealedWordClass : String
revealedWordClass = "revealed-word"

gameStatsClass : String
gameStatsClass = "game-stats"

gameOverButtonsClass : String
gameOverButtonsClass = "game-over-buttons"

playAgainButtonClass : String
playAgainButtonClass = "play-again-button"

backToStartButtonClass : String
backToStartButtonClass = "back-to-start-button"

errorMessageClass : String
errorMessageClass = "error-message"

clearErrorButtonClass : String
clearErrorButtonClass = "clear-error-button"

-- UI Text Constants
gameTitleText : String
gameTitleText = "🎯 HANGMAN GAME"

gameDescriptionText : String
gameDescriptionText = "Guess the word letter by letter!"

startGameText : String
startGameText = "Start Game"

chooseLanguageText : String
chooseLanguageText = "Choose Language"

englishText : String
englishText = "🇬🇧 English"

germanText : String
germanText = "🇩🇪 German"

estonianText : String
estonianText = "🇪🇪 Estonian"

chooseCategoryText : String
chooseCategoryText = "Choose Category"

animalsText : String
animalsText = "🐾 Animals"

foodText : String
foodText = "🍔 Food & Drinks"

sportText : String
sportText = "⚽ Sport"

chooseDifficultyText : String
chooseDifficultyText = "Choose Difficulty"

easyText : String
easyText = "Easy"

easyDescriptionText : String
easyDescriptionText = "3-5 letter words"

mediumText : String
mediumText = "Medium"

mediumDescriptionText : String
mediumDescriptionText = "6-8 letter words"

hardText : String
hardText = "Hard"

hardDescriptionText : String
hardDescriptionText = "9+ letter words"

hangmanText : String
hangmanText = "Hangman"

difficultyLabelText : String
difficultyLabelText = "Difficulty: "

remainingGuessesText : String
remainingGuessesText = "Remaining guesses: "

guessedLettersText : String
guessedLettersText = "Guessed letters:"

guessText : String
guessText = "Guess"

gameOverText : String
gameOverText = "Game Over"

youWonText : String
youWonText = "🎉 You Won!"

youLostText : String
youLostText = "💀 You Lost!"

wordWasText : String
wordWasText = "The word was:"

guessedLettersStatsText : String
guessedLettersStatsText = "Guessed letters: "

remainingGuessesStatsText : String
remainingGuessesStatsText = "Remaining guesses: "

playAgainText : String
playAgainText = "Play Again"

backToStartText : String
backToStartText = "Back to Start"

clearErrorText : String
clearErrorText = "×"

-- Placeholder Text
enterLetterPlaceholder : String
enterLetterPlaceholder = "Enter a letter..."

-- Display Constants
noneText : String
noneText = "None"

unknownText : String
unknownText = "Unknown"

-- Error Messages
noWordsAvailableError : String
noWordsAvailableError = "No words available for this combination"

selectLanguageCategoryError : String
selectLanguageCategoryError = "Please select language and category first"

enterLetterError : String
enterLetterError = "Please enter a letter"

lettersOnlyError : String
lettersOnlyError = "Please enter only letters"

alreadyGuessedError : String
alreadyGuessedError = "You already guessed that letter"

oneLetterOnlyError : String
oneLetterOnlyError = "Please enter only one letter"