# Modules

Gleam programs are made up of bundles of functions and types called modules.
Each module has its own namespace and can export types and values to be used
by other modules in the program.

```gleam
// inside module src/nasa/rocket_ship.gleam

fn count_down() {
  "3... 2... 1..."
}

fn blast_off() {
  "BOOM!"
}

pub fn launch() {
  [
    count_down(),
    blast_off(),
  ]
}
```

Here we can see a module named `nasa/rocket_ship`, the name determined by the
filename `src/nasa/rocket_ship.gleam`. Typically all the modules for one
project would live within a directory with the name of the project, such as
`nasa` in this example.

For the functions `count_down` and `blast_off` we have omitted the `pub`
keyword, so these functions are _private_ module functions. They can only be
called by other functions within the same module.


## Import

To use functions or types from another module we need to import them using the
`import` keyword.

```gleam
// inside module src/nasa/moon_base.gleam

import nasa/rocket_ship

pub fn explore_space() {
  rocket_ship.launch()
}
```

The statement `import nasa/rocket_ship` creates a new variable with the name
`rocket_ship` and the value of the `rocket_ship` module.

In the `explore_space` function we call the imported module's public `launch`
function using the `.` operator. If we had attempted to call `count_down` it
would result in a compile time error as this function is private to the
`rocket_ship` module.


## Named import

It is also possible to give a module a custom name when importing it using the
`as` keyword.

```gleam
import unix/cat
import animal/cat as kitty
```

This may be useful to differentiate between multiple modules that would have
the same default name when imported.


## Unqualified import

Values and types can also be imported in an unqualified fashion.

```gleam
import animal/cat.{Cat, stroke}

pub fn main() {
  let kitty = Cat(name: "Nubi")
  stroke(kitty)
}
```

This may be useful for values that are used frequently in a module, but
generally qualified imports are preferred as it makes it clearer where the
value is defined.


## The prelude module

There is one module that is built into the language, the `gleam` prelude
module.  By default its types and values are automatically imported into
every module you write, but you can still choose to import it the regular way.
This may be useful if you have created a type or value with the same name as
an item from the prelude.

```gleam
import gleam

/// This definition locally overrides the `Result` type
/// and the `Ok` constructor.
pub type Result {
  Ok
}

/// The original `Result` and `Ok` can still be used
pub fn go() -> gleam.Result(Int) {
  gleam.Ok(1)
}
```

The prelude module contains these types:

- `BitString`
- `Bool`
- `Float`
- `Int`
- `List(element)`
- `Nil`
- `Result(value, error)`
- `String`
- `UtfCodepoint`

And these values:

- `Error`
- `False`
- `Nil`
- `Ok`
- `True`

## Documentation

You may add user facing documentation at the head of modules with a module
documentation comment `////` per line. Markdown is supported and this text
will be included with the module's entry in generated HTML documentation.
