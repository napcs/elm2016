import Html exposing (Html, text, h1, p, div, button, label, input)
import Html.Attributes exposing ( style, for, id, step, type', value)
import StartApp.Simple as StartApp
import Html.Events exposing (onClick)


main =
  StartApp.start {model = model, view = view, update = update}

-- model

model: Float
model = 0


-- view

view: Signal.Address String -> Float -> Html
view address model =
  div [] [
    h1 [] [text "Calculator"],
    div [] [
      numberField "principal" "Principal",
      numberField "rate" "Rate",
      numberField "years" "Periods",
      numberField "years" "Years"
    ],
    button [onClick address "calculate"] [text "Calculate"]
  ]


-- update

update: String -> Float -> Float
update action model =
  model


-- helpers

numberField: String -> String -> Html
numberField fieldID fieldName =
  div [] [
    label [for fieldID] [text fieldName],
    input [ id fieldID, type' "number", step "any"] []
  ]
