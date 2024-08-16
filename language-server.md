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
  - [Code completion](#code-completion)
  - [Document symbols](#document-symbols)
  - [Signature help](#signature-help)
  - [Code Actions](#code-actions)
    - [Case correction](#case-correction)
    - [Fill labels](#fill-labels)
    - [Remove unused imports](#remove-unused-imports)
    - [Remove redundant tuples](#remove-redundant-tuples)
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

## Code completion

The language server support completion of:

- Modules in import statements.
- Unqualified types and values in import statements.
- Type constructors in type annotations.
- Record fields.
- Functions and constants defined in the same module.
- Functions and constants defined in other modules, automatically adding import
  statements if the module has not yet been imported.

## Document symbols

The language server supports listing document symbols, such as functions and
constants, for the current Gleam file.

## Signature help

The language server can show the type of each argument when calling a function,
along with the labels of the arguments that have them.

## Code Actions

### Case correction

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

### Fill labels

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

### Remove unused imports

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

### Remove redundant tuples

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

### Use label shorthand syntax

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
