module Data.Currency exposing (..)

type alias Currency =
  { high: Float
  , low: Float
  , vol: Float
  , last: Float
  , exchange: String 
  }
