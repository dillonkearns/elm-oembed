module ProviderTests exposing (..)

import Expect
import Oembed
import Oembed.Provider
import Test exposing (..)


suite : Test
suite =
    describe "find match"
        [ test "match twitter" <|
            \_ ->
                "https://twitter.com/dillontkearns/status/1105250778233491456"
                    |> Oembed.Provider.lookup []
                    |> Expect.equal (Just "https://publish.twitter.com/oembed")
        , test "match youtube" <|
            \_ ->
                "https://www.youtube.com/watch?v=43eM4kNbb6c"
                    |> Oembed.Provider.lookup []
                    |> Expect.equal (Just "https://www.youtube.com/oembed")
        , test "matchesDefaultProvider finds Soundcloud" <|
            \_ ->
                "https://soundcloud.com/trang-phan-th-491539371/amore-mio-elm-la-mix-mp3"
                    |> Oembed.matchesDefaultProvider
                    |> Expect.equal True
        , test "matchesDefaultProvider doesn't find X" <|
            \_ ->
                "https://x.com/elmlang"
                    |> Oembed.matchesDefaultProvider
                    |> Expect.equal False
        ]
