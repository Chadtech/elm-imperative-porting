module FindPrimes exposing (..)

import Html
import Loop


main =
    allPrimesUnder 9000
        |> List.map (toString >> (++) " ")
        |> List.foldr (++) ""
        |> Html.text


allPrimesUnder : Int -> List Int
allPrimesUnder amount =
    Loop.until (Tuple.second >> (==) amount) ( [], 2 ) nextNumber
        |> Tuple.first


nextNumber : ( List Int, Int ) -> ( List Int, Int )
nextNumber ( primes, int ) =
    ( addIfPrime primes int, int + 1 )


addIfPrime : List Int -> Int -> List Int
addIfPrime primes int =
    if isPrime int then
        int :: primes
    else
        primes


isPrime : Int -> Bool
isPrime int =
    Loop.while isFactorAndPositive ( int, int - 1 ) nextFactor
        |> Tuple.second
        |> (==) 1


nextFactor : ( Int, Int ) -> ( Int, Int )
nextFactor ( i, j ) =
    ( i, j - 1 )


isFactorAndPositive : ( Int, Int ) -> Bool
isFactorAndPositive ( i, j ) =
    i % j /= 0 && (j > 1)
