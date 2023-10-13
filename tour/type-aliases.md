{% include linkedHeading.html heading="Type aliases" level=1 %}

Type aliases are a way of creating a new name for an existing type. This is
useful when the name of the type may be long and awkward to type repeatedly.

Here we are giving the type `List(#(String, String))` the new name
`Headers`. This may be useful in a web application where we want to write
multiple functions that return headers.

```gleam
pub type Headers =
  List(#(String, String))
```
