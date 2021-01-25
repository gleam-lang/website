# Strings

In Gleam Strings can be written as text surrounded by double quotes.

```gleam
"Hello, Gleam!"
```

They can span multiple lines.

```gleam
"Hello
Gleam!"
```

Under the hood Strings are [UTF-8](https://en.wikipedia.org/wiki/UTF-8) encoded binaries
and can contain any valid unicode.

```gleam
"👩‍💻 こんにちは Gleam 💫"
```

## Escape Sequences

Gleam supports common string escape sequences. Here's all of them:

| Sequence | Result          |
| -------- | --------------- |
| `\n`     | Newline         |
| `\r`     | Carriage Return |
| `\t`     | Tab             |
| `\"`     | Double Quote    |
| `\\`     | Backslash       |

For example to include a double quote (`"`) character in a string literal it
must be escaped by placing a backslash (`\`) character before it.

```gleam
"Here is a double quote -> \" <-"
```

Similarly all backslash characters must be escaped:

```gleam
// A Windows filepath C:\Users\Gleam
"C:\\Users\\Gleam"

// A Decorative border /\/\/\/\
"/\\/\\/\\/\\"
```
