module Data.Currency exposing (..)
import Json.Decode exposing (
  Decoder,
  string,
  succeed,
  field,
  at,
  list,
  keyValuePairs,
  map, float)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import List

type alias Currency =
  { high: Float
  , low: Float
  , vol: Float
  , last: Float
  , exchange: String
  }

currenciesDecoder : Decoder (List Currency)
currenciesDecoder =
      at [ "ticker_24h", "exchanges" ]
        ( itemDecoder
           |> keyValuePairs
           |> Json.Decode.map (\a -> List.map transformToCurrencyList  a ) )

transformToCurrencyList : (String, Currency) -> Currency
transformToCurrencyList (key, currency) =
  {currency | exchange = getFullExchangeName key}

getFullExchangeName : String -> String
getFullExchangeName abbr =
  case abbr of
    "NEG" -> "NegocieCoins"
    "MBT" -> "MercadoBitcoin"
    "FOX" -> "FoxBit"
    "B2U" -> "BitcoinToYou"
    "ARN" -> "Arena Bitcoin"
    _ -> abbr

itemDecoder : Decoder Currency
itemDecoder =
  decode Currency
    |> required "high" float
    |> required "low" float
    |> required "vol" float
    |> required "last" float
    |> hardcoded ""
