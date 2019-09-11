module Oembed exposing (view, viewOrDiscover)

{-|


## Oembed Discovery

If you use `Oembed.view`, you get back a `Maybe` value because it is looking up
a list of provider schemes (like `https://youtube.com/watch/abc123` would
find a youtube scheme) and returning `Nothing` if it doesn't find one. This is nice because you can fail your build if there are
any issues.

But some services may not be registered in [the official list of providers](https://oembed.com/#section7).
These sites may instead use `<link rel="alternate">` tags in their HTML `<head>` tags to [become discoverable](https://oembed.com/#section4).
That is to say, it will contain the information needed to get an API call to get the oembed content given a particular HTML page.
This is handy, but it means that this information is not conveniently accessible in Elm. So it's preferrable to
use `Oembed.view`, but `Oembed.discover` is provided to explicitly.

Also note that it requires an additional HTTP request to fetch the HTML page and process before it makes
the Oembed API request based on that page's `<head>` tags.

-}

import Html exposing (Html)
import Html.Attributes as Attr
import List.Extra
import Oembed.Provider
import Regex
import Url


{-| Look for an oembed provider in [the hardcoded list](https://oembed.com/#section7). If none is found,
fallback to trying to [discover the oembed url](https://oembed.com/#section4). Note
that discovery will fail if the url passed in doesn't not link to a page
that contains the `<link>` tag in the format used for discovery. So even
though those doesn't return `Maybe (Html msg)`, it may fail to render oembed content.
-}
viewOrDiscover : Maybe { maxWidth : Int, maxHeight : Int } -> String -> Html msg
viewOrDiscover options resourceUrl =
    resourceUrl
        |> view options
        |> Maybe.withDefault (discover resourceUrl)


{-| Lookup a way to handle the passed in url using [the hardcoded list](https://oembed.com/#section7)
of oembed provider schemes. If none is found, it will return `Nothing`. Otherwise,
you will have correctly rendered Oembed content (assuming no unexpected errors occur).
-}
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
