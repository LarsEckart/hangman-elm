module Test.Generated.Main exposing (main)

import GameLogicTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    Test.Runner.Node.run
        { runs = 100
        , report = ConsoleReport Monochrome
        , seed = 405905293467228
        , processes = 4
        , globs =
            []
        , paths =
            [ "/home/lars/projects/hangman-elm/tests/GameLogicTest.elm"
            ]
        }
        [ ( "GameLogicTest"
          , [ Test.Runner.Node.check GameLogicTest.suite
            ]
          )
        ]