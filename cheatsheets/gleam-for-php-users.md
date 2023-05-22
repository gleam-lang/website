---
layout: page
title: Gleam for PHP users
subtitle: Hello Hypertext crafters!
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
  - [Unions](#unions)
  - [Opaque custom types](#opaque-custom-types)
- [Modules](#modules)
  - [Imports](#imports)
  - [Named imports](#named-imports)
  - [Unqualified imports](#unqualified-imports)
- [Architecture](#architecture)

## Comments

### PHP

In PHP, comments are written with a `//` prefix.

```php
// Hello, Joe!
```

Multi line comments may be written like so:

```php
/*
 * Hello, Joe!
 */
```

IN PHP, above `trait`, `interface`, `class`, `member`, `function` declarations
there can be `docblocks` like so:

```php
/**
 * a very special trait.
 */
trait Foo {}

/**
 * A Bar class
 */
class Bar {}

/**
 * A quux function.
 *
 * @var string $str        String passed to quux
 * @return string          An unprocessed string
 */
function quux(string $str) : string { return $str; }
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

### PHP

```php
$size = 50;
$size = $size + 100;
$size = 1;
```

In local scope PHP has no specific variable keyword. You choose a name
and that's it!

In class scope for property declaration PHP uses at least one related
modifier keyword to create properties such as: `public`, `private`,
`protected`, `static` or `readonly` (`var` is deprecated).

### Gleam

Gleam has the `let` keyword before its variable names.

```gleam
let size = 50
let size = size + 100
let size = 1
```

### Match operator

#### PHP

PHP supports basic, one directional destructuring (also called unpacking).
Tuple of values can be unpacked and inner values can be assigned to left-hand
variable names.

```php
[$a, $b] = [1, 2];
// $a == 1
// $b == 2

[1 => $idx2] = ['foo', 'bar', 'quux'];
// $idx2 == 'bar'

["profession" => $job] = ['name' => 'Joe', 'profession' => 'hacker'];
// $job == 'hacker'
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

#### PHP

PHP is a dynamically typed language. Types are only checked at runtime and
a variable can have different types in its lifetime.

PHP gradually introduced more and more type hints that are optional.
The type information is accessible via `get_type()` at runtime.

These hints will mainly be used to inform static analysis tools like IDEs,
linters, etc.

```php
class Foo {
  private ?string $bar;
}
```

As PHP's `array` structure is a combination of maps and arrays.
The PHP manual states that it is an *ordered map*.
While creating arrays in PHP the type of its elements cannot be set explicitly
and each element can be of a different type:

```php
$someList = [1, 2, 3];
$someTuple = [1, "a", true];
$someMap = [0 => 1, "foo" => "bar", true => false];
```

Single variables cannot be type-annotated unless they are `class` or `trait`
members.

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```gleam
let some_list: List(Int) = [1, 2, 3]
let some_String: String = "Foo"
```

Gleam will check the type annotation to ensure that it matches the type of the
assigned value. It does not need annotations to type check your code, but you
may find it useful to annotate variables to hint to the compiler that you want
a specific type to be inferred.

## Functions

### PHP

In PHP, you can define functions with the `function` keyword. One or many `return`
keywords are optional.

```php
function hello($name = 'Joe') : string
{
  if ($name = 'Joe') {
    return 'Hello back, Joe!';
  }
  return "Hello $name";
}

function noop()
{
  // Will automatically return NULL
}
```

Anonymous functions returning a single expression can also be defined and be
bound to variables.

```php
$x = 2
$phpAnonFn = function($y) use ($x) { return $x * $y; }; // Creates a new scope
$phpAnonFn(2, 3); // 6
$phpArrowFn = ($x) => $x * $y; // Uses the outside scope
$phpArrowFn(2, 3); // 6
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

A difference between PHP's and Gleam's anonymous functions is that in PHP they
create a new local scope, in Gleam they close over the local scope, aka create
a copy and inherit all variables in the scope. This means that in Gleam you can
shadow local variables within anonymous functions but you cannot influence the
variable bindings in the outer scope. This is different for PHP's arrow
functions where they inherit the scope like Gleam does.

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

#### PHP

In PHP, top level functions are exported by default. There is no notion of
private module-level functions.

However at class level, all properties are public, by default.

```php
class Foo {
  static $bar = 5;
  private $quux = 6;

  static function batz() {
    return "Hello Joe!";
  }

  private static function kek() {
    return "Hello Rasmus!";
  }
}
echo Foo::$bar; // 5
echo Foo::$quux; // Error
echo Foo::batz(); // "Hello Joe"
echo Foo::kek(); // Error
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

### PHP

Global functions may exist in a global scope, and to execute functions or
create objects and invoke methods at some point they have to be called from
the global scope. Usually there is one `index.php` file whose global scope
acts as if it was the `main()` function.

### Gleam

Gleam does not support a global scope. Instead Gleam code is either
representing a library, which can be required as a dependency, and/or it
represents an application having a main module, whose name must match to the
application name and within that `main()`-function which will be called via
either `gleam run` or when the `entrypoint.sh` is executed.

In contrast to PHP, where any PHP file can contain a global scope that can
be invoked by requiring the file, in Gleam only code that is within functions
can be invoked.

On the Beam, Gleam code can also be invoked from other Erlang code, or it
can be invoked from browser's JavaScript, Deno or NodeJS runtime calls.

### Function type annotations

#### PHP

Type hints can be used to optionally annotate function arguments and return
types.

Discrepancies between type hints and actual values at runtime do not prevent
interpretation of the code. Static code analysers (IDE tooling, type checkers
like `phpstan`) will be required to detect those errors.

```php
function sum(int $x, int $y) : int {
    return $x + $y;
}

function mul(int $x, int $y) : bool {
    # no errors from the interpreter.
    return $x * $y;
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

### Referencing functions

#### PHP

As long as functions are in scope they can be assigned to a new variable.
As methods or static functions classes, functions can be accessed via
`$this->object_instance_method()` or `self::static_class_function()`.

Other than that only anonymous functions can be moved around the same way as
other values.

```php
$doubleFn = function($x) { return $x + $x; };
// Some imaginary pushFunction
pushFunction($queue, $doubleFn);
```

However in `PHP` it is not possible to pass around global, class or instance
functions as values.

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

Both PHP and Gleam have ways to give arguments names and in any order.

#### PHP

When calling a function, arguments can be passed:

- positionally, in the same order of the function declaration
- by name, in any order

```php
// Some imaginary replace function
function replace(string $each, string $with, string $inside) {
  // TODO implementation
}
// Calling with positional arguments:
replace(",", " ", "A,B,C")
// Calling with named arguments:
replace(inside: "A,B,C", each: ",", with: " ")
```

#### Gleam

In Gleam arguments can be given a label as well as an internal name.
Contrary to PHP, the name used at the call-site does not have to match
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

There is no performance cost to Gleam's labelled arguments as they are
optimised to regular function calls at compile time, and all the arguments
are fully type checked.

## Operators

| Operator           | PHP    | Gleam                     | Notes                                                                                  |
| ------------------ | ------ | ------------------------- | -------------------------------------------------------------------------------------- |
| Equal              | `==`   | `==`                      | In Gleam both values must be of the same type                                          |
| Strictly equal to  | `===`  | `==`                      | Comparison in Gleam is always strict. (see note for PHP)                               |
| Reference equality | `instanceof` |                     | True only if an object is an instance of a class                                       |
| Not equal          | `!=`   | `!=`                      | In Gleam both values must be of the same type                                          |
| Not equal          | `!==`  | `!=`                      | Comparison in Gleam is always strict (see note for PHP)                                |
| Greater than       | `>`    | `>`                       | In Gleam both values must be **Int**                                                   |
| Greater than       | `>`    | `>.`                      | In Gleam both values must be **Float**                                                 |
| Greater or equal   | `>=`   | `>=`                      | In Gleam both values must be **Int**                                                   |
| Greater or equal   | `>=`   | `>=.`                     | In Gleam both values must be **Float**                                                 |
| Less than          | `<`    | `<`                       | In Gleam both values must be **Int**                                                   |
| Less than          | `<`    | `<.`                      | In Gleam both values must be **Float**                                                 |
| Less or equal      | `<=`   | `<=`                      | In Gleam both values must be **Int**                                                   |
| Less or equal      | `<=`   | `<=.`                     | In Gleam both values must be **Float**                                                 |
| Boolean and        | `&&`   | `&&`                      | In Gleam both values must be **Bool**                                                  |
| Logical and        | `&&`   |                           | Not available in Gleam                                                                 |
| Boolean or         | <code>&vert;&vert;</code> | <code>&vert;&vert;</code> | In Gleam both values must be **Bool**                               |
| Logical or         | <code>&vert;&vert;</code> |        | Not available in Gleam                                                                 |
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
| Concatenate        | `.`    | `<>`                      | In Gleam both values must be **String**
| Pipe               | `->`   | <code>&vert;></code>      | Gleam's pipe can chain function calls. See note for PHP                                |

### Notes on operators

- For bitwise operators, which exist in PHP but not in Gleam,
  see: <https://github.com/gleam-lang/bitwise>.
- `==` is by default comparing by value in PHP:
  - Types may be autocast to be compareable.
  - Two objects with the same members values will equal:
- `===` is for comparing by strict equality in PHP:
  - Types will not be autocast for comparison
  - Two objects with the same members will not equal. Only if a variable binds
    to the same reference it will equal.
- PHP operators are short-circuiting as in Gleam.
- Chains and pipes:
  - In PHP chaining is usually done by constructing class methods that return
    an object: `$foo->bar(1)->quux(2)` means `bar(1)` is called as a method
    of `$foo` and then `quux()` is called as a method of the return value
    (object) of the `bar(1)` call. The objects in this chain usually
    mutate to keep the changed state and carry it forward in the chain.
  - In contrast in Gleam piping, no objects are being returned but mere data
    is pushed from left to right much like in unix tooling.

## Constants

### PHP

In PHP, constants can only be defined within classes and traits.

```php
class TheQuestion {
  public const theAnswer = 42;
}
echo TheQuestion::theAnswer; // 42
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

### PHP

PHP blocks are always associated with a function / conditional / loop or
similar declaration. Blocks are limited to specific language constructs.
There is no way to create multi-line expressions blocks like in Gleam.

Blocks are declared via curly braces.

```php
function a_func() {
  // A block starts here
  if ($foo) {
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

Unlike in PHP, in Gleam function blocks are always expressions, so are `case`
blocks or arithmetic sub groups. Because they are expressions they always
return a value.

For Gleam the last value in a block's expression is always the value being
returned from an expression.

## Data types

### Strings

In PHP strings are stored as an array of bytes and an integer indicating the
length of the buffer. PHP itself has no information about how those bytes
translate to characters, leaving that task to the programmer. PHP's
standard library however features a bunch of multi-byte compatible functions
and conversion functions between UTF-8, ISO-8859-1 and further encodings.

PHP strings allow interpolation.

In Gleam all strings are UTF-8 encoded binaries. Gleam strings do not allow
interpolation, yet. Gleam however offers a `string_builder` via its standard
library for performant string building.

#### PHP

```php
$what = 'world';
'Hellø, world!';
"Hellø, ${what}!";
```

#### Gleam

```gleam
"Hellø, world!"
```

### Tuples

Tuples are very useful in Gleam as they're the only collection data type that
allows mixed types in the collection.

#### PHP

PHP does not really support tuples, but its array type can easily be used to
mimick tuples. Unpacking can be used to bind a name to a specific value of
the tuple.

```php
$myTuple = ['username', 'password', 10];
[$_, $pwd, $_] = $myTuple;
echo $pwd; // "password"
// Direct index access
echo $myTuple[0]; // "username"
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
```

### Maps

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
```

### Numbers

PHP and Gleam both support `Integer` and `Float`. Integer and Float sizes for
both depend on the platform: 64-bit or 32-bit hardware and OS and for Gleam
JavaScript and Erlang.

#### PHP

While PHP differentiates between integers and floats it automatically converts
floats and integers for you, removing precision or adding floating point
decimals.

```php
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

## Flow control

### Case

Case is one of the most used control flow in Gleam. It can be seen as a switch
statement on steroids. It provides a terse way to match a value type to an
expression. It is also used to replace `if`/`else` statements.

#### PHP

PHP features 3 different expressions to achieve similar goals:

- `if`/`else if`/`else` (does not return)
- `switch`/`case`/`break`/`default` (does not return, does not autobreak)
- `match` (returns)

```php
function http_error_impl_1($status) {
  if ($status === 400) {
      return "Bad request";
  } else if ($status === 404) {
      return "Not found";
  } else if ($status === 418) {
      return "I'm a teapot";
  } else {
    return "Internal Server Error";
  }
}

function http_error_impl_2($status) {
  switch ($status) {
    case "400": // Will work because switch ($status) compares non-strict as in ==
      return "Bad request";
      break; // Not strictly required here, but combined with weak typing multiple cases could be executed if break is omitted
    case 404:
      return "Not found";
      break;
    case 418:
      return "I'm a teapot";
      break;
    default:
      return "Internal Server Error";
  }
}

function http_error_impl_3($status) {
  return match($status) { // match($status) compares strictly
    400 => "Bad request",
    404 => "Not found",
    418 => "I'm a teapot",
    default => "Internal Server Error"
  };
}
```

#### Gleam

The case operator is a top level construct in Gleam:

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
any branch must return unlike in PHP, where it is possible to mutate a
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

#### PHP

PHP does not offer pipes but it can chain calls by making functions return
objects which in turn ship with their list of methods.

```php
// Imaginary PHP code
(new Session($request))
  ->authorize()
  ->setSuccessFlash('Logged in successfully!')
  ->setFailureFlash('Failed to login!')
  ->redirectToRequestedUrl();
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

Despite being similar to read and comprehend, the PHP code creates a session
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

### Try

Error management is approached differently in PHP and Gleam.

#### PHP

PHP uses the notion of exceptions to interrupt the current code flow and
pop up the error to the caller.

An exception is raised using the keyword `throw`.

```php
function aFunctionThatFails() {
  throw new RuntimeException('an error');
}
```

The callee block will be able to capture any exception raised in the block
using a `try/except` set of blocks:

```php
// callee block
try {
    echo 'this line will be executed and thus printed';
    aFunctionThatFails()
    echo 'this line will not be executed and thus not printed';
} catch (Throwable $e) {
    var_dump(['doing something with the exception', $e]);
}
```

#### Gleam

In contrast in gleam, errors are just containers with an associated value.

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

In order to simplify this construct, we can use the `try` keyword that will:

- either bind a value to the providing name if `Ok(Something)` is matched,
- or **interrupt the current block's flow** and return `Error(Something)` from
  the given block.

```gleam
let a_number = "1"
let an_error = Error("ouch")
let another_number = "3"

try int_a_number = parse_int(a_number)
try attempt_int = parse_int(an_error) // Error will be returned
try int_another_number = parse_int(another_number) // never gets executed

Ok(int_a_number + attempt_int + int_another_number) // never gets executed
```

## Type aliases

Type aliases allow for easy referencing of arbitrary complex types.
PHP does not have this feature, though either regular classes or static classes
can be used to design custom types and class definitions in take can be aliased
using `class_alias()`.

### PHP

A simple variable can store the result of a compound set of types.

```php
static class Point {
  // Can act as an opaque type and utilize Point
  // Can be class_aliased to Coordinate
}

static class Triangle {
  // Can act as an opaque type definition and utilize Point
}
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

#### PHP

PHP uses classes to define user-defined, record-like types.
Properties are defined as class members and initial values are generally set in
the constructor.

By default the constructor does not provide base initializers in the
constructor so some boilerplate is needed:

```php
class Person {
  public string $name;
  public int $age;
  function __construct(string $name, int $age) {
    $this->name = $name;
    $this->age = $age;
  }
}
$person = new Person(name: "Joe", age: 40);
// $person->name // Joe;
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

### Unions

PHP generally does not support unions with a few exceptions such as:

- type x or `null`
- `Array` or `Traversable`.

In Gleam functions must always take and receive one type. To have a union of
two different types they must be wrapped in a new custom type.

#### PHP

```php
class Foo {
  public ?string $aStringOrNull;
}
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

In PHP, constructors can be marked as private and opaque types can either be
modelled in an immutable way via static classes or in a mutable way via
a factory pattern.

In Gleam, custom types can be defined as being opaque, which causes the
constructors for the custom type not to be exported from the module. Without
any constructors to import other modules can only interact with opaque types
using the intended API.

#### PHP

```php
class PointObject
{
  private int $x;
  private int $y;

  private function __construct(int $x, int $y) {
      $this->x = $x;
      $this->y = $y;
  }

  public static function spawn(int $x, int $y) {
    if ($x >= 0 && $x <= 99 && $y >= 0 && $y <= 99) {
      return new self($x, $y);
    }
    return false;
  }
}
PointObject::spawn(1, 2); // Returns a Point object
```

This requires mutation, but prohibits direct property changes.

PHP allows to skip object mutation by using static classes:

```php
class PointStruct
{
  public static function spawn(int $x, int $y) {
    if ($x >= 0 && $x <= 99 && $y >= 0 && $y <= 99) {
      return compact('x', 'y') + ['struct' => __CLASS__];
    }
    return false;
  }
}
PointStruct::spawn(1, 2); // Returns an array managed by PointStruct
```

However PHP will in this case not prohibit the direct alteration the returned
structure, like Gleam's custom types can.

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

### PHP

PHP does not feature modules, but many other containers such as classes, traits
and interfaces. Historically a single file can contain many classes, traits and
interfaces one after another, though it is best practise to only contain one
such declaration per file.

Using PHP namespaces, these can be placed in a registry that does not need to
map to the source code file system hierarchy, but by convention should.

In `src/Foo/Bar.php`:

```php
// Anything declared in this file will be inside namespace Foo
namespace Foo;

// Creation of (static) class Bar in Foo, thus as Foo/Bar
class Bar {
  public static function identity($x) {
    return $x;
  }
}
```

Making the static class available in the local scope and calling the function
`index.php` (aka PHP's main function):

```php
// After auto-loading has happened
use Foo\Bar;

Bar::identity(1) // 1;
```

### Gleam

Coming from PHP the closest thing PHP has that are similar to Gleam's modules
are static classes: Collections of functions and constants grouped into a
static class.

In comparison Gleam modules can also contain custom types.

A gleam module name corresponds to its file name and path.

Since there is no special syntax to create a module, there can be only one
module in a file and since there is no way name the module the filename
always matches the module name which keeps things simple and transparent.

In `/src/foo/bar.gleam`:

```gleam
// Creation of module function identity
// in module bar
pub fn identity(x) {
  x
}
```

Importing the `bar` module and calling a module function:

```gleam
// In src/main.gleam
import foo/bar // if foo was in a directory called `lib` the import would be `lib/foo/bar`.

pub fn main() {
  bar.identity(1) // 1
}
```

### Imports

#### PHP

PHP features ways to load arbitrary PHP code: `require`, `include` and
autoload such as `spl_autoload_register`. Once class pathes are known and
registered for autoloading, they can brought into the scope of a file by using
the `use`statement which is part of PHP's namespacing.
Also see <https://www.php-fig.org/psr/psr-4/>.

Inside `src/Nasa/MoonBase.php`

```php
// Makes available src/nasa/RocketShip.php
use Nasa\RocketShip;

class MoonBase {
  public static function exploreSpace() {
    RocketShip::launch();
  }
}
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

#### PHP

PHP features namespaces which can be used to rename classes when they clash:

```php
// Source files must first be added to the auto-loader
use Unix\Cat;
use Animal\Cat as Kitty;
// Cat and Kitty are available
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

#### PHP

```php
use Animal\Cat{
  Cat,
  function stroke
};
```

```php
$kitty = new Cat(name: "Nubi");
stroke($kitty);
```

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

To iterate a few foundational differences:

1. Programming model: Java-style object-orientation VS functional immutable
   programming
2. Guarantees: weak dynamic typing VS strong static typing
3. Runtime model: request-response script VS Erlang/OTP processes
4. Error handling: exceptions VS result type
5. Language reach

### Programming model

- PHP mixes imperative, Java-style object-orientation and functional code
  styles. Gleam offers only functional code style, though it can appear
  imperative and reads easily thanks to pipes.
- In Gleam, data structures are never mutated but always updated into new
  structures. This allows processes that fail to simply restart as there are no
  mutated objects that can be in an invalid state and take the whole
  application down (such as in Go, Ruby or PHP).
- Gleam offers syntax to make it easy to extract data out of custom types and
  update data into new copies of custom types without ever mutating variables.
  PHP sometimes directly mutates references of simple values such as when using
 `reset()` or `end()` or `array_pop()`.
- Gleam allows to rebind variables freely to make it easy to update data
  structures by making a copy and binding it to the existing variable.
- PHP features a massive, powerful but inconsistent standard library that is
  always loaded and partially extended and deprecated with new PHP releases.
- Gleam allows you to opt into a smaller, well polished and consistent standard
  library.

### Guarantees and types

- PHP features opt-in static typing which is only checked at runtime.
- PHP values tend to be automatically cast for comparison purposes or when used
  as indexes in arrays. Gleam values are not automatically cast.
- PHP allows comparison between most if not all values, even if it does not
  make any sense say comparing a file `resource` to a `Date` in terms of order.
  Gleam's comparison operators are very strict and limited, any other
  comparisons and conversions must happen via function calls.
- PHP's checks happen at runtime, Gleam's checks (for the most part) do not
  and rely on the compiler to allow only type safe and sound code to be
  compiled.
- Gleam's type inference allows you to be lazy for almost all type definitions.
  Gleam's type system will always assist you in what types are expected and/or
  conflicting. Gleam's type system will help you discover APIs.

### Runtime model

- Gleam can run on Erlang/BEAM, on the browser but also Deno or NodeJS.
- For Gleam on Erlang/BEAM the runtime model has some striking similarities
  in practise: In PHP a script starts and runs. It allocates memory for this
  script and frees it upon end or after the max execution time is exceeded
  or the memory limit is exceeded.
- Gleam on Erlang/BEAM allows to processes requests in a similar isolation
  level that PHP offers in contrast to applications running *Go* or *Ruby*.
  The level of isoluation means that, very similar to PHP, if a process
  crashes (in PHP read: if a request crashes) then the supervision system
  can restart that process or after a while or amount of tries abort
  repeating restarts on the process with that given input data. This means
  Erlang/BEAM will yield similar robustness that PHP developers are used
  to and similar isoluation guarantuees.
- When executing Gleam code in fact its compiled Erlang or JavaScript is
  executed. So in case there are runtime crashes, the crash log will show
  Erlang (or browser-console/NodeJS/Deno) debug information. In Gleam
  applications runtime errors should almost never happen but they are harder
  to read, in PHP applications runtime errors much more often and are easier
  to read.

### Error handling

- Gleam will catch all errors that are expected to happen via the `Result`
  type. There can however be other errors, such as miss-behavior due
  accidental to division by 0, crashes on RAM or storage limits, hardware
  failures, etc. In these cases on the BEAM there are ways to manage these
  via BEAM's supervision trees.
- In contrast PHP will use exceptions to handle errors and by doing so blurs
  the line between expected errors and unexpected errors. Also function
  signatures are enlarged de-facto by whatever exceptions they can throw
  and thus function calls and return types become much harder to manage.

### Language reach

- PHP is tailored towards web applications, servers, and static to low-dynamic
  frontends.
- Gleam can be utilized as a JavaScript replacement to drive your frontend
  application not just your backend web server.
- Gleam on Erlang/BEAM can be used to write non-blocking, massively concurrent
  server applications comparable to RadditMQ or multiplayer game servers.
