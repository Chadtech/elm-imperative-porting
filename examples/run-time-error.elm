module While exposing (..)

import Html
import Loop


main =
    Loop.while
        (always True)
        (Html.text "(x) fx . v . ~fx")
        identity
