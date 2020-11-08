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
  - [Modules](#modules)
- [Comments](#comments)
- [Operators](#operators)
- [Constants](#constants)
- [Blocks](#blocks)
- [Data types](#data-types)
  - [Strings](#strings)
  - [Tuples](#tuples)
  - [Lists](#lists)
  - [Atoms](#atoms)
  - [Maps](#maps)
- [Custom types](#custom-types)
  - [Records](#records)

## Variables

#### Elixir

In Elixir and Gleam are similar, only gleam has the `let` keyword before its variable names. You can reassign variables in both languages.

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

In Elixir `=` is really just a match operator and can be used to assert that a given term has a specific shape or value.

```elixir
[x] = [1] # assert `x` is a 1 element list and assign it to this element's value
2 = x # error because x's value is 1
```

#### Gleam

In Gleam `=` could be used for pattern matching as well, but you'll get compile errors if there's a type mismatch and a runtime error if there's a value mismatch. Also, there's the `assert` keyword, used to make assertions.

```rust
assert [element] = [1] // works
assert element = 1 // works
assert [element] = "Hello" // Compile error, type mismatch
assert [element] = [1, 2] // Erlang runtime error
```

### Variables type annotations

#### Elixir

In Elixir there's no static types.

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```rust
let some_list: List(Int) = [1, 2, 3]
```

Gleam will check the type annotation to ensure that it matches the type of the assigned value. It does not need annotations to type check your code, but you may find it useful to annotate variables to hint to the compiler that you want a specific type to be inferred.

## Functions

In Elixir, you can define functions inside modules, or anonymous functions which need a `.` when calling them.

Gleam's top level functions are declared using a syntax similar to Rust or JavaScript and anonymous functions have a similar syntax without the name and doesn't need a `.` to call.

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

In Gleam functions are private by default and need the `pub` keyword to be public.

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

Functions can **optionally** have their argument and return types annotated in Gleam. The compiler will still type check your program if they are omitted using type inference. These type annotations will always be checked by the compiler and throw a compilation error if not valid.

You can use Typespecs to annotate functions in Elixir but they need Dializer to be checked. However, Gleam's type system is much stronger and will catch more errors.

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

### Function heads

Unlike Elixir, Gleam does not support multiple function heads, so to pattern match on an argument a case expression must be used.

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

Unlike Elixir, Gleam does not support function overloading, so there can only be 1 function with a given name, and the function can only have a single implementation for the types it accepts.

### Modules

Gleam's file is a module and values and functions inside it will be referenced by its name, so there is no need for a special syntax to declare a module.

#### Elixir

```elixir
defmodule Foo do
  def identity(x) do
    x
  end
end

defmodule Bar do
  def main(x) do
    Foo.identity(1)
  end
end
```

#### Gleam

```rust
// in file foo.gleam
fn identity(x) {
  x
}

// in file main.gleam
import foo // if foo was in a folder called `lib` the import would be `lib/foo`
fn main() {
  foo.identity(1)
}
```

## Comments

#### Elixir

In Elixir comments are written with a `#` prefix.

```elixir
# Hello, Joe!
```

#### Gleam

In Gleam comments are written with a `//` prefix.

```rust
// Hello, Joe!
```

Comments starting with `///` are used to document the following statement, comments starting with `////` are used to document the current module.

```rust
//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
```

## Operators

| Operator          | Elixir | Gleam | Notes                                         |
| ----------------- | ------ | ----- | --------------------------------------------- |
| Equal             | `==`   | `==`  | In Gleam both values must be of the same type |
| Strictly equal to | `===`  |       | Useful in Elixir but not in Gleam             |
| Not equal         | `!=`   | `!=`  | In Gleam both values must be of the same type |
| Greater than      | `>`    | `>`   | In Gleam both values must be **ints**         |
| Greater than      | `>`    | `>.`  | In Gleam both values must be **floats**       |
| Greater or equal  | `>=`   | `>=`  | In Gleam both values must be **ints**         |
| Greater or equal  | `>=`   | `>=.` | In Gleam both values must be **floats**       |
| Less than         | `<`    | `<`   | In Gleam both values must be **ints**         |
| Less than         | `<`    | `<.`  | In Gleam both values must be **floats**       |
| Less or equal     | `=<`   | `>=`  | In Gleam both values must be **ints**         |
| Less or equal     | `=<`   | `>=.` | In Gleam both values must be **floats**       |
| Boolean and       | `and`  | `&&`  | In Gleam both values must be **bools**        |
| Boolean and       | `&&`   | `&&`  |                                               |
| Boolean or        | `or`   | `|| ` | In Gleam both values must be **bools**        |
| Boolean and       | `||`   | `||`  |                                               |
| Add               | `+`    | `+`   | In Gleam both values must be **ints**         |
| Add               | `+`    | `+.`  | In Gleam both values must be **floats**       |
| Subtract          | `-`    | `-`   | In Gleam both values must be **ints**         |
| Subtract          | `-`    | `-.`  | In Gleam both values must be **floats**       |
| Multiply          | `*`    | `*`   | In Gleam both values must be **ints**         |
| Multiply          | `*`    | `*.`  | In Gleam both values must be **floats**       |
| Divide            | `div`  | `/`   | In Gleam both values must be **ints**         |
| Divide            | `/`    | `/.`  | In Gleam both values must be **floats**       |
| Modulo            | `rem`  | `%`   | In Gleam both values must be **ints**         |
| Pipe              | `|>`   | `||`  |                                               |


## Constants

In Elixir module attributes can be defined to name literals we may want to use in multiple places. They can only be used within the current module.

In Gleam constants can be used to achieve the same.

#### Elixir

```elixir
defmodule MyServer do
  @the_answer 42
  def main, do: @the_answer
end
```

#### Gleam

```rust
const the_answer = 42

fn main() {
  the_answer
}
```

Gleam constants can be referenced from other modules.

```rust
import other_module

fn main() {
  other_module.the_answer
}
```

## Blocks

#### Elixir

In Elixir expressions can be grouped using `do` and `end`.

```elixir
defmodule Foo do
  def main() do
    x = do
      print(1)
      2
    end
    y = x * (x + 10)
    y
  end
end
```

#### Gleam

In Gleam braces `{` `}` are used to group expressions.

```rust
fn main() {
  let x = {
    print(1)
    2
  }
  let y = x * {x + 10}
  y
}
```

## Data types

### Strings

All strings in Elixir & Gleam are UTF-8 encoded binaries.

#### Elixir

```elixir
"Hellø, world!"
```

#### Gleam

```rust
"Hellø, world!"
```

### Tuples

Tuples are very useful in Gleam as they're the only collection data type that allows mixed types in the collection. The syntax for a tuple literal - `tuple("a", "b")` - can be confused for a function call, which is not!

#### Elixir

```elixir
tuple = {"username", "password", 10}
{_, Password, _} = tuple
```

#### Gleam

```rust
let my_tuple = tuple("username", "password", 10)
let tuple(_, password, _) = my_tuple
```

### Lists

Lists in Elixir are allowed to be of mixed types, but not in Gleam. They retain all of the same performance sematics.

The `cons` operator works the same way both for pattern matching and for appending elements to the head of a list, but it uses a different syntax.

#### Elixir

```elixir
list = [2, 3, 4]
list = [1 | list]
[1, second_element | _] = list
[1.0 | list] # works
```

#### Gleam

```rust
let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // Type error!
```

### Atoms

In Elixir atoms can be created as needed, but in Gleam all atoms must be defined as values in a custom type before being used. Any value in a type definition in Gleam that does not have any arguments is an atom in Elixir.

There are some exceptions to that rule for atoms that are commonly used and have types built-in to Gleam that incorporate them, such as `Ok`, `Error` and booleans.

In general, atoms are not used much in Gleam, and are mostly used for boolens, `Ok` and `Error` result types, and defining custom types.

#### Elixir

```elixir
var = :my_new_var

# true and false are atoms in elixir
{:ok, true}
{:error, false}
```

#### Gleam

```rust
type MyNewType {
  MyNewVar
}
let var = MyNewVar

// Ok(_) and Error(_) are of type Result(_, _) in Gleam
Ok(True)
Error(False)
```

### Maps

In Elixir, maps can have keys and values of any type, and they can be mixed in a given map. In Gleam, maps can have keys and values of any type, but all keys must be of the same type in a given map and all values must be of the same type in a given map.

There is no map literal syntax in Gleam, and you cannot pattern match on a map. Maps are generally not used much in Gleam, custom types are more common.

#### Elixir

```elixir
%{"key1" => "value1", "key2" => "value2"}
%{"key1" => :value1, "key2" => 2}
```

#### Gleam

```rust
import gleam/map

map.from_list([tuple("key1", "value1"), tuple("key2", "value2")])
map.from_list([tuple("key1", "value1"), tuple("key2", 2)]) // Type error!
```

## Custom types

### Records

In Elixir, Records are the same thing as Erlang's Record but it's not used frequently. Elixir uses Structs more which is implemented using Erlang's Map. Gleam does not have anything called a `record`, but custom types can be used in Gleam in much the same way that records are used in Elixir.

The important thing is that a custom type allows you to define a collection data type with a fixed number of named fields, and the values in those fields can be of differing types.

#### Elixir

```elixir
# Elixir's struct
defmodule Person do
 defstruct name: "John", age: 35
end
person = %Person{name="John", age=35}
name = person.name

# Elixir's record
{Person, "John", 35}
```

#### Gleam

```rust
type Person {
  Person(age: Int, name: String)
}
```

```rust
let person = Person(name: "name", age: 35)
let name = person.name
```
