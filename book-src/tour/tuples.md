# Tuples

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

## Type

Because tuples have a variable number of parameters the tuple type has a dedicated syntax rather than a regular type constructor, like for instance `List` has.
For example while the type for `["Joe", "says", "hello"]` is `List(String, String, String)` the type of `#("Joe", "says, "hello")` is **not** `Tuple(String, String, String)` but rather `#(String, String, String)`.

## Accessor

Once you have a tuple the values contained can be accessed using the `.0`
accessor syntax.

```gleam
let my_tuple = #("one", "two")
let first = my_tuple.0  // "one"
let second = my_tuple.1 // "two"
```
