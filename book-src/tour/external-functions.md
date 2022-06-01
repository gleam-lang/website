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
pub external fn random_float() -> Float =
  "rand" "uniform"

// Elixir modules start with `Elixir.`
pub external fn inspect(a) -> a =
  "Elixir.IO" "inspect"
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
pub external fn run() -> Int =
  "./my-module.js" "run"
```

Gleam uses the JavaScript import syntax, so any module imported must use the
esmodule export syntax, and if you are using the NodeJS runtime the file
extension must be `.mjs`.

## Labelled arguments

Like regular functions, external functions can have labelled arguments.

```gleam
pub external fn any(in: List(a), satisfying: fn(a) -> Bool) =
  "my_external_module" "any"
```

This function has the labelled arguments `in` and `satisfying`, and can be
called like so:

```gleam
any(in: my_list, satisfying: is_even)
any(satisfying: is_even, in: my_list)
```
