import Html exposing(Html, div, text, p, em)

main =
  view

view =
  div [] [
    p [] [
      text "Hello ",
      em [] [text "world"]
    ]
  ]
