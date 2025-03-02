module Oembed exposing
    ( view, viewOrDiscover, matchesProvider
    , Provider
    )

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

@docs view, viewOrDiscover, matchesProvider


## Custom Providers

Explicitly looking up providers is preferrable to using Oembed Discovery because it:

1.  Gives you a `Maybe` type which you can check for to see if anything went wrong, and
2.  Doesn't require the extra HTTP request to do the Discovery.

Here's an example of supplying a custom provider.

    import Html
    import Oembed exposing (Provider)
    import Regex

    customProviders : List Provider
    customProviders =
        [ { url = "https://ellie-app.com/oembed/"
          , schemes =
                [ Regex.fromString "https://ellie-app\\.com/.*" |> Maybe.withDefault Regex.never ]
          }
        ]

    ellieView =
        Oembed.view customProviders Nothing "https://ellie-app.com/4Xt4jdgtnZ2a1"
            |> Maybe.withDefault (Html.text "Couldn't find oembed provider")

@docs Provider

-}

import Html exposing (Html)
import Html.Attributes as Attr
import Oembed.Provider
import Regex exposing (Regex)


{-| `elm-oembed` has a default list of providers from [the official list](https://github.com/iamcal/oembed/tree/master/providers).
You can add custom ones (see the above section in this docs page).
-}
type alias Provider =
    { schemes : List Regex
    , url : String
    }


{-| Look for an oembed provider in [the hardcoded list](https://oembed.com/#section7). If none is found,
fallback to trying to [discover the oembed url](https://oembed.com/#section4). Note
that discovery will fail if the url passed in doesn't not link to a page
that contains the `<link>` tag in the format used for discovery. So even
though those doesn't return `Maybe (Html msg)`, it may fail to render oembed content.
-}
viewOrDiscover : List Provider -> Maybe { maxWidth : Int, maxHeight : Int } -> String -> Html msg
viewOrDiscover providers options resourceUrl =
    resourceUrl
        |> view providers options
        |> Maybe.withDefault (discover resourceUrl)


{-| Lookup a way to handle the passed in url using [the hardcoded list](https://oembed.com/#section7)
of oembed provider schemes. If none is found, it will return `Nothing`. Otherwise,
you will have correctly rendered Oembed content (assuming no unexpected errors occur).
-}
view : List Provider -> Maybe { maxWidth : Int, maxHeight : Int } -> String -> Maybe (Html msg)
view customProviders options resourceUrl =
    resourceUrl
        |> Oembed.Provider.lookup customProviders
        |> Maybe.map (urlToIframe options resourceUrl)


{-| Check if the passed in url matches any provider in [the hardcoded list](https://oembed.com/#section7)
of oembed provider schemes or a custom one.

Usage example: if you want to display a preview (thumbnail) of the link and only show
the embedded content after the user clicks the thumbnail,
you need to know in advance if the link is embeddable at all, otherwise you may want to display a plain link.

    isEmbeddable : String -> Bool
    isEmbeddable urlString =
        Oembed.matchesProvider [] urlString


    viewLink : String -> List (Html msg) -> Html msg
    viewLink urlString body =
        if isEmbeddable urlString then
            -- generate preview / embedded content

        else
            -- plain link
            a [ href urlString ] body

-}
matchesProvider : List Provider -> String -> Bool
matchesProvider customProviders inputUrl =
    Oembed.Provider.lookup customProviders inputUrl /= Nothing


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
