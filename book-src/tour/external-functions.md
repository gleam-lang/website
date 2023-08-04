# External function

Gleam is just one of many languages on the Erlang virtual machine and JavaScript
runtimes. At times we may want to use functions from these other languages in
our Gleam programs. To enable this Gleam allows the importing of _external
functions_, which may be written in any language on the same runtime.

External functions are typically written in a different language with a
different type system, so the compiler is unable to determine the type of the
function and instead the programmer must inform the compiler the type.

Gleam trusts that the type given is correct so an inaccurate type annotation
can result in unexpected behaviour and crashes at runtime. Be careful!


## Erlang external functions

The Erlang `rand` module has a function named `uniform` that takes no
arguments and returns a `Float`.

The Elixir module `IO` has a function named `inspect` that takes any value,
prints it, and returns the same value.

If we want to import these functions and use them in our program we would do
so like this:

```gleam
@external(erlang, "rand", "uniform")
pub fn random_float() -> Float

// Elixir modules start with `Elixir.`
@external(erlang, "Elixir.IO", "inspect")
pub fn inspect(value: a) -> a
```

## JavaScript external functions

When importing a JavaScript function the path to the module is given instead of
the module name.

```javascript
// In src/my-module.mjs
export function run() {
  return 0;
}
```

```gleam
// In src/my_program.gleam
@external(javascript, "./my-module.js" "run")
pub fn run() -> Int
```

Gleam uses the JavaScript import syntax, so any module imported must use the
esmodule export syntax, and if you are using the NodeJS runtime the file
extension must be `.mjs`.

## Multi-target external functions

An external implementation can be provided for multiple targets by given the
`@external` attribute multiple times.

```gleam  
@external(erlang, "rand" "uniform")
@external(javascript, "./my-module.js" "random")
pub fn random() -> Float
```

The appropriate implementation will be chosen based on the target the program is
being compiled for.

## Gleam fallbacks

A Gleam implementation can be given as a fallback for when no external
implementation has been specified for the current target.

```gleam
@external(erlang, "lists" "reverse")
pub fn reverse(items: List(a)) -> List(a) {
  do_reverse(items, [])
}

fn do_reverse(items: List(a), accumulator: List(a)) -> List(a) {
  case items {
    [] -> accumulator
    [first, ..rest] -> do_reverse(rest, [first, ..accumulator])
  }
}
