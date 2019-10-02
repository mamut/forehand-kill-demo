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
    layout
        [ Font.family [ Font.typeface "Lato", Font.sansSerif ]
        ]
        (column
            [ width fill, height fill ]
            [ viewScoreBoard model
            , viewResetButton
            ]
        )


viewScoreBoard : Model -> Element Msg
viewScoreBoard model =
    wrappedRow
        [ spaceEvenly
        , width fill
        , height fill
        ]
        [ viewPointPad "Player A" LeftScore model.left
        , viewPointPad "Player B" RightScore model.right
        ]


viewPointPad : String -> Msg -> Int -> Element Msg
viewPointPad label msg score =
    column
        [ width fill
        , height fill
        ]
        [ Element.el
            [ alignTop
            , centerX
            , padding 5
            ]
            (text label)
        , Input.button
            [ width (minimum 300 fill)
            , height fill
            , Font.size 120
            ]
            { onPress = Just msg
            , label = el [ centerX, centerY ] (text (String.fromInt score))
            }
        ]


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
