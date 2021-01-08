# Tuple

Lists are good for when we want a collection of one type, but sometime we want
to combine multiple values of different types. In this case tuples are a quick
and convenient option.

```gleam
fn run() {
  tuple(10, "hello") // Type is tuple(Int, String)
  tuple(1, 4.2, [0]) // Type is tuple(Int, Float, List(Int))
}
```
