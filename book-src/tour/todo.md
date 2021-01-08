# Todo

Gleam's `todo` keyword is used to indicate that some code is not yet finished.

It can be useful when designing a module, type checking functions and types
but leaving the implementation of the functions until later.

```gleam
fn favourite_number() -> Int {
  // The type annotations says this returns an Int, but we don't need
  // to implement it yet.
  todo
}

pub fn main() {
  favourite_number() * 2
}
```

When this code is built Gleam will type check and compile the code to ensure
it is valid, and the `todo` will be replaced with code that crashes the
program if that function is run.

A message can be given as a form of documentation. The message will be printed
in the error message when the `todo` code is run.

```gleam
fn favourite_number() -> Int {
  todo("We're going to decide which number is best tomorrow")
}
```

When the compiler finds a `todo` it will print a warning, which can be useful
to avoid accidentally forgetting to remove a `todo`.

The warning also includes the expected type of the expression that needs to
replace the `todo`. This can be a useful way of asking the compiler what type
is needed if you are ever unsure.


```gleam
fn main() {
  my_complicated_function(
    // What type does this function take again...?
    todo
  )
}
```
