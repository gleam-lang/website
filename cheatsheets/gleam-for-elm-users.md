---
layout: page
title: Gleam for Elm users
---

## Overview

Elm and Gleam have similar goals of providing a robust and sound type system with a friendly and approachable set of features.

They have some differences in their output and focus. Where Elm compiles to JavaScript, Gleam compiles to Erlang, and where Elm is best suited for front-end browser based applications, Gleam initially targets back-end and server-side application development.

Another area in which Elm and Gleam differ is around talking to other languages.
Elm does not provide user-defined foreign function interfaces for interacting
with JavaScript code and libraries. All communication between Elm and JavaScript
has to go through the Elm ports. In contrast to this, Gleam makes it easy to
define inferfaces for using Erlang or JavaScript code and libraries directly and
has no concept of ports.

## Contents

- [Comments](#comments)
- [Variables](#variables)
  - [Variables type annotations](#variables-type-annotations)
- [Constants](#constants)
- [Functions](#functions)
  - [Function type annotations](#function-type-annotations)
  - [Function heads](#function-heads)
  - [Function overloading](#function-overloading)
  - [Referencing functions](#referencing-function)
  - [Calling anonymous functions](#calling-anonymous-functions)
  - [Labelled arguments](#labelled-arguments)
- [Modules](#modules)
  - [Exports](#exports)
- [Blocks](#blocks)
- [Data types](#data-types)
  - [Numbers](#numbers)
  - [Strings](#strings)
  - [Tuples](#tuples)
  - [Records](#records)
  - [Lists](#lists)
  - [Dicts](#dicts)
- [Operators](#operators)
- [Type aliases](#type-aliases)
- [Custom types](#custom-types)
  - [Maybe](#maybe)
  - [Result](#result)
- [If expressions](#if-expressions)
- [Case expressions](#case-expressions)
- [Commands](#commands)
- [Talking to other languages](#talking-to-other-languages)
- [Architecture](#architecture)
- [Package management](#package-management)
- [Implementation](#implementation)
- [Other concepts](#other-concepts)
  - [Atoms](#atoms)

## Comments

#### Elm

In Elm, single line comments are written with a `--` prefix and multiline comments are written with `{- -}` and `{-| -}` for documentation comments.

```elm
-- Hello, Joe!

{- Hello, Joe! 
   This is a multiline comment.
-}

{-| Determine the length of a list.
    length [1,2,3] == 3
-}
length : List a -> Int
length xs =
  foldl (\_ i -> i + 1) 0 xs
```

#### Gleam

In Gleam comments are written with a `//` prefix.

```gleam
// Hello, Joe!
```

Comments starting with `///` are used to document the following function, constant, or type definition. Comments starting with `////` are used to document the current module.

```gleam
//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
```

There are no multiline comments in Gleam.

## Variables

#### Elm

In Elm, you assign variables in let-blocks and you cannot re-assign variables within a let-block. 

You also cannot create a variable with the same name as a variable from a higher scope.

```elm
let
    size = 50
    size = size + 100 -- Compile Error!
in
```

#### Gleam

Gleam has the `let` keyword before its variable names. You can re-assign variables and you can shadow variables from other scopes. This does not mutate the previously assigned value.

```gleam
let size = 50
let size = size + 100
let size = 1
```

### Variables type annotations

Both Elm and Gleam will check the type annotation to ensure that it matches the type of the assigned value. They do not need annotations to type check your code, but you may find it useful to annotate variables to hint to the compiler that you want a specific type to be inferred.

#### Elm

In Elm, type annotations are optionally given on the line above the variable assignment. They can be provided in let-blocks but it frequently only provided for top level variables and functions.

```elm
someList : List Int
someList = [1, 2, 3]
```

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```gleam
let some_list: List(Int) = [1, 2, 3]
```

### Constants

#### Elm

In Elm, constants can be defined at the top level of the module like any other value and exported if desired and reference from other modules.

```elm
module Hikers exposing (theAnswer)

theAnswer: Int
theAnswer =
    42
```

#### Gleam

In Gleam constants can be created using the `const` keyword.

```gleam
const the_answer = 42

pub fn main() {
  the_answer
}
```

Gleam constants can be referenced from other modules.

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

## Functions

#### Elm

In Elm, functions are defined as declarations that have arguments, or by assigning anonymous functions to variables.

```elm
sum x y =
  x + y

mul =
  \x y -> x * y

mul 3 2
-- 6
```

#### Gleam

Gleam's functions are declared using a syntax similar to Rust or JavaScript. Gleam's anonymous functions are declared using the `fn` keyword.

```gleam
pub fn sum(x, y) {
  x + y
}

let mul = fn(x, y) { x * y }
mul(1, 2)
```

### Function type annotations

#### Elm

In Elm, functions can **optionally** have their argument and return types annotated. These type annotations will always be checked by the compiler and throw a compilation error if not valid. The compiler will still type check your program using type inference if annotations are omitted.


```elm
sum : number -> number -> number
sum x y = x + y

mul : number -> number -> Bool -- Compile error
mul x y = x * y
```

#### Gleam

All the same things are true of Gleam though the type annotations go inline in the function declaration, rather than above it.

```gleam
pub fn add(x: Int, y: Int) -> Int {
  x + y
}

pub fn mul(x: Int, y: Int) -> Bool {
  x * y // compile error, type mismatch
}
```

### Labelled arguments

#### Elm

Elm has no built-in way to label arguments. Instead it would standard for a function to expect a record as an argument in which the field names would serve as the argument labels. This can be combined with providing a 'defaults' value of the same record type where callers can override only the fields that they want to differ from the default.

```elm
defaultOptions =
  { inside = defaultString
  , each = defaultPattern,
  , with = defaultReplacement
  }

replace opts =
  doReplacement opts.inside opts.each opts.with
```

```elm
replace { each = ",", with = " ", inside = "A,B,C" }

replace { defaultOptions | inside = "A,B,C,D" }
```

#### Gleam

In Gleam arguments can be given a label as well as an internal name.

```gleam
pub fn replace(inside string, each pattern, with replacement) {
  go(string, pattern, replacement)
}
```

```elixir
replace(each: ",", with: " ", inside: "A,B,C")
```

There is no performance cost to Gleam's labelled arguments as they are optimised to regular function calls at compile time, and all the arguments are fully type checked.

## Modules

#### Elm

In Elm, the `module` keyword allows to create a module. Each module maps to a single file. The module name must be explicitly stated and must match the file name.

```elm
module Foo exposing (identity)

identity : a -> a
identity x =
    x
```


#### Gleam

A Gleam file is a module, named by the file name (and its directory path). There is no special syntax to create a module. There can be only one module in a file.

```gleam
// in file one.gleam
pub fn identity(x) {
  x
}
```

```gleam
// in file main.gleam
import one // if foo was in a folder called `lib` the import would be `lib/one`
pub fn main() {
  one.identity(1)
}
```

### Exports

#### Elm

In Elm, exports are handled at the top of the file in the module declaration as a list of names.

```elm
module Math exposing (sum)

-- this is public as it is in the export list
sum x y =
  x + y

-- this is private as it isn't in the export list
mul x y =
  x * y
```

#### Gleam

In Gleam, constants & functions are private by default and need the `pub` keyword to be public.

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

## Blocks

#### Elm

In Elm, expressions can be grouped using `let` and `in`.

```elm
view =
  let
    x = 5
    y = 
      let
         z = 4
         t = 3
      in
      z + (t * 5) -- Parenthesis are used to group arithmetic expressions
  in
  y + x
```

#### Gleam

In Gleam braces `{` `}` are used to group expressions.

```gleam
pub fn main() {
  let x = {
    print(1)
    2
  }
  let y = x * { x + 10 } // braces are used to change arithmetic operations order
  y
}
```

## Data types

### Numbers

Both Elm and Gleam support `Int` and `Float` as separate number types. 

#### Elm

Elm has a built-in `number` concept that allows it to treat `Int` and `Float` generically so operators like `+` can be used for two `Int` values or two `Float` values though not for an `Int` and a `Float`.

#### Gleam

Operators in Gleam as not generic over `Int` and `Float` so there are separate symbols for `Int` and `Float` operations. For example, `+` adds integers together whilst `+.` adds floats together. The pattern of the additional `.` extends to the other common operators.

Additionally, underscores can be added to both integers and floats for clarity.

```gleam
const one_million = 1_000_000
const two_million = 2_000_000.0
```

### Strings

In both Elm and Gleam all strings support unicode. Gleam uses UTF-8 binaries. Elm compiles to JavaScript which uses UTF-16 for its strings.

Both languages use double quotes for strings.

#### Elm

```elm
"Hellø, world!"
```

Strings in Elm are combined using the `++` operator and functions like [`String.append`](https://package.elm-lang.org/packages/elm/core/latest/String#append) and [`String.concat`](https://package.elm-lang.org/packages/elm/core/latest/String#concat):

```elm
greeting =
    "Hello, " ++ "world!"

birthdayWishes =
    String.append "Happy Birthday, " person.name

holidayWishes =
    String.concat [ "Happy ", holiday.name, person.name ]
```

#### Gleam

```gleam
"Hellø, world!"
```

Gleam does not have an operator for combining strings. Like Elm, it has [`string.append`](https://hexdocs.pm/gleam_stdlib/gleam/string.html#append) and [`string.concat`](https://hexdocs.pm/gleam_stdlib/gleam/string.html#concat) in the standard library.

```gleam
let birthday_wishes =
  string.append(to: "Happy Birthday ", suffix: person.name)

let holiday_wishes =
  string.concat([ "Happy ", holiday.name, person.name ])
```

### Tuples

Tuples are very useful in both Elm and Gleam as they're the only collection data type that allows mixed types in the collection.

#### Elm

In Elm, tuples are limited to only 2 or 3 entries. It is recommended to use records when needing larger numbers of entries.

```elm
myTuple = ("username", "password", 10)
(_, password, _) = myTuple
```

#### Gleam

There is no limit to the number of entries in Gleam tuples, but records are still recommended as giving names to fields adds clarity.

```gleam
let my_tuple = #("username", "password", 10)
let #(_, password, _) = my_tuple
```

### Records

Records are used to define and create structured data.

#### Elm

In Elm, you can declare records using curly braces containing key-value pairs:

```elm
person = 
  { name = "Alice"
  , age = 43
  }
```

The type of the record is derived by the compiler. In this case it would be `{ name : String, age : number }`.

Records can also be created using a [type alias](#type-aliases) name as a constructor.

Record fields can be accessed with a dot syntax:

```elm
greeting person = 
   "Hello, " ++ person.name ++ "!"
```

#### Gleam

In Gleam, you cannot create records without creating a custom type first. 

```
type Person {
  Person(name: String, age: Int)
}

let person = Person(name: "Alice", age: 43)
```

Record fields can be accessed with a dot syntax:

```gleam
greeting = string.concat(["Hello, ",  person.name, "!"])
```

### Lists

Both Elm and Gleam support lists. All entries have to be of the same type.

#### Elm

Elm has a built-in syntax for lists and the `cons` operator (`::`) for adding a new item to the head of a list.

```elm
list = [2, 3, 4]
anotherList = 1 :: list
yetAnotherList = "hello" :: list // compile error, type mismatch
```

#### Gleam

Gleam also has a built-in syntax for lists and its own spread operator (`..`) for adding elements to the front of a list.

```gleam
let list = [2, 3, 4]
let list = [1, ..list]
let another_list = [1.0, ..list] // compile error, type mismatch
```

The standard library provides the [gleam/list](https://hexdocs.pm/gleam_stdlib/gleam/list.html) module for interacting with lists. Functions like `list.head` return an `Option` value to account for the possibility of an empty list.

### Dicts

Dict in Elm and Map in Gleam have similar properties and purpose.

In Gleam, maps can have keys and values of any type, but all keys must be of the same type in a given map and all values must be of the same type in a given map.

Like Elm, there is no map literal syntax in Gleam, and you cannot pattern match on a map.

#### Elm

```elm
import Dict

Dict.fromList [ ("key1", "value1"), ("key2", "value2") ]
Dict.fromList [ ("key1", "value1"), ("key2", 2) ] -- Compile error
```

#### Gleam

```gleam
import gleam/map

map.from_list([#("key1", "value1"), #("key2", "value2")])
map.from_list([#("key1", "value1"), #("key2", 2)]) // Type error!
```

## Operators

As Gleam does not treat integers and floats generically, there is a pattern of an extra `.` to separate `Int` operators from `Float` operators.

| Operator          | Elm           | Gleam | Notes                                          |
| ----------------- | ------------- | ----- | ---------------------------------------------- |
| Equal             | `==`          | `==`  | In Gleam both values must be of the same type  |
| Not equal         | `/=`          | `!=`  | In Gleam both values must be of the same type  |
| Greater than      | `>`           | `>`   | In Gleam both values must be **ints**          |
| Greater than      | `>`           | `>.`  | In Gleam both values must be **floats**        |
| Greater or equal  | `>=`          | `>=`  | In Gleam both values must be **ints**          |
| Greater or equal  | `>=`          | `>=.` | In Gleam both values must be **floats**        |
| Less than         | `<`           | `<`   | In Gleam both values must be **ints**          |
| Less than         | `<`           | `<.`  | In Gleam both values must be **floats**        |
| Less or equal     | `<=`          | `>=`  | In Gleam both values must be **ints**          |
| Less or equal     | `<=`          | `>=.` | In Gleam both values must be **floats**        |
| Boolean and       | `&&`          | `&&`  | Both values must be **bools**                  |
| Boolean or        | `||`          | `||`  | Both values must be **bools**                  |
| Add               | `+`           | `+`   | In Gleam both values must be **ints**          |
| Add               | `+`           | `+.`  | In Gleam both values must be **floats**        |
| Subtract          | `-`           | `-`   | In Gleam both values must be **ints**          |
| Subtract          | `-`           | `-.`  | In Gleam both values must be **floats**        |
| Multiply          | `*`           | `*`   | In Gleam both values must be **ints**          |
| Multiply          | `*`           | `*.`  | In Gleam both values must be **floats**        |
| Divide            | `//`          | `/`   | Both values must be **ints**                   |
| Divide            | `/`           | `/.`  | In Gleam both values must be **floats**        |
| Modulo            | `remainderBy` | `%`   | Both values must be **ints**                   |
| Pipe              | `|>`          | `|>`  | Gleam's pipe can pipe into anonymous functions |


## Type Aliases

Elm uses type aliases to define the layout of records. Gleam uses Custom Types to achieve a similar result.

Gleam's custom types allow you to define a collection data type with a fixed number of named fields, and the values in those fields can be of differing types.

#### Elm

```elm
type alias Person =
 { name : String
 , age : Int 
 }

person = Person "Jake" 35
name = person.name
```

#### Gleam

Gleam's custom types can be used in much the same way. At runtime, they have a tuple representation and are compatible with Erlang records.

```gleam
type Person {
  Person(name: String, age: Int)
}

let person = Person(name: "Jake", age: 35)
let name = person.name
```

## Custom Types

Both Elm and Gleam have a similar concept of custom types. These allow you to list out the different states that a particular piece of data might have.

#### Elm

The following example might represent a user in a system:

```elm
type User
  = LoggedIn String  -- A logged in user with a name
  | Guest            -- A guest user with no details
```

You must use a case-expression to interact with the contents of a value that uses a custom type:

```elm
getName : User -> String
getName user =
    case user of
        LoggedIn name ->
            name

        Guest ->
            "Guest user"

```

A custom type with a single entry can be used to help create opaque data types for your module's API if only the type and not the single constructor is exported.

#### Gleam

```gleam
type User {
  LoggedIn(name: String)  // A logged in user with a name
  Guest                   // A guest user with no details
}
```

Like in Elm, you must use a case-expression to interact with the contents of a value that uses a custom type.

```gleam
fn get_name(user) {
  case user {
    LoggedIn(name) -> name
    Guest -> "Guest user"
  }
}
```

In Gleam, a custom type with a single entry that has fields of its own fills the role of `type alias` in Elm. 

In order to create an opaque data type, you can use the [`opaque`](../book/tour/custom-types.html#opaque-types) keyword.


### Maybe

Neither Gleam nor Elm have a concept of 'null' in their type system. Elm uses `Maybe` to handle this case. Gleam uses a similar approach called `Option`.

#### Elm

In Elm, `Maybe` is defined as:

```elm
type Maybe a
    = Just a
    | Nothing
```

#### Gleam

In Gleam, `Option` is defined as:

```gleam
pub type Option(a) {
  Some(a)
  None
}
```

The standard library provides the [gleam/option](https://hexdocs.pm/gleam_stdlib/gleam/option.html) module for interacting with `Option` values.

### Result

Neither Gleam nor Elm have exceptions and instead represent failures using the `Result` type. 

#### Elm

Elm's `Result` type is defined as:

```elm
type Result error value
    = Ok value
    | Err error
```

#### Gleam

In Gleam, the `Result` type is defined in the compiler in order to support helpful warnings and error messages. 

If it were defined in Gleam, it would look like this:

```gleam
pub type Result(value, reason) {
  Ok(value)
  Error(reason)
}
```

The standard library provides the [gleam/result](https://hexdocs.pm/gleam_stdlib/gleam/result.html) module for interacting with `Result` values.

Gleam has a `try` keyword that allows for early exit from a block if a `Result` is an error. The equivalent in Elm would require the use of `Result.andThen`. The `try` keyword in Gleam provides syntactic sugar which simplifies functions that handle results.


## If expressions

#### Elm

Elm has syntax for if-expressions for control flow based on boolean values.

```elm
description =
    if value then
        "It's true!"
    else
        "It's not true."
```

#### Gleam

Gleam has no built-in if-expression syntax and instead relies on matching on boolean values in case-expressions to provide this functionality:

```gleam
let description =
  case value {
    True -> "It's true!"
    False -> "It's not true."
  }

description  // => "It's true!"
```

## Case expressions

Both Gleam and Elm support case-expressions for pattern matching on values including custom types.

#### Elm

```elm
getName : User -> String
getName user =
    case user of
        LoggedIn name ->
            name

        Guest ->
            "Guest user"
```

#### Gleam

```gleam
fn get_name(user) {
  case user {
    LoggedIn(name) -> name
    Guest -> "Guest user"
  }
}
```

Pattern matching on multiple values at the same time is supported:

```gleam
case x, y {
  1, 1 -> "both are 1"
  1, _ -> "x is 1"
  _, 1 -> "y is 1"
  _, _ -> "neither is 1"
}
```

Guard expressions can also be used to limit when certain patterns are matched:


```gleam
case xs {
  [a, b, c] if a == b && b != c -> "ok"
  _other -> "ko"
}
```

For more information and examples, see the [case expressions](../book/tour/case-expressions.html) entry in the [Gleam language tour](../book/tour/index.html).

## Commands

#### Elm

Elm is a pure language so all side-effects, eg. making an HTTP request, are managed by the command system. This means that functions for making HTTP requests return an opaque command value that you return to the runtime, normally via the update function, in order to execute the request.

#### Gleam

Gleam is not a pure language and so does not have a command system for managing side-effects. Any function can directly perform side effects and where necessary will manage success and failure using the `Result` type or other more specific custom types.

## Talking to other languages

#### Elm

Elm programs compile to JavaScript and primarily allow you to talk to JavaScript via [ports](https://guide.elm-lang.org/interop/ports.html). Elm does not have an accessible foreign function interface for calling JavaScript directly from Elm code. Only core modules can do that. Ports provide a message-passing interface between the Elm application and JavaScript. It is very safe. It is almost impossible to cause runtime errors in your Elm code by passing incorrect values to or from ports. This makes Elm a very safe language with very good guarantees against runtime exceptions but at the cost of some friction when the developer wants to interact with JavaScript.


#### Gleam

Gleam provides syntax for directly calling Erlang functions. The developer specifies the types for the Erlang function and the compiler assumes those types are accurate. This means less friction when calling Erlang code but also means less of a guarantee of safety as the developer might get the types wrong.

Functions that call Erlang code directly use the `external` keyword and use strings to refer to the Erlang function to call.

It is possible to call functions provided by other languages on the Erlang Virtual Machine but only via the Erlang name that those functions end up with.


```gleam
pub external fn random_float() -> Float = "rand" "uniform"

// Elixir modules start with `Elixir.`
pub external fn inspect(a) -> a = "Elixir.IO" "inspect"
```

## Architecture

#### Elm

Elm has 'The Elm architecture' baked into the language and the core modules. Generally speaking, all Elm applications follow the Elm architecture. Elm is generally focused on writing front-end browser applications and the architecture serves it well.

#### Gleam

Gleam does not have a set architecture. It is not focused on making front-end browser applications and so does not share the same constraints. As it compiles to Erlang, Gleam application architecture is influenced by Erlang approaches to building distributed, fault-tolerant systems including working with [OTP](http://erlang.org/faq/introduction.html#idp32109712). In order to create a type-safe version of the OTP approach, Gleam has its own [gleam/otp](https://hexdocs.pm/gleam_otp/) library.  

## Package management

#### Elm

Elm packages are installed via the `elm install` command and are hosted on [package.elm-lang.org](https://package.elm-lang.org/).

All third-party Elm packages are written in pure Elm. It is not possible to publish an Elm package that includes JavaScript code unless you are in the core team. Some packages published under the `elm` and `elm-explorations` namespaces have JavaScript internals.

#### Gleam

Gleam packages are installed via the `gleam add` command and are hosted on [hex.pm](https://hex.pm/) with their documentation on [hexdocs.pm](https://hexdocs.pm/).

All Gleam packages can be published with a mix of Gleam and Erlang code. There are no restrictions on publishing packages with Erlang code or that wrap Erlang libraries.

## Implementation

#### Elm

The Elm compiler is written in [Haskell](https://www.haskell.org/) and distributed primarily via [npm](https://www.npmjs.com/). The core libraries are written in a mix of Elm and JavaScript.

#### Gleam

The Gleam compiler is written in [Rust](https://www.rust-lang.org/) and distributed as [precompiled binaries](https://gleam.run/getting-started/#installing-gleam) or via some [package managers](https://gleam.run/getting-started/#installing-gleam). The core libraries are written in a mix of Gleam and Erlang.

## Other concepts

### Atoms

Gleam has the concept of 'atoms' inherited from Erlang. Any value in a type definition in Gleam that does not have any arguments is an atom in the compiled Erlang code.

There are some exceptions to that rule for atoms that are commonly used and have types built-in to Gleam that incorporate them, such as `Ok`, `Error` and booleans.

In general, atoms are not used much in Gleam, and are mostly used for booleans, `Ok` and `Error` result types, and defining custom types.

Custom types in Elm can be used to achieve simmilar things to atoms.

#### Elm

```elm
type Alignment 
  = Left
  | Centre
  | Right
```

#### Gleam

```gleam
type Alignment {
  Left
  Centre
  Right
}
```
