module Data.MercadoBitcoin exposing (..)
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
import Data.Currency exposing (Currency)
import List

mercadoBitcoinDecoder : Decoder (List Currency)
mercadoBitcoinDecoder =
      at [ "ticker_1h", "exchanges" ]
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
    _ -> abbr

itemDecoder : Decoder Currency
itemDecoder =
  decode Currency
    |> required "high" float
    |> required "low" float
    |> required "vol" float
    |> required "last" float
    |> hardcoded ""


-- currencyDecoder =
--   Decoder.object1 toString ("last" := string)


-- currencyDecoder : Decoder Currency
-- currencyDecoder =
--   ((decode Currency
--     |> required "high" string
--     |> required "low" string
--     |> required "vol" string
--     |> required "last" string
--     |> hardcoded "MercadoBitcoin")
--     |> keyValuePairs
--     |> Dict.values)
