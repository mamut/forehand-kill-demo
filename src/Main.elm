module Main exposing (..)

import Browser
import Html exposing (Html, div, text)


type alias Model =
    {}


init : Model
init =
    {}


update : msg -> Model -> Model
update _ model =
    model


view : Model -> Html msg
view model =
    div [] [ text "test" ]


main : Program () Model msg
main =
    Browser.sandbox { init = init, view = view, update = update }
