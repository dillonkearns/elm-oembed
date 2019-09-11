module Oembed exposing (view, viewOrDiscover)

import Html exposing (Html)
import Html.Attributes as Attr
import List.Extra
import Oembed.Provider
import Regex
import Url


viewOrDiscover : Maybe { maxWidth : Int, maxHeight : Int } -> String -> Html msg
viewOrDiscover options resourceUrl =
    resourceUrl
        |> view options
        |> Maybe.withDefault (discover resourceUrl)


view : Maybe { maxWidth : Int, maxHeight : Int } -> String -> Maybe (Html msg)
view options resourceUrl =
    resourceUrl
        |> Oembed.Provider.lookup
        |> Maybe.map (urlToIframe options resourceUrl)


discover : String -> Html msg
discover url =
    Html.node "oembed-element" [ Attr.attribute "discover-url" url ] []


urlToIframe : Maybe { maxWidth : Int, maxHeight : Int } -> String -> String -> Html msg
urlToIframe options resourceUrl oembedProviderUrl =
    Html.node "oembed-element"
        ([ Attr.attribute "url" (oembedProviderUrl ++ "?url=" ++ resourceUrl) |> Just
         , options |> Maybe.map .maxWidth |> Maybe.map String.fromInt |> Maybe.map (Attr.attribute "maxwidth")
         , options |> Maybe.map .maxHeight |> Maybe.map String.fromInt |> Maybe.map (Attr.attribute "maxheight")
         ]
            |> List.filterMap identity
        )
        []
