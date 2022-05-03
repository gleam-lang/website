# Piping & Capturing

In many object oriented languages mutating objects by sequentially executing methods is achieved by returning the object from the object's methods themselves. In an object oriented method chain that object may be of a different object type for each return value while [chaining methods](https://en.wikipedia.org/wiki/Method_chaining).

In some functional languages exist *pipe operators* which achieve similar readability while passing around immutable data - instead of mutable objects - which is transformed at every step of the pipe. Due to its type system in Gleam each call in the pipe must match by type.

Functional piping also resembles the paradigm of many unix-style command line tools which can be piped one after another. Building small functions that do one thing or side effect is a common pattern. These are optimal for flexible pipe composition. Another similarity to unix-style command line tools is returning  exit status codes along with return data. In Gleam a similar thing can be achieved by returning a [Result type](./tour/result.md), a typed variant of result tuples found in Elixir.

Gleam also allows to create partially applied functions. This can also be used to enhance piping which will be discussed below.

## Pipe operator

Gleam provides syntax for passing the return value of one function to the arguments of another function, the pipe operator: `|>`. This is similar in functionality to the same operator in Elixir or F#.

The pipe operator allows you to chain function calls without using a plethora of visually ripping open function signatures. For a simple example, consider the following implementation of `string.reverse` in Gleam:

```gleam
string_builder.to_string(string_builder.reverse(string_builder.new("Hello Hayleigh!")))
```

This can be expressed more clearly and verbosely by binding to an intermediate variable.

```gleam
let value = string_builder.new("Hello Hayleigh!")
let value = string_builder.reverse(value)
let value = string_builder.to_string(value)
```

In Gleam we can also express this naturally using the pipe operator, eliminating the need to track parenthesis closure or binding to intermediate variables.

```gleam
"Hello Hayleigh!"
|> string_builder.new()
|> string_builder.reverse()
|> string_builder.to_string()
```

Each line of this expression applies the function to the result of the previous line. This works easily because each of these functions take only one argument.

When piping into functions with only one argument, the function parenthesis may be omitted:

```gleam
"Hello Hayleigh!"
|> string_builder.new
|> string_builder.reverse
|> string_builder.to_string
```

This is the case because `|>` requires any right side expression to return a function that it will execute.

If however you are piping into functions which take multiple arguments, you will have to supply all but the first argument, which the pipe operator pushes the return value of the previous expression into by default.

```gleam
["Hello", "Harry!"]
|> string.join(with: " ")
|> string.append("\n")
|> string.repeat(2)
```

... which is equal to the far less readable:

```gleam
string.repeat(string.append(string.join(["Hello", "Harry!"], with: " "), "\n"), 2)
```

Note that as with any other function call in Gleam types must match. With piping the return type of the previous function must match the expected type where it is being piped into:

```gleam
["Hello", "Harry!"] // -> List(String)
|> string.join(with: " ") // (List(String), with: String) -> String
|> string.append("\n") // (String, String) -> String
|> string.repeat(2) // (String, Int) -> String
```

Here the returned type may change much like the class of object changes in method chaining, but in contrast to object orientated method chaining, in functional piping the values are not mutated, which allows for safe piping into asynchronous or parallely executed code.

Syntax is available to substitute specific arguments of functions that take more than one argument, which is discussed in the chapter [Function capturing](#Function_capturing).

## Function capturing / partial application

There is a shorthand syntax for creating anonymous functions that take one
argument and call another function. The capture symbol `_` is used to indicate
where the argument should be passed. In Gleam you may only capture one argument.

```gleam
pub fn add(x, y) {
  x + y
}

pub fn run() {
  let add_one = add(1, _)

  add_one(2)
}
```

This can be used to create more specific partially applied functions, say functions that define certain defaults.

## Pipes & function capturing

The function capture syntax is often used with the pipe operator to create
a series of transformations on a value:

```gleam
pub fn add(x: Int , y: Int ) -> Int {
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

In fact, this usage is so common that there is a special shorthand for it:

```gleam
pub fn run() {
  // This is the same as the example above
  1
  |> add(3)
  |> add(6)
  |> add(9)
}
```

Why is this the case? The pipe operator will first check to see if the left hand value could be used
as the first argument to the call, e.g. `a |> b(1, 2)` would become `b(a, 1, 2)`.

If not it falls back to calling the result of the right hand side as a function
, e.g. `b(1, 2)(a)`.

In other words:

```gleam
value |> b(other_arg)
```

... is equal to:

```gleam
value |> b(_, other_arg)
```

... is equal to:

```gleam
let b1 = b(_, other_arg)
b1(value)
```

However, if we define this function:

```gleam
let print_as = fn (level) {
  fn (arg) {
    ["level:", level, "arg:", arg] |> string.concat |> io.print
    arg
  }
}
```

... and are about to call `print_as` in a pipe like so:

```gleam
value |> print_as("info")
```

... then `value` cannot be piped into `print_as("info")`, because the function is complete and there is no capture operator.

When gleam encounters this in pipes, instead the return value of `print_as("info")` must return a function which gleam then executes while passing `value` into it as an argument.

### Passing values in chains into arbitrary arguments

As long as the first argument of a function contains the data to operate on, piping is made easy and the capture operator is not necessary. However sometimes it is required to specify another argument but the first to pipe into. The function capture syntax within pipes allows to specify which argument is being piped into:

```gleam
fn subtract (minuend a, subtrahend b) {
  a - b
}

pub fn main() {
  1 |> subtract(2) // -1
  1 |> subtract(_, 2) // -1
  1 |> subtract(2, _) // 1
}
```

During piping Gleam also detects single holes in functions when specifying named parameters as such:

```gleam
pub fn main() {
  1 |> subtract(subtrahend: 2) // 1 is piped into minuend, returns 1
  1 |> subtract(minuend: 2) // 1 is piped into subtrahend, returns -1
}
```

### Piping into anonymous functions

The pipe operator can also be used to pipe in and out of anonymous functions.

```gleam
"Joe"
|> fn (name) {
  case name {
    "CrownHailer" -> "Hello there CrownHailer,"
    _ -> "Hello Joe,"
  }
}
|> string.append(" have a gleamy day!")
```

## Summary

1. In Gleam function capturing (`_`) allows build more specific functions out of more general functions.
2. The same function capturing syntax can be used within pipes (`|>`) to specify into which argument values are piped to.
3. As a special case, if the expression given during a pipe is a complete function, that function is expected to return a function with one argument, which then is executed by passing the value of the pipe into that function.
