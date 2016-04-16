
import Graphics.Element exposing (show)

main =
  show [
    hello,
    toString (square 2),
    toString (add 1 2)
  ]




hello: String
hello =
  "Hello there"


square: Float -> Float
square number =
  number * number

add: Float -> Float -> Float
add number1 number2 =
  number1 + number2

