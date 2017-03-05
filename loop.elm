module Loop 
    exposing 
        ( while
        , until
        )


{-| 

@docs while, until 

-}

{-| -}
while : (a -> Bool) -> a -> (a -> a) -> a
while condition state f =
    if condition state then
        while condition (f state) f
    else 
        state

{-| -}
until : (a -> Bool) -> a -> (a -> a) -> a
until condition state f =
    if condition state then
        state
    else 
        until condition (f state) f