---
layout: page
title: Gleam for Erlang users
subtitle: Hello Erlangers and their many 9s!
---

- [Comments](#comments)
- [Variables](#variables)
  - [Partial assignments](#partial-assignments)
  - [Variable type annotations](#variable-type-annotations)
- [Functions](#functions)
  - [Exporting functions](#exporting-functions)
  - [Function type annotations](#function-type-annotations)
  - [Function heads](#function-heads)
  - [Function overloading](#function-overloading)
  - [Referencing functions](#referencing-functions)
  - [Chaining function calls](#chaining-function-calls)
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
- [Patterns](#patterns) TODO
- [Flow control](#flow-control) TODO
  - [Case](#case) TODO
  - [Try](#try) TODO
- [Type aliases](#type-aliases)
- [Custom types](#custom-types)
  - [Records](#records)
  - [Unions](#unions)
  - [Opaque custom types](#opaque-custom-types)
- [Modules](#modules) TODO
  - [Imports](#imports) TODO
  - [Nested modules](#nested-modules) TODO
  - [First class modules](#first-class-modules) TODO


## Variables

#### Erlang

In Erlang variables are written with a capital letter, and can only be
assigned once.

```erlang
Size = 50
Size2 = Size + 100
Size2 = 1 % Runtime error! Size2 is 150, not 1
```

#### Gleam

In Gleam variables are written with a lowercase letter, and names can be
reassigned.

```gleam
let size = 50
let size = size + 100
let size = 1 // size now refers to 1
```

### Partial assignments

#### Erlang

In Erlang a partial pattern that does not match all possible values can be
used to assert that a given term has a specific shape.

```erlang
[Element] = SomeList % assert `SomeList` is a 1 element list
```

#### Gleam

In Gleam the `assert` keyword is used to make assertions using partial
patterns.

```gleam
let [element] = some_list // Compile error! Partial pattern
assert [element] = some_list
```

### Variables type annotations

#### Erlang

In Erlang it's not possible to give type annotations to variables.

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```gleam
let some_list: List(Int) = [1, 2, 3]
```

Gleam will check the type annotation to ensure that it matches the type of the
assigned value.

Gleam does not need annotations to type check your code, but you may find it
useful to annotate variables to hint to the compiler that you want a specific
type to be inferred.

## Functions

Gleam's top level functions are declared using a syntax similar to Rust or
JavaScript.

#### Erlang
```erlang
my_function(X) ->
    X + 1.
```

#### Gleam
```gleam
fn my_function(x) {
  x + 1
}
```

### Exporting functions

In Gleam functions are exported with the `pub` keyword. An export statement is
not required.

#### Erlang
```erlang
-export([my_function/1]).

my_function(X) ->
    X + 1.
```

#### Gleam
```gleam
pub fn my_function(x) {
  x + 1
}
```

### Function type annotations

Functions can optionally have their argument and return types annotated.

#### Erlang
```erlang
-spec my_function(integer()) :: integer().
my_function(X) ->
    X + 1.
```

#### Gleam
```gleam
fn my_function(x: Int) -> Int {
  x + 1
}
```

Unlike in Erlang these type annotations will always be checked by the compiler
and have to be correct for compilation to succeed.

### Function heads

Unlike Erlang (but similar to Core Erlang) Gleam does not support multiple
function heads, so to pattern match on an argument a case expression must be
used.

#### Erlang
```erlang
identify(1) ->
    "one";
identify(2) ->
    "two";
identify(3) ->
    "three";
identify(_) ->
    "dunno".
```

#### Gleam
```gleam
fn identify(x) {
  case x {
    1 -> "one"
    2 -> "two"
    3 -> "three"
    _ -> "dunno"
  }
}
```

### Function overloading

Gleam does not support function overloading, so there can only be 1 function
with a given name, and the function can only have a single implementation for
the types it accepts.


### Referencing functions

Gleam has a single namespace for value and functions within a module, so there
is no need for a special syntax to assign a module function to a variable.

#### Erlang
```erlang
identity(X) ->
  X.

main() ->
  Func = fun identity/1,
  Func(100).
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

### Chaining function calls

Gleam's parser allows functions returned from functions to be called directly
without adding parenthesis around the function call.


#### Erlang
```erlang
(((some_function(0))(1))(2))(3)
```

#### Gleam

```gleam
some_function(0)(1)(2)(3)
```

### Labelled arguments

Both Erlang and Gleam have ways to give arguments names and in any order,
though they function differently.

#### Erlang

In Erlang arguments can be given as as a map so that each has a name.

The name used at the call-site does not have to match the name used for the
variable inside the function.

```erlang
replace(#{inside => String, each => Pattern, with => Replacement}) ->
  go(String, Pattern, Replacement).
```

```erlang
replace(#{each => <<",">>, with => <<" ">>, inside => <<"A,B,C">>).
```

Because the arguments are stored in a map there is a small runtime
performance penalty to naming arguments, and it is possible for any of the
arguments to be missing or of the incorrect type. There are no compile time
checks or optimisations for maps of arguments.

#### Gleam

In Gleam arguments can be given a label as well as an internal name. As with
Erlang the name used at the call-site does not have to match the name used
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

## Comments

#### Erlang

In Erlang comments are written with a `%` prefix.

```erlang
% Hello, Joe!
```

#### Gleam

In Gleam comments are written with a `//` prefix.

```gleam
// Hello, Joe!
```

Comments starting with `///` are used to document the following statement,
comments starting with `////` are used to document the current module.

```gleam
//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
```

## Operators

| Operator         | Erlang    | Gleam | Notes
| ---              | ---       | ---   | ---
| Equal            | `=:=`     | `==`  | In Gleam both values must be of the same type
| Equal            | `==`      |       |
| Not equal        | `=/=`     | `!=`  | In Gleam both values must be of the same type
| Not equal        | `/=`      |       |
| Greater than     | `>`       | `>`   | In Gleam both values must be ints
| Greater than     | `>`       | `>.`  | In Gleam both values must be floats
| Greater or equal | `>=`      | `>=`  | In Gleam both values must be ints
| Greater or equal | `>=`      | `>=.` | In Gleam both values must be floats
| Less than        | `<`       | `<`   | In Gleam both values must be ints
| Less than        | `<`       | `<.`  | In Gleam both values must be floats
| Less or equal    | `=<`      | `>=`  | In Gleam both values must be ints
| Less or equal    | `=<`      | `>=.` | In Gleam both values must be floats
| Boolean and      | `andalso` | `&&`  | In Gleam both values must be bools
| Boolean and      | `and`     |       |
| Boolean or       | `orelse`  | `⎮⎮`  | In Gleam both values must be bools
| Boolean or       | `or`      |       |
| Add              | `+`       | `+`   | In Gleam both values must be ints
| Add              | `+`       | `+.`  | In Gleam both values must be floats
| Subtract         | `-`       | `-`   | In Gleam both values must be ints
| Subtract         | `-`       | `-.`  | In Gleam both values must be floats
| Multiply         | `*`       | `*`   | In Gleam both values must be ints
| Multiply         | `*`       | `*.`  | In Gleam both values must be floats
| Divide           | `div`     | `/`   | In Gleam both values must be ints
| Remainder        | `rem`     | `%`   | In Gleam both values must be ints
| Concatenate      |           | `<>`  | In Gleam both values must be strings
| Pipe             |           | `⎮>`  | See [the pipe section](#pipe) for details

### Pipe

The pipe operator can be used to chain together function calls so that they
read from top to bottom.

#### Erlang
```erlang
X1 = trim(Input),
X2 = csv:parse(X1, <<",">>)
ledger:from_list(X2).
```

#### Gleam
```gleam
input
|> trim
|> csv.parse(",")
|> ledger.from_list
```


## Constants

#### Erlang

In Erlang macros can be defined to name literals we may want to use in
multiple places. They can only be used within the current module

```erlang
-define(the_answer, 42).

main() ->
  ?the_answer.
```

#### Gleam

In Gleam constants can be used to achieve the same.

```gleam
const the_answer = 42

fn main() {
  the_answer
}
```

Gleam constants can be referenced from other modules.

```gleam
import other_module

fn main() {
  other_module.the_answer
}
```

## Blocks

#### Erlang

In Erlang expressions can be grouped using parenthesis or `begin` and `end`.

```erlang
main() ->
  X = begin
    print(1),
    2
  end,
  Y = X * (X + 10).
  Y.
```

#### Gleam

In Gleam braces are used to group expressions.

```gleam
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

All strings in Gleam are UTF-8 encoded binaries.

#### Erlang

```erlang
<<"Hellø, world!"/utf8>>.
```

#### Gleam

```gleam
"Hellø, world!"
```

### Tuples

Tuples are very useful in Gleam as they're the only collection data type that allows for mixed
types of elements in the collection.

#### Erlang

```erlang
Tuple = {"username", "password", 10}.
{_, Password, _} = Tuple.
```

#### Gleam

```gleam
let my_tuple = #("username", "password", 10)
let #(_, password, _) = my_tuple
```

### Lists

Lists in Erlang are allowed to be of mixed types, but not in Gleam. They retain all of the same
performance sematics.

The `cons` operator works the same way both for pattern matching and for appending elements to the
head of a list, but it uses a different syntax.

#### Erlang

```erlang
List0 = [2, 3, 4].
List1 = [1 | List0].
[1, SecondElement | _] = List1.
[1.0 | List1].
```

#### Gleam

```gleam
let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // Type error!
```

### Atoms

In Erlang atoms can be created as needed, but in Gleam all atoms must be defined as values in a
custom type before being used. Any value in a type definition in Gleam that does not have any
arguments is an atom in Erlang.

There are some exceptions to that rule for atoms that are commonly used and have types built-in to
Gleam that incorporate them, such as `ok`, `error` and booleans.

In general, atoms are not used much in Gleam, and are mostly used for boolens, `ok` and `error`
result types, and defining custom types.

#### Erlang

```erlang
Var = my_new_var.

{ok, true}.

{error, false}.
```

#### Gleam

```gleam
type MyNewType {
  MyNewVar
}
let var = MyNewVar

Ok(True)

Error(False)
```

### Maps

In Erlang, maps can have keys and values of any type, and they can be mixed in a given map. In
Gleam, maps can have keys and values of any type, but all keys must be of the same type in a given
map and all values must be of the same type in a given map.

There is no map literal syntax in Gleam, and you cannot pattern match on a map. Maps are generally
not used much in Gleam, custom types are more common.

#### Erlang

```erlang
#{"key1" => "value1", "key2" => "value2"}.
#{"key1" => "value1", "key2" => 2}.
```

#### Gleam

```gleam
import gleam/map


map.from_list([#("key1", "value1"), #("key2", "value2")])
map.from_list([#("key1", "value1"), #("key2", 2)]) // Type error!
```


## Flow control

TODO

### Case

TODO

### Try

TODO


## Type aliases

#### Erlang

```erlang
-type scores() :: list(integer()).
```

#### Gleam

```gleam
pub type Scores =
  List(Int)
```


## Custom types

### Records

In Erlang, Records are a specialized data type built on a tuple. Gleam does not have anything
called a `record`, but custom types can be used in Gleam in much the same way that records are
used in Erlang, even though custom types don't actually define a `record` in Erlang when it is
compiled.

The important thing is that a custom type allows you to define a collection data type with a fixed
number of named fields, and the values in those fields can be of differing types.

#### Erlang

```erlang
-record(person, {age :: integer(),
                 name :: binary()}).
```
```erlang
Person = #person{name="name", age=35}.
Name = Person#person.name.
```

#### Gleam

```gleam
type Person {
  Person(age: Int, name: String)
}
```
```gleam
let person = Person(name: "name", age: 35)
let name = person.name
```

### Unions

In Erlang a function can take or receive values of multiple different types.
For example it could return an int some times, and float other times.

In Gleam functions must always take an receive one type. To have a union of
two different types they must be wrapped in a new custom type.

#### Erlang

```erlang
int_or_float(X) ->
  case X of
    true -> 1;
    false -> 1.0
  end.
```

#### Gleam

```gleam
type IntOrFloat {
  AnInt(Int)
  AFloat(Float)
}

fn int_or_float(X) {
  case X {
    True -> AnInt(1)
    False -> AFloat(1.0)
  }
}
```

### Opaque custom types

In Erlang the `opaque` attribute can be used to declare that the internal
structure of a type is not considered a public API and isn't to be used by
other modules. This is purely for documentation purposes and other modules
can introspect and manipulate opaque types any way they wish.

In Gleam custom types can be defined as being opaque, which causes the
constructors for the custom type not to be exported from the module. Without
any constructors to import other modules can only interact with opaque types
using the intended API.

#### Erlang
```erlang
-opaque identifier() :: integer().

-spec get_id() -> identifier().
get_id() ->
  100.
```

#### Gleam
```gleam
pub opaque type Identifier {
  Identifier(Int)
}

pub fn get_id() {
  Identifier(100)
}
```
## Modules

### Imports

### Nested modules

### First class modules
