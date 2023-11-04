# Expression blocks

Every block in Gleam is an expression. All expressions in the block are
executed, and the result of the last expression is returned.

```gleam
let value: Bool = {
    "Hello"
    42 + 12
    False
} // => False
```

Expression blocks are used instead of parentheses to change the precedence
of operations.

```gleam
let celsius = { fahrenheit - 32 } * 5 / 9
```
