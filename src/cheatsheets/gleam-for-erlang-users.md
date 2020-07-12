# Gleam for Erlang users

- [Comments](#comments)
- [Variables](#variables)
  - [Partial assignments](#partial-assignments)
  - [Variable type annotations](#variable-type-annotations)
- [Functions](#functions) TODO
  - [Function type annotations](#function-type-annotations) TODO
  - [Function heads](#function-heads) TODO
  - [Referencing functions](#referencing-function) TODO
- [Operators](#operators)
- [Constants](#constants)
- [Blocks](#blocks) TODO
- [Data types](#data-types)
  - [Strings](#strings)
  - [Tuples](#tuples)
  - [Lists](#lists)
  - [Atoms](#atoms)
  - [Maps](#maps)
- [Type aliases](#type-aliases) TODO
- [Custom types](#custom-types)
  - [Records](#records)
  - [Unions](#unions) TODO
  - [Opaque custom types](#opaque-custom-types) TODO
- [Flow control](#flow-control) TODO
  - [Case](#case) TODO
  - [Try](#try) TODO
- [Modules](#modules) TODO
  - [Imports](#imports) TODO
  - [Nested modules](#nested-modules) TODO
  - [First class modules](#first-class-modules) TODO


## Variables

#### Erlang

In Erlang variables are written with a capital letter, and can only be
assigned once.

```erlang
Size = 50
Size2 = Size + 100
Size2 = 1 % Runtime error! Size2 is 150, not 1
```

#### Gleam

In Gleam variables are written with a lowercase letter, and names can be
reassigned.

```rust,noplaypen
let size = 50
let size = size + 100
let size = 1 // size now refers to 1
```

### Partial assignments

#### Erlang

In Erlang a partial pattern that does not match all possible values can be
used to assert that a given term has a specific shape.

```erlang
[Element] = SomeList % assert `SomeList` is a 1 element list
```

#### Gleam

In Gleam the `assert` keyword is used to make assertions using partial
patterns.

```rust,noplaypen
let [element] = some_list // Compile error! Partial pattern
assert [element] = some_list
```

### Variables type annotations

#### Erlang

In Erlang it's not possible to give type annotations to variables.

#### Gleam

In Gleam type annotations can optionally be given when binding variables.

```rust,noplaypen
let some_list: List(Int) = [1, 2, 3]
```

Gleam will check the type annotation to ensure that it matches the type of the
assigned value.

Gleam does not need annotations to type check your code, but you may find it
useful to annotate variables to hint to the compiler that you want a specific
type to be inferred.


## Comments

#### Erlang

In Erlang comments are written with a `%` prefix.

```erlang
% Hello, Joe!
```

#### Gleam

In Gleam comments are written with a `//` prefix.

```rust,noplaypen
// Hello, Joe!
```

Comments starting with `///` are used to document the following statement,
comments starting with `////` are used to document the current module.

```rust,noplaypen
//// This module is very important.

/// The answer to life, the universe, and everything.
const answer: Int = 42
```

## Operators

| Operator         | Erlang    | Gleam | Notes
| ---              | ---       | ---   | ---
| Equal            | `=:=`     | `==`  | In Gleam both values must be of the same type
| Equal            | `==`      |       |
| Not equal        | `=/=`     | `!=`  | In Gleam both values must be of the same type
| Not equal        | `/=`      |       |
| Greater than     | `>`       | `>`   | In Gleam both values must be ints
| Greater than     | `>`       | `>.`  | In Gleam both values must be floats
| Greater or equal | `>=`      | `>=`  | In Gleam both values must be ints
| Greater or equal | `>=`      | `>=.` | In Gleam both values must be floats
| Less than        | `<`       | `<`   | In Gleam both values must be ints
| Less than        | `<`       | `<.`  | In Gleam both values must be floats
| Less or equal    | `=<`      | `>=`  | In Gleam both values must be ints
| Less or equal    | `=<`      | `>=.` | In Gleam both values must be floats
| Boolean and      | `andalso` | `&&`  | In Gleam both values must be bools
| Boolean and      | `and`     |       |
| Boolean or       | `orelse`  | `⎮⎮`  | In Gleam both values must be bools
| Boolean or       | `or`      |       |
| Add              | `+`       | `+`   | In Gleam both values must be ints
| Add              | `+`       | `+.`  | In Gleam both values must be floats
| Subtract         | `-`       | `-`   | In Gleam both values must be ints
| Subtract         | `-`       | `-.`  | In Gleam both values must be floats
| Multiply         | `*`       | `*`   | In Gleam both values must be ints
| Multiply         | `*`       | `*.`  | In Gleam both values must be floats
| Divide           | `div`     | `/`   | In Gleam both values must be ints
| Modulo           | `rem`     | `%`   | In Gleam both values must be ints
| Pipe             |           | `⎮>`  | See [the pipe section](#pipe) for details

## Constants

#### Erlang

In Erlang macros can be defined to name literals we may want to use in
multiple places. They can only be used within the current module

```erlang
-define(the_answer, 42).

main() ->
  ?the_answer.
```

#### Gleam

In Gleam constants can be used to achieve the same.

```rust,noplaypen
const the_answer = 42

fn main() {
  the_answer
}
```

Gleam constants can be referenced from other modules.

```rust,noplaypen
import other_module

fn main() {
  other_module.the_answer
}
```

## Data types

### Strings

All strings in Gleam are UTF-8 encoded binaries.

#### Erlang

```erlang
<<"Hellø, world!"/utf8>>.
```

#### Gleam

```rust,noplaypen
"Hellø, world!"
```

### Tuples

Tuples are very useful in Gleam as they're the only collection data type that allows for mixed
types of elements in the collection. The syntax for a tuple literal - `tuple("a", "b")` - can be
confused for a function call, which it is not!

#### Erlang

```erlang
Tuple = {"username", "password", 10}.
{_, Password, _} = Tuple.
```

#### Gleam

```rust,noplaypen
let my_tuple = tuple("username", "password", 10)
let tuple(_, password, _) = my_tuple
```

### Lists

Lists in Erlang are allowed to be of mixed types, but not in Gleam. They retain all of the same
performance sematics.

The `cons` operator works the same way both for pattern matching and for appending elements to the
head of a list, but it uses a different syntax.

#### Erlang

```erlang
List0 = [2, 3, 4].
List1 = [1 | List0].
[1, SecondElement | _] = List1.
[1.0 | List1].
```

#### Gleam

```rust,noplaypen
let list = [2, 3, 4]
let list = [1, ..list]
let [1, second_element, ..] = list
[1.0, ..list] // Type error!
```

### Atoms

In Erlang atoms can be created as needed, but in Gleam all atoms must be defined as values in a
custom type before being used. Any value in a type definition in Gleam that does not have any
arguments is an atom in Erlang.

There are some exceptions to that rule for atoms that are commonly used and have types built-in to
Gleam that incorporate them, such as `ok`, `error` and booleans.

In general, atoms are not used much in Gleam, and are mostly used for boolens, `ok` and `error`
result types, and defining custom types.

#### Erlang

```erlang
Var = my_new_var.

{ok, true}.

{error, false}.
```

#### Gleam

```rust,noplaypen
type MyNewType {
  MyNewVar
}
let var = MyNewVar

Ok(True)

Error(False)
```

### Maps

In Erlang, maps can have keys and values of any type, and they can be mixed in a given map. In
Gleam, maps can have keys and values of any type, but all keys must be of the same type in a given
map and all values must be of the same type in a given map.

There is no map literal syntax in Gleam, and you cannot pattern match on a map. Maps are generally
not used much in Gleam. You're more often going to use custom types (which are analagous to Erlang
Records) or lists of two element tuples (which are `proplist`s or `orddict`s in Erlang).

#### Erlang

```erlang
#{"key1" => "value1", "key2" => "value2"}.

#{["key1"] => "value1", "key2" => "value2"}.
```

#### Gleam

```rust,noplaypen
import gleam/map

map.from_list([tuple("key1", "value1"), tuple("key2", "value2")])

map.from_list([tuple(["key1"], "value1"), tuple("key2", "value2")]) \\ Type error!
```

## Custom types

### Records

In Erlang, Records are a specialized data type built on a tuple. Gleam does not have anything
called a `record`, but custom types can be used in Gleam in much the same way that records are
used in Erlang, even though custom types don't actually define a `record` in Erlang when it is
compiled.

The important thing is that a custom type allows you to define a collection data type with a fixed
number of named fields, and the values in those fields can be of differing types.

#### Erlang

```erlang
-record(person, {age, name}).

Person = #person{name="name", age=35}.

Name = #Person.name.
```

#### Gleam

```rust,noplaypen
type Person {
  Person(age: Int, name: String)
}

let person = Person(name: "name", age: 35)

let name = person.name
```

