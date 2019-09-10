module Example exposing (..)

import Expect exposing (Expectation)
import Oembed
import Test exposing (..)


suite : Test
suite =
    describe "find match"
        [ test "match twitter" <|
            \_ ->
                "https://twitter.com/dillontkearns/status/1105250778233491456"
                    |> Oembed.lookup
                    |> Expect.equal (Just "https://publish.twitter.com/oembed")
        , test "match youtube" <|
            \_ ->
                "https://www.youtube.com/watch?v=43eM4kNbb6c"
                    |> Oembed.lookup
                    |> Expect.equal (Just "https://www.youtube.com/oembed")
        ]
