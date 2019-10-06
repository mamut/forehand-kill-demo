module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


type alias Game =
    { left : Int
    , right : Int
    , state : GameState
    }


type alias Model =
    { game : Game
    , undo : Maybe Game
    }


init : Model
init =
    { game =
        { left = 0
        , right = 0
        , state = Playing
        }
    , undo = Nothing
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
    | Undo Game


checkForWin : Int -> Int -> Player -> GameState
checkForWin currentPlayerScore otherPlayerScore player =
    if currentPlayerScore >= 11 && (currentPlayerScore - otherPlayerScore) >= 2 then
        Won player

    else
        Playing


update : Msg -> Model -> Model
update msg model =
    let
        { game } =
            model
    in
    case msg of
        LeftScore ->
            let
                newLeftScore =
                    game.left + 1
            in
            { model
                | game =
                    { game
                        | left = newLeftScore
                        , state = checkForWin newLeftScore game.right PlayerA
                    }
                , undo = Just game
            }

        RightScore ->
            let
                newRightScore =
                    game.right + 1
            in
            { model
                | game =
                    { game
                        | right = newRightScore
                        , state = checkForWin newRightScore game.left PlayerB
                    }
                , undo = Just game
            }

        ResetScore ->
            init

        Undo undo ->
            { model
                | game = undo
                , undo = Nothing
            }


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
            case model.game.state of
                Playing ->
                    viewScoreBoard model.game

                Won player ->
                    viewWinScreen player model.game
    in
    layout
        [ Font.family [ Font.typeface "Lato", Font.sansSerif ]
        ]
        (column
            [ width fill, height fill ]
            [ screen
            , row
                [ alignBottom
                , width fill
                , height (px 50)
                ]
                [ viewUndoButton model.undo
                , viewResetButton
                ]
            ]
        )


viewScoreBoard : Game -> Element Msg
viewScoreBoard game =
    wrappedRow
        [ spaceEvenly
        , width fill
        , height fill
        ]
        [ viewPointPad "Player A" LeftScore game.left
        , viewPointPad "Player B" RightScore game.right
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


viewBottomButton : { onPress : Maybe Msg, label : Element Msg } -> Element Msg
viewBottomButton options =
    Input.button
        [ alignBottom
        , width fill
        , height fill
        , Background.color darkGreen
        , Font.bold
        , Font.color white
        , Border.color green
        , Border.widthEach { bottom = 0, top = 3, right = 0, left = 0 }
        ]
        options


viewResetButton : Element Msg
viewResetButton =
    viewBottomButton
        { onPress = Just ResetScore
        , label = Element.el [ centerX ] (text "Reset")
        }


viewUndoButton : Maybe Game -> Element Msg
viewUndoButton maybeGame =
    case maybeGame of
        Just game ->
            viewBottomButton
                { onPress = Just (Undo game)
                , label = Element.el [ centerX ] (text "Undo")
                }

        Nothing ->
            el [ alignBottom, width fill, height fill, Background.color darkGreen ] (text "")


viewWinScreen : Player -> Game -> Element Msg
viewWinScreen player game =
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
            (text (String.fromInt game.left ++ " : " ++ String.fromInt game.right))
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
