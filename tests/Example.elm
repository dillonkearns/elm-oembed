module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


oembedUrl : String -> Maybe String
oembedUrl input =
    Just "https://publish.twitter.com/oembed"


type OembedUrl
    = OembedUrl String


suite : Test
suite =
    test "match twitter" <|
        \_ ->
            "https://twitter.com/dillontkearns/status/1105250778233491456"
                |> oembedUrl
                |> Expect.equal (Just "https://publish.twitter.com/oembed")
