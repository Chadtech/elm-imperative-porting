module Imperative exposing
    ( while, until, doWhile
    , Termination(..), explicitLoop
    , function
    )

{-| Functions that resemble imperative syntax

@docs while, until, doWhile

@docs Termination, explicitLoop

-}


{-| Just like C-syntax switch statements. Why use this instead of an Elm case statement? Because they arent the same. Theres a gotcha to switch statements, which is that once is switches, it keeps going through every case until the code explicitly breaks or returns. A switch statement
with 10 cases doesnt exactly fork to 10 paths, rather, it has two paths and 10 points on which the main path can switch onto the fork path.

    -- switch statements are..
    --
    --     A
    --     |
    --     |
    --     |\
    --     |  \
    --     |    \
    --     |\    | case 0
    --     |  \  |
    --     |    \|
    --     |\    | case 1
    --     |  \  |
    --     |    \|
    --     |     | case 2
    --     |     |
    --     v     v
    --
    --     A     B
    --
    --
    -- switch statements are NOT..
    --
    --     A
    --     |
    --     |
    --     |-----> case 0
    --     |
    --     |
    --     |-----> case 1
    --     |
    --     |
    --     |-----> case 2
    --     |
    --     |
    --     A



-}
switch : List ( case_, a -> Termination a b ) -> ( case_, a ) -> Maybe b
switch cases initial =
    switchHelper False cases initial


switchHelper : Bool -> List ( case_, a -> Termination a b ) -> ( case_, a ) -> Maybe b
switchHelper hitPreviousCase cases ( caseOn, value ) =
    case cases of
        ( thisCase, f ) :: rest ->
            if hitPreviousCase || caseOn == thisCase then
                case f value of
                    Break result ->
                        Just result

                    Continue newValue ->
                        switchHelper True rest ( caseOn, newValue )

            else
                switchHelper False rest ( caseOn, value )

        [] ->
            Nothing


{-| A way that a loop can end
-}
type Termination a b
    = Break b
    | Continue a


{-| A loop in imperative code might have break and continue cases that are clearly marketed out with words like `break;` and `return ...;`. With this `explicitLoop` function you can map the break points in imperative code directly to `Break` and `Continue` points in a function.

    clipSegment x0 y0 x1 y1 c0 c1 ({ xmax, xmin, ymax, ymin } as viewport) =
        Imperative.explicitLoop
            (\{ x0, y0, x1, y1, c0, c1 } ->
                if c0 == 0 && c1 == 0 then
                    Imperative.Break <| Just ( x0, y0, x1, y1 )

                else if Bitwise.and c0 c1 /= 0 then
                    Imperative.Break Nothing

                else
                    let
                        c =
                            if c0 == 0 then
                                c1

                            else
                                c0

                        ( x, y ) =
                            if Bitwise.and c 8 /= 0 then
                                ( x0 + (x1 - x0) * (ymax - y0) / (y1 - y0), ymax )

                            else if Bitwise.and c 4 /= 0 then
                                ( x0 + (x1 - x0) * (ymin - y0) / (y1 - y0), ymin )

                            else if Bitwise.and c 2 /= 0 then
                                ( xmax, y0 + (y1 - y0) * (xmax - x0) / (x1 - x0) )

                            else
                                ( xmin, y0 + (y1 - y0) * (xmin - x0) / (x1 - x0) )
                    in
                    if c0 /= 0 then
                        Imperative.Continue { x0 = x, y0 = y, x1 = x1, y1 = y1, c0 = regionCode x y viewport, c1 = c1 }

                    else
                        Imperative.Continue { x0 = x0, y0 = y0, x1 = x, y1 = y, c1 = regionCode x y viewport, c0 = c0 }
            )
            { x0 = x0, y0 = y0, x1 = x1, y1 = y1, c1 = c1, c0 = c0 }

-}
explicitLoop : (a -> Termination a b) -> a -> b
explicitLoop fn initial =
    case fn initial of
        Break result ->
            result

        Continue intermediate ->
            explicitLoop fn intermediate


{-| Much like `while`, however this function applies its `a -> a` before it continues, ensuring that `f` is applied to the output at least once.

    while ((>) 0) 0 ((+) 1) == 0

    doWhile ((>) 0) 0 ((+) 1) == 1

-}
doWhile : (a -> Bool) -> a -> (a -> a) -> a
doWhile condition initial f =
    let
        state =
            f initial
    in
    if condition state then
        doWhile condition state f

    else
        state


{-| The classic while loop.


    count : Int
    count =
        Loop.while ((>) 100) 0 ((+) 1)


    -- is basically analagous to..
    --
    -- var i = 0;
    -- while ( i < 100) {
    --   i++;
    -- }

-}
while : (a -> Bool) -> a -> (a -> a) -> a
while condition state f =
    if condition state then
        while condition (f state) f

    else
        state


{-| A twist on the classic while loop. It loops while the condition is NOT met.

    countJustForFun : Int -> Int
    countJustForFun to =
        Loop.until
            ((==) to)
            0
            ((+) 1)

-}
until : (a -> Bool) -> a -> (a -> a) -> a
until condition state f =
    if condition state then
        state

    else
        until condition (f state) f
