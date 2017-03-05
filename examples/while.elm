module While exposing (..)

import Html
import Loop


main =
    Html.text <|
        Loop.while
            (String.length >> (>) 9000)
            "▲ "
            (String.repeat 3)
