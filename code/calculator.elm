import Html exposing (Html, text, h1, p, div, button)
import StartApp.Simple as StartApp
import Html.Events exposing (onClick)

main =
  StartApp.start {model = "Hello ", view = view, update = update}

view address initialText =
  div [] [
    h1 [] [text "Calculator"],
    p [] [ text initialText ],
    button [onClick address "change"] [text "Push me"]
  ]

update action model =
  "it changed"
