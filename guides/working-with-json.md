---
title: Working with JSON
subtitle: Learn to work with JSON in Gleam
layout: page
---
## Encoding

To work with JSON, we will use a package named `gleam_json` which helps us create JSON from Gleam types, and to decode JSON into Gleam types.
```gleam
import gleam/json

type Person {
  Person(name: String, age: Int)
}

pub fn main() {
  let some_person = Person("Lucy", 2)

  json.object([
    #("name", json.string(some_person.name)),
    #("age", json.int(some_person.age)),
  ])
  |> json.to_string()
  |> echo
}
```

This will output:
```sh
src/app.gleam:15
"{\"name\":\"Lucy\",\"age\":2}
```

## Decoding

```gleam
import gleam/dynamic/decode
import gleam/json

type Person {
  Person(name: String, age: Int)
}

fn person_decoder() -> decode.Decoder(Person) {
  use name <- decode.field("name", decode.string)
  use age <- decode.field("age", decode.int)
  decode.success(Person(name:, age:))
}

pub fn main() {
  let some_person = Person("Lucy", 2)

  let json_string =
    json.object([
      #("name", json.string(some_person.name)),
      #("age", json.int(some_person.age)),
    ])
    |> json.to_string()

  // This returns a Result, but we know this is OK.
  let assert Ok(decoded_person) = json.parse(json_string, person_decoder())

  echo decoded_person

  Nil
}
```

This will output:
```sh
src/app.gleam:27
Person("Lucy", 2)
```

See the [gleam_json docs](https://hexdocs.pm/gleam_json/) for more details.
