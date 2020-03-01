# Type aliases

Type aliases are a way of creating a new name for an existing type. This is
useful when the name of the type may be long and awkward to type repeatedly.

Here we are giving the type `List(tuple(String, String))` the new name
`Headers`. This may be useful in a web application where we want to write
multiple functions that return headers.

```rust,noplaypen
pub type Headers =
  List(tuple(String, String))
```


## Commonly used type aliases

### `Option(value)`

The `gleam/result` module in the standard library defines `Option(value)` as
an alias for `Result(value, Nil)`.

This alias is useful for when you wish to return a value that may or may not
be present. This is a type safe alterntaive to a value that may be `null` in
other languages.

```rust,noplaypen
import gleam/result.{Option}

pub fn present() -> Option(Int) {
  Ok(1) // This Int is present
}

fn not_present() -> Option(Int) {
  Error(Nil) // This Int is not present
}

fn also_not_present() -> Option(Int) {
  result.none() // Error(Nil) can also be written like this
}
```
