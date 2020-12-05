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

We've already seen a custom type with multiple constructors in the Language Tour,
- [`Bool`](./bools.md).

The built-in Gleam's `Bool` type is defined like this:

```rust,noplaypen
// A Bool is a value that is either `True` or `False`
pub type Bool {
  True
  False
}
```

It's a simple custom type which constructors that take no arguments at all!
Use it to answer yes/no questions and to indicate whether something is `True`
or `False`.

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

For example we can create a `Counter` type which holds an int which can be
incremented. We don't want the user to alter the int value other than by
incrementing it, so we can make the type opaque to prevent them from being
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


## Record updates

Gleam provides a dedicated syntax for updating some of the fields of a custom
type record.

```rust,noplaypen
pub type Person {
  Person(
    name: String,
    gender: Option(String),
    shoe_size: Int,
    age: Int,
    is_happy: Bool,
  )
}

pub fn have_birthday(person) {
  // It's this person's birthday, so increment their age and
  // make them happy
  Person(..person, age: person.age + 1, is_happy: true)
}
```

As Gleam records are immutable the update syntax does not alter the fields in
place, instead it created a new record with the values of the initial record
with the new values added.


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
