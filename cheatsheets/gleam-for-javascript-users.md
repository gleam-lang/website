---
layout: page
title: Gleam for JavaScript users
subtitle: Hello JavaScripticians!
---

<!-- TODO table of contents -->

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
- [Flow control](#flow-control)
  - [Case](#case)
  - [Piping](#piping)
  - [Try](#try)


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
 * @param {string} str    String passed to quux
 * @returns {string}      An unprocessed string
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

### Notes on operators

- JavaScript operators are short-circuiting as in Gleam.
- Gleam's `/` operator always returns an integer.
- Chains and pipes:
  - In JavaScript chaining is usually done by constructing class methods that
    return an object: `foo.bar(1).quux(2)` means `bar(1)` is called as a method
    of `foo` and then `quux()` is called as a method of the return value
    (object) of the `bar(1)` call.
  - In contrast in Gleam piping, no objects are being returned but mere data is
    pushed from left to right, much like in unix tooling.

## Constants

#### JavaScript

In JavaScript constants are just regular variables using the `const` keyword.

```javascript
const THE_ANSWER = 42;

function main() {
  const justANormalVariable = "can also use the const keyword";
  return THE_ANSWER;
}
```

#### Gleam

In Gleam constants are also created using the `const` keyword. The difference to
JavaScript is that Gleam constants can only live at the top-level of a module
(not inside a function), and variables defined using `let` can only live inside
functions (not at the top-level of a module).

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

#### JavaScript

In JavaScript statements can be grouped together using braces `{` `}`. These
blocks are usually associated with specific language constructs like functions,
conditionals, loops, etc. The only way to create multi-line expression blocks
like in Gleam is using an immediately-invoked function expression (IIFE).

Parentheses `(` `)` are used to group arithmetic expressions.

```javascript
function main() {
  // x gets assigned the result of the IIFE
  const x = (() => {
    console.log(1);
    return 2;
  })();
  const y = x * (x + 10);  // parentheses are used to change arithmetic operations order
  return y;
}
```

#### Gleam

In Gleam curly braces, `{` and `}`, are used to group expressions.

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

Unlike in JavaScript, in Gleam function blocks are always expressions, so are
`case` blocks or arithmetic sub groups. Because they are expressions they always
return a value.

For Gleam the last value in a block's expression is always the value being
returned from an expression.

## Data types

### Strings

#### JavaScript

In JavaScript strings are sequences of UTF-16 code units, and can be delimited
by single quotes `'`, double quotes `"`, or backticks <code>&grave;</code>.
Strings using backticks support interpolation.

```javascript
const world = 'world';
"Hellø, world!"
`Hello, ${world}!`
```

#### Gleam

In Gleam strings are encoded as UTF-8 binaries, and must be delimited by double
quotes. Gleam strings do not allow interpolation, yet. Gleam however offers a
`string_builder` via its standard library for performant string building.

```gleam
"Hellø, world!"
```

### Tuples

Tuples are very useful in Gleam as they're the only collection data type that
allows mixed types in the collection.

#### JavaScript

JavaScript doesn't have a concept of tuples, but some tuple behavior can be
imitated using arrays.

```javascript
const myArray = ["username", "password", 10];
const [_, password] = myArray;
console.log(password); // "password"
// Direct index access
console.log(myArray[0]); // "username"
```

#### Gleam

```gleam
let my_tuple = #("username", "password", 10)
let #(_, pwd, _) = my_tuple
io.print(pwd) // "password"
// Direct index access
io.print(my_tuple.0) // "username"
```

### Lists

Arrays in JavaScript are allowed to be of mixed types, but not in Gleam.

#### JavaScript

JavaScript arrays are delimited by square brackets `[` `]`. The `...` operator
can insert one array into another.

```javascript
let list = [2, 3, 4];
list = [1, ...list, 3];
const [firstElement, secondElement, ...rest] = list;
console.log(["hello", ...list]); // works
```

#### Gleam

Gleam has a "cons" operator that works for lists destructuring and pattern
matching. In Gleam lists are immutable so adding and removing elements from the
start of a list is highly efficient.

```gleam
let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // compile error, type mismatch
```

An important difference between Gleam's "cons" operator and JavaScript's `...`
is that the `..tail` can only appear as the last item between the brackets.

```gleam
let list = [2, 3, 4]
let list = [1, ..list] // works
let list = [1, 2, ..list] // still works
let list = [1, ..list, 5] // compile error
```

### Maps

#### JavaScript

In JavaScript, key–value pairs are usually stored in objects, whose keys can
only be strings, numbers, or symbols. There is also the `Map` class, which
allows any type to be used for keys. In both cases, types of keys and values can
be mixed in a given map.

```javascript
const map1 = {
  key1: "value1",
  key2: 5,
};
```

#### Gleam

In a Gleam map, the type for keys and the type for values are fixed. So, for
example, you can't have a map with some `String` values and some `Int` values,
and you can't have a map with some `String` keys and some `Int` values. But you
can have a map with `String` keys and `Int` values.

There is no map literal syntax in Gleam, and you cannot pattern match on a map.
Maps are generally not used much in Gleam, custom types are more common. (You
would usually translate a TypeScript `type`, `class`, or `interface` to a Gleam
custom type, and TypeScript `Map`s and `Record`s to Gleam maps.)

```gleam
import gleam/map

map.from_list([#("key1", "value1"), #("key2", "value2")])
map.from_list([#("key1", "value1"), #("key2", 2)]) // Type error!
```


