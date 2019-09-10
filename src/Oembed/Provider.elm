module Oembed.Provider exposing (Provider, all, lookup)

import List.Extra
import Regex exposing (Regex)


type alias Provider =
    { schemes : List Regex
    , url : String
    }


regex : String -> Regex
regex string =
    string
        |> Regex.fromString
        |> Maybe.withDefault Regex.never


all : List Provider
all =
    [ { schemes =
            [ regex "https://.*\\.youtube\\.com/watch.*"
            ]
      , url = "https://www.youtube.com/oembed"
      }
    , { schemes =
            [ regex "https://twitter\\.com/.*/status/.*"
            , regex "https://.*\\.twitter\\.com/.*/status/.*"
            ]
      , url = "https://publish.twitter.com/oembed"
      }
    ]


lookup : String -> Maybe String
lookup inputUrl =
    all
        |> List.Extra.find
            (\provider ->
                provider.schemes
                    |> List.any (\scheme -> Regex.contains scheme inputUrl)
            )
        |> Maybe.map .url
