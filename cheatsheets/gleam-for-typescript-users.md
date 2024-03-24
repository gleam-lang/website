---
layout: page
title: Gleam for TypeScript users
subtitle: Hello TypeScripters!
---

<!-- Copy of PHP Table of Contents -->
<!-- ----------------------------------------------------------------------- -->
- [Comments](#comments)
- [Variables](#variables)
- [Constants](#constants)
- [Variables type annotations](#variables-type-annotations)
- [Data types](#data-types) -->
  - [Strings](#strings)
  - [Numbers](#numbers)
  - [Tuples, Arrays, Lists](#tuples-arrays-lists)
  - [Objects and Records](#objects-and-records)
  - [Maps](#maps)
- [Destructuring Arrays and Tuples](#destructuring-arrays-and-tuples)
<!-- - [Functions](#functions) -->
  <!-- - [Exporting functions](#exporting-functions) -->
  <!-- - [Function type annotations](#function-type-annotations) -->
  <!-- - [Referencing functions](#referencing-functions) -->
  <!-- - [Labelled arguments](#labelled-arguments) -->
<!-- - [Operators](#operators) -->
<!-- - [Blocks](#blocks) -->
<!-- - [Flow control](#flow-control) -->
  <!-- - [Case](#case) -->
  <!-- - [Piping](#piping) -->
  <!-- - [Try](#try) -->
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
## Constants

### TypeScript

In TypeScript, `const` is used for variables that may not be reassigned.

```ts
const example = 50;
example = 100; // throws "TypeError: Assignment to constant variable."
```

### Gleam

In Gleam constants can also be created using the `const` keyword. Constants must be literal values, defined at the top level of a module and functions cannot be used in their definitions.

```gleam
// the_question.gleam module
const the_answer = 42

pub fn main() {
  the_answer
}
```

They can also be marked public via the `pub` keyword and will then be
automatically exported.

```gleam
pub const the answer = 42
```
## Variables type annotations

### TypeScript

TypeScript has optional type annotations (depending on compiler configuration).

```ts
const example1: number[] = [1, 2, 3];
const example2: Array<number> = [1, 2, 3]; // equivalent to example 1
const example3: [number, number, number] = [1, 2, 3];
const example4 = [1, 2, 3]; // valid, inferred without explicit type annotation
```

### Gleam

In Gleam type annotations can optionally be given when binding variables.

```gleam
let some_list: List(Int) = [1, 2, 3]
let some_string: String = "Foo"
let another_string = "Bar" // valid, inferred without explicit type annotation
```

Gleam will check the type annotation to ensure that it matches the type of the
assigned value. It does not need annotations to type check your code, but you
may find it useful to annotate variables to hint to the compiler that you want
a specific type to be inferred.


## Data types

### Strings

In TypeScript (JavaScript), strings are represented fundamentally as sequences
of UTF-16 code units. They can be defined with single quotes, double quotes,
or back-ticks (also known as template strings). Interpolation is supported in
template literal strings.

In Gleam all strings are UTF-8 encoded binaries. Gleam strings do not allow
interpolation, yet. Gleam however offers a `string_builder` via its standard
library for performant string building.

#### TypeScript

```ts
const firstExample = 'one';
const secondExample = "two";
const thirdExample = `three`;

const concat1 = 'one' + 'example';
const concat2 = "two" + "example";
const concat3 = `${concat1} ${concat2}`;
```


#### Gleam

```gleam
let example = "Hellø, world!"
let another = "Hello" <> ", world!"
```

### Numbers

#### TypeScript

TypeScript (JavaScript) only has a single number type implemented as a double-precision
64-bit binary format IEEE 754 value.

```typescript
1 / 2 // 0.5
```

#### Gleam

```gleam
1 / 2 // 0
1.5 + 10 // Compile time error
```

You can use the gleam standard library's `int` and `float` modules to convert
between floats and integers in various ways including `rounding`, `floor`,
`ceiling` and many more.

Floats in gleam use float-specific operators like `+.` and `/.` instead of sharing `+` and `/`.

```gleam
1 / 2 // 0
1.0 /. 2.0 // 0.5
```

### Tuples

#### TypeScript

TypeScript supports tuple types for arrays. They must be explicitly declared.

```ts
const a: [number, number] = [1, 2]; // valid
const b: [number, number] = [1, 2, 3]; // not valid
const c = [1, 2]; // inferred type is number[], NOT a tuple
const d: [string, number] = ["wow", 42];
```

#### Gleam

Tuples are very useful in Gleam as they're the only collection data type that
allows mixed types in the collection.

```gleam
let my_tuple = #("username", "password", 10)
let #(_, pwd, _) = my_tuple
io.print(pwd) // "password"
// Direct index access
io.print(my_tuple.0) // "username"
```

<!-- ### Lists

Arrays in PHP are allowed to have values of mixed types, but not in Gleam.

#### PHP

PHP does not feature special syntax for list handling.

```php
$list = [2, 3, 4];
$head = array_slice($list, 0, 1)[0];
$tail = array_slice($list, 1);
# $head == 2
# $tail == [3, 4]
$arr = array_merge($tail, [1.1]);
# $arr == [3, 4, 1.1]
```

#### Gleam

Gleam has a `cons` operator that works for lists destructuring and
pattern matching. In Gleam lists are immutable so adding and removing elements
from the start of a list is highly efficient.

```gleam
let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // compile error, type mismatch
``` -->

<!-- ### Maps

In PHP, the `array` type also covers maps and can have keys of any type as long as:

- the key type is `null`, an `int`, a `string` or a `bool` (some conversions
  occur, such as null to `""` and `false` to `0` as well as `true` to `1`
  and `"1"` to `1`. Float indexes, which are not representing integers
  indexes are deprecated due to being auto downcast to integers).
- the key is unique in the dictionary.
- the values are of any type.

In Gleam, maps can have keys and values of any type, but all keys must be of
the same type in a given map and all values must be of the same type in a
given map. The type of key and value can differ from each other.

There is no map literal syntax in Gleam, and you cannot pattern match on a map.
Maps are generally not used much in Gleam, custom types are more common.

#### PHP

```php
["key1" => "value1", "key2" => "value2"]
["key1" => "1", "key2" => 2]
```

#### Gleam

```gleam
import gleam/map

map.from_list([#("key1", "value1"), #("key2", "value2")])
map.from_list([#("key1", "value1"), #("key2", 2)]) // Type error!
``` -->

### Destructuring Arrays amd Tuples

#### TypeScript

TypeScript supports destructuring arrays with `const` or `let` statements.

```ts 
type NumberArray = number[];
type NumberPair = [number, number]; // tuple

const [a, b]: NumberArray = [1, 2]; // the type annotation here is not required
console.log(a); // 1
console.log(b); // 2

const [c]: NumberPair = [3, 4]; // the type annotation here is not required
console.log(c); // 3

const [d, ...e] = [5, 6, 7, 8];
console.log(d); // 5
console.log(e); // [6, 7, 8]
```

#### Gleam

Similar syntax is supported in Gleam for tuples. However, variadic destructuring is not.

```gleam
let #(a, b) = #(1, 2)

io.debug(a) // 1
io.debug(b) // 2

let #(c, _) = #(3, 4)
io.debug(c) // 3
// _ ignores the 4
```

For lists, the `list.split` method may be used.

```gleam
import gleam/io
import gleam/list

pub fn main() {
  let ints = [11, 22, 33]

  let #(a, rest) = list.split(ints, 1)

  io.debug(a) // [11]
  io.debug(rest) // [22, 33]
}
```
