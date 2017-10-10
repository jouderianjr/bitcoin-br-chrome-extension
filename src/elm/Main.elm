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
  td,
  h3,
  a)

import List exposing (map)
import String

import Html.Attributes exposing (class, target, href)
import Http

import Data.Currency exposing (currenciesDecoder, Currency)

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
  { currencies: List Currency
  , err: String
  }

model : Model
model = {currencies = [], err = ""}

-- UPDATE
type Msg = NoOp
  | OnBtnClicked
  | GetCurrencies (Result Http.Error (List Currency))

update : Msg -> Model -> (Model, Cmd Msg)
update msg {currencies, err} =
  case msg of
    NoOp -> (model, Cmd.none)
    OnBtnClicked ->
      ({model | currencies = []}, getCurrencies)
    GetCurrencies (Ok currencies) ->
      ({model | currencies = currencies } , Cmd.none)
    GetCurrencies (Err err) ->
      ({model | err = toString err}, Cmd.none)

-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view {currencies} =
  div
    [ class "container" ]
    [ h3 [ class "text-center" ] [ text "BR Bitcoin Currency" ]
    , table [ class "table table-inverse" ]
      [ thead []
        [ tr []
          [ th [] [ text "Exchange" ]
          , th [] [ text "High" ]
          , th [] [ text "Last" ]
          , th [] [ text "Low" ]
          , th [] [ text "Vol" ]
          ]
        ]
      , tbody [] (map renderCurrencyRow currencies)
      ]
    ]

renderCurrencyRow : Currency -> Html Msg
renderCurrencyRow currency =
  tr []
    [ th [] [ a [ target "_blank", href currency.link] [ text currency.exchange ] ]
    , th [] [ text (formattedCurrency currency.high) ]
    , th [] [ text (formattedCurrency currency.last) ]
    , th [] [ text (formattedCurrency currency.low) ]
    , th [] [ currency.vol |> toString |> text ]
    ]

formattedCurrency : Float -> String
formattedCurrency number =
  number
    |> toString
    |> String.append "R$ "

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- INIT
init : (Model, Cmd Msg)
init = ( model , getCurrencies )

getCurrencies : Cmd Msg
getCurrencies =
  let
    url = "https://api.bitvalor.com/v1/ticker.json"
  in
    Http.send GetCurrencies (Http.get url currenciesDecoder)
