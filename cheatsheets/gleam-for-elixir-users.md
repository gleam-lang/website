---
layout: page
title: Gleam for Elixir users
subtitle: Hello Elixir Alchemists!
---

- [Comments](#comments)
- [Variables](#variables)
  - [Match operator](#match-operator)
  - [Variables type annotations](#variables-type-annotations)
- [Functions](#functions)
  - [Exporting functions](#exporting-functions)
  - [Function type annotations](#function-type-annotations)
  - [Function heads](#function-heads)
  - [Function overloading](#function-overloading)
  - [Referencing functions](#referencing-function)
  - [Calling anonymous functions](#calling-anonymous-functions)
  - [Labelled arguments](#labelled-arguments)
- [Modules](#modules)
- [Operators](#operators)
- [Constants](#constants)
- [Blocks](#blocks)
- [Data types](#data-types)
  - [Strings](#strings)
  - [Tuples](#tuples)
  - [Lists](#lists)
  - [Atoms](#atoms)
  - [Maps](#maps)
- [Patterns] TODO
- [Flow control](#flow-control) TODO
  - [Case](#case) TODO
  - [Try](#try) TODO
- [Type aliases](#type-aliases) TODO
- [Custom types](#custom-types)
  - [Records](#records)
  - [Unions](#unions)
  - [Opaque custom types](#opaque-custom-types) TODO
- [Modules](#modules) TODO
  - [Imports](#imports) TODO
  - [Nested modules](#nested-modules) TODO
  - [First class modules](#first-class-modules) TODO


## Comments

#### Elixir

In Elixir comments are written with a `#` prefix.

```elixir
# Hello, Joe!
```

#### Gleam

In Gleam comments are written with a `//` prefix.

```gleam
// Hello, Joe!
```

Comments starting with `///` are used to document the following statement. Comments starting with `////` are used to document the current module.

```gleam
//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
```

## Variables

You can reassign variables in both languages.

#### Elixir

```elixir
size = 50
size = size + 100
size = 1
```

#### Gleam

Gleam has the `let` keyword before each variable assignment.

```gleam
let size = 50
let size = size + 100
let size = 1
```

### Match operator

#### Elixir

```elixir
[x, y] = [1, 2] # assert that the list has 2 elements
2 = y # assert that y is 2
2 = x # runtime error because x's value is 1
[y] = "Hello" # runtime error
```

#### Gleam

In Gleam, `let` and `=` can be used for pattern matching, but you'll get compile errors if there's a type mismatch, and a runtime error if there's a value mismatch. For assertions, the equivalent `let assert` keyword is preferred.

```gleam
let assert [x, y] = [1, 2]
let assert 2 = y // assert that y is 2
let assert 2 = x // runtime error
let assert [y] = "Hello" // compile error, type mismatch
```

### Variables type annotations

#### Elixir

In Elixir there's no static types.

```elixir
some_list = [1, 2, 3]
```

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```gleam
let some_list: List(Int) = [1, 2, 3]
```

Gleam will check the type annotation to ensure that it matches the type of the assigned value. It does not need annotations to type check your code, but you may find it useful to annotate variables to hint to the compiler that you want a specific type to be inferred.


## Functions

#### Elixir

In Elixir, you can define functions with the `def` keyword, or assign anonymous functions to variables. Anonymous functions need a `.` when calling them.

```elixir
def sum(x, y) do
  x + y
end

mul = fn(x, y) -> x * y end
mul.(1, 2)
```

#### Gleam

Gleam's functions are declared using a syntax similar to Rust or JavaScript. Gleam's anonymous functions have a similar syntax and don't need a `.` when called.

```gleam
pub fn sum(x, y) {
  x + y
}

let mul = fn(x, y) { x * y }
mul(1, 2)
```

### Exporting functions

#### Elixir

In Elixir functions defined by `def` are public by default, while ones defined by `defp` are private.

```elixir
# this is public
def sum(x, y) do
  x + y
end

# this is private
defp mul(x, y) do
  x * y
end
```

#### Gleam

In Gleam functions are private by default and need the `pub` keyword to be public.

```gleam
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

#### Elixir

You can use Typespecs to annotate functions in Elixir but they mainly serve as documentation. Typespecs can be optionally used by tools like Dialyzer to find some subset of possible bugs.

```elixir
@spec sum(number, number) :: number
def sum(x, y), do: x + y

@spec mul(number, number) :: boolean # no Elixir compile error
def mul(x, y), do: x * y
```

#### Gleam

Functions can **optionally** have their argument and return types annotated in Gleam. These type annotations will always be checked by the compiler and throw a compilation error if not valid. The compiler will still type check your program using type inference if annotations are omitted.

```gleam
pub fn add(x: Int, y: Int) -> Int {
  x + y
}

pub fn mul(x: Int, y: Int) -> Bool { // compile error, type mismatch
  x * y
}
```

### Function heads

#### Elixir

Elixir functions can have multiple function heads.

```elixir
def zero?(0), do: true
def zero?(x), do: false
```

#### Gleam

Gleam functions can have only one function head. Use a case expression to pattern match on function arguments.

```gleam
pub fn is_zero(x) { // we cannot use `?` in function names in Gleam
  case x {
    0 -> True
    _ -> False
  }
}
```

### Function overloading

Unlike Elixir, Gleam does not support function overloading, so there can only
be 1 function with a given name, and the function can only have a single
implementation for the types it accepts.

### Referencing functions

Gleam has a single namespace for value and functions within a module, so there
is no need for a special syntax to assign a module function to a variable.

#### Elixir
```elixir
def identity(x) do
  x
end

def main() do
  func = &identity/1
  func.(100)
end
```

#### Gleam
```gleam
fn identity(x) {
  x
}

fn main() {
  let func = identity
  func(100)
}
```

### Calling anonymous functions

Elixir has a different namespace for module functions and anonymous functions
so a special `.()` syntax has to be used to call anonymous functions.

In Gleam all functions are called using the same syntax.

#### Elixir

```elixir
anon_function = fn x, y -> x + y end
anon_function.(1, 2)
mod_function(3, 4)
```

#### Gleam

```gleam
let anon_function = fn(x, y) { x + y }
anon_function(1, 2)
mod_function(3, 4)
```

### Labelled arguments

Both Elixir and Gleam have ways to give arguments names and in any order,
though they function differently.

#### Elixir

In Elixir arguments can be given as a list of tuples with the name of the
argument being the first element in the tuple.

The name used at the call-site does not have to match the name used for the
variable inside the function.

```elixir
def replace(opts \\ []) do
  string = opts[:inside] || default_string()
  pattern = opts[:each] || default_pattern()
  replacement = opts[:with] || default_replacement()
  go(string, pattern, replacement)
end
```

```elixir
replace(each: ",", with: " ", inside: "A,B,C")
```

Because the arguments are stored in a list there is a small runtime
performance penalty for using Elixir's keyword arguments, and it is possible
for any of the arguments to be missing or of the incorrect type. There are no
compile time checks or optimisations for keyword arguments.

#### Gleam

In Gleam arguments can be given a label as well as an internal name. As with
Elixir the name used at the call-site does not have to match the name used
for the variable inside the function.

```gleam
pub fn replace(inside string, each pattern, with replacement) {
  go(string, pattern, replacement)
}
```

```gleam
replace(each: ",", with: " ", inside: "A,B,C")
```

There is no performance cost to Gleam's labelled arguments as they are
optimised to regular function calls at compile time, and all the arguments
are fully type checked.

## Operators

| Operator          | Elixir | Gleam | Notes                                          |
| ----------------- | ------ | ----- | ---------------------------------------------- |
| Equal             | `==`   | `==`  | In Gleam both values must be of the same type  |
| Strictly equal to | `===`  | `==`  | Comparison in Gleam is always strict           |
| Not equal         | `!=`   | `!=`  | In Gleam both values must be of the same type  |
| Greater than      | `>`    | `>`   | In Gleam both values must be **ints**          |
| Greater than      | `>`    | `>.`  | In Gleam both values must be **floats**        |
| Greater or equal  | `>=`   | `>=`  | In Gleam both values must be **ints**          |
| Greater or equal  | `>=`   | `>=.` | In Gleam both values must be **floats**        |
| Less than         | `<`    | `<`   | In Gleam both values must be **ints**          |
| Less than         | `<`    | `<.`  | In Gleam both values must be **floats**        |
| Less or equal     | `<=`   | `<=`  | In Gleam both values must be **ints**          |
| Less or equal     | `<=`   | `<=.` | In Gleam both values must be **floats**        |
| Boolean and       | `and`  | `&&`  | In Gleam both values must be **bools**         |
| Logical and       | `&&`   |       | Not available in Gleam                         |
| Boolean or        | `or`   | `||`  | In Gleam both values must be **bools**         |
| Logical or        | `||`   |       | Not available in Gleam                         |
| Add               | `+`    | `+`   | In Gleam both values must be **ints**          |
| Add               | `+`    | `+.`  | In Gleam both values must be **floats**        |
| Subtract          | `-`    | `-`   | In Gleam both values must be **ints**          |
| Subtract          | `-`    | `-.`  | In Gleam both values must be **floats**        |
| Multiply          | `*`    | `*`   | In Gleam both values must be **ints**          |
| Multiply          | `*`    | `*.`  | In Gleam both values must be **floats**        |
| Divide            | `div`  | `/`   | In Gleam both values **ints**                  |
| Divide            | `/`    | `/.`  | In Gleam both values must be **floats**        |
| Remainder         | `rem`  | `%`   | In Gleam both values must be **ints**          |
| Concatenate       | `<>`   | `<>`  | In Gleam both values must be **strings**       |
| Pipe              | `|>`   | `|>`  | Gleam's pipe can pipe into anonymous functions |


## Constants

#### Elixir

In Elixir module attributes can be defined to name literals we may want to use in multiple places. They can only be used within the current module.

```elixir
defmodule MyServer do
  @the_answer 42
  def main, do: @the_answer
end
```

#### Gleam

In Gleam constants can be created using the `const` keyword.

```gleam
const the_answer = 42

pub fn main() {
  the_answer
}
```

Additionally, Gleam constants can be referenced from other modules.

```gleam
// in file other_module.gleam
pub const the_answer: Int = 42
```

```gleam
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
    y = x * (x + 10) # parentheses are used to change arithmetic operations order
    y
  end
end
```

#### Gleam

In Gleam braces `{` `}` are used to group expressions.

```gleam
pub fn main() {
  let x = {
    print(1)
    2
  }
  // Braces are used to change arithmetic operations order
  let y = x * { x + 10 }
  y
}
```


## Data types

### Strings

In both Elixir and Gleam all strings are UTF-8 encoded binaries.

#### Elixir

```elixir
"Hellø, world!"
```

#### Gleam

```gleam
"Hellø, world!"
```

### Tuples

Tuples are very useful in Gleam as they're the only collection data type that allows mixed types in the collection.

#### Elixir

```elixir
my_tuple = {"username", "password", 10}
{_, password, _} = my_tuple
```

#### Gleam

```gleam
let my_tuple = #("username", "password", 10)
let #(_, password, _) = my_tuple
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

```gleam
let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // compile error, type mismatch
```

### Atoms

In Elixir atoms can be created as needed, but in Gleam all atoms must be defined as values in a custom type before being used. Any value in a type definition in Gleam that does not have any arguments is an atom in Elixir.

There are some exceptions to that rule for atoms that are commonly used and have types built-in to Gleam that incorporate them, such as `Ok`, `Error` and booleans.

In general, atoms are not used much in Gleam, and are mostly used for booleans, `Ok` and `Error` result types, and defining custom types.

#### Elixir

```elixir
var = :my_new_var

# true and false are atoms in elixir
{:ok, true}
{:error, false}
```

#### Gleam

```gleam
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

```gleam
import gleam/map

map.from_list([#("key1", "value1"), #("key2", "value2")])
map.from_list([#("key1", "value1"), #("key2", 2)]) // Type error!
```

## Custom types

Custom type allows you to define a collection data type with a fixed number of named fields, and the values in those fields can be of differing types.

#### Elixir

Elixir uses Structs which are implemented using Erlang's Map.

```elixir
defmodule Person do
 defstruct name: "John", age: 35
end

person = %Person{name: "Jake"}
name = person.name
```

In Elixir, the Record module can be used to create Erlang's Records, but they are not used frequently.

```elixir
defmodule Person do
  require Record
  Record.defrecord(:person, Person, name: "John", age: "35")
end

require Person
{Person, "Jake", 35} == Person.person(name: "Jake")
```

#### Gleam

Gleam's custom types can be used in much the same way that structs are used in Elixir. At runtime, they have a tuple representation and are compatible with Erlang records.

```gleam
type Person {
  Person(name: String, age: Int)
}

let person = Person(name: "Jake", age: 35)
let name = person.name
```

## Modules

#### Elixir

In Elixir, the `defmodule` keyword allows to create a module. Multiple modules can be defined in a single file.

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

Gleam's file is a module and named by the file name (and its directory path). Since there is no special syntax to create a module, there can be only one module in a file.

```gleam
// in file foo.gleam
pub fn identity(x) {
  x
}
```

```gleam
// in file main.gleam
import foo // if foo was in a folder called `lib` the import would be `lib/foo`
pub fn main() {
  foo.identity(1)
}
```

