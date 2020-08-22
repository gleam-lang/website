# Custom types

Gleam's custom types are named collections of keys and values. They are
similar to objects in object oriented languages, though they don't have
methods.

Custom types are defined with the `type` keyword.

```rust,noplaypen
pub type Cat {
  Cat(name: String, cuteness: Int)
}
```

Here we have defined a custom type called `Cat`. Its constructor is called
`Cat` and it has two fields: A `name` field which is a `String`, and a
`cuteness` field which is an `Int`.

The `pub` keyword makes this type usable from other modules.

Once defined the custom type can be used in functions:

```rust,noplaypen
fn cats() {
  // Labelled fields can be given in any order
  let cat1 = Cat(name: "Nubi", cuteness: 2001)
  let cat2 = Cat(cuteness: 1805, name: "Biffy")

  // Alternatively fields can be given without labels
  let cat3 = Cat("Ginny", 1950)

  [cat1, cat2, cat3]
}
```


## Multiple constructors

Custom types in Gleam can be defined with multiple constructors, making them a
way of modeling data that can be one of a few different variants.

We've seen a custom type with multiple constructors already in this chapter -
`Bool`.

Bool is defined like this:

```rust,noplaypen
// A Bool is a value that is either `True` or `False`
pub type Bool {
  True
  False
}
```

The records created by different constructors for a custom type can contain
different values. For example a `User` custom type could have a `LoggedIn`
constructors that creates records with a name, and a `Guest` constructor which
creates records without any contained values.

```rust,noplaypen
type User {
  LoggedIn(name: String)  // A logged in user with a name
  Guest                   // A guest user with no details
}
```
```rust,noplaypen
let sara = LoggedIn(name: "Sara")
let rick = LoggedIn(name: "Rick")
let visitor = Guest
```



## Destructuring

When given a custom type record we can pattern match on it to determine which
record constructor matches, and to assign names to any contained values.

```rust,noplaypen
fn get_name(user) {
  case user {
    LoggedIn(name) -> name
    Guest -> "Guest user"
  }
}
```

Custom types can also be destructured with a `let` binding.

```rust,noplaypen
type Score {
  Points(Int)
}
```
```rust,noplaypen
let score = Points(50)
let Points(p) = score

p // => 50
```


## Opaque types

At times it may be useful to create a type and make the constructors and
fields private so that users of this type can only use the type through
publically exported functions.

For example we can create an `Counter` type which holds an int which can be
incremented. We don't want the user to alter the int value other than by
incrementing it, so we can make the opaque opaque to prevent them from being
able to do this.

```rust,noplaypen
// The type is defined with the opaque keyword
pub opaque type Counter {
  Counter(value: Int)
}

pub fn new() {
  Counter(0)
}

pub fn increment(counter: Counter) {
  Counter(counter.value + 1)
}
```

Because the `Counter` type has been marked as `opaque` it is not possible for
code in other modules to construct or pattern match on counter values or
access the `value` field. Instead other modules have to manipulate the opaque
type using the exported functions from the module, in this case `new` and
`increment`.

## Commonly used custom types

### `Bool`

```rust,noplaypen
pub type Bool {
  True
  False
}
```

As seen above Gleam's `Bool` type is a custom type! Use it to answer yes/no
questions and to indicate whether something is `True` or `False`.


### `Result(value, error)`

```rust,noplaypen
pub type Result(value, reason) {
  Ok(value)
  Error(reason)
}
```

Gleam doesn't have exceptions or `null` to represent errors in our programs,
instead we have the `Result` type. If a function call fail wrap the returned
value in a `Result`, either `Ok` if the function was successful, or `Error`
if it failed.

```rust,noplaypen
pub fn lookup(name, phone_book) {
  // ... we found a phone number in the phone book for the given name here
  Ok(phone_number)
}
```

The `Error` type needs to be given a reason for the failure in order to
return, like so:

```rust,noplaypen
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

```rust,noplaypen
pub fn lookup(name, phone_book) {
  // ... That name wasn't found in the phone book
  Error(Nil)
}
```

When we have a `Result` type returned to us from a function we can pattern
match on it using `case` to determine whether we have an `Ok` result or
an `Error` result.

The standard library `gleam/result` module contains helpful functions for
working with the `Result` type, make good use of them!


## Erlang interop

At runtime custom type records with no contained values become atoms. The
atoms are written in `snake_case` rather than `CamelCase` so `LoggedIn`
becomes `logged_in`.

Custom type records with contained values are Erlang records. The Gleam
compiler generates an Erlang header file with a record definition for each
constructor, for use from Erlang.

```rust,noplaypen
// Gleam
Guest
LoggedIn("Kim")
```
```
# Elixir
:guest
{:logged_in, "Kim"}
```
```
% Erlang
guest,
{logged_in, <<"Kim">>}.
```
