# Elm Imperative Porting

This package is for porting code from imperative languages like C++ into Elm. Its a pretty obscure use case, so dont feel any rush to use it.

How exactly does this help porting imperative code? Imperative code and ML Syntax code are pretty different. Even if you figure out how imperative code works, you cant really copy and paste it. But even that is a best case scenario, because a lot of times high performance C code is pretty much human un-readable. I get the impression that C developers are able to squeeze every bit of performance out of their code by relying on clever math and tricky programming. 

This package makes it a little bit easier to port imperative code by trying to match the syntax of imperative languages. For example, imperative code might use a while loop and theres no such thing as a while loop in functional programming. You'll need to figure out how to do that in Elm eventually, whether it be through mapping, folding, or recursion, but in the meantime you can reduce your mental overhead by just using the function in this module called `while`.


```javascript
var index = 0;
while (index < 100) {
  index++;
}
```

..can be expressed using this package as as..

```elm
Imperative.while ((>) 100) 0 ((+) 1)
```

# Think twice before using this package.

You probably dont need this package. I made it mostly for fun. You should be mapping, folding, and using recursion most of the time. If you need to transform all the values in a list, use a map. If you need to collapse all the values in a list, use a fold. Below is an example of how to use recursion well.

```elm
-- Recusrion examples
firstValue : List (Maybe a) -> Maybe a
firstValue maybes =
    case maybes of
        Just value :: _ ->
            Just value

        Nothing :: rest ->
            firstValue rest

        [] ->
            Nothing


insertAt : Int -> a -> List a -> List a
insertAt index value list =
    if index == 0 then
        value :: list

    else
        case list of
            _ :: rest ->

                insertAt (index - 1) value rest

            [] ->
                []

```
