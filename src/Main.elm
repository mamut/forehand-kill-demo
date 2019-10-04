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
    , gameState : GameState
    }


init : Model
init =
    { left = 0
    , right = 0
    , gameState = Playing
    }


type Player
    = PlayerA
    | PlayerB


type GameState
    = Playing
    | Won Player


type Msg
    = LeftScore
    | RightScore
    | ResetScore


checkForWin : Int -> Int -> Player -> GameState
checkForWin currentPlayerScore otherPlayerScore player =
    if currentPlayerScore >= 11 && (currentPlayerScore - otherPlayerScore) >= 2 then
        Won player

    else
        Playing


update : Msg -> Model -> Model
update msg model =
    case msg of
        LeftScore ->
            let
                newLeftScore =
                    model.left + 1
            in
            { model
                | left = newLeftScore
                , gameState = checkForWin newLeftScore model.right PlayerA
            }

        RightScore ->
            let
                newRightScore =
                    model.right + 1
            in
            { model
                | right = newRightScore
                , gameState = checkForWin newRightScore model.left PlayerB
            }

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


playerName : Player -> String
playerName player =
    case player of
        PlayerA ->
            "Player A"

        PlayerB ->
            "Player B"


view : Model -> Html Msg
view model =
    let
        screen =
            case model.gameState of
                Playing ->
                    viewScoreBoard model

                Won player ->
                    viewWinScreen player model
    in
    layout
        [ Font.family [ Font.typeface "Lato", Font.sansSerif ]
        ]
        (column
            [ width fill, height fill ]
            [ screen
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


viewWinScreen : Player -> Model -> Element Msg
viewWinScreen player model =
    column
        [ width fill
        , height fill
        , spacing 20
        , Font.bold
        ]
        [ el
            [ centerX
            , centerY
            , Font.size 30
            ]
            (text (playerName player ++ " won the game!"))
        , el
            [ centerX
            , centerY
            , Font.size 60
            ]
            (text (String.fromInt model.left ++ " : " ++ String.fromInt model.right))
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
