# `Result(value, error)`

```gleam
pub type Result(value, reason) {
  Ok(value)
  Error(reason)
}
```

Gleam doesn't have exceptions or `null` to represent errors in our programs,
instead we have the `Result` type. If a function call fails, wrap the returned
value in a `Result`, either `Ok` if the function was successful, or `Error`
if it failed.

```gleam
pub fn lookup(name, phone_book) {
  // ... we found a phone number in the phone book for the given name here
  Ok(phone_number)
}
```

The `Error` type needs to be given a reason for the failure in order to
return, like so:

```gleam
pub type MyDatabaseError {
  InvalidQuery
  NetworkTimeout
}

pub fn insert(db_row) {
  // ... something went wrong connecting to a database here
  Error(NetworkTimeout)
}
```

In cases where we don't care about the specific error enough to want to create
a custom error type, or when the cause of the error is obvious without further
detail, the `Nil` type can be used as the `Error` reason.

```gleam
pub fn lookup(name, phone_book) {
  // ... That name wasn't found in the phone book
  Error(Nil)
}
```

When we have a `Result` type returned to us from a function we can pattern
match on it using `case` to determine whether we have an `Ok` result or
an `Error` result.

The standard library [gleam/result](https://hexdocs.pm/gleam_stdlib/gleam/result.html) module contains helpful functions for
working with the `Result` type, make good use of them!

## Stdlib references

- [gleam/result](https://hexdocs.pm/gleam_stdlib/gleam/result.html)
