# Functions

## Named functions

Named functions in Gleam are defined using the `pub fn` keywords.

```gleam
pub fn add(x: Int, y: Int) -> Int {
  x + y
}

pub fn multiply(x: Int, y: Int) -> Int {
  x * y
}
```

Functions in Gleam are first class values and so can be assigned to variables,
passed to functions, or anything else you might do with any other data type.

```gleam
/// This function takes a function as an argument
pub fn twice(f: fn(t) -> t, x: t) -> t {
  f(f(x))
}

pub fn add_one(x: Int) -> Int {
  x + 1
}

pub fn add_two(x: Int) -> Int {
  twice(add_one, x)
}
```

## Chaining / Pipe Operator

See [Pipe & Capture](./tour/pipe-and-capture.md#markdown-header-my-paragraph-title#Pipe_Operator)

## Type annotations

Function arguments are normally annotated with their type, and the
compiler will check these annotations and ensure they are correct.

```gleam
fn identity(x: some_type) -> some_type {
  x
}

fn inferred_identity(x) {
  x
}
```

The Gleam compiler can infer all the types of Gleam code without annotations
and both annotated and unannotated code is equally safe. It's considered a
best practice to always write type annotations for your functions as they
provide useful documentation, and they encourage thinking about types as code
is being written.

## Generic functions

At times you may wish to write functions that are generic over multiple types.
For example, consider a function that consumes any value and returns a list
containing two of the value that was passed in. This can be expressed in Gleam
like this:

```gleam
fn list_of_two(my_value: a) -> List(a) {
  [my_value, my_value]
}
```

Here the type variable `a` is used to represent any possible type.

You can use any number of different type variables in the same function. This
function declares type variables `a` and `b`.

```gleam
fn multi_result(x: a, y: b, condition: Bool) -> Result(a, b) {
  case condition {
    True -> Ok(x)
    False -> Error(y)
  }
}
```

Type variables can be named anything, but the names must be lower case and may
contain underscores. Like other type annotations, they are completely optional,
but may aid in understanding the code.

## Labelled arguments

When functions take several arguments it can be difficult for the user to
remember what the arguments are, and what order they are expected in.

To help with this Gleam supports _labelled arguments_, where function
arguments are given an external label in addition to their internal name.

Take this function that replaces sections of a string:

```gleam
pub fn replace(string: String, pattern: String, replacement: String) {
  // ...
}
```

It can be given labels like so.

```gleam
pub fn replace(
  in string: String,
  each pattern: String,
  with replacement: String,
) {
  // The variables `string`, `pattern`, and `replacement` are in scope here
}
```

These labels can then be used when calling the function.

```gleam
replace(in: "A,B,C", each: ",", with: " ")

// Labelled arguments can be given in any order
replace(each: ",", with: " ", in: "A,B,C")

// Arguments can still be given in a positional fashion
replace("A,B,C", ",", " ")
```

The use of argument labels can allow a function to be called in an expressive,
sentence-like manner, while still providing a function body that is readable
and clear in intent.

## Anonymous functions

Anonymous functions can be defined with a similar syntax.

```gleam
pub fn run() {
  let add = fn(x, y) { x + y }

  add(1, 2)
}
```

## Partial application / function capturing

See [Pipe & Capture](./tour/pipe-and-capture.md#markdown-header-my-paragraph-title#Function_capturing)

## Documentation

You may add user facing documentation in front of function definitions with a
documentation comment `///` per line. Markdown is supported and this text
will be included with the module's entry in generated HTML documentation.

```gleam
/// Does nothing, returns `Nil`.
///
fn returns_nil(a) -> Nil {
  Nil
}
```
