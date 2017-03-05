module Loop 
    exposing 
        ( while
        , until
        )


{-| Just some loop functions.

@docs while, until 

-}

{-| The classic while loop. So classic. 


    Loop.while ((>) 100) 0 ((+) 1)

    -- is basically analagous to..
    --
    -- var i = 0;
    -- while ( i < 100) {
    --   i++;
    -- }

    ponder : String -> String
    ponder this =
        Loop.while 
            (always False)
            this
            identity

-}
while : (a -> Bool) -> a -> (a -> a) -> a
while condition state f =
    if condition state then
        while condition (f state) f
    else 
        state

{-| A twist on the classic while loop. It loops until the condition is NOT met.


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