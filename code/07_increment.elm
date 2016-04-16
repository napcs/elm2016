import StartApp.Simple as StartApp
import Html exposing(Html, button, div, text, span)
import Signal exposing (Address)
import Html.Events exposing(onClick)

type Action = Increment | Decrement

main =
  StartApp.start { model = model, view = view, update = update }

model = 0

view: Signal.Address Action -> Int -> Html
view address model =
  div []
    [ button [ onClick address Increment ] [ text "Up" ]
    , span [] [ text (toString model) ]
    , button [ onClick address Decrement ] [ text "Down" ]
    ]

update: Action -> Int -> Int
update action model =
  case action of
    Increment -> model + 1
    Decrement -> model - 1
