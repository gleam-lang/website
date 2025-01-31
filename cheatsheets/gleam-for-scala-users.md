---
layout: page
title: Gleam for Scala users
subtitle: Hello typesafe object-oriented functional programmers!
---

- [Comments](#comments)
- [Variables](#variables)
  - [Match operator](#match-operator)
  - [Variables type annotations](#variables-type-annotations)
- [Functions](#functions)
  - [Exporting functions](#exporting-functions)
  - [Function type annotations](#function-type-annotations)
  - [Referencing functions](#referencing-functions)
  - [Labelled arguments](#labelled-arguments)
- [Operators](#operators)
- [Constants](#constants)
- [Blocks](#blocks)
- [Data types](#data-types)
  - [Strings](#strings)
  - [Tuples](#tuples)
  - [Lists](#lists)
  - [Maps](#maps)
  - [Numbers](#numbers)
- [Flow control](#flow-control)
  - [Case](#case)
  - [Piping](#piping)
  - [Try](#try)
- [Type aliases](#type-aliases)
- [Custom types](#custom-types)
  - [Records](#records)
  - [Algebraic Data Types](#algebraic-data-types)
  - [Opaque custom types](#opaque-custom-types)
- [Type Parameters](#type-parameters)
- [Modules](#modules)
  - [Imports](#imports)
  - [Named imports](#named-imports)
  - [Unqualified imports](#unqualified-imports)
- [Architecture](#architecture)

## Comments

### Scala

In Scala, comments are written with a `//` prefix.

```scala
// Hello, Joe!
```

Multi line comments may be written like so:

```scala
/*
 * Hello, Joe!
 */
```

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

```

`//` comments are not used while generating documentation files, while
`////` and `///` will appear in them.

## Variables

Scala has mutable and immutable variable bindings; in Gleam, all data is immutable but
variable names can be reassigned in the same scope.

### Scala

```scala
val size = 50
val size = size + 100 // compile error
val size = 1 // compile error
```

### Gleam

Gleam has the `let` keyword before its variable names.

```gleam
let size = 50
let size = size + 100
let size = 1
```

### Match operator

Both Scala and Gleam can use the left hand side of an `=` as a pattern.

#### Scala

```scala
val List(a, b) = List(1, 2)
// a == 1
// b == 2

val List(c,d) = List(1) // runtime MatchError
```

#### Gleam

In Gleam, `let` and `=` can be used for pattern matching, but you'll get
compile errors if there's a type mismatch. For assertions, the equivalent
`let assert` keyword is used.

```gleam
let #(a, _) = #(1, 2)
// a = 1
// `_` matches 2 and is discarded

let assert [] = [1] // runtime error
let assert [y] = "Hello" // compile error, type mismatch
```

Asserts should be used with caution.

### Variables type annotations

#### Scala

Scala is a strongly typed language with pretty good type inference.
Type annotations are usually optional. It may be useful for documentation
and improving compile times for complex inferences.

```scala
val someList: List[Int] = List(1, 2, 3)
```


#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```gleam
let some_list: List(Int) = [1, 2, 3]
```

Gleam will check the type annotation to ensure that it matches the type of the
assigned value. It does not need annotations to type check your code, but you
may find it useful to annotate variables to hint to the compiler that you want
a specific type to be inferred.

## Functions

### Scala

In Scala, you can define methods with the `def` keyword. 
The return value is the value of the last expression.

```scala
def hello(name: String = "Joe"): String = {
  if (name == "Joe") {
    "Welcome back, Joe!"
  } else {
    s"Hello $name"
  }
}

```

Anonymous functions can also be defined and be bound to variables.

```scala
val x = 3
val anonFn = (y: Int) => x * y // Creates a new scope
anonFn(3) // 6
```

### Gleam

Gleam's functions are declared like so:

```gleam
fn sum(x, y) {
  x + y
}
```

Gleam's anonymous functions have the same basic syntax.

```gleam
let mul = fn(x, y) { x * y }
mul(1, 2)
```

### Exporting functions

#### Scala

In Scala, class methods are public by default but can be made private or protected.

```scala
object Math {
  // this is public
  def sum(x: Int, y: Int): Int = x + y

  // this is private
  private def mul(x: Int, y: Int): Int = x * y
}
```

#### Gleam

In Gleam, functions are private by default and need the `pub` keyword to be
marked as public.

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

#### Scala

Method parameters in Scala require type annotations. The return type is
usually optional but encouraged for public methods.

```scala
object Math {
  // int return type will be statically inferred
  def sum(x: Int, y: Int) = x + y

  def mul(x: Int, y: Int): Boolean = {
    x * y // compile error, required Int found Boolean
  }
}
```

#### Gleam

Functions can **optionally** have their argument and return types annotated in
Gleam. These type annotations will always be checked by the compiler and throw
a compilation error if not valid. The compiler will still type check your
program using type inference if annotations are omitted.

```gleam
fn add(x: Int, y: Int) -> Int {
  x + y
}

fn mul(x: Int, y: Int) -> Bool {
  x * y // compile error, type mismatch
}
```

### Labelled arguments

Both Scala and Gleam have ways to give arguments names and in any order.
Both are resolved at compile time, so there is no runtime performance cost.

#### Scala

When calling a method, arguments can be passed:

- positionally, in the same order of the method declaration
- by name, in any order

```scala
// Some imaginary replace function
def replace(inside: String, each: String, replace: String) = ???

// Calling with positional arguments:
replace(",", " ", "A,B,C")

// Calling with named arguments:
replace(inside = "A,B,C", each = ",", replace = " ")
```

Parameters with default values can be omitted:

```scala
def toCsvRow(items: List[String], separator: String = ","): String = items.mkString(separator)

toCsvRow(List("a", "b", "c")) // a,b,c
toCsvRow(List("a", "b", "c"), "\t") // a\tb\tc
toCsvRow(List("a", "b", "c"), separator = "|") // a|b|c
```

#### Gleam

In Gleam arguments can be given a label as well as an internal name.
Contrary to Scala, the name used at the call-site does not have to match
the name used for the variable inside the function.

```gleam
pub fn replace(inside str, each pattern, with replacement) {
  todo
}
```

```gleam
replace(",", " ", "A,B,C")
replace(inside: "A,B,C", each: ",", with: " ")
```

## Operators

| Operator           | Scala                     | Gleam                     | Notes                                         |
|--------------------|---------------------------|---------------------------|-----------------------------------------------|
| Equal              | `==`                      | `==`                      | In Gleam both values must be of the same type |
| Reference equality | `eq`                      |                           |                                               |
| Not equal          | `!=`                      | `!=`                      | In Gleam both values must be of the same type |
| Greater than       | `>`                       | `>`                       | In Gleam both values must be **Int**          |
| Greater than       | `>`                       | `>.`                      | In Gleam both values must be **Float**        |
| Greater or equal   | `>=`                      | `>=`                      | In Gleam both values must be **Int**          |
| Greater or equal   | `>=`                      | `>=.`                     | In Gleam both values must be **Float**        |
| Less than          | `<`                       | `<`                       | In Gleam both values must be **Int**          |
| Less than          | `<`                       | `<.`                      | In Gleam both values must be **Float**        |
| Less or equal      | `<=`                      | `<=`                      | In Gleam both values must be **Int**          |
| Less or equal      | `<=`                      | `<=.`                     | In Gleam both values must be **Float**        |
| Boolean and        | `&&`                      | `&&`                      | In Gleam both values must be **Bool**         |
| Logical and        | `&&`                      |                           | Not available in Gleam                        |
| Boolean or         | <code>&vert;&vert;</code> | <code>&vert;&vert;</code> | In Gleam both values must be **Bool**         |
| Logical or         | <code>&vert;&vert;</code> |                           | Not available in Gleam                        |
| Boolean not        | `!`                       | `!`                       | In Gleam both values must be **Bool**         |
| Add                | `+`                       | `+`                       | In Gleam both values must be **Int**          |
| Add                | `+`                       | `+.`                      | In Gleam both values must be **Float**        |
| Subtract           | `-`                       | `-`                       | In Gleam both values must be **Int**          |
| Subtract           | `-`                       | `-.`                      | In Gleam both values must be **Float**        |
| Multiply           | `*`                       | `*`                       | In Gleam both values must be **Int**          |
| Multiply           | `*`                       | `*.`                      | In Gleam both values must be **Float**        |
| Divide             | `/`                       | `/`                       | In Gleam both values must be **Int**          |
| Divide             | `/`                       | `/.`                      | In Gleam both values must be **Float**        |
| Remainder          | `%`                       | `%`                       | In Gleam both values must be **Int**          |
| Concatenate        | `+`                       | `<>`                      | In Gleam both values must be **String**       |
| Pipe               |                           | <code>&vert;></code>      | Gleam's pipe can chain function calls         |

### Notes on operators

- `==` by default uses Java's `Object::equals` method. Scala case classes
  will automatically implement `equals` for you. You can enable strong type
  checking on equals with `import scala.language.strictEquality`
- Scala operators are short-circuiting as in Gleam.
- In Scala, everything is an object, so operators are not special, they are
  simply just methods with symbolic names.

## Constants

### Scala

In Scala, there's no special feature for constants; since `val`s are
immutable bindings, they can be declared in any scope.

```scala
object TheQuestion {
  val TheAnswer: Int = 42
}

TheQuestion.TheAnswer // 42
```

### Gleam

In Gleam constants can be created using the `const` keyword.

```gleam
// the_question.gleam module
const the_answer = 42

pub fn main() {
  the_answer
}
```

They can also be marked public via the `pub` keyword and will then be
automatically exported.

## Blocks

### Scala

In Scala, blocks can use either curly braces or indentation.

```scala
def main() = {
  val x = {
    someFunction(1)
    2
  }
  // Parenthesis are used to change precedence of arithmetic operators
  // Although curly braces would work here too.
  val y = x * (x + 10)
  y
}
```

### Gleam

In Gleam curly braces, `{` and `}`, are used to group expressions.

```gleam
pub fn main() {
  let x = {
    some_function(1)
    2
  }
  // Braces are used to change precedence of arithmetic operators
  let y = x * {x + 10}
  y
}
```

Like in Scala, in Gleam function blocks are always expressions, so are `case`
blocks or arithmetic sub groups. Because they are expressions they always
return a value.

For Gleam the last value in a block's expression is always the value being
returned from an expression.

## Data types

### String character encoding

On the JVM, Scala uses Java's String implementation which are internally stored as ASCII
or UTF-16 sequences. Strings can be encoded or decoded to/from a specific encoding.
Strings are defined with double-quotes `"` or triple-double-quotes `"""`, the later
allows for mutli-line strings.

Scala has string interpolation and allows for custom string interpolators.

In Gleam all strings are UTF-8 encoded binaries. Strings use double quotes and can
span lines. Gleam strings do not allow interpolation, yet. Gleam however offers a
`string_builder` via its standard library for performant string building.

#### Scala

```scala
val what = "world"
"""Hello
world!"""
s"Hellø, $what!"
```

#### Gleam

```gleam
"Hello
world"

"Hellø, world!"
```


### Tuples

Tuples are very useful in Gleam as they're the only collection data type that
allows mixed types in the collection. They behave very similar to Scala's tuples,
but are 0-index instead of 1 indexed when accessing by index.

#### Scala

```scala
val myTuple = ("username", "password", 10)
val (_, pwd, _) = myTuple
println(pwd) // "password"
// Direct index access
println(myTuple._1) // "username"
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

Both Gleam and Scala use immutable linked-lists for their standard lists.

#### Scala

Scala's `List` is a linked-list with a cons operator (`::`).

```scala
val list = List(2, 3, 4)
val list2 = 1 :: list // list of 1,2,3,4
val 1 :: secondElement :: _ = list2 // secondElement = 2
1.0 :: list // compiles, but casts to List[AnyVal]
```

#### Gleam

Gleam has a `..` prepend operator that works for lists destructuring and
pattern matching. In Gleam lists are immutable so adding and removing elements
from the start of a list is highly efficient.

```gleam
let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // compile error, type mismatch
```

### Maps

Scala's Map is an immutable hashmap; there is no literal syntax for it but
there is some sugar to use `->` as a 2-tuple which can be used to define
keys and values.

In Gleam, dicts can have keys and values of any type, but all keys must be of
the same type in a given map and all values must be of the same type in a
given dict. The type of key and value can differ from each other.

There is no dict literal syntax in Gleam, and you cannot pattern match on a Dict.
Dicts are generally not used much in Gleam, custom types are more common.

#### Scala

```scala
Map("key1" -> "value1", "key2" -> "value2")
```


#### Gleam

```gleam
import gleam/dict

dict.from_list([#("key1", "value1"), #("key2", "value2")])
dict.from_list([#("key1", "value1"), #("key2", 2)]) // Type error!
```

### Numbers

Scala has 8-bit, 32-bit, and 64-bit signed integers (`Byte`, `Short`, `Int`, `Long`)
and also 32-bit and 64-bit floating point numbers (`Float`, `Double`). For arbitrary
sized numbers, there are `BigDecimal` and `BigInteger`.

Gleam has both support `Integer` and `Float`. Integer and Float sizes for
both depend on the platform: JavaScript and Erlang.

#### Scala

Scala will automatically cast integers into floating point numbers when doing
math operations between them.

```scala
1 / 2 // 0
1.5 + 10 // 11.5
```

#### Gleam

```gleam
1 / 2 // 0
1.5 + 10 // Compile time error
```

You can use the gleam standard library's `gleam/int` and `gleam/float` modules to convert
between floats and integers in various ways including `rounding`, `floor`,
`ceiling` and many more.

## Flow control

### Case

Case is one of the most used control flow in Gleam, and it is very similar to the
`match` operator in Scala. Scala and Gleam both support guards, destructuring,
exhaustiveness checking and disjoint union matching.

#### Scala

```scala

def nameNumber(status: Int): String = {
  status match { 
    case 0 => "Zero"
    case 1 => "One"
    case 2 => "Two"
    case _ => "Some other number"
  }
}
```

Cases can also have guards, similar to Gleam
```scala
status match {
  case 400 => "Bad request"
  case 404 => "Not found"
  case _ if status / 100 == 4 => "4xx"
  case _ => "I'm not sure"
}
```

The `|` operator works just like in Gleam.

```scala
number match {
  case 2 | 4 | 6 | 8 => "This is an even number"
  case 1 | 3 | 5 | 7 => "This is an odd number"
  case _ => "I'm not sure"
}
```

#### Gleam

Gleam's syntax is a little shorter:

```gleam
case name_number {
  0 -> "Zero"
  1 -> "One"
  2 -> "Two"
  n -> "Some other number" // This matches anything
}
```

Exhaustiveness checking at compile time will make certain that you must check for
all possible values. A lazy and common way is to check of expected values and have a
catchall clause with a single underscore `_`:

```gleam
case status {
  400 -> "Bad Request"
  404 -> "Not Found"
  status if status / 100 == 4 -> "4xx" // This will work in future versions of Gleam
  _ -> "I'm not sure"
}
```

The case operator especially coupled with destructuring to provide native pattern
matching:

```gleam
case xs {
  [] -> "This list is empty"
  [a] -> "This list has 1 element"
  [a, b] -> "This list has 2 elements"
  _other -> "This list has more than 2 elements"
}
```

The case operator supports guards:

```gleam
case xs {
  [a, b, c] if a >. b && a <=. c -> "ok"
  _other -> "ko"
}
```

...and disjoint union matching:

```gleam
case number {
  2 | 4 | 6 | 8 -> "This is an even number"
  1 | 3 | 5 | 7 -> "This is an odd number"
  _ -> "I'm not sure"
}
```

### Piping

In Gleam most functions, if not all, are data first, which means the main data
value to work on is the first argument. By this convention and the ability to
specify the argument to pipe into, Gleam allows writing functional, immutable
code, that reads imperative-style top down, much like unix tools and piping.

#### Scala

Scala does not have piping operator built-in, although it can be easily implemented
with extension methods and `import scala.util.chaining._` helpers.

That being said, it isn't really idiomatic or necessary because with OOP,
the first "argument" to the function is the object itself, so it's usually
more clear to just call the next method directly on the result.

```scala
List(1, 2, 3, 4)
  .map(_ * 2)
  .filter(_ % 3 == 0)
  .reduce((acc, x) => acc + x)
```

#### Gleam

```gleam
[1,2,3,4]
|> list.map( fn(x) { x * 2 } )
|> list.filter( fn (x) { x % 3 == 0 })
|> list.reduce(fn (acc, x) { acc + x })
```

### Try

Error management is approached differently in Scala and Gleam.

#### Scala

Scala uses the notion of exceptions to interrupt the current code flow and
pop up the error to the caller.


```scala
import scala.util.{Try,Success,Failure}

// Integer.parseInt is from the Java std library and
// it throws a java.lang.NumberFormatException
Try(Integer.parseInt("123")) match {
  case Success(i) => println("We parsed an Int")
  case Failure(err) => println("That wasn't an Int")
}

```

Unlike Gleam, the "`ErrorType`" in a `Try` cannot be changed, it
is always the Java Exception base-type, `Throwable`. There is also
`Either` in Scala, with more generic sub-types `Left` and `Right`,
but the compiler still cannot prevent code you call from throwing an
exception, which may circumvent your error handling.

Both `Either` and `Try` can use `for` comprehensions when chaining
together multiple operations in a row.

```scala
def parseInt(s: String): Try[Int] = Try(Integer.parseInt(s))

for {
  intANumber <- parseInt("1")
  attemptInt <- parseInt("ouch") // Error will be returned
  intAnotherNumber <- parseInt("3") // never gets executed

} yield {
  intANumber + attemptInt + intAnotherNumber
}
```

#### Gleam

In Gleam, errors are always containers with an associated value.

A common container to model an operation result is
`Result(ReturnType, ErrorType)`.

A `Result` is either:

- an `Error(ErrorValue)`
- or an `Ok(Data)` record

Handling errors actually means to match the return value against those two
scenarios, using a case for instance:

```gleam
case parse_int("123") {
  Ok(i) -> io.println("We parsed the Int")
  Error(e) -> io.println("That wasn't an Int")
}
```

In order to simplify this construct, we can use the `use` expression with the
`try` function from the `gleam/result` module.

- either bind a value to the providing name if `Ok(Something)` is matched,
- or **interrupt the current block's flow** and return `Error(Something)` from
  the given block.

```gleam
let a_number = "1"
let an_error = Error("ouch")
let another_number = "3"

use int_a_number <- parse_int(a_number)
use attempt_int <- parse_int(an_error) // Error will be returned
use int_another_number <- parse_int(another_number) // never gets executed

Ok(int_a_number + attempt_int + int_another_number) // never gets executed
```

## Type aliases

Type aliases allow for easy referencing of arbitrary complex types.
This feature works similarly in Scala and Gleam.

### Scala

```scala
type Headers = List[(String, String)]
```

Scala can also make the type alias `opaque` which prevents the call-site
usage from passing in the underlying type.

```scala

opaque type Meters = Double

def toFeet(meters: Meters): Double = meters * 3.2

toFeed(1.0) // compile error

```

### Gleam

The `type` keyword can be used to create aliases.

```gleam
pub type Headers =
  List(#(String, String))
```

## Custom types

### Records

Custom type allows you to define a collection data type with a fixed number of
named fields, and the values in those fields can be of differing types.

#### Scala

The simplest way to make a new datatype in Scala is with case classes.

```scala
case class Person(name: String, age: Int)
val person = Person("Joe", 40)
person.name // Joe
```

#### Gleam

Gleam's custom types can be used as structs. At runtime, they have a tuple
representation and are compatible with Erlang records (or JavaScript objects).

```gleam
type Person {
  Person(name: String, age: Int)
}

let person = Person(name: "Joe", age: 40)
let name = person.name
```

An important difference to note is there is no Java-style object-orientation in
Gleam, thus methods can not be added to types. However opaque types exist,
see below.

### Algebraic Data Types


In Gleam functions must always take and receive one type. To have a union of
two different types they must be wrapped in a new custom type.

#### Scala

```scala

enum IntOrFloat {
  case AnInt(i: Int)
  case AFloat(f: Float)
}

```

Although for this particular example, we could just use a union type (in Scala 3)

```scala
type IntOrFloat = Int | Float
```

#### Gleam

```gleam
type IntOrFloat {
  AnInt(Int)
  AFloat(Float)
}

fn int_or_float(X) {
  case X {
    True -> AnInt(1)
    False -> AFloat(1.0)
  }
}
```

### Opaque custom types

In Scala, constructors can be marked as private and a factory methods can be
added onto a companion object.

In Gleam, custom types can be defined as being opaque, which causes the
constructors for the custom type not to be exported from the module. Without
any constructors to import other modules can only interact with opaque types
using the intended API.

This is not to be confused with Scala's "opaque types" which are type aliases.

#### Scala

There's many approaches to encapsulating an implementation in Scala, here is just one.

```scala

trait Point

case class PointImpl private(x: Int, y: Int) extends Point

object Point {
  def spawn(x: Int, y: Int): Option[Point] = {
    if (x >= 0 && x <= 99 && y >= 0 && y <= 99) {
      Some(PointImpl(x, y))
    } else {
      None
    }
  }
}

Point.spawn(1, 2) // Returns a Point object
```


#### Gleam

```gleam
// In the point.gleam opaque type module:
pub opaque type Point {
  Point(x: Int, y: Int)
}

pub fn spawn(x: Int, y: Int) -> Result(Point, Nil) {
  case x >= 0 && x <= 99 && y >= 0 && y <= 99 {
    True -> Ok(Point(x: x, y: y))
    False -> Error(Nil)
  }
}

// In the main.gleam module
pub fn main() {
  assert Ok(point) = Point.spawn(1, 2)
  point
}
```

## Type Parameters

Gleam and Scala's type parameters work similarly,
but Scala has more syntax around constraining parameters.

Also unlike Scala, Gleam does not have higher kinded types.

### Scala

Generic parameters are defined between `[` `]`.

```scala

enum Tree[T] {
  case Branch(left: Tree[T], right: Tree[T])
  case Leaf(value: T)
}

val newTree: Tree[Int] = Branch(Leaf(1), Leaf(2))

```


### Gleam

Generic parameters are defined between `(` `)`.

```gleam
type Tree(t) {
  Branch(left: Tree(t), right: Tree(t))
  Leaf(value: t)
}

const new_tree: Tree(Int) =
  Branch(Leaf(1), Leaf(2))
```


## Modules

Gleam has a more explicit module system where every file is a module.

### Scala
In Scala we can use traits or objects to group types aliases, methods,
and constants into a namespace.

```scala
package one // this package could be defined in any file

object MyModule {
  def identity[T](t: T) = t
}

```

```scala
package another.packge

import one.MyModule

def main() = MyModule.identity(1) // 1

```


### Gleam

The closest thing Scala has that are similar to Gleam's modules
are companion objects: Collections of functions and constants grouped into a
static class.

A Gleam module name corresponds to its file name and path.

Since there is no special syntax to create a module, there can be only one
module in a file and since there is no way name the module the filename
always matches the module name which keeps things simple and transparent.

In `one.gleam`:

```gleam
// Creation of module function identity
// in module one
pub fn identity(x) {
  x
}
```

Importing the `one` module and calling a module function:

```gleam
// In src/main.gleam
import one // if `one` was in a directory called `lib` the import would be `lib/one`.

pub fn main() {
  one.identity(1) // 1
}
```

### Imports

#### Scala

Classes in the same package do not need to be imported.
Otherwise, all imports are done from the full package name.

#### Gleam

Imports are relative to the app `src` folder.

Modules in the same directory will need to reference the entire path from `src`
for the target module, even if the target module is in the same folder.

Inside module `src/nasa/moon_base.gleam`:

```gleam
// imports module src/nasa/rocket_ship.gleam
import nasa/rocket_ship

pub fn explore_space() {
  rocket_ship.launch()
}
```

### Named imports

#### Scala

Scala allows imports to be renamed:

```scala
import java.util.{List => JUList}
```

#### Gleam

Gleam has as similar feature:

```gleam
import unix/cat
import animal/cat as kitty
// cat and kitty are available
```

This may be useful to differentiate between multiple modules that would have the same default name when imported.


## Architecture

To iterate a few foundational differences:

1. Programming model: Multi-paradigm function/object-orientation VS strictly functional immutable
   programming
2. Runtime environment

### Programming model

- Scala encourages immutable, functional style of code but offers escape
  hatches and mutable types, as well as access to the Java standard library.
- This can allow performance-critical code to be written in the most efficient
  ways, but it can also lead to too many coding styles across the ecosystem
  and even in a single codebase.
- In Gleam, there are no such escape hatches
- Scala inherits many of the warts from Java-compatability, such as nullability and exceptions
- Scala has several different approaches to concurrent applications, including
  several the actor model implementations, multi-threading, and asynchronous programming.
  Libraries written for one style do not necessarily interact well with libraries written
  for another style.
- Gleam benefits from Erlang/Beam Processes, a concurrently model similar
  to Project Loom on the JVM. This allows for writing in a "direct" coding
  style without sacrificing scalability.
- Probably the biggest difference between Gleam and Scala's object-oriented features. In Scala,
  everything is an object, and as such two values of different types maybe have a least-upper-bound.
  This has the consequence of a more complicated and slower type inference system.
- Scala is a large language with many other features for which there are no Gleam equivalent, such as:
  * Implicit parameters
  * Extension methods
  * Traits
  * Singleton objects
  * Type classes
  * By-name parameters
  

### Runtime environment

- Gleam runs on Erlang/BEAM and Scala runs on the JVM
- As a generalization, the JVM has better performance for computation but Erlang/BEAM
  will have better concurrency.
- Both Scala and Gleam can compile to Javascript to run in the browser, NodeJS, Deno, etc.
- Scala can also compile to native code.
