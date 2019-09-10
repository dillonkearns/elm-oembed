module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import List.Extra
import Regex
import Test exposing (..)


oembedUrl : String -> Maybe String
oembedUrl input =
    providers
        |> List.Extra.find
            (\provider ->
                provider.schemes
                    |> List.any (\scheme -> Regex.contains scheme input)
            )
        |> Maybe.map .url


type alias Provider =
    { schemes : List Regex.Regex
    , url : String
    }


providers : List Provider
providers =
    [ { schemes =
            [ Regex.fromString "https://.*\\.youtube\\.com/watch.*" |> Maybe.withDefault Regex.never
            ]
      , url = "https://www.youtube.com/oembed"
      }
    , { schemes =
            [ Regex.fromString "https://twitter\\.com/.*/status/.*" |> Maybe.withDefault Regex.never
            , Regex.fromString "https://.*\\.twitter\\.com/.*/status/.*" |> Maybe.withDefault Regex.never
            ]
      , url = "https://publish.twitter.com/oembed"
      }
    ]


type OembedUrl
    = OembedUrl String


suite : Test
suite =
    describe "find match"
        [ test "match twitter" <|
            \_ ->
                "https://twitter.com/dillontkearns/status/1105250778233491456"
                    |> oembedUrl
                    |> Expect.equal (Just "https://publish.twitter.com/oembed")
        , test "match youtube" <|
            \_ ->
                "https://www.youtube.com/watch?v=43eM4kNbb6c"
                    |> oembedUrl
                    |> Expect.equal (Just "https://www.youtube.com/oembed")
        ]
