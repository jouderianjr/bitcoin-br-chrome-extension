module Main exposing (..)

import Html exposing (Html, program, div, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing ( onClick )
import Http

-- component import example
import Data.MercadoBitcoin exposing (
  mercadoBitcoinDecoder,
  MercadoBitcoinCurrency )


-- APP
main : Program Never Model Msg
main = program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

-- MODEL
type alias Model =
  { mercadoBitcoin: MercadoBitcoinCurrency
  , err: String
  }

example : MercadoBitcoinCurrency
example =
  { high = ""
  }

model : Model
model = {mercadoBitcoin = example, err = ""}


-- UPDATE
type Msg = NoOp
  | OnBtnClicked
  | SearchUsers (Result Http.Error MercadoBitcoinCurrency)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)
    OnBtnClicked -> (model, searchUsers "w")
    SearchUsers (Ok teste) -> (model , Cmd.none)
    SearchUsers (Err (Http.BadPayload message response)) ->
        ({model | err = message}, Cmd.none)
    SearchUsers (Err (Http.BadUrl _)) -> (model , Cmd.none)
    SearchUsers (Err (Http.Timeout)) -> (model , Cmd.none)
    SearchUsers (Err (Http.NetworkError)) -> (model , Cmd.none)
    SearchUsers (Err (Http.BadStatus _)) -> (model , Cmd.none)


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div
    [ class "container" ]
    [ div [ class "row" ] [
      button [ class "btn btn-danger", onClick OnBtnClicked] [text "click me!"]
    ] ]

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- INIT
init : (Model, Cmd Msg)
init = ( model , Cmd.none )

searchUsers : String -> Cmd Msg
searchUsers term =
  let
    url = "https://www.mercadobitcoin.net/api/BTC/ticker/"
  in
    Http.send SearchUsers (Http.get url mercadoBitcoinDecoder)
