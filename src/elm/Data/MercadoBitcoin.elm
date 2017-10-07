module Data.MercadoBitcoin exposing (..)
import Json.Decode exposing (Decoder, string, succeed, field)
import Json.Decode.Extra exposing ((|:))

type alias MercadoBitcoinCurrency =
  { high: String
  }

dataDecoder : Decoder MercadoBitcoinCurrency
dataDecoder =
    field "ticker" mercadoBitcoinDecoder

mercadoBitcoinDecoder : Decoder MercadoBitcoinCurrency
mercadoBitcoinDecoder =
  succeed
    MercadoBitcoinCurrency
      |: (field "high" string)

