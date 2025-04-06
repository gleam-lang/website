---
layout: page
title: The Gleam Language Server reference
subtitle: Gleam IDE features for all editors
---

The Gleam Language Server is a program that can provide IDE features to text
editors that implement the language server protocol, such as VS Code and Neovim.
This document details the current state of the language server and its features.

- [Project Status](#project-status)
- [Installation](#installation)
  - [Helix](#helix)
  - [Neovim](#neovim)
  - [VS Code](#vs-code)
  - [Zed](#zed)
  - [Other editors](#other-editors)
- [Features](#features)
  - [Multiple project support](#multiple-project-support)
  - [Project compilation](#project-compilation)
  - [Error and warning diagnostics](#error-and-warning-diagnostics)
  - [Code formatting](#code-formatting)
  - [Hover](#hover)
  - [Go-to definition](#go-to-definition)
  - [Go-to type definition](#go-to-type-definition)
  - [Code completion](#code-completion)
  - [Rename](#rename)
  - [Document symbols](#document-symbols)
  - [Signature help](#signature-help)
- [Code actions](#code-actions)
  - [Add annotations](#add-annotations)
  - [Add missing import](#add-missing-import)
  - [Add missing patterns](#add-missing-labels)
  - [Case correction](#case-correction)
  - [Convert to and from pipe](#convert-to-and-from-pipe)
  - [Convert to and from use](#convert-to-and-from-use)
  - [Discard unused result](#discard-unused-result)
  - [Expand function capture](#expand-function-capture)
  - [Extract variable](#extract-variablee)
  - [Fill labels](#fill-labels)
  - [Generate decoder](#generate-decoder)
  - [Generate function](#generate-function)
  - [Generate JSON encoder](#generate-json-encoder)
  - [Inexhaustive let to case](#inexhaustive-let-to-case)
  - [Inline variable](#inline-variable)
  - [Interpolate string](#interpolate-string)
  - [Pattern match](#pattern-match)
  - [Qualify and unqualify](#qualify-and-unqualify)
  - [Remove redundant tuples](#remove-redundant-tuples)
  - [Remove unused imports](#remove-unused-imports)
  - [Use label shorthand syntax](#use-label-shorthand-syntax)
- [Security](#security)
- [Use outside Gleam projects](#use-outside-gleam-projects)


# Project Status

The Gleam Language Server is an official Gleam project and the newest part of
the Gleam toolchain. It is actively being developed and is rapidly improving,
but it does not have all the features you might find in more mature language
servers for older languages.

If you wish to to see what is currently being worked on you can view 
[the project roadmap](https://github.com/orgs/gleam-lang/projects/4) on GitHub.


# Installation

The Gleam Language Server is included in the regular `gleam` binary, so if you
have Gleam installed then you have the Gleam language server installed. You may
need to configure your editor to use the language server for Gleam code.

## Helix

Helix supports the language server out-of-the-box. No additional configuration
is required and Helix will automatically start the language server when a Gleam
file is opened.

## Neovim

Neovim's [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) includes
configuration for Gleam. Install `nvim-lspconfig` with your preferred plugin
manager and then add the language server to your `init.lua`.

```lua
require('lspconfig').gleam.setup({})
```

The language server will then be automatically started when you open a Gleam
file.

If you are using [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
you can run `:TSInstall gleam` to get syntax highlighting and other tree-sitter
features.

## VS Code

Install the [VS Code Gleam plugin](https://marketplace.visualstudio.com/items?itemName=Gleam.gleam).

The language server will then automatically started when you open a Gleam
file. If VS Code is unable to run the language server ensure that the `gleam`
binary is included on VS Code's `PATH`, and consider restarting VS Code.

## Zed

Zed supports the language server out-of-the-box. No additional configuration
is required and Zed will automatically start the language server when a Gleam
file is opened.

## Other Editors

Any other editor that supports the Language Server Protocol can use the Gleam
Language Server. Configure your editor to run `gleam lsp` from the root of your
workspace.

# Features

## Multiple project support

You can open Gleam files from multiple projects in one editor session and the
Gleam language server will understand which projects they each belong to, and
how to work with each of them.

## Project compilation

The language server will automatically compile code in Gleam projects opened in
the editor. Code generation and Erlang compilation are not performed.

If any files are edited in the editor but not yet saved then these edited
versions will be used when compiling in the language server.

The target specified in `gleam.toml` is used by the language server. If no
target is specified then it defaults to Erlang.

## Error and warning diagnostics

Any errors and warnings found when compiling Gleam code are surfaced in the
editor as language server diagnostics.

## Code formatting

The language server can format Gleam code using the Gleam formatter. You may
want to configure your code to run this automatically when you save a file.

## Hover

The language server will show documentation, types, and other information when
hovering on:

- Constants.
- Import statements, including unqualified values and types.
- Module functions.
- Module qualifiers.
- Patterns.
- Record fields.
- The `..` used to ignore additional fields in record pattern.
- Type annotations.
- Values.

## Go-to definition

The language server supports go-to definition for:

- Constants.
- Functions.
- Import statements, including unqualified values and types.
- Type annotations.
- Variables.

## Go-to type definition

The language server supports go-to type definition. When triggered on an
expression the language server will identify the types of all the values used in
the expression and present their definitions for you to view and to jump to.

## Code completion

The language server support completion of:

- Function arguments.
- Functions and constants defined in other modules, automatically adding import statements if the module has not yet been imported.
- Functions and constants defined in the same module.
- Locally defined variables.
- Modules in import statements.
- Record fields.
- Type constructors in type annotations.
- Unqualified types and values in import statements.

## Code completion

The langauge server is able to rename:

- Function arguments.
- Local variables.

## Document symbols

The language server supports listing document symbols, such as functions and
constants, for the current Gleam file.

## Signature help

The language server can show the type of each argument when calling a function,
along with the labels of the arguments that have them.

# Code actions

## Add annotations

This code action can add type annotations to assignments and functions.

```gleam
pub fn increment(x) {
  x + 1
}
```

If your cursor is within a function that does not have the all of the argument
types and the return type annotated then code action will be suggested, and if
run the code will be updated to include them:

```gleam
pub fn increment(x: Int) -> Int {
  x + 1
}
```

It can also be triggered on `let` and `use` assignments.

## Add missing import

This code action can add missing imports.

```gleam
pub fn main() -> Nil {
  io.println("Hello, world!")
}
```

If your cursor is within the `io.println` and there is an importable module with
the name `io` and a function named `println` then code action will be suggested,
and if run the code will be updated to this:

```gleam
import gleam/io

pub fn main() -> Nil {
  io.println("Hello, world!")
}
```

## Add missing patterns

This code action can add missing patterns to an inexhaustive case expression.

```gleam
pub fn run(value: Bool) -> Nil {
  case value {}
}
```

If your cursor is within the case expression then code action will be suggested,
and if run the code will be updated to this:

```gleam
pub fn run(value: Bool) -> Nil {
  case value {
    True -> todo
    False -> todo
  }
}
```

## Case correction

This code action can correct names written with the wrong case.

```gleam
pub main() {
  let myNumber = 100
}
```

If your cursor is within the name written with the wrong case then code action
will be suggested, and if run the code will be updated to this:

```gleam
pub main() {
  let my_number = 100
}
```

## Convert to and from pipe

These code actions can be used to convert between the `|>` pipe syntax and the
regular function call syntax.

```gleam
import gleam/list

pub fn main() {
  list.map([1, 2, 3], double)
}
```

If your cursor is within the list argument then the code action will be
suggested, and if run the code will be updated to this:

```gleam
import gleam/list

pub fn main() {
  [1, 2, 3] |> list.map(double)
}
```

The running the code action again will reverse this change.

You can also choose to pipe arguments other than the first by selecting them in
your editor before triggering the code action. 


## Convert to and from use

These code actions can be used to convert between the `use` syntax and the
regular function call syntax.

```gleam
pub fn main() {
  use profile <- result.try(fetch_profile(user))
  render_welcome(user, profile)
}
```

If your cursor is within one of the `use` expression then the code action will
be suggested, and if run the code will be updated to this:

```gleam
pub fn main() {
  result.try(fetch_profile(user), fn(profile) {
    render_welcome(user, profile)
  })
}
```

The running the code action again will reverse this change.

## Discard unused result

This code action assigns unused results to `_`, silencing the warning. Typically
it is better to handle the result than to ignore the possible failure.

```gleam
pub fn main() {
  function_which_can_fail()
  io.println("Done!")
}
```

If your cursor is within the result-returning-statement then code action
will be suggested, and if run the code will be updated to this:

```gleam
pub fn main() {
  let _ = function_which_can_fail()
  io.println("Done!")
}
```

## Expand function capture

This code action converts from the function capture syntax to an anonymous function.

```gleam
pub fn main() {
  let add_eleven = int.add(_, 11)
  list.map([1, 2, 3], add_eleven)
}
```

If your cursor is within the function capture then code action will be
suggested, and if run the code will be updated to this:

```gleam
pub fn main() {
  list.map([1, 2, 3], fn(value) { int.add(value, 11) })
}
```

## Extract variable

This code action assigns assigns an expression to a variable.

```gleam
pub fn main() {
  list.each(["Hello, Mike!", "Hello, Joe!"], io.println)
}
```

If your cursor is within the list then code action will be suggested, and if
run the code will be updated to this:

```gleam
pub fn main() {
  let value = ["Hello, Mike!", "Hello, Joe!"]
  list.each(value, io.println)
}
```

## Fill labels

This code action can add any expected labels to a call.

```gleam
pub fn main() {
  Date()
}
```

If your cursor is within the `Date()` import the code action will be suggested,
and if run the code will be updated to this:

```gleam
pub fn main() {
  Date(year: todo, month: todo, day: todo)
}
```

## Generate decoder

This code action can generate a dynamic decoder function from a custom type
definition.

```gleam
pub type Person {
  Person(name: String, age: Int)
}
```

If your cursor is within the `Person` then the code action will be suggested,
and if run the code will be updated to this:

```gleam
import gleam/dynamic/decode

pub type Person {
  Person(name: String, age: Int)
}

fn person_decoder() -> decode.Decoder(Person) {
  use name <- decode.field("name", decode.string)
  use age <- decode.field("age", decode.int)
  decode.success(Person(name:, age:))
}
```

## Generate function

This code action can generate the definition of a local function that is being
used but does not yet exist.

```gleam
pub fn main() {
  let items = [1, 2, 3]
  io.println(describe(items))
}
```

If your cursor is within `describe` then the code action will be suggested,
and if run the code will be updated to this:

```gleam
import gleam/io

pub fn main() {
  let items = [1, 2, 3]
  io.println(describe(items))
}

fn describe(list: List(Int) -> String {
  todo
}
```

## Generate JSON encoder

This code action can generate a function that turns a custom type value into
JSON using the `gleam_json` library.

```gleam
pub type Person {
  Person(name: String, age: Int)
}
```

If your cursor is within `Person` definition then the code action will be
suggested, and if run the code will be updated to this:

```gleam
import gleam/json

pub type Person {
  Person(name: String, age: Int)
}

fn encode_person(person: Person) -> json.Json {
  json.object([
    #("name", json.string(person.name)),
    #("age", json.int(person.age)),
  ])
}
```

## Inexhaustive let to case

This code action can convert from `let` to `case` when the pattern is not exhaustive.

```gleam
pub fn unwrap_result(result: Result(a, b)) -> a {
  let Ok(inner) = result // error: inexhaustive
  inner
}
```

If your cursor is within the `let` assignment then the code action will be
suggested, and if run the code will be updated to this:

```gleam
pub fn unwrap_result(result: Result(a, b)) -> a {
  let inner = case result {
    Ok(inner) -> inner
    Error(_) -> todo
  }
  inner
}
```

## Inline variable

This code action can inline a variable that is used only once.

```gleam
pub fn main() {
  let greeting = "Hello!"
  echo greeting
}
```

If your cursor is within the `greeting` variable then the code action will be
suggested, and if run the code will be updated to this:

```gleam
pub fn main() {
  echo "Hello!"
}
```
## Interpolate string

This code action can split a string in order to interpolate a value.

```gleam
pub fn greet(name: String) -> String {
  "Hello, !"
}
```

If your cursor is before the `!` character in the string then the code action
will be suggested, and if run the code will be updated to this:

```gleam
pub fn greet(name: String) -> String {
  "Hello, " <> todo <> "!"
}
```


If the cursor is selecting a valid Gleam name then that will be used as a
variable name in the interpolation.


```gleam
pub fn greet(name: String) -> String {
  "Hello, name!"
  //      ^^^^ This is selected
}
```
```gleam
pub fn greet(name: String) -> String {
  "Hello, " <> name <> "!"
}
```

## Pattern match

This code action can generate an exhaustive case expression for variable or argument.

```gleam
import gleam/list

pub fn run(items: List(Int)) -> Nil {
  let result = list.first(items)
}
```

If your cursor is within the `result` assignment then the code action will be
suggested, and if run the code will be updated to this:

```gleam
import gleam/list

pub fn run(items: List(Int)) -> Nil {
  let result = list.first(items)
  case result {
    Ok(value) -> todo
    Error(value) -> todo
  }
}
```

## Qualify and unqualify

These code actions can be used to add or remove module qualifiers for types and
values.

```gleam
import gleam/option.{Some}

pub fn main() {
  [Some(1), Some(2)]
}
```

If your cursor is within one of the `Some`s then the "qualify" code action will
be suggested, and if run the code will be updated to this:

```gleam
import gleam/option.{}

pub fn main() {
  [option.Some(1), option.Some(2)]
}
```
Note that the import statement has been updated as needed, and all instances of
the `Some` constructor in the module have been qualified.

The "unqualify" action behaves the same, except it removes module qualifiers.

The "unqualify" action is available for types and custom type variants
constructors. The "qualify" action is available for all types and values.

## Remove unused imports

This code action can be used to delete unused import statements from a module.

```gleam
import gleam/io
import gleam/list

pub fn main() {
  io.println("Hello, Joe!")
}
```

If your cursor is within the unused `import gleam/list` import the code action
will be suggested, and if run the module will be updated to this:

```gleam
import gleam/io

pub fn main() {
  io.println("Hello, Joe!")
}
```

## Remove redundant tuples

This code action removes redundant tuples from case expression subjects and
patterns.

```gleam
case #(a, b) {
  #(1, 2) -> todo
  _ -> todo
}
```

If your cursor is within the case expression the code action will be suggested,
and if run the module will be updated to this:

```gleam
case a, b {
  1, 2 -> todo
  _, _ -> todo
}
```

## Use label shorthand syntax

This code action updates calls and patterns to use the label shorthand syntax.

```gleam
case date {
  Day(day: day, month: month, year: year) -> todo
}
```

If your cursor is within the call that could use the shorthand syntax the code
action will be suggested, and if run the module will be updated to this:

```gleam
case date {
  Day(day:, month:, year:) -> todo
}
```

# Security

The language server does not perform code generation or compile Erlang or Elixir
code, so there is no chance of any code execution occurring due to opening a
file in an editor using the Gleam language server.

# Use outside Gleam projects

The language server is unable to build Gleam code that are not in Gleam
projects. When one of these files is opened the language server will provide
code formatting but other features are not available.
