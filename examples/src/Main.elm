module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import Oembed


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = viewDocument
        }


type alias Model =
    ()


init : () -> ( Model, Cmd Msg )
init _ =
    ( (), Cmd.none )


type alias Msg =
    ()


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Oembed example gallery", body = [ view model ] }


customProviders =
    []


oembed options url =
    Oembed.view customProviders options url
        |> Maybe.withDefault (Html.text ("Couldn't find oembed provider for url " ++ url))


view : Model -> Html Msg
view model =
    div []
        [ oembed Nothing "https://www.youtube.com/watch?v=IcgmSRJHu_8"
        , oembed Nothing "https://twitter.com/dillontkearns/status/1105250778233491456"
        , oembed (Just { maxWidth = 250, maxHeight = 1000 }) "https://giphy.com/gifs/art-weird-ewan-26hiu3mZVquuykwhy"
        , oembed Nothing "https://ellie-app.com/4Xt4jdgtnZ2a1"
        ]
