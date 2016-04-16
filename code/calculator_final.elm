module Calculator where
import Html exposing(Html, Attribute, button, div, h1, p, em, text, label, input, span)
import Html.Attributes exposing(for, id, type', value, step, style)
import StartApp.Simple as StartApp
import Html.Events exposing(onClick, on, targetValue)
import Signal exposing (Address)
import String


type Action
  = NoOp
    | SetPrinciple String
    | SetPeriods String
    | SetRate String
    | SetYears String
    | Calculate

type alias Model =
  { principle: String
  , rate: String
  , years: String
  , periods: String
  , newAmount: Float}



main =
  StartApp.start { model = model , view = view , update = update }


model: Model
model =
  { principle = "1500.00"
  , rate = "4.3"
  , years = "6"
  , periods = "4"
  , newAmount = 0 }


view: Signal.Address Action -> Model -> Html
view address model =
  div [] [
    h1 [] [text "Calculator"],
    div [] [
      numberField address SetPrinciple "principle" "Principle" model.principle,
      numberField address SetRate "rate" "Rate" model.rate,
      numberField address SetPeriods "periods" "Periods" model.periods,
      numberField address SetYears "years" "Years" model.years
    ],
    button [onClick address Calculate] [text "Click me"],
    output model

  ]

output: Model -> Html
output model =
  div [] [
    span [] [text "Amount: "],
    span [] [text (toString model.newAmount) ]
  ]


numberField: Signal.Address Action -> (String -> Action) -> String -> String -> String -> Html
numberField address action fieldID name fieldValue =
  div [] [
    label [labelStyle, for fieldID] [text name],
    input [id fieldID, type' "number", step "any",
        on "input" targetValue (Signal.message address << action ),
        value fieldValue] []
  ]




update: Action -> Model -> Model
update action model =
  case action of
    NoOp -> model

    SetPrinciple p -> {model | principle = p}

    SetRate r -> {model | rate = r}

    SetYears y -> {model | years = y}

    SetPeriods p -> {model | periods = p}

    Calculate -> calculateNewAmount model


labelStyle: Attribute
labelStyle =
  style
    [ ("width", "200px")
    , ("padding", "10px")
    , ("text-align", "right")
    , ("display", "inline-block")
    ]

calculateNewAmount: Model -> Model
calculateNewAmount model =
  let
    rate = convertToFloat model.rate / 100
    years = convertToFloat model.years
    principle = convertToFloat model.principle
    periods = convertToFloat model.periods
  in
    {model | newAmount = (compoundInterest principle rate periods years) }



compoundInterest: Float -> Float -> Float -> Float -> Float
compoundInterest principle rate periods years =
  (principle * (1 + (rate / periods ) ) ^ (years * periods) )


convertToFloat: String -> Float
convertToFloat string =
  case String.toFloat string of
    Ok n -> n
    Err _ -> 0.0
