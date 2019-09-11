module Oembed exposing (view)

import Html exposing (Html)
import Html.Attributes as Attr
import List.Extra
import Oembed.Provider
import Regex
import Url


view : String -> Maybe (Html msg)
view resourceUrl =
    resourceUrl
        |> Oembed.Provider.lookup
        |> Maybe.map (urlToIframe resourceUrl)


urlToIframe : String -> String -> Html msg
urlToIframe resourceUrl oembedProviderUrl =
    Html.node "oembed-element"
        [ Attr.attribute "url" (oembedProviderUrl ++ "?url=" ++ resourceUrl)
        ]
        []
