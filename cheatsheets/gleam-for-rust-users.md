---
layout: page
title: Gleam for Rust users
---

- [Comments](#comments)
- [Variables](#variables)
  - [Match operator](#match-operator)
  - [Variables type annotations](#variables-type-annotations)
- [Functions](#functions)
  - [Exporting functions](#exporting-functions)
  - [Function type annotations](#function-type-annotations)
  - [Function overloading](#function-overloading)
  - [Referencing functions](#referencing-function)
  - [Labelled arguments](#labelled-arguments)
- [Modules](#modules)
- [Operators](#operators)
- [Constants](#constants)
- [Blocks](#blocks)
- [Data types](#data-types)
  - [Strings](#strings)
  - [Tuples](#tuples)
  - [Lists](#lists)
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

Comments look very similar in both languages.

#### Rust

In Rust comments are written with a `//` prefix.

```rust
// Hello, Joe!
```

Comments starting with `///` are used to document the following statement. Comments starting with `//! are used to document the current module.

```rust
//! This module is very important.

/// The answer to life, the universe, and everything.
const answer: u64 = 42;
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

You can declare and redeclare variables in both languages by using the `let` keyword. Variables are immutable in both languages.

#### Rust

```rust
let size = 50;
let size = size + 100;
let size = 1;
```

#### Gleam

```gleam
let size = 50
let size = size + 100
let size = 1
```

Gleam doesn't have a `mut` keyword to mark variables as mutable, they're always immutable.

### Match operator

#### Rust

In Rust, `let` and `=` can be used for pattern matching, but you'll get compile errors if there's a type mismatch.

```rust
let [x] = [1];
let 2 = x; // compile error
let [y] = "Hello"; // compile error, type mismatch
```

#### Gleam

In Gleam, `let` and `=` can also be used for pattern matching, but you'll get compile errors if there's a type mismatch, and a runtime error if there's a value mismatch. For assertions, the equivalent `assert` keyword is preferred.

```gleam
let [x] = [1]
assert 2 = x // runtime error
assert [y] = "Hello" // compile error, type mismatch
```

### Variables type annotations

Both languages allow you to annotate variables with types in a similar style. The compilers will check that the type matches the variable's assigned value. Both languages allow you to skip type annotation, and will instead infer the type from the provided value.

#### Rust

```rust
let some_list: [u64; 3] = [1, 2, 3];
let other_list = [1, 2, 3];
```

#### Gleam

```gleam
let some_list: List(Int) = [1, 2, 3]
let other_list = [1, 2, 3]
```

## Functions

#### Rust

```rust
pub fn sum(x: u64, y: u64) -> u64 {
  x + y
}

let mul = |x, y| x * y;
mul(1, 2);
```

#### Gleam

Gleam's functions are declared using a syntax similar to Rust's. Anonymous functions are a bit different from Rust, using the `fn` keyword again.

```gleam
pub fn sum(x, y) {
  x + y
}

let mul = fn(x, y) { x * y }
mul(1, 2)
```

### Exporting functions

Both languages use the same system, where functions are private by default, and need the `pub` keyword to be marked as public.

#### Rust

```rust
// this is public
pub fn sum(x: u64, y: u64) -> u64 {
    x + y
}

// this is private
fn mul(x: u64, y: u64) -> u64 {
    x * y
}
```

#### Gleam

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

#### Rust

Rust functions **always** need type annotations.

```rust
pub fn sum(x: u64, y: u64) -> u64 {
  x + y
}

pub fn mul(x: u64, y: u64) -> u64 {
  x * y
}
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

### Function overloading

Like Rust, Gleam does not support function overloading, so there can only
be 1 function with a given name, and the function can only have a single
implementation for the types it accepts.

### Referencing functions

Referencing functions in Gleam works like in Rust, without any special syntax.

#### Rust

```rust
fn identity(x: u64) -> u64 {
  x
}

fn main() {
  let func = identity;
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

In Gleam arguments can be given a label as well as an internal name. As with
Erlang the name used at the call-site does not have to match the name used
for the variable inside the function.

There is no performance cost to Gleam's labelled arguments as they are
optimised to regular function calls at compile time, and all the arguments
are fully type checked.

```rust
pub fn replace(inside string, each pattern, with replacement) {
  go(string, pattern, replacement)
}
```

```elixir
replace(each: ",", with: " ", inside: "A,B,C")
```

There is no equivalent feature in Rust.


## Operators

| Operator         | Rust  | Gleam | Notes                                          |
| ---------------- | ----- | ----- | ---------------------------------------------- |
| Equal            | `==`  | `==`  |                                                |
| Not equal        | `!=`  | `!=`  |                                                |
| Greater than     | `>`   | `>`   | In Gleam both values must be **ints**          |
| Greater than     | `>`   | `>.`  | In Gleam both values must be **floats**        |
| Greater or equal | `>=`  | `>=`  | In Gleam both values must be **ints**          |
| Greater or equal | `>=`  | `>=.` | In Gleam both values must be **floats**        |
| Less than        | `<`   | `<`   | In Gleam both values must be **ints**          |
| Less than        | `<`   | `<.`  | In Gleam both values must be **floats**        |
| Less or equal    | `<=`  | `<=`  | In Gleam both values must be **ints**          |
| Less or equal    | `<=`  | `<=.` | In Gleam both values must be **floats**        |
| Boolean and      | `&&`  | `&&`  | Both values must be **bools**                  |
| Boolean or       | `||`  | `||`  | Both values must be **bools**                  |
| Add              | `+`   | `+`   | In Gleam both values must be **ints**          |
| Add              | `+`   | `+.`  | In Gleam both values must be **floats**        |
| Subtract         | `-`   | `-`   | In Gleam both values must be **ints**          |
| Subtract         | `-`   | `-.`  | In Gleam both values must be **floats**        |
| Multiply         | `*`   | `*`   | In Gleam both values must be **ints**          |
| Multiply         | `*`   | `*.`  | In Gleam both values must be **floats**        |
| Divide           | `/`   | `/`   | Both values must be **ints**                   |
| Divide           | `/`   | `/.`  | In Gleam both values must be **floats**        |
| Modulo           | `%`   | `%`   | Both values must be **ints**                   |
| Pipe             |       | `⎮>`  | Gleam's pipe can pipe into anonymous functions |

## Constants

#### Rust

In Rust constants can be created using the `const` keyword, and have to be given a type annotation.

```rust
const the_answer: u64 = 42;

pub fn main() {
  the_answer;
}
```

In Rust, public constants can be referenced from other modules.

```rust
mod other_module {
  pub const the_answer: u64 = 42;
}

fn main() {
  other_module::the_answer;
}
```

#### Gleam

In Gleam constants can be created using the `const` keyword, and can be optionally given a type annotation.

```gleam
const the_answer = 42

pub fn main() {
  the_answer
}
```

Additionally, public constants can be referenced from other modules.

```rust
// in file other_module.gleam
pub const the_answer: Int = 42
```

```rust
import other_module

fn main() {
  other_module.the_answer
}
```

## Blocks

#### Rust

In Rust braces `{` `}` are used to group expressions, and arithmetic operations are grouped with parenthesis `(` `)`.

```rust
let x = {
    println!("{}", 1);
    2
};
let y = x * (x + 10); // parenthesis are used to change arithmetic operations order
```

#### Gleam

In Gleam braces `{` `}` are used to group both expressions and arithmetic operations.

```gleam
let x = {
  print(1)
  2
}
let y = x * {x + 10} // braces are used to change arithmetic operations order
```

## Data types

### Strings

In both Rust and Gleam all strings are UTF-8 encoded binaries.

#### Rust

```rust
"Hellø, world!"
```

#### Gleam

```gleam
"Hellø, world!"
```

### Tuples

#### Rust

```rust
let my_tuple = ("username", "password", 10);
let (_, password, _) = my_tuple;
```

#### Gleam

Tuples are very useful in Gleam as they're the only collection data type that allows mixed types in the collection.

```gleam
let my_tuple = #("username", "password", 10)
let #(_, password, _) = my_tuple
```

### Lists

Rust arrays and Gleam lists are similar, but Rust's are slightly more limited.

#### Rust

```rust
let list = [1, 2, 3];

let other = [0, ..list]; // Compile error!
let [0, second_element, ..] = list; // Compile error!
```

#### Gleam

The `cons` operator works the same way both for pattern matching and for appending elements to the head of a list.

```gleam
let list = [1, 2, 3]
let list = [0, ..list]
let [0, second_element, ..] = list
[1.0, ..list] // compile error, type mismatch
```

## Custom types

Custom type allows you to define a collection data type with a fixed number of named fields, and the values in those fields can be of differing types.

#### Rust

Rust has Structs, which are declared using the `struct` keyword.

```rust
struct Person {
  name: String,
  age: u64,
}

let person = Person {
  name: "Jake".to_string(),
  age: 35,
};
let name = person.name;
```

#### Gleam

Gleam's custom types can be declared using the `type` keyword. At runtime, they have a tuple representation and are compatible with Erlang records.

```gleam
type Person {
  Person(name: String, age: Int)
}

let person = Person(name: "Jake", age: 35)
let name = person.name
```

### Unions

#### Rust

Rust's union type is called Enum and declared with the `enum` keyword:

```rust
enum IpAddress {
  V4(u8, u8, u8, u8),
  V6(String)
}

let addr_v4 = IpAddress::V4(192, 168, 1, 1);
let addr_v6 = IpAddress::V6("::1".to_string());
```

#### Gleam

In Gleam, custom types become unions by having multiple constructors:

```gleam
type IpAddress {
  V4(Int, Int, Int, Int)
  V6(String)
}

let addr_v4 = V4(192, 168, 1, 1)
let addr_v6 = V6("::1")
```

## Flow control

### Case

#### Rust

When you need to match a value against multiple possible patterns, Rust has the `match` expression.
Such matches are e.g. enums or string slices:

```rust
enum MyEnum {
  A(i32),
  B,
  C,
}

let my_enum = MyEnum::A(10);

match my_enum {
  MyEnum::A(n) => do_a(n),
  MyEnum::B => do_b(),
  MyEnum::C => {
    do_sth();
    do_c()
  }
}
```

```rust
let my_str = "abcd";

match my_str {
  "abc" => do_sth(),
  "abcd" => do_sth_else(),
  _ => (),
}
```

#### Gleam

Similar to Rust's `match`, Gleam has `case`:

```gleam
type MyEnum {
  A(Int)
  B
  C
}

let x = A(10)

case x {
  A(n) -> do_a(n)
  B -> do_b()
  C -> {
    do_sth()
    do_c()
  }
}
```

## Modules

#### Rust

In Rust, the `mod` keyword allows to create a module. Multiple modules can be defined in a single file.

Rust uses the `use` keyword to import modules, and the `::` operator to access properties and functions inside.

```rust
mod foo {
    pub fn identity(x: u64) -> u64 {
        x
    }
}

mod bar {
    use super::foo;

    fn main() {
        foo::identity(1);
    }
}
```

#### Gleam

In Gleam, each file is a module, named by the file name (and its directory path). Since there is no special syntax to create a module, there can be only one module in a file.

Gleam uses the `import` keyword to import modules, and the dot `.` operator to access properties and functions inside.

```gleam
// in file foo.gleam
pub fn identity(x) {
  x
}
```

```rust
// in file main.gleam
import foo // if foo was in a folder called `lib` the import would be `lib/foo`
pub fn main() {
  foo.identity(1)
}
```
