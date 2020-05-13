# Documenting the project

If our project is a library it is important that it is well documented so that
people understand how to use the code.

To document modules and function Gleam supports two special comments, `///`
which is for documenting types and functions, and `////` which is for
documenting the module as a whole.

```rust,noplaypen
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

The documentation can be built locally using this command, which renders the
documentation to `gen/docs`.

```sh
cd path/to/project
gleam docs build
```

Once you are happy with the documentation it can be pushed to HexDocs, the
documentation hosting website for the Erlang ecosystem.

Note you will need to have published your project to the the Hex package
manager before attempting to publish the documentation for that version.

```sh
cd path/to/project
gleam docs publish --version v1.0.0
```

Lastly, if you wish to remove documentation from HexDoc (possibly to correct
an error) then this command can be used:

```sh
cd path/to/project
gleam docs remove --package my_project_name --version v1.0.0
```
