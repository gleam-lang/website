# Struct

Gleam's struct types are named collections of keys and values. They are
similar to objects in object oriented languages, though they don't have
methods.

Structs are defined with the `struct` keyword.

```rust,noplaypen
pub struct Cat {
  name: String
  cuteness: Int
}
```

Here we have defined a struct called `Cat` which has two fields: A `name`
field which is a `String`, and a `cuteness` field which is an `Int`.

The `pub` keyword has been used to make this struct usable from other modules.

Once defined the struct type can be used in functions:

```rust,noplaypen
fn cats() {
  // Struct fields can be given in any order
  let cat1 = Cat(name: "Nubi", cuteness: 2001)
  let cat2 = Cat(cuteness: 1805, name: "Biffy")

  // Alternatively fields can be given without labels
  let cat3 = Cat("Ginny", 1950)

  [cat1, cat2, cat3]
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
