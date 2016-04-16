import Html exposing(Html, input, label, div, text)
import Html.Attributes exposing(id, for, type')


fieldWithLabel: String -> String -> String -> Html
fieldWithLabel fieldID fieldName fieldType =
  div [] [
    label [for fieldID] [text fieldName],
    input [ id fieldID, type' fieldType] []
  ]

numberField: String -> String -> Html
numberField fieldID fieldName =
  fieldWithLabel fieldID fieldName "number"

textField: String -> String -> Html
textField fieldID fieldName =
  fieldWithLabel fieldID fieldName "text"

emailField: String -> String -> Html
emailField fieldID fieldName =
  fieldWithLabel fieldID fieldName "email"

main: Html
main =
  div [] [
    textField "name" "Name",
    numberField "age" "Age",
    emailField "email" "Email"
  ]

