---
layout: page
title: Gleam for Elixir users
---

- [Comments](#comments)
- [Variables](#variables)
  - [Match operator](#match-operator)
  - [Variable type annotations](#variable-type-annotations)
- [Functions](#functions)
  - [Exporting functions](#exporting-functions)
  - [Function type annotations](#function-type-annotations)
  - [Function heads](#function-heads)
  - [Function overloading](#function-overloading)
  - [Referencing functions](#referencing-function)
  - [Labelled arguments](#labelled-arguments)
- [Operators](#operators)
  - [Pipe](#pipe)
- [Constants](#constants)
- [Blocks](#blocks)
- [Data types](#data-types)
  - [Strings](#strings)
  - [Tuples](#tuples)
  - [Lists](#lists)
  - [Atoms](#atoms)
  - [Maps](#maps)
- [Type aliases](#type-aliases)
- [Custom types](#custom-types)
  - [Records](#records)
  - [Unions](#unions) TODO
  - [Opaque custom types](#opaque-custom-types) TODO
- [Flow control](#flow-control) TODO
  - [Case](#case) TODO
  - [Try](#try) TODO
- [Modules](#modules) TODO
  - [Imports](#imports) TODO
  - [Nested modules](#nested-modules) TODO
  - [First class modules](#first-class-modules) TODO

## Variables

#### Elixir

In Elixir and Gleam are similar, only gleam has the `let` keyword before its variable names.
You can reassign variables in both languages.

```elixir
size = 50
size2 = size + 100
size2 = 1
```

#### Gleam

```rust
let size = 50
let size = size + 100
let size = 1
```

### Match operator

#### Elixir

In Elixir `=` is really just a match operator and can be
used to assert that a given term has a specific shape or value.

```elixir
[x] = [1] # assert `x` is a 1 element list and assign it to this element's value
2 = x # error because x's value is 1
```

#### Gleam

In Gleam `=` could be used for pattern matching as well, but you'll get compile errors if there's a type mismatch
and a runtime error if there's a value mismatch. Also, there's the `assert` keyword, used to make assertions.

```rust
let [element] = "Hello" // Compile error, type mismatch
let [element] = [1, 2] // Erlang runtime error
let [element] = [1] // works
assert element = 1 // works
```

### Variables type annotations

#### Elixir

In Elixir there's no static types.

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```rust
let some_list: List(Int) = [1, 2, 3]
```

Gleam will check the type annotation to ensure that it matches the type of the
assigned value.

Gleam does not need annotations to type check your code, but you may find it
useful to annotate variables to hint to the compiler that you want a specific
type to be inferred.

## Functions

In Elixir, you can only define top level anonymous functions which need a `.` when invoking them,
and regular functions are defined inside modules only.

Gleam's top level functions are declared using a syntax similar to Rust or
JavaScript.

#### Elixir

```elixir
# Anonymous functions (notice the dot)
square = fn(x) -> x * x end
square.(5) #=> 25

defmodule Math do
  def sum(a, b) do
    a + b
  end
end
```

#### Gleam

```rust
fn sum(x, y) {
  x + y
}

// anonymous functions are defined in a similar syntax without the name
fn calculate(x) {
    let add_one = fn(z) { z + 1 }
    add_one(x)
}
```

### Exporting functions

In Elixir functions defined by `def` are public by default, while ones defined by `defp` are private.

In Gleam functions are priavate by default and need `pub` keyword to be public.

#### Elixir

```elixir
defmodule Math do
  # this is public
  def sum(x, y) do
    x + y
  end

  # this is private
  defp mul(x, y) do
    x * y
  end
end
```

#### Gleam

```rust
// this is public
pub fn sum(x, y) {
  x + y
}

// this is private
fn mul(x, y) {
  x * y
}
```

### Function type annotations

Functions can optionally have their argument and return types annotated in Gleam.

You can use Typespecs to annotate functions in Elixir

#### Elixir

```elixir
defmodule LousyCalculator do
  @spec add(number, number) :: {number, String.t}
  def add(x, y), do: {x + y, "You need a calculator to do that?!"}
end
```

#### Gleam

```rust
fn add(x: Int, y: Int) -> Int {
  x + y
}
```

Unlike in Elixir these type annotations will always be checked by the compiler
and have to be correct for compilation to succeed.

### Function heads

Unlike Elixir, Gleam does not support multiple
function heads, so to pattern match on an argument a case expression must be
used.

#### Elixir

```elixir
defmodule Math do
  def zero?(0), do: true
  def zero?(x), do: false
end
```

#### Gleam

```rust
// we cannot use `?` in function names in Gleam
fn is_zero(x) {
  case x {
    0 -> true
    _ -> false
  }
}
```

### Function overloading

Gleam does not support function overloading, so there can only be 1 function
with a given name, and the function can only have a single implementation for
the types it accepts.
