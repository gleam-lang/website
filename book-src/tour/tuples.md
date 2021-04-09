# Tuple

Lists are good for when we want a collection of one type, but sometimes we want
to combine multiple values of different types. In this case tuples are a quick
and convenient option.

Gleam provides two ways to construct or match on tuples: the `#(1, 2, 3)` format,
introduced in Gleam 0.15.0, and the original `tuple(1, 2, 3)` format which will
be removed in a future version of Gleam.

```gleam
#(10, "hello") // Type is #(Int, String)
#(1, 4.2, [0]) // Type is #(Int, Float, List(Int))
```

Once you have a tuple the values contained can be accessed using the `.0`
accessor syntax.

```gleam
let my_tuple = #("one", "two")
let first = my_tuple.0   // "one"
let seccond = my_tuple.1 // "two"
```
