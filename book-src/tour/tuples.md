# Tuple

Lists are good for when we want a collection of one type, but sometimes we want
to combine multiple values of different types. In this case tuples are a quick
and convenient option.

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
