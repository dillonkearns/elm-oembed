module Oembed exposing (lookup)

import List.Extra
import Oembed.Provider
import Regex


lookup : String -> Maybe String
lookup inputUrl =
    Oembed.Provider.all
        |> List.Extra.find
            (\provider ->
                provider.schemes
                    |> List.any (\scheme -> Regex.contains scheme inputUrl)
            )
        |> Maybe.map .url
