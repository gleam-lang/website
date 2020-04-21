# String

Gleam's has UTF-8 binary strings, written as text surrounded by double quotes.

```rust,noplaypen
"Hello, Gleam!"
```

Strings can span multiple lines.

```rust,noplaypen
"Hello
Gleam!"
```

Special characters such as `"` need to be escaped with a `\` character.

```rust,noplaypen
"Here is a double quote -> \" <-"
```

## Manipulating strings.

The `string` module implements functions for working with strings in Gleam.

```rust,noplaypen
import gleam/string

let reversed = string.reverse("hello")

reversed // => "olleh"
```
