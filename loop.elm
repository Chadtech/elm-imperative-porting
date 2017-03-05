module Loop
    exposing
        ( while
        , until
        )

{-| Loop functions, just like the ones in C syntax programming languages.

@docs while, until

-}


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
