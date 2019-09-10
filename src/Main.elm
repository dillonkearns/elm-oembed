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


type Model
    = Failure
    | Loading
    | Success String


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getRandomCatGif )


type Msg
    = MorePlease
    | GotGif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( Loading, getRandomCatGif )

        GotGif result ->
            case result of
                Ok url ->
                    ( Success url, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Some cats", body = [ view model ] }


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ --  Oembed.view "https://www.youtube.com/watch?v=43eM4kNbb6c"
              --     |> Maybe.withDefault (Html.text "Couldn't find oembed provider.")
              -- , Oembed.view "https://twitter.com/dillontkearns/status/1105250778233491456"
              --     |> Maybe.withDefault (Html.text "Couldn't find oembed provider.")
              -- , Oembed.view "https://giphy.com/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
              -- , Oembed.view "https://giphy.com/gifs/cant-hardly-wait-kW8mnYSNkUYKc"
              --     |> Maybe.withDefault (Html.text "Couldn't find GIPHY oembed provider.")
              Html.node "oembed-element" [] []
            ]
        , div []
            [ text "This is below"
            ]
        ]


viewGif : Model -> Html Msg
viewGif model =
    case model of
        Failure ->
            div []
                [ text "I could not load a random cat for some reason. "
                , button [ onClick MorePlease ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success url ->
            div []
                [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
                , img [ src url ] []
                ]



-- HTTP


getRandomCatGif : Cmd Msg
getRandomCatGif =
    Http.get
        { url = "https://giphy.com/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , expect = Http.expectJson GotGif gifDecoder
        }



-- https://giphy\\.com/gifs/.*


gifDecoder : Decoder String
gifDecoder =
    field "data" (field "image_url" string)
