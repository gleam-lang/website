# Gleam for Erlang users

- [Comments](#comments)
- [Variables](#variables)
  - [Partial assignments](#partial-assignments)
  - [Variable type annotations](#variable-type-annotations)
- [Functions](#functions) TODO
  - [Function type annotations](#function-type-annotations) TODO
  - [Function heads](#function-heads) TODO
  - [Referencing functions](#referencing-function) TODO
- [Operators](#operators)
- [Constants](#constants)
- [Blocks](#blocks) TODO
- [Data types](#data-types) TODO
  - [Strings](#strings) TODO
  - [Tuples](#tuples) TODO
  - [Lists](#lists) TODO
  - [Atoms](#atoms) TODO
  - [Maps](#maps) TODO
- [Type aliases](#type-aliases) TODO
- [Custom types](#custom-types) TODO
  - [Records](#records) TODO
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

```rust,noplaypen
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

```rust,noplaypen
let [element] = some_list // Compile error! Partial pattern
assert [element] = some_list
```

### Variables type annotations

#### Erlang

In Erlang it's not possible to give type annotations to variables.

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```rust,noplaypen
let some_list: List(Int) = [1, 2, 3]
```

Gleam will check the type annotation to ensure that it matches the type of the
assigned value.

Gleam does not need annotations to type check your code, but you may find it
useful to annotate variables to hint to the compiler that you want a specific
type to be inferred.


## Comments

#### Erlang

In Erlang comments are written with a `%` prefix.

```erlang
% Hello, Joe!
```

#### Gleam

In Gleam comments are written with a `//` prefix.

```rust,noplaypen
// Hello, Joe!
```

Comments starting with `///` are used to document the following statement,
comments starting with `////` are used to document the current module.

```rust,noplaypen
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
| Modulo           | `rem`     | `%`   | In Gleam both values must be ints
| Pipe             |           | `⎮>`  | See [the pipe section](#pipe) for details

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

```rust,noplaypen
const the_answer = 42

fn main() {
  the_answer
}
```

Gleam constants can be referenced from other modules.

```rust,noplaypen
import other_module

fn main() {
  other_module.the_answer
}
```

