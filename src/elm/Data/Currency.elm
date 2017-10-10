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
  , link: String
  }

currenciesDecoder : Decoder (List Currency)
currenciesDecoder =
      at [ "ticker_12h", "exchanges" ]
        ( itemDecoder
           |> keyValuePairs
           |> Json.Decode.map (\a -> List.map transformToCurrencyList  a ) )

transformToCurrencyList : (String, Currency) -> Currency
transformToCurrencyList (key, currency) =
  {currency | exchange = getFullExchangeName key, link = getExchangeLink key}

getFullExchangeName : String -> String
getFullExchangeName abbr =
  case abbr of
    "NEG" -> "NegocieCoins"
    "MBT" -> "MercadoBitcoin"
    "FOX" -> "FoxBit"
    "B2U" -> "BitcoinToYou"
    "ARN" -> "Arena Bitcoin"
    "LOC" -> "LocalBitcoins"
    _ -> abbr

getExchangeLink : String -> String
getExchangeLink abbr =
  case abbr of
    "NEG" -> "https://www.negociecoins.com.br"
    "MBT" -> "https://www.mercadobitcoin.com.br"
    "FOX" -> "https://foxbit.exchange"
    "B2U" -> "https://www.bitcointoyou.com"
    "ARN" -> "https://www.arenabitcoin.com.br"
    "LOC" -> "https://localbitcoins.com/"
    _ -> "#"

itemDecoder : Decoder Currency
itemDecoder =
  decode Currency
    |> required "high" float
    |> required "low" float
    |> required "vol" float
    |> required "last" float
    |> hardcoded ""
    |> hardcoded ""
