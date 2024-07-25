---
layout: page
title: Gleam for Go users
subtitle: Hello Gophers!
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
  - [Error Handling](#error-handling)
- [Type aliases](#type-aliases)
- [Custom types](#custom-types)
  - [Records](#records)
  - [Unions](#unions) IN PROGRESS
  - [Opaque custom types](#opaque-custom-types) IN PROGRESS
- [Modules](#modules) IN PROGRESS
  - [Imports](#imports) IN PROGRESS
  - [Named imports](#named-imports) IN PROGRESS
  - [Unqualified imports](#unqualified-imports) IN PROGRESS
- [Architecture](#architecture) IN PROGRESS

## Comments

### Go

In Go, comments are written with a `//` prefix.

```Go
// Hello, Joe!
```

Multi line comments may be written like so:

```Go
/*
 * Hello, Joe!
 */
```

In Go, top level declarations can be annotated with a comment directly above it to create documentation for that symbol.

```Go
// This is a special interface
type Stringer interface {}

// Config struct
type Config Struct {}

// This will quux a string
func Quux(str string) string {
  return str
}
```

Any of these documentation comments on exported members will be included in your package documentation

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

### Go

In Go you specify values by:
- Specifically declare the variable with the `var` keyboard and a name and then either just the type, or an optional type and value
- a variable name (or comma separated list of names), the `:=` operator and then an expression

```Go
size := 50
size := size + 100
size = 1
```

### Gleam

Gleam has the `let` keyword before its variable names.

```gleam
let size = 50
let size = size + 100
let size = 1
```

### Match operator

#### Go

Go has no real support for any sort of pattern matching or destructuring.  It does support multiple return values.  These are assigned to
separated variable names separated by commas

```Go
a, b := func() (int, int) { return 1, 2 }();
// a == 1
// b == 2
```

#### Gleam

In Gleam, `let` and `=` can be used for pattern matching, but you'll get
compile errors if there's a type mismatch, and a runtime error if there's
a value mismatch. For assertions, the equivalent `let assert` keyword is
preferred.

```gleam
let #(a, _) = #(1, 2)
// a = 1
// `_` matches 2 and is discarded

let assert [] = [1] // runtime error
let assert [y] = "Hello" // compile error, type mismatch
```

Asserts should be used with caution.

### Variables type annotations

#### Go

In Go type annotations are generally required in most places.  The exception is when variables or constants are initialized with a value. Multiple consecutive struct fields or function arguments of the same time can combined their type annotation. 

```Go
type SomethingElse struct {
  field string
  otherField int
  x, y float64
}

func multipleArgsOfSameType(str string, x, y float64) {}
```

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```gleam
let some_list: List(Int) = [1, 2, 3]
let some_string: String = "A string"
```

Gleam will check the type annotation to ensure that it matches the type of the
assigned value. It does not need annotations to type check your code, but you
may find them useful for documentation purposes.

## Functions

### Go

In Go, you can define functions with the `func` keyword. The `return`
keyword is required if the function has a return value, and optional otherwise.

```Go
func hello(name string) string {
  if name == 'Joe' {
    return 'Welcome back, Joe!'
  }
  return "Hello $name"
}

func noop() {
  // No return value
}
```

Anonymous functions can also be defined and be bound to variables.

```Go
x := 2
GoAnonFn := func(y) { return x * y } // Captures x
GoAnonFn(2, 3) // 6
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

A difference between Go's and Gleam's anonymous functions is that in Go they
create a new local scope but inherit the surrounding scope, allowing you to mutate variables in that scope. In Gleam you can shadow local variables within anonymous functions but you cannot influence the variable bindings in the outer scope.  In Go you can actually change the values in the outer scope, even if that scope has been returned.

The only difference between module functions and anonymous functions in Gleam
is that module functions heads may also feature argument labels, like so:

```gleam
// In some module.gleam
pub fn distance(from x: Int, to y: Int) : Int {
  abs(x) - abs(y) |> abs()
}
// In some other function
distance(from: 1, to: -2) // 3
```

### Exporting functions

#### Go

In Go, functions are exported if their name is capitalized, and private to the package otherwise.

```Go
func PublicHello(name string) string {  // Exported
  if name == 'Joe' {
    return 'Welcome back, Joe!'
  }
  return "Hello $name"
}

func privateHello(name string) string { // Package private
  if name == 'Joe' {
    return 'Welcome back, Joe!'
  }
  return "Hello $name"
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

### Go

Go does not support a global scope.  All variables are scoped to the package
in which they are defined.  A package is all Go files in a single directory,
so two files in the same package can see all symbols in that package whether
they are exported or not.  This allows for complicated functionality to be
easily spread across multiple files without worrying about any sort of hard
boundary between them.

### Gleam

Gleam does not support a global scope. Like Go, in Gleam only code that is within functions can be invoked.

On the BEAM, Gleam code can also be invoked from other Erlang code. It
can also be invoked from JavaScript runtime calls.

### Function type annotations

#### Go

You are required to annotate function arguments and return types.  They will be
checked by the compiler and the program will fail to build if type checking fails.
Again, multiple consecutive arugments of the same type can share an annotation.

```Go
func sum(x, y int) int {
    return x + y
}

func mul(x, y int) bool {
    return x * y // This will be a compile-time error
}
```

#### Gleam

Functions can **optionally** have their argument and return types annotated in
Gleam. These type annotations don't change how type checking works, but are good documentation for you and other readers of your code.

```gleam
fn add(x: Int, y: Int) -> Int {
  x + y
}

fn mul(x: Int, y: Int) -> Bool {
  x * y // compile error, type mismatch
}
```

### Referencing functions

#### Go

In Go, functions are called the same way, using C style function call syntax.
Functions are first class values, and can be function arguments and return values.
You can even return methods - even if the struct the method belongs to a scope that
has returned.

```Go
func returnsAFunc() func() {
	x := 2
	return func() {
		x = x + 1
		fmt.Printf("%d\n", x)
	}
}

type SomethingElse struct {
	something string
}

func (b SomethingElse) Func() {
	fmt.Printf("This somethingElse has %s in something field", b.something)
}

func returnsAMethod() func() {
	somethingElse := SomethingElse{"Hello"}
	return somethingElse.Func
}

func main() {
	fn := returnsAFunc()
	fn()
	returnsAMethod()()
}
```

#### Gleam

Gleam has a single namespace for constants and functions within a module, so
there is no need for a special syntax to assign a module function to a
variable.

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

#### Go

Go has no way to supply arguments out of order or by name.  To do so
would require one of two things:
- Creating a struct that represents the parameters.  Any fields of that
  struct not explicitly set would default to the zero value of their type.
- Using the _functional option parameter_ pattern, where the function takes
  a varargs parameters that is of a interface type that can be created by a
  number of functions that are available to create values that implement said
  interface.

#### Gleam

In Gleam arguments can be given a label as well as an internal name.

```gleam
pub fn replace(inside str, each pattern, with replacement) {
  todo
}
```

```gleam
replace(",", " ", "A,B,C")
replace(inside: "A,B,C", each: ",", with: " ")
```

There is no performance cost to Gleam's labelled arguments as they are
optimised to regular function calls at compile time, and all the arguments
are fully type checked.

## Operators

| Operator           | Go     | Gleam                     | Notes                                                                                  |
| ------------------ | ------ | ------------------------- | -------------------------------------------------------------------------------------- |
| Equal              | `==`   | `==`                      | Both values must be of the same type                                                   |
| Reference equality | `instanceof` |                     | True only if an object is an instance of a class                                       |
| Not equal          | `!=`   | `!=`                      | In Gleam both values must be of the same type                                          |
| Greater than       | `>`    | `>`                       | In Gleam both values must be **Int**                                                   |
| Greater than       | `>`    | `>.`                      | In Gleam both values must be **Float**                                                 |
| Greater or equal   | `>=`   | `>=`                      | In Gleam both values must be **Int**                                                   |
| Greater or equal   | `>=`   | `>=.`                     | In Gleam both values must be **Float**                                                 |
| Less than          | `<`    | `<`                       | In Gleam both values must be **Int**                                                   |
| Less than          | `<`    | `<.`                      | In Gleam both values must be **Float**                                                 |
| Less or equal      | `<=`   | `<=`                      | In Gleam both values must be **Int**                                                   |
| Less or equal      | `<=`   | `<=.`                     | In Gleam both values must be **Float**                                                 |
| Boolean and        | `&&`   | `&&`                      | In Gleam both values must be **Bool**                                                  |
| Boolean or         | <code>&vert;&vert;</code> | <code>&vert;&vert;</code> | In Gleam and Go both values must be **Bool**                        |
| Boolean not        | `xor`  |                           | Not available in Gleam                                                                 |
| Boolean not        | `!`    | `!`                       | In Gleam both values must be **Bool**                                                  |
| Add                | `+`    | `+`                       | In Gleam both values must be **Int**                                                   |
| Add                | `+`    | `+.`                      | In Gleam both values must be **Float**                                                 |
| Subtract           | `-`    | `-`                       | In Gleam both values must be **Int**                                                   |
| Subtract           | `-`    | `-.`                      | In Gleam both values must be **Float**                                                 |
| Multiply           | `*`    | `*`                       | In Gleam both values must be **Int**                                                   |
| Multiply           | `*`    | `*.`                      | In Gleam both values must be **Float**                                                 |
| Divide             | `/`    | `/`                       | In Gleam both values must be **Int**                                                   |
| Divide             | `/`    | `/.`                      | In Gleam both values must be **Float**                                                 |
| Remainder          | `%`    | `%`                       | In Gleam both values must be **Int**                                                   |
| Concatenate        | `+`    | `<>`                      | In Gleam and Go both values must be **String**                                         |
| Pipe               | N/A    | <code>&vert;></code>      | Gleam's pipe can chain function calls. Go does not support this                        |

### Notes on operators

- For bitwise operators, which exist in Go but not in Gleam,
  instead use the `bitwise_*` functions exposed in the `gleam/int` standard library module.
- `==` is by default comparing value for primtive values, and reference for structs, arrays, and interface values in Go.
  - In Gleam equality is checked for structurally.
- Go operators are short-circuiting as in Gleam.

## Constants

### Go

In Go, constants can only be defined at the top level of any file.

```Go
const theAnswer int = 42

func main() {
  fmt.Printf("%d\n", theAnswer) // 42
}
```

They are exported by capitalizing it's name.

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

### Go

Go blocks are always associated with a function / conditional / loop or
similar declaration. Blocks are limited to specific language constructs.
You can create an arbitrary block as well, but it is not an expression
like in Gleam.

Blocks are declared via curly braces.

```Go
func aFunc() {
  // A block starts here
  if someBool {
    // A block here
  } else {
    // A block here
  }
  // Block continues
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

Unlike in Go, in Gleam function blocks are always expressions, so are `case`
blocks or arithmetic sub groups. Because they are expressions they always
return a value.

For Gleam the last value in a block's expression is always the value being
returned from an expression.

## Data types

### Strings

In Go strings are slices (dynamically sized arrays) of bytes. Those bytes are
arbitrary, and are not required to contain Unicode or any other string encoding.
Go's standard library however has extensive support for string operations. Strings
can be built efficiently with a `StringBuilder` type from the `strings` package in
the standard library.  Interpolation can be accomplished using `Sprintf` and other
similar functions found in `fmt` package amongst others in the standard library.
This uses C `strfmt` style format strings that are statically checked at compile time.

In Gleam all strings are unicode binaries. Gleam however offers a `StringBuilder` type via its standard
library which may be more performant than joining strings in some scenarios.

#### Go

```Go
what := "world"
"Hellø, world!"
fmt.Sprintf("Hellø, %d!", what);
```

#### Gleam

```gleam
"Hellø, world!"
```

### Tuples

Tuples are very useful in Gleam as they're a fixed-length collection data type that
allows mixed types in the collection without naming the fields.

#### Go

Go does not support tuples.  It does however support multiple return values, and
anonymous struct types.

```go
myTuple := struct{ username, pwd string; age int }{ "username", "password", 10 }
pwd := myTuple.pwd
fmt.Print(pwd)
fmt.Print(myTuple.pwd)
```

```go
func returnUserInfo() (string, string, int) {
  return "username", "password", 10
}

func main() {
  _, pwd, _ := returnUserInfo()
  fmt.Print(pwd)
}
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

Go and Gleam have very different data structures for representing an ordered
collection of elements of the same type.

#### Go

Go has both arrays - that are statically sized - and slices - that are growable
and dynamically sized. They have a type declared when constructed

```Go
array := [3]int{ 2, 3, 4 }
slice := []int{ 2, 3, 4 }
slice = append(slice, 5, 6) // Adds 5 and 6 to the slice
```

Slices have some unique concerns as regards to references as if you append to
a slice, the underlying array may no longer be in the same memory location as
it was before and some mutative operations can have unexpected behavior for the
unpracticed (or even experienced) Gopher.

#### Gleam

Gleam has syntax for lists destructuring and pattern matching. In Gleam lists are immutable so adding and removing elements from the start of a list is highly efficient.

```gleam
let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // compile error, type mismatch
```

### Maps

Maps are similar in Go and Gleam, except that they are mutated in Go and
immutable in Gleam.

#### Go

```Go
myMap := map[string]string{
  "key1": "value1"
}
fmt.Print(myMap["key1"])
```

#### Gleam

```gleam
import gleam/map

map.from_list([#("key1", "value1"), #("key2", "value2")])
map.from_list([#("key1", "value1"), #("key2", 2)]) // Type error!
```

### Numbers

Go and Gleam both support platform-dependent sized integer and float types.
`Int` and `Float` in Gleam and `int` and `float` in Go sizes for both depend
on the platform: 64-bit or 32-bit hardware and OS and for Gleam JavaScript and Erlang.

#### Go

In Go ints and float are distinct types and there is no automatic type coercion.
You must explicitly convert between even different sized ints and floats

```Go
var x int32 = 2
var y int = 22
x + y // Will not compile
x + int32(int) // Will compile
```

#### Gleam

```gleam
1 / 2 // 0
1.5 + 10 // Compile time error
```

You can use the gleam standard library's `int` and `float` modules to convert
between floats and integers in various ways including `rounding`, `floor`,
`ceiling` and many more.

## Flow control

### Case

Case is how control flow is done in Gleam. It can be seen as a switch
statement with extra abilities. It provides a terse way to match a value type to an
expression. It is also used to replace `if`/`else` statements.

#### Go

Go features 2 different expressions to achieve similar goals:

- `if`/`else if`/`else`
- `switch`/`case`/`default`

```Go
func httpErrorImpl1(status int) string {
  if status == 400 {
      return "Bad request"
  } else if status == 404 {
      return "Not found"
  } else if status == 418 {
      return "I'm a teapot"
  } else {
    return "Internal Server Error"
  }
}

func httpErrorImpl2(status int) string {
  switch (status) {
    case 400:
      return "Bad request"
    case 404:
      return "Not found"
    case 418:
      return "I'm a teapot"
    default:
      return "Internal Server Error"
  }
}
```

#### Gleam

In Gleam, the case expression is similar in concept:

```gleam
case some_number {
  0 -> "Zero"
  1 -> "One"
  2 -> "Two"
  n -> "Some other number" // This matches anything
}
```

As all expressions the case expression will return the matched value.

They can be used to mimick if/else or if/elseif/else, with the exception that
any branch must return unlike in Go, where it is possible to mutate a
variable of the outer block/scope and not return at all.

```gleam
let is_status_within_4xx = status / 400 == 1
case status {
  400 -> "Bad Request"
  404 -> "Not Found"
  _ if is_status_within_4xx -> "4xx" // This works as of now
  // status if status / 400 == 1 -> "4xx" // This will work in future versions of Gleam
  _ -> "I'm not sure"
}
```

if/else example:

```gleam
case is_admin {
  True -> "allow access"
  False -> "disallow access"
}
```

if/elseif/else example:

```gleam
case True {
  _ if is_admin == True -> "allow access"
  _ if is_confirmed_by_mail == True -> "allow access"
  _ -> "deny access"
}
```

Exhaustiveness checking at compile time, which is in the works, will make
certain that you must check for all possible values. A lazy and common way is
to check of expected values and have a catchall clause with a single underscore
`_`:

```gleam
case scale {
  0 -> "none"
  1 -> "one"
  2 -> "pair"
  _ -> "many"
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

#### Go

Go does not offer pipes but if a method returns a type that has methods, they
can be chained.  These sort of methods are not idiomatic in Go and not seen
often.

```Go
// Imaginary Go code
func setOptions() somePkg.Options {
  return options.New().
    WithDelay(200).
    WithCompression(true);
}
```

#### Gleam

```gleam
// Imaginary Gleam code
request
|> session.new()
|> session.authorize()
|> flash.set_success_flash('Logged in successfully!')
|> flash.set_failure_flash('Failed to login!')
|> response.redirect_to_requested_url()
```

Despite being similar to read and comprehend, the Go code creates a session
object, and calls the authorize method of the session object: That session
object then returns another object, say an `AuthorizedUser` object - you don't
know by looking at the code what object gets returned. However you know it must
implement a `setSuccessFlash` method. At the last step of the chain `redirect`
is called on an object returned from `setFailureFlash`.

In the Gleam code the request data is piped into `session.new()`'s first
argument and that return value is piped further down. It is readability sugar
for:

```gleam
response.redirect_to_requested_url(
  flash.set_failure_flash(
    flash.set_success_flash(
      session.authorize(
        session.new(request)
      ),
      'Logged in successfully!'
    ),
    'Failed to login!'
  )
)
```

### Error handling

Error management is approached slightly differently in Go and Gleam.

#### Go

Idiomatic error handling in Go revolves around Error values.  Coupled with Go's
support for multiple return values creates a very straightforward pattern
for error handling that almost defines the Go experience.
```Go
func aFunctionThatFails() error {
  return errors.New("This is an error")
}
```

The callee just needs to check that the err value is nil.

```Go
// callee block
err := aFunctionThatFails()
if err != nil {
	// Handle err
}
// Continue
```

Go also has panics to signal that an error was so extraordinary, the state
of the current goroutine should not continue execution.  Panics can be recovered
from, but this should only happen at a high level and only if it makes sense to
recover.

#### Gleam

In Gleam functions that can fail return the `Result(success, error)` generic type.

A `Result` is either:

- an `Ok` record holding a success value
- an `Error` record holding an error value

Handling errors actually means to match the return value against those two
scenarios, using a case for instance:

```gleam
case parse_int("123") {
  Ok(i) -> io.println("We parsed the Int")
  Error(e) -> io.println("That wasn't an Int")
}
```

Sometimes this can get complicated, and there are functions like `try` from the `gleam/result` module in the standard library that can help:

```gleam
pub fn without_use() {
  result.try(get_username(), fn(username) {
    result.try(get_password(), fn(password) {
      result.map(log_in(username, password), fn(greeting) {
        greeting <> ", " <> username
      })
    })
  })
}
```

But this can get nested quickly.  In order to simplify these scenarios, we can use the `use` construct which allows for a flattening of callbacks to make this code much easier
to read, and somewhat gives one the feel of an early return.

```gleam
pub fn with_use() {
  use username <- result.try(get_username()) // If this fails, we return its error
  use password <- result.try(get_password()) // If this fails, we return its error
  use greeting <- result.map(log_in(username, password))
  greeting <> ", " <> username
}
```

You can see that `use` is great not just for error handling with `result.try`, but for
dealing with higher order functions of all sorts.

## Type aliases

Type aliases allow for easy referencing of arbitrary complex types. They are
supported by both Gleam and Go.

### Go

```go
type Headers = []struct{key, value string}
```

### Gleam


```gleam
pub type Headers =
  List(#(String, String))
```

## Custom types

### Records

Custom type allows you to define a collection data type with a fixed number of
named fields, and the values in those fields can be of differing types.

#### Go

Go uses structs to define user-defined, record-like types.
Properties are defined as fields and initial values are generally set in
the literal form. Any unset fields during construction are defaulted to
their zero value.

Go does not use constructors, but many Go developers will create one or more
functions to construct a struct in an ergonomic way.

```Go
type Person struct {
  name string
  age int
}

func NewPerson(name string, age int) Person {
    return Person{ name, age } // Short hand literal construction
    // Could also be done with
    // return Person { name: name, age: age }
}

// Inside of a function
person := NewPerson("Joe", 40);
person.name // Joe;
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

An important difference to note is there is no object-orientation in
Gleam, thus methods can not be added to types. However opaque types exist,
see below.

### Unions

Go generally does not support unions, with a small exception to that.

In Gleam functions must always take and receive one type. To have a union of
two different types they must be wrapped in a new custom type.

#### Go

Generally the usecase of wanting to use multiple concrete types is solved with
Interfaces.

```Go
type Stringer interface {
	String() string // Types must have a function with this signature defined
}

type StructA struct {
	name string
	age int
}

func (s StructA) String() string {  // This method fulfills the Stringer interface
	return fmt.Sprintf("%s,%d", s.name, s.age)
}

type StructB struct {
	x int
	y int
}

func (s StructB) String() string {  // This method fulfills the Stringer interface
	return fmt.Sprintf("%d,%d", s.x, s.y)
}

func print(str Stringer) {
	fmt.Print(str.String())
}

func main() {
	print(StructA{ "Bob", 47}) // Prints Bob,47
	print(StructB{ 42,0 }) // Prints 42,0
}
```

The only place where Go uses something related to true unions or sum types is in Type Sets,
which are constraints on a Generic.

```go
type Num interface {
	int | float
}
```

Unfortunately, these unions provide little value to the Go Developer due to their
constraints.

#### Gleam

Data modeling in Gleam will often use unions like seen below.  It's a great way to hold single values of different types in a single value.  Pattern matching makes them easy to work with and reason about.

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

In Go, you can choose to not export a type and then they will be considered
opaque to the user of your package.  Just have the type have a lowercase
identifier.  Or, if it's desirable to have the type be referenceable by a
consuming package, the name of the type can be uppercase(public), but all fields
and methods of the type be lowercase(private).  In the latter case the consumer
will be able to construct a zero value for the type, which might not be desirable.

In Gleam, custom types can be defined as being opaque, which causes the
constructors for the custom type not to be exported from the module. Without
any constructors to import other modules can only interact with opaque types
using the intended API.

#### Go

```Go
package mypkg
type myType struct { // Can't be referenced outside of this package

}

func SomeFunc() myType {}
func OtherFunc(mt myType) bool {}
```

```go
package main

import "someurl.com/mymodule/mypkg"

func main() {
  mt := mypkg.SomeFunc()
  if mypkg.OtherFunc(mt) {
    fmt.Println("I can use the opaque type but can't create it!")
  }
}
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

## Modules

Modules in Gleam are the principal unit of code organization. Each
Gleam file is a Module.  A module exports a number of symbols and
can import symbols from other modules.

### Go

In Go, the term _modules_ refers to a set of packages that share
common dependencies and are stored alongside one another.  A _package_
in Go is closer to the Gleam concept of _modules_.  The biggest difference
is that a _package_ in Go can be spread across many files in one directory.

In `mymod/something/something.go`:
```Go
// Anything declared in the something directory will be inside the <path-to-mymod>/something package
package something

// This function is available for import by other packages
func Identity(x any) {
  return x;
}

func privateFunc() {}
```

In `mymod/something/other.go`:
```Go
// Anything declared in the something directory will be inside the <path-to-mymod>/something package
package something

func otherFunc(x any) {
  privateFunc() // Can be used here
  return x;
}

```

We can now call Identity from the main package in your binary.

```Go
package main

import (
  "fmt"
m
  "someurl.com/mymod/something"
)

func main() {
  fmt.Println(something.Identity("Hello, world!"))
  // privateFunc is not visible here
}
```

### Gleam

Coming from Go the closest thing Go has that are similar to Gleam's modules
are static classes: Collections of functions and constants grouped into a
static class.

In comparison Gleam modules can also contain custom types.

A gleam module name corresponds to its file name and path.

Since there is no special syntax to create a module, there can be only one
module in a file and since there is no way name the module the filename
always matches the module name which keeps things simple and transparent.

In `/src/something/somethingElse.gleam`:

```gleam
// Creation of module function identity
// in module somethingElse
pub fn identity(x) {
  x
}
```

Importing the `somethingElse` module and calling a module function:

```gleam
// In src/main.gleam
import something/somethingElse // if something was in a directory called `lib` the import would be `lib/something/somethingElse`.

pub fn main() {
  somethingElse.identity(1) // 1
}
```

### Imports

#### Go

Go imports are fairly simple.  Using `import` keyword with either a string literal
that contains the path to a package, or several such strings each on separate lines
inside of parentheses.

Besides the standard library, all packages have to be fully qualified, where the
qualifier is the name of the containing module, which by convention is the url
at which the module is hosted.

```go
import "fmt" // Single import.  Stdlib packages are referenced bare, no path required
import ( // Multi-package import
  "strings" // Available for use as `strings`

  "github.com/example/example-go-project/somepkg" // Will be available as `somepkg`
)
```

There is no way in Go to import a symbol itself, all imports are qualified by their
package.

```go
fmt.Println()
strings.Trim()
```

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

#### Go

Go allows you to alias a package import

```go
import (
  other "github.com/example/example-go-project/somepkg"
)

func main() {
  other.SomeFunc()
}
```

#### Gleam

Gleam has as similar feature:

```gleam
import unix/cat
import animal/cat as kitty
// cat and kitty are available
```

This may be useful to differentiate between multiple modules that would have the same default name when imported.

### Unqualified imports

#### Go

Go does not support unqualified imports

#### Gleam

```gleam
import animal/cat.{
  Cat,
  stroke
}

pub fn main() {
  let kitty = Cat(name: "Nubi")
  stroke(kitty)
}
```

Importing common types such as `gleam/order.{Lt, Eq, Gt}` or
`gleam/option.{Some,None}` can be very helpful.

## Architecture

To iterate a few foundational differences (Go VS Gleam):

1. Programming model: imperative VS functional immutable
   programming
2. Guarantees: implicit nullability VS explicit nullability
3. Runtime model: lightweight coroutines(`goroutines`) VS Erlang/OTP processes
4. Error handling: error value VS result type .  Both do have some form of runtime panic or exception which can be recovered from.
5. Distribution: Single static binaries VS BEAM virtual machine bytecode (or Javascript code).

### Programming model

- Go is an imperative programming language, with only very limited object-oriented facilities 
  provided. Gleam offers only functional code style, though it can appear
  imperative and reads easily thanks to pipes.
- In Gleam, data structures are never mutated but always updated into new
  structures. This allows processes that fail to simply restart as there are no
  mutated objects that can be in an invalid state and take the whole
  application down (such as in languages like Ruby or Go).
- Gleam offers syntax to make it easy to extract data out of custom types and
  update data into new copies of custom types without ever mutating variables.
  Go sometimes directly mutates references of simple values such as when using
  pointers or global variables, though this is very much not idiomatic.
- Gleam allows to rebind variables freely to make it easy to update data
  structures by making a copy and binding it to the existing variable.
- Go features a massive, powerful standard library centered around simple interfaces.
  Everything from string manipulation to the tools to create an http server are included
  out of the box.  It has been tuned for over 15 years for performance and has strong
  guarantees about backwards and forwards compatibility. While Gleam allows you to opt into a smaller, well polished and consistent standard
  library.

### Guarantees and types

- Both Go and Gleam features strong static typing.
- Both Go and Gleam values are not automatically cast.
- Both Go and Gleam's comparison operators are very strict and limited, any other
  comparisons and conversions must happen via function calls or other explicit type
  conversion mechanisms.
- Go's checks happen at compile time (except for reflection), Gleam uses the compiler
  and pattern matching to allow for robust compile-time checks. But Gleam does have interop with Erlang, a dynamically-typed language that relies on good interfaces written in Gleam to provide any type-safety for those interactions.
- Go has limited type inference, all functions and data structures require explicit types.
  Gleam's type inference allows you to be lazy for almost all type definitions.
  Gleam's type system will always assist you in what types are expected and/or
  conflicting. Gleam's type system will help you discover APIs.

### Runtime model

- Gleam can run on Erlang or JavaScript runtimes.
- Gleam on Erlang allows to processes requests in complete isolation,
  unlike Go, where memory sharing is allowed - though communicating through
  channels is recommended.  Channels and Goroutines allow for good isolation
  if used in a disciplined manner.  That being said, Mutexes and other shared
  state mechanisms are included in the standard library.

  The level of isolation means that, if a process crashes then the supervision
  system can restart that process or after a while or amount of tries abort
  repeating restarts on the process with that given input data. This means
  Erlang can yield incredibly robust concurrent systems, even superior
  to what experienced Gophers can accomplish with Goroutines, Channels, and
  recover patterns.
- When executing Gleam code in fact its compiled Erlang or JavaScript is
  executed. So in case there are runtime crashes, the crash log will show
  Erlang or JavaScript debug information. In Gleam
  applications runtime errors should almost never happen but they are harder
  to read, in Go applications runtime errors might be more common but the will be
  easier to read.

### Error handling

- Gleam will catch all errors that are expected to happen via the `Result`
  type. There can however be other errors, such as miss-behavior due
  accidental to division by 0, crashes on RAM or storage limits, hardware
  failures, etc. In these cases on the BEAM there are ways to manage these
  via Erlang/OTP's supervision trees.
- Go has explicit errors as well, and pairs it with multiple return values
  to provide a similar experience to Gleam, but in an imperative, non-monadic
  form.  Go does have panics which will crash the running goroutine (and if that
  is the main goroutine, the program will crash).  Panics are generally not
  explicitly created by a developer, but there are a number of issues that can cause
  panics to occur:  Division by zero, accessing the field of a nil struct, accessing an
  out of bounds array element, etc.

### Language reach

- Go is tailored towards web applications, servers, CLI tools, and infrastructure.
- Gleam can be utilized as a JavaScript replacement to drive your frontend
  application not just your backend web server.
- Gleam on Erlang/BEAM can be used to write non-blocking, massively concurrent
  server applications comparable to RabbitMQ or multiplayer game servers.---