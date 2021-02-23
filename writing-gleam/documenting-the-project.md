---
title: Documenting the project
layout: page
---

If our project is a library it is important that it is well documented so that
people understand how to use the code.

## Modules and functions

To document modules and functions Gleam supports two special comments, `///`
which is for documenting types and functions, and `////` which is for
documenting the module as a whole.

```rust
//// This module contains some useful functions for working
//// with numbers.
////
//// For more information see [this website](https://example.com).


import gleam/result

/// A type for representing numbers
pub type Number {
  /// This constructor is used when the number is an Int
  I(Int)

  /// This constructor is used when the number is an Float
  F(Float)
}

/// Returns the next number
///
/// # Examples
///
///   > successor(1)
///   2
///
pub fn successor(i: Int) -> Int {
  i + 1
}

/// Returns a number held by an Ok record, returning a default if the
/// Result is an Error record.
///
/// # Examples
///
///   > from_result(Ok(1))
///   1
///
///   > from_result(Error(Nil))
///   0
///
pub fn from_result(result: Result(Int, e)) -> Int {
  result.unwrap(result, 0)
}
```

Once documentation comments have been added Gleam can generate HTML
documentation for the project.

## Additional documentation pages

To add additional pages to the documentation for the project that aren't
automatically generated, simply define them in Markdown and add them to
`gleam.toml` as follows:

```toml
name = "my_awesome_gleam_app"

[[docs.pages]]
title = "Hello"
path = "hello.html"
source = "docs/hello_world.md"

[[docs.pages]]
title = "Testing"
path = "testing.html"
source = "docs/testing.md"
```

Links will automatically be generated for these additional pages and the
Markdown will be converted into HTML documentation.

Your project's `README.md` file will automatically be used to generate the
default page for the documentation.

## Building and pushing

The documentation can be built locally using this command, which renders the
documentation to `gen/docs`.

```sh
cd path/to/project
gleam docs build --version 1.0.0
```

Once you are happy with the documentation it can be pushed to HexDocs, the
documentation hosting website for the Erlang ecosystem.

Note you will need to have published your project to the the Hex package
manager before attempting to publish the documentation for that version.

```sh
cd path/to/project
gleam docs publish --version 1.0.0
```

Lastly, if you wish to remove documentation from HexDoc (possibly to correct
an error) then this command can be used:

```sh
cd path/to/project
gleam docs remove --package my_project_name --version 1.0.0
```
