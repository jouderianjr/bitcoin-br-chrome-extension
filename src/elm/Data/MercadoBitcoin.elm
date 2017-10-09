module Data.MercadoBitcoin exposing (..)
import Json.Decode exposing (
  Decoder,
  string,
  succeed,
  field,
  at,
  list,
  keyValuePairs,
  dict, map, float)
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Data.Currency exposing (Currency)
import List exposing (..)
import Dict exposing (..)

mercadoBitcoinDecoder : Decoder (List (String, Currency))
mercadoBitcoinDecoder =
    at [ "ticker_24h", "exchanges" ]
      ((decode Currency
        |> required "high" float
        |> required "low" float
        |> required "vol" float
        |> required "last" float
        |> hardcoded "MercadoBitcoin")
        |> keyValuePairs
        |> Json.Decode.map (\(a,b) -> b ))
        -- |> Json.Decode.map (\a -> List.map -> (\c, d -> ))
        -- |> Json.Decode.map (\a -> List.map (\(t1, t2) -> t2 t1) a)


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



