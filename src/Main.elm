module Main exposing (..)

import Browser
import Element
import Element.Input as Input
import Html exposing (Html)


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
    Element.layout []
        (Element.column
            []
            [ viewScoreBoard model
            , viewResetButton
            ]
        )


viewScoreBoard : Model -> Element.Element Msg
viewScoreBoard model =
    Element.wrappedRow
        []
        [ viewPointPad LeftScore model.left
        , viewPointPad RightScore model.right
        ]


viewPointPad : Msg -> Int -> Element.Element Msg
viewPointPad msg score =
    Input.button
        []
        { onPress = Just msg
        , label = Element.text (String.fromInt score)
        }


viewResetButton : Element.Element Msg
viewResetButton =
    Input.button
        []
        { onPress = Just ResetScore
        , label = Element.text "Reset"
        }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
