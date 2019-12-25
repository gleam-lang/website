# Function

## Named functions

Named functions in Gleam are defined using the `pub fn` keywords.

```rust,noplaypen
pub fn add(x, y) {
  x + y
}

pub fn multiply(x, y) {
  x * y
}
```

Functions in Gleam are first class values and so can be assigned to variables,
passed to functions, or anything else you might do with any other data type.

```rust,noplaypen
// This function takes a function as an argument
pub fn twice(f, x) {
  f(f(x))
}

pub fn add_one(x) {
  x + 1
}

pub fn add_two(x) {
  twice(add_one, x)
}
```


## Type annotations

Function arguments can be optionally be annotated with their type. The
compiler will check these annotations and ensure they are correct.

```rust,noplaypen
fn identity(x: Int) -> Int {
  x
}
```

Without an annotation this identity function would have have the inferred type
`fn(a) -> a`, but the type annotation on the argument results in the type
of the function being `fn(Int) -> Int`. This shows how type annotations can be
used to create functions with types less general than the compiler may have
inferred otherwise.


## Labelled arguments

When functions take several arguments it can be difficult for the user to
remember what the arguments are, and what order they are expected in.

To help with this Gleam supports _labelled arguments_, where function
arguments are given an external label in addition to their internal name.

Take this function that replaces sections of a string:

```rust,noplaypen
pub fn replace(string, pattern, replacement) {
  // ...
}
```

It can be given labels like so.

```rust,noplaypen
pub fn replace(in string, each pattern, with replacement) {
  // The variables `string`, `pattern`, and `replacement` are in scope here
}
```

These labels can then be used when calling the function.

```rust,noplaypen
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

```rust,noplaypen
pub fn run() {
  let add = fn(x, y) { x + y }

  add(1, 2)
}
```

## Function capturing

There is a shorthand syntax for creating anonymous functions that take one
argument and call another function. The `_` is used to indicate where the
argument should be passed.

```rust,noplaypen
pub fn add(x, y) {
  x + y
}

pub fn run() {
  let add_one = add(1, _)

  add_one(2)
}
```

The function capture syntax is often used with the pipe operator to create
a series of transformations on some data.

```rust,noplaypen
pub fn add(x, y) {
  x + y
}

pub fn run() {
  // This is the same as add(add(add(1, 3), 6), 9)
  1
  |> add(_, 3)
  |> add(_, 6)
  |> add(_, 9)
}
```
