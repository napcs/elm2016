import Html exposing(Html, div, text, p, em)

main =
  div [] [
    view "Hello",
    view "Goodbye"
  ]

view: String -> Html
view word =
  div [] [
    p [] [
      text (word ++ " "),
      em [] [text "world"]
    ]
  ]
