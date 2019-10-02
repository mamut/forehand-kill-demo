module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)


type alias Model =
    { left : Int
    , right : Int
    }


init : Model
init =
    { left = 0
    , right = 0
    }


type Msg
    = LeftScore
    | RightScore
    | ResetScore


update : Msg -> Model -> Model
update msg model =
    case msg of
        LeftScore ->
            { model | left = model.left + 1 }

        RightScore ->
            { model | right = model.right + 1 }

        ResetScore ->
            init


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button
                [ onClick LeftScore ]
                [ text (String.fromInt model.left) ]
            , button
                [ onClick RightScore ]
                [ text (String.fromInt model.right) ]
            ]
        , button
            [ onClick ResetScore ]
            [ text "Reset" ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox { init = init, view = view, update = update }
