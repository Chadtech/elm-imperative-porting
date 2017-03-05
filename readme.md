# Elm Loop

This is just an elm lang implementation of the while loop, typical to many C syntax languages. It exposes `while` and `until`.

```javascript
var index = 0;
while (index < 100) {
  index++;
}
```

..can be expressed in Elm as..

```elm
Loop.while ((>) 100) 0 ((+) 1)
```

Check out the find primes example in the examples folder to see a realistic application of this package.

# THINK TWICE BEFORE USING THIS PACKAGE.

You probably dont need this package. You should be mapping and folding most of the time. Make sure you really need a while loop before using this package. If you need to transform all the values in a list, use a map. If you need to collapse all the values in a list, use a fold. Even my find primes example could be accomplished with `List.range` and `List.filter`. Basically, if you need to iterate, and the number of iterations is known in advance, or calculated in a straight forward manner, then you dont need a while loop.