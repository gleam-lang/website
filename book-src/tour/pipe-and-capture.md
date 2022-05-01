# Piping & Capturing

In many object oriented languages mutating objects by sequentially executing methods is achieved by returning the object itself. In an object oriented chain that object may be of a different type and the [chaining methods](https://en.wikipedia.org/wiki/Method_chaining) must return and take in the whole object to achieve this feature and mutate its properties or returning other objects altogether during the chaining.

In functional languages such as F#, Elixir or Gleam exist so called pipe-operators which achieve similar readability while passing around immutable data - instead of mutable objects - which is transformed at every step of the pipe.

This also resembles the paradigm of many unix-style command line tools which can be piped one after another. In this wake, similar to unix-style command line tools, to power functional piping it is recommended to build small functions that do one thing or side effect and thus are optimal for flexible pipe composition.

Another similarity to unix-style command line tools is returning posix exit status codes and data. In Gleam a similar thing can be achieved by returning a [Result type](./tour/result.md), a typed variant of result tuples found in Elixir.

TODO: Add remark about railway oriented programming <https://vimeo.com/113707214>, either-monad, either here and/or better more extensive at the end
TODO: Add remark about <https://redrapids.medium.com/learning-elixir-its-all-reduce-204d05f52ee7>

Gleam also allow to capture partial function application. This can also be used to enhance piping which will be discussed below.

## Pipe operator

Gleam provides syntax for passing the result of one function to the arguments of another function, the pipe operator (`|>`). This is similar in functionality to the same operator in Elixir or F#.

The pipe operator allows you to chain function calls without using a plethora of parenthesis. For a simple example, consider the following implementation of `string.reverse` in Gleam:

```gleam
iodata.to_string(iodata.reverse(iodata.new("Hello Hayleigh!")))
```

This can be expressed more naturally using the pipe operator, eliminating the need to track parenthesis closure.

```gleam
"Hello Hayleigh!"
|> iodata.new()
|> iodata.reverse()
|> iodata.to_string()
```

Each line of this expression applies the function to the result of the previous line. This works easily because each of these functions take only one argument.

When piping functions with only one argument, the function parenthesis may be omitted:

```gleam
"Hello Hayleigh!"
|> iodata.new
|> iodata.reverse
|> iodata.to_string
```

This is because `|>` requires any right side expression to return a function that it will execute.

If however you are piping into functions which take multiple arguments, you will have to supply all but the first argument, which the pipe operator pushes the return value of the previous expression into by default.

```gleam
["Hello", "Harry!"]
|> string.join(with: ", ")
|> string.repeat(2)
```

Syntax is available to substitute specific arguments of functions that take more than one argument;
for more, look below in the section "Function capturing".

## Function capturing

There is a shorthand syntax for creating anonymous functions that take one
argument and call another function. The capture symbol `_` is used to indicate
where the argument should be passed.

```gleam
pub fn add(x, y) {
  x + y
}

pub fn run() {
  let add_one = add(1, _)

  add_one(2)
}
```

## Pipes & function capturing

The function capture syntax is often used with the pipe operator to create
a series of transformations on some data.

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

In fact, this usage is so common that there is a special shorthand for it.

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

However if this is the case:

```gleam
let builder = fn (level) {
  fn (arg) {
    io.print(string.append("level: ", level))
    io.print(string.append("arg: ", arg))
    arg
  }
}
```

... and you are about to call `builder` in a pipe like so `value |> builder("info")`, then `value` cannot be piped into `builder("info")`, because the function is complete and there is no capture operator.

When gleam encounters this in pipes, instead the return value of `builder("info")` must function which gleam then executes passing `value` into it.

### Passing values in chains into arbitrary arguments

While it is generally good design to let the first argument of a function be the data to operator on the function capture syntax within pipes allows to specific which argument is piped into:

```gleam
let divider = fn (dividend, divisor) {
  case divisor {
    0 -> 9_223_372_036_854_775_807 // DivisionResult(Infinity)
    divisor -> dividend / divisor
  }
}

4 |> divider(2) // 2
4 |> divider(2, _) // 0, because in gleam the return of a full integer division `2 / 4` is 0
```

## Summary

In Gleam function capturing allows build more specific functions out of more general functions. The same function capturing syntax can be used within pipes to specify into which argument values are piped to.
