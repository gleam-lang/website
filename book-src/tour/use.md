# Use expressions

Gleam lacks exceptions, macros, type classes, early returns, and a variety of
other features, instead going all-in with just first-class-functions and pattern
matching.

This makes Gleam code easier to understand, but it can sometimes result in
excessive indentation.

```gleam
pub fn main() {
  logger.record_timing(fn() {
    database.connect(fn(db) {
      file.open("file.txt", fn(f) {
        // Do with something here...
      })
    })
  })
}
```

This code doesn't look super pretty. Some folks might call this "callback hell".

Gleam's `use` expression helps out here by enabling us to write code like this
in an unindented style. The above code could be re-written using it like so:

```gleam
pub fn main() {
  use <- logger.record_timing
  use db <- database.connect
  use f <- file.open("file.txt")
  // Do with something here...
}
```

The higher order function being called goes on the right hand side of the `<-`
operator. It must take a callback function as its final argument.

The argument names for the callback function go on the left hand side of the
`<-` operator. The function can take any number of arguments, including zero.

All the following code in the `{}` block becomes the body of the callback
function.

This is a very capable and useful feature, but excessive application of `use`
may result in code that is unclear otherwise, especially to beginners. Often
using the regular function call syntax will result in more approachable code!

## Syntactic sugar

The `use` expression is syntactic sugar for a regular function call and an
anonymous function.

This code:

```gleam
use a, b <- my_function
next(a)
next(b)
```

Expands into this code:

```gleam
my_function(fn(a, b) {
  next(a)
  next(b)
})
```

To ensure that your `use` code works and is as understandable as possible, the
right-hand-side ideally should be a function call rather than a pipeline, block,
or other expression, which may be less clear.

```gleam
use x <- result.try(
  current_user
  |> get_profile
  |> result.map_error(ProfileError)
)
```
