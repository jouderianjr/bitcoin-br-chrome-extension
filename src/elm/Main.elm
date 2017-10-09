module Main exposing (..)

import Html exposing (
  Html,
  program,
  div,
  text,
  button,
  table,
  thead,
  tbody,
  tr,
  th,
  td)

import List exposing (map)

import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http

-- component import example
import Data.MercadoBitcoin exposing (mercadoBitcoinDecoder)
-- import Data.FoxBit exposing (foxBitDecoder)

import Data.Currency exposing (
  Currency)


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
  { currencies: String
  , err: String
  }

exampleTest : Currency
exampleTest =
  { high =  0
  , low = 0
  , vol = 0
  , last = 0
  , exchange = ""
  }

model : Model
model = {currencies = "", err = ""}

-- UPDATE
type Msg = NoOp
  | OnBtnClicked
  | GetMercadoBitcoinCurrency (Result Http.Error (List ( String, Currency )))

update : Msg -> Model -> (Model, Cmd Msg)
update msg {currencies, err} =
  case msg of
    NoOp -> (model, Cmd.none)
    OnBtnClicked -> (model, getMercadoBitcoinCurrency)
    GetMercadoBitcoinCurrency (Ok currencies) ->
      ({model | currencies = toString currencies } , Cmd.none)
    GetMercadoBitcoinCurrency (Err (Http.BadPayload message response)) ->
      ({model | err = message}, Cmd.none)
    GetMercadoBitcoinCurrency (Err (Http.BadUrl _)) -> (model , Cmd.none)
    GetMercadoBitcoinCurrency (Err (Http.Timeout)) -> (model , Cmd.none)
    GetMercadoBitcoinCurrency (Err (Http.NetworkError)) -> (model , Cmd.none)
    GetMercadoBitcoinCurrency (Err (Http.BadStatus _)) -> (model , Cmd.none)


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view {currencies} =
  div
    [ class "container" ]
    [ div [ class "row" ] [ text currencies]
    ]
-- view : Model -> Html Msg
-- view {currencies} =
--   div
--     [ class "container" ]
--     [ div [ class "row" ]
--       [ button [ class "btn btn-danger", onClick OnBtnClicked] [text "click me!"]
--       , table [ class "table table-inverse" ]
--         [ thead []
--           [ tr []
--             [ th [] [ text "Exchange" ]
--             , th [] [ text "Buy" ]
--             , th [] [ text "High" ]
--             , th [] [ text "Last" ]
--             , th [] [ text "Low" ]
--             , th [] [ text "Sell" ]
--             , th [] [ text "Vol" ]
--             ]
--           ]
--         , tbody [] (map renderCurrencyRow currencies)
--         ]
--       ]
--     ]

-- renderCurrencyRow : Currency -> Html Msg
-- renderCurrencyRow currency =
--   tr []
--     [ th [] [ text currency.exchange ]
--     , th [] [ text currency.buy ]
--     , th [] [ text currency.high ]
--     , th [] [ text currency.last ]
--     , th [] [ text currency.low ]
--     , th [] [ text currency.sell ]
--     , th [] [ text currency.vol ]
--     ]

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- INIT
init : (Model, Cmd Msg)
init = ( model , getMercadoBitcoinCurrency )

getMercadoBitcoinCurrency : Cmd Msg
getMercadoBitcoinCurrency =
  let
    url = "https://api.bitvalor.com/v1/ticker.json"
    -- url = "https://www.mercadobitcoin.net/api/BTC/ticker/"
  in
    Http.send GetMercadoBitcoinCurrency (Http.get url mercadoBitcoinDecoder)
