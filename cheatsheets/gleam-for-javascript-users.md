---
layout: page
title: Gleam for JavaScript users
subtitle: Hello JavaScripticians!
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

### JavaScript

In JavaScript, comments are written with a `//` prefix.

```javascript
// Hello, Joe!
```

Multi-line comments may be written like so:

```javascript
/*
 * Hello, Joe!
 */
```

In JavaScript, above `class` and `function` declarations there can be
`docblocks` like so:

```javascript
/**
 * A Bar class
 */
class Bar {}

/**
 * A quux function.
 *
 * @param {string} str        String passed to quux
 * @returns {string}          An unprocessed string
 */
function quux(string) { return str; }
```

Documentation blocks (docblocks) are extracted into generated API
documentation.

### Gleam

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

In JavaScript, you can declare variables using `let`, `const`, or `var`. `let`
and `var` variables can be reassigned, and `const`s cannot.

#### JavaScript

```javascript
let size = 50;
size = size + 100;

const height = 60;
const height = height + 100; // Error!
```

#### Gleam

Gleam has the `let` keyword before each variable assignment. Variables can be
reassigned, but each assignment must start with the `let` keyword.

```gleam
let size = 50
let size = size + 100
let size = 1
```

### Variables type annotations

#### JavaScript/TypeScript

In plain JavaScript there are no static types, but in TypeScript variables can
optionally be annotated with types.

```typescript
const some_list: number[] = [1, 2, 3];
```

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```gleam
let some_list: List(Int) = [1, 2, 3]
```

Gleam will check the type annotation to ensure that it matches the type of the assigned value. It does not need annotations to type-check your code, but you may find it useful to annotate variables to hint to the compiler that you want a specific type to be inferred.

## Functions

#### JavaScript

In JavaScript, you can define functions with the `function` keyword, or assign
anonymous functions to variables.

```javascript
function sum(x, y) {
  return x + y;
}

const mul = (x, y) => x * y;
```

#### Gleam

Gleam's functions are declared using a syntax similar to Rust. Gleam's anonymous functions have a similar syntax, just without the function name.

```gleam
pub fn sum(x, y) {
  x + y
}

let mul = fn(x, y) { x * y }
mul(1, 2)
```

### Exporting functions

#### JavaScript

In both JavaScript and Gleam, functions are private by default. In JavaScript,
functions can be made public with the `export` keyword.

```javascript
// this is public
export function sum(x, y) {
  return x + y;
}

// this is private
function mul(x, y) {
  return x * y;
}
```

#### Gleam

In Gleam functions need the `pub` keyword to be public.

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

#### JavaScript/TypeScript

In TypeScript, you can annotate the types of function parameters and return
values.

```typescript
function sum(x: number, y: number): number {
  return x + y;
}
```

The choice of whether, and exactly how to annotate a function can influence how
type-safe your code is.

#### Gleam

In Gleam, functions can **optionally** have their argument and return types
annotated. These type annotations will always be checked by the compiler and
throw a compilation error if not valid. The compiler will still type check your
program using type inference if annotations are omitted.

```gleam
pub fn add(x: Int, y: Int) -> Int {
  x + y
}

pub fn mul(x: Int, y: Int) -> Bool { // compile error, type mismatch
  x * y
}
```

### Function overloading

Like JavaScript, Gleam does not support function overloading, so there can only
be 1 function with a given name, and the function can only have a single
implementation for the types it accepts.

### Referencing functions

Referencing functions in Gleam works like in JavaScript, without any special
syntax.

#### JavaScript
```javascript
function identity(x) {
  return x
}

function main() {
  const func = identity;
  func(100);
}
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


### Labelled arguments

#### JavaScript

JavaScript doesn't really have a syntax for passing arguments by name and in any
order, but this behavior can be approximated using an object literal.

```javascript
function replace({ inside: string, each: pattern, with: replacement }) {
  go(string, pattern, replacement)
}
```

```javascript
replace({ each: ",", with: " ", inside: "A,B,C" });
```

Because the arguments are stored in an object there is a small runtime
performance penalty for this pattern.

#### Gleam

In Gleam arguments can be given a label as well as an internal name. The name
used at the call-site does not have to match the name used for the variable
inside the function.

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

| Operator          | JavaScript | Gleam | Notes                                          |
| ----------------- | ---------- | ----- | ---------------------------------------------- |
| Equal             | `==`       | `==`  | In Gleam both values must be of the same type  |
| Strictly equal to | `===`      | `==`  | Comparison in Gleam is always strict           |
| Not equal         | `!==`      | `!=`  | In Gleam both values must be of the same type  |
| Greater than      | `>`        | `>`   | In Gleam both values must be **ints**          |
| Greater than      | `>`        | `>.`  | In Gleam both values must be **floats**        |
| Greater or equal  | `>=`       | `>=`  | In Gleam both values must be **ints**          |
| Greater or equal  | `>=`       | `>=.` | In Gleam both values must be **floats**        |
| Less than         | `<`        | `<`   | In Gleam both values must be **ints**          |
| Less than         | `<`        | `<.`  | In Gleam both values must be **floats**        |
| Less or equal     | `<=`       | `<=`  | In Gleam both values must be **ints**          |
| Less or equal     | `<=`       | `<=.` | In Gleam both values must be **floats**        |
| Boolean and       | `&&`       | `&&`  | In Gleam both values must be **bools**         |
| Boolean or        | `||`       | `||`  | In Gleam both values must be **bools**         |
| Add               | `+`        | `+`   | In Gleam both values must be **ints**          |
| Add               | `+`        | `+.`  | In Gleam both values must be **floats**        |
| Subtract          | `-`        | `-`   | In Gleam both values must be **ints**          |
| Subtract          | `-`        | `-.`  | In Gleam both values must be **floats**        |
| Multiply          | `*`        | `*`   | In Gleam both values must be **ints**          |
| Multiply          | `*`        | `*.`  | In Gleam both values must be **floats**        |
| Divide            | `/`        | `/`   | In Gleam both values **ints**                  |
| Divide            | `/`        | `/.`  | In Gleam both values must be **floats**        |
| Remainder         | `%`        | `%`   | In Gleam both values must be **ints**          |
| Concatenate       | `+`        | `<>`  | In Gleam both values must be **strings**       |
| Pipe              |            | `|>`  | Gleam's pipe can pipe into anonymous functions |

