# Rethinking Front End Development With Elm

This year I released a book called *Exercises For Programmers*, which is a collection of programming practice problems aimed at beginning coders. However, the problems in the book 

## What's Elm?

Elm is a functional programming language designed to make web programming simpler and more fun. It follows in the footsteps of languages like Haskell, but it's more friendly. Elm's developers have put tons of effort into creating error messages that help dig you out of trouble, rather than just giving you a stack trace.

Elm comes out of the box with tools for managing projects, managing dependencies, a package management system, and a REPL for playing around.

* Elm website: <http://elm-lang.org/>
* Try Elm <http://elm-lang.org/try>
* Package system: <http://package.elm-lang.org/>
* Documentation <http://elm-lang.org/docs>

## Setting Up an Elm project


1. Install Elm
   
   ```
   $ npm install elm
   ```


2. Create folder for project
    
    ```
    $ mkdir calculator && cd calculator
    ```
    
3. Initialize the project
    
    ```
    $ elm package install
    ```
    
4. Install support for HTML
    
    ```
    $ elm package install evancz/elm-html
    ```

5. Install elm-live
    
    ```
    $ npm install --g elm-live
    ```

The last one's just there so you can live-reload your work.


## Elm and User Interfaces

Elm is a language that compiles to JavaScript and runs in your web browser. Unlike traditional web apps, you use Elm to build all of the user interface as well as the logic. If you're familiar with HTML, you may find this terrifying. But it's not. React developers, for example, already do a lot of this with JSX. It's becoming the norm.

Let's explore this with some code:

Initial skeleton

```
import Html exposing (text, p)

main = 
  p [] [text "Hello World"]
```

Elm automatically calls a `main` function for us, so we need to define it. And in that `main` function, we do our program's output.

`p` is a function that Elm provides which creates a paragraph. It takes two arguments. The first is a list of attributes. The second is a list of child elements. The `text` keyword is also a function which creates a text node.  

So we've just written a paragraph of HTML by using two functions. And that may seem like a ton of overkill. Why not just use HTML? Well, we'll get to that.

Now, if we wanted to add a heading above the paragraph, we have to wrap them in a `div`. We can't return a list of elements - we have to return just one element. This is similar to how React works.

So first, we add `div` and `h1` to our elements list:

~~~
import Html exposing (text, p, div, h1)
~~~

Then we add a `div`, and then we create `h1` and `p` inside of the second argument.

~~~
main = 
  div [] [
    h1 [] [text "Calculator"],
    p [] [text "Hello World"]
  ]

~~~

Alright, that's cool. Let's add a little more:

~~~
import Html exposing (text, p, em, div)


main = 
  div [] [
    h1 [] [text "Calculator"],
    p [] [
      text "Hello ", 
      em [] [text "world"]
    ]
  ]

~~~


These functions create HTML elements. And to put elements inside of other elements, we nest them. What we're really doing is passing a list of elements to a parent element. Either HTML elements or text elements.

But really, doing a lot of stuff in `main` is a bad idea. Let's instead break out our HTML into its own function, called `view`:


~~~
import Html exposing (Html, text, p, em, div)


main = 
  view
  
view = 
  div [] [
    h1 [] [text "Calculator"],
    p [] [
      text "Hello ", 
      em [] [text "world"]
    ]
  ]

~~~

So, `main` calls `view`, and `view` returns the elements that get rendered. 

Of course, this `view` is a function. So we can pass arguments:

```
import Html exposing (Html, text, p, em, div)


main = 
  view "Hello"
  
view initialText = 
  div [] [
    h1 [] [text "Calculator"],
    p [] [
      text (initialText ++ " "),
      em [] [text "world"]
    ]
  ]

```

We can reuse this function again and again. The `main` function has to return an HTML parent node, so we'll add a `div`, and within it call the view twice:


```
main = 
  div [] [
    view "Hello", 
    view "Goodbye"
  ]
  
```

And now we see two messages. We can use Elm to easily build components.


Elm makes it pretty simple to build up composable interfaces. Elm has a `model`-`view`-`update` architecture... we create a model that represents our data, we have a view that renders that model, and we re-render the view whenever we update the model.  

## StartApp

Let's add another module in, called StartApp Simple.  This is the easiest way to implement Elm's "model-view-update" architecture.

Before we add this we have to include it.

```
    $ elm package install evancz/start-app
```

~~~
import Html exposing (Html, text, p, em, div)
import StartApp.Simple as StartApp

main = 
  StartApp.start {model = "Hello ", view = view, update = update}
  
view address initialText = 
  div [] [
    h1 [] [text "Calculator"],
    p [] [
      text initialText, 
      em [] [text "world"]
    ]
  ]
  
update action model =
  "it changed"
 
~~~

The `update` function returns a new representation of the model. So initially, our "model" isn't anything more than a string. But the `update` function changes the model to a different string. 

Of course it won't work until we create an element someone can click on.

First add `button` to the list of HTML elements:

```
import Html exposing (text, p, em, div, button)
```	


Next, add the `Html.Events` module, and add the `onClick` event:

~~~
import Html.Events exposing (onClick)
~~~

Unless we include everything, which is bad, or include what we specifically need, we won't have anything available.


So then add the new button to the view:

~~~
view address initialText = 
  div [] [
    h1 [] [text "Calculator"],
    p [] [
      text initialText, 
      em [] [text "world"]
    ],
    button [onClick address "change"] [text "Push me"]
  ]
~~~

The `onClick` function requires us to send an address and a message. The message, right now, doesn't matter. But the address is a reference to the part of the app that's gonna change, so that StartApp knows where to return to.

When I press the button, it changes the text. How? Well, in StartApp, any events fire the `update` function. The `update` function then ret


## Annotations

Let's make our application easier to maintain. Elm apps are statically typed, and we can add annotations to our functions to make the typing more clear.

Let's add `address` to our project:

~~~
import Signal exposing (Address)
~~~

Annotate view

~~~
view : Signal.Address String -> String -> Html
view address model = 
~~~

This says that the `view` function accepts a `Signal.Address` with a `String` type, followed by another `String` type, and the function returns `Html`. The last element in this chain is the return type. So think of it as a pipeline of data. This comes in, and this comes out.

The `update` can have an annotation too:

```
update: String -> String -> String
```

It takes a string, followed by another string, and returns a string. This is going to get a lot more complicated in a second though.

Let's make a more realistic app. Let's make a simple compound interest calculator. All of this logic can be done client-side, and will let us explore the Elm architecture in depth.


## Add form fields with attributes

~~~
import Html exposing (Html, text, div, p, button, form, input, label)
import Html.Attributes exposing (for, id, type', value, step)
~~~

Create a function for the form.

~~~
calculatorForm = 
  div [] [
    div [] [
      label [for "principle"] [text "Principle"],
      input [id "principle", type' "number", step "any"] []
    ]
~~~

Then test it out. Add the function call

~~~
view address model = 
  div [] [
    p [] [text "Compound Interest Calculator"],
    calculatorForm,
    button [onClick address "button" ] [text "Calculate"]  
  ]
~~~

Now add the rest of the fields. But that'd be redundant. So let's make a `numberField` function.

```
numberField: String -> String -> Html
numberField fieldID name =
  div [] [
    label [for fieldID ] [text name ],
    input [id fieldID, type' "number", step "any"] []
  ]

```

That'll save us some time. Now change the `calculateForm` function:

```
calculatorForm: Html
calculatorForm =
  div [] [
    numberField "principle" "Principle",
    numberField "rate" "Rate",
    numberField "years" "Years",
    numberField "periods" "Periods"
  ]

```


See how we're composing our view from little components?


## Define a model

~~~
type alias Model = 
  {
    principle: String,
    rate: String,
    years: String,
    periods: String
  }
~~~

Make the model:

~~~
model : Model
model = 
  {
    principle = "1500.00",
    rate = "4.3",
    years = "6",
    periods = "4"
  }
~~~

Change the view:

~~~
view : Address String -> Model -> Html
view address model = 
  div [] [
    calculatorForm,
    button [onClick address "button" ] [text "Calculate"]  
  ]
~~~

Make the update return the model

~~~
update: String -> Model -> Model
update action model =
  model
~~~

## Make values show up on form


Pass model to the calculator

~~~
view : Address String -> Model -> Html
view address model = 
  div [] [
    p [] [text "Compound Interest Calculator"],
    calculatorForm model,
    button [onClick address "button" ] [text "Calculate"]  
  ]
~~~


Modify calculator form so it pulls in the values. Add the `value` attribute:

```
import Html.Attributes exposing (for, id, type', value)
```

Then pluck the value from the model into each field. First, pass it along to the `numberField` function:

~~~
calculatorForm: Model -> Html
calculatorForm model =
  div [] [
    numberField "principle" "Principle" model.principle,
    numberField "rate" "Rate" model.rate,
    numberField "years" "Years" model.years,
    numberField "periods" "Periods" model.periods
  ]
~~~

Then update the `numberField` function:

```
numberField: String -> String -> String -> Html
numberField fieldID name initialValue =
  div [] [
    label [for fieldID ] [text name ],
    input [id fieldID, type' "number", step "any", value initialValue] []
  ]

```

And the fields show up on the page.

## Make pretty

Import the `Attribute` from `Html`.

```
import Html exposing (Html, Attribute, text, p, em, div, button, form, label, input)
```

Then import the `style` attribute.

```
import Html.Attributes exposing (for, id, type', value, step, style)
```

Make a function that creates a style. It should return a new Attribute. This way we can design custom attributes to control things.

```
labelStyle: Attribute
labelStyle =
  style
    [ ("width", "200px")
    , ("padding", "10px")
    , ("text-align", "right")
    , ("display", "inline-block")
    ]
```

Then apply this to the numberField:

```
label [labelStyle, for "principle"] [text "Principle"],

```

Boom! Looks better. Of course, we can modify this:


```
labelStyle: String -> Attribute
labelStyle width =
  style
    [ ("width", width)
    , ("padding", "10px")
    , ("text-align", "right")
    , ("display", "inline-block")
    ]

```

And pass the value!

```
label [labelStyle "200px", for "principle"] [text "Principle"],
```


## Make form update model

We've got a pretty good interface going. But now we should add the behavior to it. Here's what we're going to do - every time we change a value, we'll need to update the state of the model that represents the data behind the form. 



Define an Action

~~~
type Action
  = NoOp 
  | SetPrinciple String
  | SetPeriods String
  | SetYears String
  | SetRate String
  | Calculate
~~~

Change the type annotation

~~~
view : Address Action -> Model -> Html
~~~

Change calculatorForm call to take the address in.

~~~
view address model = 
  div [] [
    calculatorForm address model,
    button [onClick address Calculate ] [text "Calculate"]  
  ]
~~~

Change the calculatorForm to take the action

~~~
calculatorForm: Address Action -> Model -> Html
calculatorForm address model = 

~~~


Change the input to send the data. First add the `on` and `targetValue` things.

~~~
import Html.Events exposing (onClick, on, targetValue)
~~~

Then change the `calculatorForm` so it passes the address to our Update as well as the action that should be called:

```
calculatorForm: Signal.Address Action -> Model -> Html
calculatorForm address model =
  div [] [
    numberField address SetPrinciple "principle" "Principle" model.principle,
    numberField address SetRate "rate" "Rate" model.rate,
    numberField address SetPeriods "periods" "Periods" model.periods,
    numberField address SetYears "years" "Years" model.years
  ]
```

and  change the `numberField` so it receives the address to our Update function as well as the action itself.

~~~
numberField: Signal.Address Action -> (String -> Action) -> String -> String -> String -> Html
~~~


Then use those new options to handle the input events:

~~~
numberField address action fieldID name fieldValue =
  div [] [
    label [labelStyle, for fieldID] [text name],
    input [id fieldID, type' "number", step "any",
        on "input" targetValue (Signal.message address << action ),
        value fieldValue] []
  ]
~~~

And modify the rest to do the same.


Finally, change the update function.


~~~
update: Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
      
    SetPrinciple p ->
      {model | principle = p}
      
    SetRate r ->
      {model | rate = r}
      
    SetYears y -> 
      {model | years = y}
      
    SetPeriods p ->
      {model | periods = p}
    
    Calculate ->
      model 
~~~


## Write the calculation

Ok, time to make this actually calculate!

First, let's modify the model. We need to store the result in the model.

~~~
type alias Model = 
  {
    principle: String,
    rate: String,
    years: String,
    periods: String,
    newAmount: Float
  }
~~~

Then, to make it match, we must add a default value for this new amount:

~~~
model : Model
model = 
  {
    principle = "1500.0",
    rate = "4.3",
    years = "6",
    periods = "4",
    newAmount = 0.0
  }

~~~

Now let's make the view changes we need. We'll need some spans.

~~~
import Html exposing (Html, text, div, p, button, input, label, span)
~~~

Now we define an `outputArea` function that sets up the output:

~~~
outputArea: Model -> Html
outputArea model =
  p [] [
    span [] [text "Amount: "],
    span [] [text (toString model.newAmount) ]
  ]
~~~

And we change the `view` method to use this new `outputArea` function:

~~~
view address model = 
  div [] [
    calculatorForm address model,
    button [onClick address Calculate ] [text "Calculate"],
    outputArea model
  ]
~~~
The data going to the model is strings. So we must convert these values to numbers. Let's make
a quick helper function to do that.

We'll need the `String.toFloat` function, which we get by importing `String`:

```
import String
```

Then we create the helper:

~~~
convertToFloat: String -> Float
convertToFloat string =
  case String.toFloat string of
    Ok n -> n
    Err _ -> 0.0
~~~  

Now we make a function that does the compound interest formula. It'll take in all four values, as floats, and return the result as a float:

~~~
compoundInterest: Float -> Float -> Float -> Float -> Float
compoundInterest principle rate periods years = 
  (principle * (1 + (rate / periods ) ) ^ (years * periods) )
~~~


Finally,  we can create the code that does the work and updates the model. It'll
read all the values from the model and convert them to floats, then call ourfunction to compute the new amount.


~~~
calculateNewAmount: Model -> Model      
calculateNewAmount model = 
  let
    rate = convertToFloat model.rate / 100
    years = convertToFloat model.years
    principle = convertToFloat model.principle
    periods = convertToFloat model.periods
  in
    {model | newAmount = (compoundInterest principle rate periods years) }
    
~~~

So then we can call this in our update function:

~~~
    Calculate ->
      calculateNewAmount model   
~~~


## Formatting Currency

~~~
formatCurrency: Float -> String
formatCurrency value =
  let result = 
    value * 100
    |> round
    |> Basics.toFloat
  in
    "$" ++ toString (result / 100.0)
~~~

Modify the output to call this formatting function instead:

~~~
outputArea: Model -> Html
outputArea model =
  p [] [
    span [] [text "Amount: "],
    span [] [text (formatCurrency model.newAmount) ]
  ]
~~~

## Elm downsides


