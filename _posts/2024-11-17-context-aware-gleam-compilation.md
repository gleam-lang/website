---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Context aware compilation
subtitle: Gleam v1.5.0 released
tags:
  - Release
---

Gleam is a type-safe and scalable language for the Erlang virtual machine and
JavaScript runtimes. Today Gleam [v1.6.0][release] has been published, featuring
so many excellent improvements that I struggled to one to title this post with.
Let's take a look a them now.

[release]: https://github.com/gleam-lang/gleam/releases/tag/v1.6.0

## Context aware errors

A big part of what makes Gleam productive is the way its powerful static
analysis can immediately provide you feedback as you type, enabling you to
confidently make changes within large or unfamiliar codebases. Much of this
feedback will come in the form of error messages, so it is vital that they are
as clear and as understandable as possible.

With this release Gleam's errors are now _context aware_ and will use
data from the compiler's code analysis system to display type information using
the names and the syntax that the programmer would use within that specific
area of the code.

For example, here is some code with a type error.

```gleam
import gleam/order

pub fn run(value: order.Order) -> Int {
  100 + value
}
```
```txt
error: Type mismatch
  ┌─ /src/problem.gleam:4:9
  │
4 │   100 + value
  │         ^^^^^

The + operator expects arguments of this type:

    Int

But this argument has this type:

    order.Order
```

Notice how the `Order` type is qualified with the module name, the same as the
programmer would write in this module. If the module is aliased when imported
that alias will also be used in the error.

```diff
-import gleam/order
+import gleam/order as some_imported_module

-pub fn run(value: order.Order) -> Int {
+pub fn run(value: some_imported_module.Order) -> Int {
  100 + value
}
```
```diff
error: Type mismatch
  ┌─ /src/problem.gleam:4:9
  │
4 │   100 + value
  │         ^^^^^

The + operator expects arguments of this type:

    Int

But this argument has this type:

-   order.Order
+   some_imported_module.Order
```
Or the type could be imported in an unqualified fashion, in which case the error
would not have the redundant qualifier. Maybe don't write code like this though.

```gleam
pub type Int
pub type String

pub fn run() {
  [100, "123"]
}
```
```txt
error: Type mismatch
  ┌─ /src/thingy.gleam:6:9
  │
6 │   [100, "123"]
  │         ^^^^^

All elements of a list must be the same type, but this one doesn't
match the one before it.

Expected type:

    gleam.Int

Found type:

    gleam.String
```

These context aware errors should reduce the mental overhead of understanding
them, making Gleam programming easier and more productive.
Thank you [Surya Rose](https://github.com/GearsDatapacks) for this!

## Context aware editing hovering

Not being satisfied with improving only the error messages, Surya has also made
the language server hover support context aware. This means that if you hover
over Gleam code in your editor the type information will be shown using the
appropriate names and syntax for that module.

```gleam
import gleam/option

const value = option.Some(1)
//    ^ hovering here shows `option.Option(Int)`
```
```gleam
import gleam/option.{type Option as Maybe}

const value = option.Some(1)
//    ^ hovering here shows `Maybe(Int)`
```

Thank you again Surya!

## Add annotations code action

In Gleam all type annotations are optional, full analysis is always performed.
Adding annotations does not make your code more safe or well typed, but we still
think it's a good idea to add them to make your code easier to read.

If your colleague has sadly forgotten this and not written any annotations for
their functions you can use the language server's new code action within your
editor to add missing annotations.

```gleam
pub fn add_int_to_float(a, b) {
  a +. int.to_float(b)
}
```
```gleam
pub fn add_int_to_float(a: Float, b: Int) -> Float {
  a +. int.to_float(b)
}
```

Thanks to, you guessed it, [Surya Rose](https://github.com/GearsDatapacks) for
this new feature!

## Erlang compilation daemon

When targeting the Erlang virtual machine the build tool makes use of the Erlang
compiler to generate BEAM bytecode for Gleam code, taking advantage of all of
its optimisations. The Erlang compiler is written in Erlang, so this would
involve booting the virtual machine and the compiler once per package, including
each of the project dependencies. In the worst case on a slow machine this could
take as much as half a second each time, which would add up and slow down
from-scratch build times.

The build tool now boots one instance of the virtual machine and sends code to
it for compilation when needed, completely removing this cost. This change will
be most impactful for clean builds such when changing Gleam version or in your
CI pipeline, or in monorepos of many packages.

Thank you [yoshi](https://github.com/joshi-monster) for this!

## Variant inference

The compiler now infers and keeps track of the variant of custom types within
expressions that construct or pattern match on them. Using this information it
can now be more precise with exhaustiveness checking, identifying patterns for
the other variants as unnecessary.

That's quite a technical and hard to understand explanation, so here's some
examples. Imagine a custom type named `Pet` which has two variants, `Dog` and
`Turtle`.

```gleam
pub type Pet {
  Dog(name: String, cuteness: Int)
  Turtle(name: String, speed: Int, times_renamed: Int)
}
```

Any place where a value of type `Pet` is used the code would have to take into
account both variants, even if it seems obvious to us as humans that the value
is definitely a specific variant at this point in the code.

With variant inference you no longer need to include patterns for the other
variants.

```gleam
pub fn main() {
  // We know `charlie` is a `Dog`...
  let charlie = Dog("Charles", 1000)

  // ...so you do not need to match on the `Turtle` variant
  case charlie {
    Dog(..) -> todo
  }
}
```

It also works for the record update syntax. This code would previously fail to
compile due to the compiler not being able to tell that `pet` is the right
variant.

```gleam
pub fn rename(pet: Pet, to name: String) -> Pet {
  case pet {
    Dog(..) -> Dog(..pet, name:)
    Turtle(..) -> Turtle(..pet, name:, times_renamed: pet.times_renamed + 1)
  }
}
```

It also works for the field accessor syntax, enabling their use with fields that
do not exist on all of the variants.

```gleam
pub fn speed(pet: Pet) -> Int {
  case pet {
    Dog(..) -> 500

    // Here the speed field can be safely accessed even though
    // it only exists on the `Turtle` variant.
    Turtle(..) -> pet.speed
  }
}
```

Thank you [Surya Rose](https://github.com/GearsDatapacks), the superstar of this
release!

## Precise dependency updates

The `gleam update` command can be used to update your dependencies to the latest
versions compatible with the requirements specified in `gleam.toml`.

You can now also use this command to update a specific set of dependencies,
rather than all of them. If I wanted to update `lustre` and `gleam_json` I could
run this command:

```shell
gleam update lustre gleam_json
```

Thank you [Jason Sipula](https://github.com/SnakeDoc) for this feature!

## Monorepo documentation links

When a package is published to package repository Gleam will also generate and
upload HTML documentation for users of the package to read. This documentation
includes links to the source code in its repository, assuming it is hosted using
a known service such as Forgejo or GitHub.

Unfortunately these links would not be accurate if you were using a monorepo and
so the package was not located at the root of the repository.

To resolve this the `repository` config in `gleam.toml` can now optionally
include a `path` so Gleam knows how to build the correct URLs.

```toml
[repository]
type = "github"
user = "pink-inc"
repo = "monorepo"
path = "packages/fancy_package"
```

Thank you [Richard Viney](https://github.com/richard-viney)!

## Compiler

- The compiler can now suggest to pattern match on a `Result(a, b)` if it's
  being used where a value of type `a` is expected. For example, this code:

  ```gleam
  import gleam/list
  import gleam/int

  pub fn main() {
    let not_a_number = list.first([1, 2, 3])
    int.add(1, not_a_number)
  }
  ```

  Results in the following error:

  ```txt
  error: Type mismatch
    ┌─ /src/one/two.gleam:6:9
    │
  6 │   int.add(1, not_a_number)
    │              ^^^^^^^^^^^^

  Expected type:

      Int

  Found type:

      Result(Int, a)

  Hint: If you want to get a `Int` out of a `Result(Int, a)` you can pattern
  match on it:

      case result {
        Ok(value) -> todo
        Error(error) -> todo
      }
  ```

  ([Giacomo Cavalieri](https://github.com/giacomocavalieri))

## Compiler

- Improved the error message for unknown record fields, displaying an additional
  note on how to have a field accessor only if it makes sense.
  ([Giacomo Cavalieri](https://github.com/giacomocavalieri))

## Compiler

- The compiler now ignores `optional` dependencies when resolving versions
  unless explicitly specified.
  ([Gustavo Inacio](https://github.com/gusinacio))

## Compiler

- Improved the error message for using `@deprecated` with no deprecation message
  ([Jiangda Wang](https://github.com/frank-iii))

## Compiler

- Optimised creation of bit arrays on the JavaScript target.
  ([Richard Viney](https://github.com/richard-viney))


## Compiler

- When targeting JavaScript the compiler now emits a warning for integer
  literals and constants that lie outside JavaScript's safe integer range:

  ```txt
  warning: Int is outside the safe range on JavaScript
    ┌─ /Users/richard/Desktop/int_test/src/int_test.gleam:1:15
    │
  1 │ pub const i = 9_007_199_254_740_992
    │               ^^^^^^^^^^^^^^^^^^^^^ This is not a safe integer on JavaScript

  This integer value is too large to be represented accurately by
  JavaScript's number type. To avoid this warning integer values must be in
  the range -(2^53 - 1) - (2^53 - 1).

  See JavaScript's Number.MAX_SAFE_INTEGER and Number.MIN_SAFE_INTEGER
  properties for more information.
  ```

  ([Richard Viney](https://github.com/richard-viney))

## Formatter

- The formatter no longer removes the first argument from a function
  which is part of a pipeline if the first argument is a capture
  and it has a label. This snippet of code is left as is by the formatter:

  ```gleam
  pub fn divide(dividend a: Int, divisor b: Int) -> Int {
    a / b
  }

  pub fn main() {
    10 |> divide(dividend: _, divisor: 2)
  }
  ```

  Whereas previously, the label of the capture variable would be lost:

  ```gleam
  pub fn divide(dividend a: Int, divisor b: Int) -> Int {
    a / b
  }

  pub fn main() {
    10 |> divide(divisor: 2)
  }
  ```

  ([Surya Rose](https://github.com/GearsDatapacks))

## Language Server

- The Language Server now suggests a code action to convert qualified imports to
  unqualified imports, which updates all occurrences of the qualified name
  throughout the module:

  ```gleam
  import option

  pub fn main() {
    option.Some(1)
  }
  ```

  Becomes:

  ```gleam
  import option.{Some}

  pub fn main() {
    Some(1)
  }
  ```

  ([Jiangda Wang](https://github.com/Frank-III))

## Language Server

- The Language Server now suggests a code action to convert unqualified imports
  to qualified imports, which updates all occurrences of the unqualified name
  throughout the module:

  ```gleam
  import list.{map}

  pub fn main() {
    map([1, 2, 3], fn(x) { x * 2 })
  }
  ```

  Becomes:

  ```gleam
  import list.{}

  pub fn main() {
    list.map([1, 2, 3], fn(x) { x * 2 })
  }
  ```

  ([Jiangda Wang](https://github.com/Frank-III))












## JavaScript project creation

Gleam can compile to JavaScript as well as to Erlang. If you know your project
is going to target JavaScript primarily you can now use `gleam new myapp
--template javascript` to create a new project that is already configured for
JavaScript, saving you adding the `target = "javascript"` to your `gleam.toml`.

Thank you [Mohammed Khouni](https://github.com/Tar-Tarus) for this!

### Bug fixes

And thank you to the bug fixers [Antonio Iaccarino](https://github.com/eingin),
[Giacomo Cavalieri](https://github.com/giacomocavalieri), [Markus
Pettersson](https://github.com/MarkusPettersson98/),
[PgBiel](https://github.com/PgBiel), [Richard
Viney](https://github.com/richard-viney), [Surya
Rose](https://github.com/GearsDatapacks), [Zak
Farmer](https://github.com/ZakFarmer), and
[yoshi](https://github.com/joshi-monster)!

For full details of the many fixes they've implemented see [the
changelog][changelog].

[changelog]: https://github.com/gleam-lang/gleam/blob/main/changelog/v1.6.md
