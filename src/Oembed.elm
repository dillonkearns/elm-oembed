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
    Html.iframe
        [ Attr.src
            ("https://oembed.netlify.com/?url="
                ++ Url.percentEncode
                    (oembedProviderUrl ++ "?url=" ++ resourceUrl)
            )
        , Attr.width 500
        , Attr.height 750
        , Attr.attribute "border" "0"
        , Attr.attribute "frameborder" "0"
        ]
        []
