module Test.Generated.Main exposing (main)

import GameLogicTest
import UpdateTest
import WordsTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    Test.Runner.Node.run
        { runs = 100
        , report = JsonReport
        , seed = 150181712836994
        , processes = 4
        , globs =
            []
        , paths =
            [ "/home/lars/projects/hangman-elm/tests/GameLogicTest.elm"
            , "/home/lars/projects/hangman-elm/tests/UpdateTest.elm"
            , "/home/lars/projects/hangman-elm/tests/WordsTest.elm"
            ]
        }
        [ ( "GameLogicTest"
          , [ Test.Runner.Node.check GameLogicTest.suite
            ]
          )
        , ( "UpdateTest"
          , [ Test.Runner.Node.check UpdateTest.suite
            ]
          )
        , ( "WordsTest"
          , [ Test.Runner.Node.check WordsTest.suite
            ]
          )
        ]