module Styles exposing 
    ( applyStyles
    , appStyles
    , screenStyles
    , gameTitleStyles
    , gameDescriptionStyles
    , screenTitleStyles
    , buttonBaseStyles
    , buttonContainerStyles
    , easyButtonStyles
    , mediumButtonStyles
    , hardButtonStyles
    , difficultyDescriptionStyles
    , gameInfoStyles
    , wordDisplayStyles
    , maskedWordStyles
    , gameResultStyles
    , resultMessageStyles
    , wonStyles
    , lostStyles
    , wordRevealStyles
    , wordLabelStyles
    , revealedWordStyles
    , gameStatsStyles
    , gameOverButtonsStyles
    , errorMessageStyles
    , clearErrorButtonStyles
    , letterButtonsContainerStyles
    , letterButtonStyles
    , letterButtonCorrectStyles
    , letterButtonWrongStyles
    )

import Html exposing (Html)
import Html.Attributes exposing (style)


-- INLINE STYLES FOR MOBILE RESPONSIVENESS

-- App container styles (mobile-first responsive)
appStyles : List (String, String)
appStyles = 
    [ ("width", "100%")
    , ("min-height", "100vh")
    , ("display", "flex")
    , ("flex-direction", "column")
    , ("justify-content", "center")
    , ("align-items", "center")
    , ("background", "linear-gradient(135deg, #667eea 0%, #764ba2 100%)")
    , ("padding", "5px")
    , ("box-sizing", "border-box")
    , ("font-family", "-apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif")
    , ("-webkit-font-smoothing", "antialiased")
    , ("-moz-osx-font-smoothing", "grayscale")
    ]

-- Screen container styles (mobile-first responsive)
screenStyles : List (String, String)
screenStyles = 
    [ ("background", "white")
    , ("border-radius", "8px")
    , ("box-shadow", "0 10px 30px rgba(0, 0, 0, 0.2)")
    , ("padding", "15px")
    , ("max-width", "400px")
    , ("width", "100%")
    , ("margin", "5px")
    , ("box-sizing", "border-box")
    , ("text-align", "center")
    ]

-- Title styles (mobile-first responsive)
gameTitleStyles : List (String, String)
gameTitleStyles = 
    [ ("font-size", "clamp(1.5rem, 4vw, 2rem)")
    , ("font-weight", "bold")
    , ("color", "#333")
    , ("margin", "0 0 10px 0")
    , ("text-shadow", "2px 2px 4px rgba(0, 0, 0, 0.1)")
    ]

-- Description styles
gameDescriptionStyles : List (String, String)
gameDescriptionStyles = 
    [ ("font-size", "1rem")
    , ("color", "#666")
    , ("margin", "0 0 20px 0")
    ]

-- Screen title styles (mobile-first responsive)
screenTitleStyles : List (String, String)
screenTitleStyles = 
    [ ("font-size", "clamp(1.2rem, 3vw, 1.5rem)")
    , ("font-weight", "bold")
    , ("color", "#333")
    , ("margin", "0 0 20px 0")
    ]

-- Button base styles
buttonBaseStyles : List (String, String)
buttonBaseStyles = 
    [ ("background", "#667eea")
    , ("color", "white")
    , ("border", "none")
    , ("border-radius", "8px")
    , ("padding", "12px 24px")
    , ("font-size", "1rem")
    , ("font-weight", "500")
    , ("cursor", "pointer")
    , ("transition", "all 0.3s ease")
    , ("margin", "5px")
    , ("min-height", "48px")
    , ("min-width", "120px")
    ]

-- Button container styles
buttonContainerStyles : List (String, String)
buttonContainerStyles = 
    [ ("display", "flex")
    , ("flex-direction", "column")
    , ("gap", "10px")
    , ("margin", "20px 0")
    ]

-- Difficulty button styles
difficultyButtonStyles : List (String, String)
difficultyButtonStyles = 
    buttonBaseStyles ++ 
    [ ("display", "flex")
    , ("flex-direction", "column")
    , ("align-items", "center")
    , ("padding", "16px")
    , ("text-align", "center")
    ]

-- Easy button styles
easyButtonStyles : List (String, String)
easyButtonStyles = 
    difficultyButtonStyles ++
    [ ("background", "#4CAF50")
    ]

-- Medium button styles
mediumButtonStyles : List (String, String)
mediumButtonStyles = 
    difficultyButtonStyles ++
    [ ("background", "#FF9800")
    ]

-- Hard button styles
hardButtonStyles : List (String, String)
hardButtonStyles = 
    difficultyButtonStyles ++
    [ ("background", "#f44336")
    ]

-- Difficulty description styles
difficultyDescriptionStyles : List (String, String)
difficultyDescriptionStyles = 
    [ ("font-size", "0.8rem")
    , ("margin", "4px 0 0 0")
    , ("opacity", "0.9")
    ]

-- Game info styles (mobile-first responsive)
gameInfoStyles : List (String, String)
gameInfoStyles = 
    [ ("display", "flex")
    , ("flex-direction", "column")
    , ("gap", "5px")
    , ("text-align", "center")
    , ("margin", "20px 0")
    , ("font-size", "0.9rem")
    , ("color", "#666")
    ]

-- Word display styles
wordDisplayStyles : List (String, String)
wordDisplayStyles = 
    [ ("margin", "20px 0")
    ]

-- Masked word styles (mobile-first responsive)
maskedWordStyles : List (String, String)
maskedWordStyles = 
    [ ("font-size", "clamp(1.5rem, 5vw, 2rem)")
    , ("font-weight", "bold")
    , ("color", "#333")
    , ("letter-spacing", "0.1em")
    , ("margin", "0")
    , ("font-family", "'Courier New', monospace")
    ]


-- Game result styles
gameResultStyles : List (String, String)
gameResultStyles = 
    [ ("margin", "20px 0")
    ]

-- Result message styles (mobile-first responsive)
resultMessageStyles : List (String, String)
resultMessageStyles = 
    [ ("font-size", "clamp(1.2rem, 3vw, 1.5rem)")
    , ("font-weight", "bold")
    , ("margin", "0 0 20px 0")
    ]

-- Won styles
wonStyles : List (String, String)
wonStyles = 
    [ ("color", "#4CAF50")
    ]

-- Lost styles
lostStyles : List (String, String)
lostStyles = 
    [ ("color", "#f44336")
    ]

-- Word reveal styles
wordRevealStyles : List (String, String)
wordRevealStyles = 
    [ ("margin", "20px 0")
    , ("padding", "15px")
    , ("background", "#f8f9fa")
    , ("border-radius", "8px")
    , ("border", "1px solid #e9ecef")
    ]

-- Word label styles
wordLabelStyles : List (String, String)
wordLabelStyles = 
    [ ("font-size", "0.9rem")
    , ("color", "#666")
    , ("margin", "0 0 5px 0")
    ]

-- Revealed word styles (mobile-first responsive)
revealedWordStyles : List (String, String)
revealedWordStyles = 
    [ ("font-size", "clamp(1.2rem, 4vw, 1.5rem)")
    , ("font-weight", "bold")
    , ("color", "#333")
    , ("margin", "0")
    , ("font-family", "'Courier New', monospace")
    ]

-- Game stats styles
gameStatsStyles : List (String, String)
gameStatsStyles = 
    [ ("margin", "20px 0")
    , ("font-size", "0.9rem")
    , ("color", "#666")
    ]

-- Game over buttons styles (mobile-first responsive)
gameOverButtonsStyles : List (String, String)
gameOverButtonsStyles = 
    buttonContainerStyles ++
    [ ("flex-direction", "column")
    , ("gap", "10px")
    ]

-- Error message styles
errorMessageStyles : List (String, String)
errorMessageStyles = 
    [ ("background", "#ffebee")
    , ("color", "#c62828")
    , ("padding", "10px")
    , ("border-radius", "8px")
    , ("margin", "15px 0")
    , ("border", "1px solid #ffcdd2")
    , ("display", "flex")
    , ("justify-content", "space-between")
    , ("align-items", "center")
    ]

-- Clear error button styles
clearErrorButtonStyles : List (String, String)
clearErrorButtonStyles = 
    [ ("background", "transparent")
    , ("border", "none")
    , ("color", "#c62828")
    , ("font-size", "1.2rem")
    , ("cursor", "pointer")
    , ("padding", "0")
    , ("margin", "0")
    , ("min-height", "auto")
    , ("min-width", "auto")
    ]

-- Letter buttons container styles
letterButtonsContainerStyles : List (String, String)
letterButtonsContainerStyles = 
    [ ("display", "grid")
    , ("grid-template-columns", "repeat(auto-fill, minmax(38px, 1fr))")
    , ("gap", "6px")
    , ("margin", "20px 0")
    , ("padding", "12px")
    , ("background", "#f8f9fa")
    , ("border-radius", "8px")
    , ("border", "1px solid #e9ecef")
    , ("max-width", "100%")
    ]

-- Letter button base styles
letterButtonStyles : List (String, String)
letterButtonStyles = 
    [ ("background", "white")
    , ("color", "#333")
    , ("border", "2px solid #ddd")
    , ("border-radius", "6px")
    , ("padding", "6px")
    , ("font-size", "0.95rem")
    , ("font-weight", "600")
    , ("cursor", "pointer")
    , ("transition", "all 0.2s ease")
    , ("min-width", "38px")
    , ("min-height", "38px")
    , ("display", "flex")
    , ("align-items", "center")
    , ("justify-content", "center")
    ]

-- Letter button correct guess styles
letterButtonCorrectStyles : List (String, String)
letterButtonCorrectStyles = 
    letterButtonStyles ++
    [ ("background", "#4CAF50")
    , ("color", "white")
    , ("border-color", "#4CAF50")
    , ("cursor", "not-allowed")
    , ("opacity", "0.8")
    ]

-- Letter button wrong guess styles
letterButtonWrongStyles : List (String, String)
letterButtonWrongStyles = 
    letterButtonStyles ++
    [ ("background", "#ffebee")
    , ("color", "#f44336")
    , ("border-color", "#f44336")
    , ("cursor", "not-allowed")
    , ("opacity", "0.6")
    ]

-- Helper function to apply styles
applyStyles : List (String, String) -> List (Html.Attribute msg)
applyStyles styles =
    List.map (\(prop, val) -> style prop val) styles