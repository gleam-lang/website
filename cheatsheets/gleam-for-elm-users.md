---
layout: page
title: Gleam for Elm users
---

- [Overview](#overview)
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

## Overview

Elm and Gleam have similar goals of providing a robust and sound type system with an approachable
set of features. Gleam started off with a similar syntax to Elm but as moved to use one that is more
familiar to many developers.

Where Elm compiles to Javascript, Gleam initially aimed to compile to Erlang. Where Elm is best
suited for front-end browser based applications, Gleam initially targets a back-end ecosystem.

There is work in progess to compile Gleam to Javascript which opens up the possibility for front-end
development.

One area in which Elm and Gleam differ in their approach is where Elm does not provide easy access
to defining foreign-function-interfaces for interacting with Javascript libraries. In contrast to
this, Gleam makes it easy to define this inferfaces for using Erlang libraries.

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

```rust
// Hello, Joe!
```

Comments starting with `///` are used to document the following statement. Comments starting with `////` are used to document the current module.

```rust
//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
```

There are no multiline commends in Gleam.

## Variables

#### Elm

In Elm, you assign variables in let-blocks and you cannot re-assign variables within a let-block. 

You also cannot create a variable with the same name as a variable from a higher scope.

```Elm
let
    size = 50
    size = size + 100 -- Compile Error!
in
```

#### Gleam

Gleam has the `let` keyword before its variable names. You can re-assign variables and you can
shadow variables from other scopes.

```rust
let size = 50
let size = size + 100
let size = 1
```

### Match operator

Both langauges supporting pattern matching.

#### Elm

Elm supports pattern matching or destructuring in assignment but only when the matching is
exhaustive. This means you can use assignment to destructure a tuple but not
elements of a list.


```elm
(x, y) = (1, 2) -- set x = 1 and y = 2
[x] = [5]       -- Compile error
```

Additionally, `=` is used for assignments not for matching in the way that Gleam and Erlang support
it. The follow statement is an error in Elm.

```elm
2 = x           -- Compile error
```

#### Gleam

In Gleam, `let` and `=` can be used for pattern matching, but you'll get compile errors if there's a type mismatch, and a runtime error if there's a value mismatch. For assertions, the equivalent `assert` keyword is preferred.

```rust
let [x] = [1]
assert 2 = x // runtime error
assert [y] = "Hello" // compile error, type mismatch
```

### Variables type annotations

Both Elm and Gleam will check the type annotation to ensure that it matches the type of the assigned value. They do not need annotations to type check your code, but you may find it useful to annotate variables to hint to the compiler that you want a specific type to be inferred.

#### Elm

In Elm, type annotations are optionally given on the line above the variable assignment. They can be
provided in let-blocks but it frequently only provided for top level variables and functions.

```elm
someList : List Int
someList = [1, 2, 3]
```

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```rust
let some_list: List(Int) = [1, 2, 3]
```

## Functions

#### Elm

In Elm, functions are defined as declarations that have arguments, or by assigning anonymous functions to variables.

```elixir
sum x y =
  x + y

mul =
  \x y -> x * y

mul 3 2
-- 6
```

#### Gleam

Gleam's functions are declared using a syntax similar to Rust or JavaScript. Gleam's anonymous functions are declared using the `fn` keyword.

```rust
pub fn sum(x, y) {
  x + y
}

let mul = fn(x, y) { x * y }
mul(1, 2)
```

### Exporting functions

#### Elm

In Elm, exports are handled at the top of the file in the module declaration as a list of names.

```elixir
module Math exposing (sum)

-- this is public as it is in the export list
sum x y =
  x + y

-- this is private as it isn't in the export list
mul x y =
  x * y
```

#### Gleam

In Gleam functions are private by default and need the `pub` keyword to be public.

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

#### Elm

In Elm, functions can **optionally** have their argument and return types annotated. These type annotations will always be checked by the compiler and throw a compilation error if not valid. The compiler will still type check your program using type inference if annotations are omitted.


```elm
sum : number -> number -> number
sum x y = x + y

@spec mul(number, number) :: boolean # no Elixir compile error
mul : number -> number -> Bool -- Compile error
mul x y = x * y
```

#### Gleam

All the same things are true of Gleam though the type annotations go inline in the function
declaration, rather than above it.

```rust
pub fn add(x: Int, y: Int) -> Int {
  x + y
}

pub fn mul(x: Int, y: Int) -> Bool { // compile error, type mismatch
  x * y
}
```

