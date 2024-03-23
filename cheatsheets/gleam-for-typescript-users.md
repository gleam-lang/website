---
layout: page
title: Gleam for TypeScript users
subtitle: Hello TypeScripters!
---

<!-- Copy of PHP Table of Contents -->
<!-- ----------------------------------------------------------------------- -->
- [Comments](#comments)
- [Variables](#variables)
  <!-- - [Match operator](#match-operator) -->
  <!-- - [Variables type annotations](#variables-type-annotations) -->
<!-- - [Functions](#functions) -->
  <!-- - [Exporting functions](#exporting-functions) -->
  <!-- - [Function type annotations](#function-type-annotations) -->
  <!-- - [Referencing functions](#referencing-functions) -->
  <!-- - [Labelled arguments](#labelled-arguments) -->
<!-- - [Operators](#operators) -->
<!-- - [Constants](#constants) -->
<!-- - [Blocks](#blocks) -->
<!-- - [Data types](#data-types) -->
  <!-- - [Strings](#strings) -->
  <!-- - [Tuples](#tuples) -->
  <!-- - [Lists](#lists) -->
  <!-- - [Maps](#maps) -->
  <!-- - [Numbers](#numbers) -->
<!-- - [Flow control](#flow-control) -->
  <!-- - [Case](#case) -->
  <!-- - [Piping](#piping) -->
  <!-- - [Try](#try) -->
<!-- - [Type aliases](#type-aliases) -->
<!-- - [Custom types](#custom-types) -->
  <!-- - [Records](#records) -->
  <!-- - [Unions](#unions) -->
  <!-- - [Opaque custom types](#opaque-custom-types) -->
<!-- - [Modules](#modules) -->
  <!-- - [Imports](#imports) -->
  <!-- - [Named imports](#named-imports) -->
  <!-- - [Unqualified imports](#unqualified-imports) -->
<!-- - [Architecture](#architecture) -->

<!--
Other misc reminders
- [ ] string concatenation
-->

## Comments

### TypeScript

In TypeScript, comments are written with a `//` prefix.

```ts
// Hello, Joe!
```

Multi-line comments may be written like so:

```ts
/*
 * Hello, Joe!
 */
```

TypeScript also [supports JSDoc annotations](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html).

```ts
/**
 * @type {string}
 */
var s;
 
/** @type {Window} */
var win;
 
/** @type {PromiseLike<string>} */
var promisedString;
 
// You can specify an HTML Element with DOM properties
/** @type {HTMLElement} */
var myElement = document.querySelector(selector);
element.dataset.myData = "";
```

Documentation blocks (docblocks) are extracted into generated API
documentation.

### Gleam

In Gleam, comments are written with a `//` prefix.

```gleam
// Hello, Joe!
```

Comments starting with `///` are used to document the following function,
constant, or type definition. Comments starting with `////` are used to
document the current module.

```gleam
//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42

/// A main function
fn main() {}

/// A Dog type
type Dog {
  Dog(name: String, cuteness: Int)
}
```

`//` comments are not used while generating documentation files, while
`////` and `///` will appear in them.

## Variables

You can rebind variables in both languages.

### TypeScript

```ts
let a = 50;
a = a + 100;
a = 1;
```

### Gleam

Gleam also has the `let` keyword before its variable names. However, it needs to be used explicitly each time when rebinding/reassinging a new value.

```gleam
let size = 50
let size = size + 100
let size = 1
```
