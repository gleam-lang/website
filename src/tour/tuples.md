# Tuple

Lists are good for when we want a collection of one type, but sometime we want
to combine multiple values of different types. In this case tuples are a quick
and convenient option.

```rust,noplaypen
fn run() {
  tuple(10, "hello") // Type is tuple(Int, String)
  tuple(1, 4.2, [0]) // Type is tuple(Int, Float, List(Int))
}
```

## Destructuring structs

To extract values from structs we can pattern match on them with `let` or
`case`.

```rust,noplaypen
let Cat(name: name1, cuteness: cuteness1) = cat1

name1     // => "Nubi"
cuteness1 // => 2001
```

We can also pattern match using positional arguments:

```rust,noplaypen
let Cat(name2, cuteness2) = cat2

name2     // => "Biffy"
cuteness2 // => 1805
```


## Generic structs

Structs types can be parameterised so the same struct can be constructed with
different contained types.

```rust,noplaypen
pub struct Box(a) {
  tag: String
  contents: a // The type of this field is injected when constructed
}

fn run() {
  Box(tag: "one", contents: 1.0) // the type is Box(Float)
  Box(tag: "two", contents: "2") // the type is Box(String)
}
```


## Anonymous structs

In addition to named structs Gleam has anonymous structs. Anonymous structs
don't need to be declared up front but also don't have names for their fields,
so for clarity prefer named structs for when you have more than 2 or 3 fields.

```rust,noplaypen
fn run() {
  struct(10, "hello") // Type is struct(Int, String)
  struct(1, 4.2, [0]) // Type is struct(Int, Float, List(Int))
}
```


## Erlang interop

At runtime Gleam structs are Erlang tuples. Named structs have a name tag in
the first position and the Gleam compiler will generate a compatible Erlang
record definition for use from other languages such as Erlang and Elixir.
