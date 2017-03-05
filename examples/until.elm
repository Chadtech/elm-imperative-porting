module Until exposing (..)

import Html
import Loop


main =
    Loop.until ((==) 1776) 0 ((+) 1)
        |> toString
        |> Html.text
