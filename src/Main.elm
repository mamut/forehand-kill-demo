module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
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


darkGreen : Color
darkGreen =
    rgb255 66 128 81


green : Color
green =
    rgb255 82 128 98


white : Color
white =
    rgb255 255 255 255


view : Model -> Html Msg
view model =
    layout []
        (column
            [ width fill, height fill, spacing 20 ]
            [ viewScoreBoard model
            , viewResetButton
            ]
        )


viewScoreBoard : Model -> Element Msg
viewScoreBoard model =
    wrappedRow
        [ spacing 20 ]
        [ viewPointPad LeftScore model.left
        , viewPointPad RightScore model.right
        ]


viewPointPad : Msg -> Int -> Element Msg
viewPointPad msg score =
    Input.button
        []
        { onPress = Just msg
        , label = text (String.fromInt score)
        }


viewResetButton : Element Msg
viewResetButton =
    Input.button
        [ alignBottom
        , width fill
        , height (px 50)
        , Background.color darkGreen
        , Font.bold
        , Font.color white
        , Border.color green
        , Border.widthEach { bottom = 0, top = 3, right = 0, left = 0 }
        ]
        { onPress = Just ResetScore
        , label = Element.el [ centerX ] (text "Reset")
        }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
