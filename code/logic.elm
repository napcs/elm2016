module Logic where

import String
compoundInterest: Float -> Float -> Float -> Float -> Float
compoundInterest principle rate periods years =
  (principle * (1 + (rate / periods ) ) ^ (years * periods) )


convertToFloat: String -> Float
convertToFloat string =
  case String.toFloat string of
    Ok n -> n
    Err _ -> 0.0
