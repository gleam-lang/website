# Try

In Gleam if a function can either succeed or fail then it normally will
return the `Result` type. With `Result` a successful return value is wrapped
in an `Ok` record, and wrapping any error value in an `Error` record.

```rust,noplaypen
// parse_int(String) -> Result(Int, String)

parse_int("123") // -> Ok(123)
parse_int("erl") // -> Error("expected a number, got `erl`")
```

When a function returns a Result we can pattern match on it to handle success
and failure:

```rust,noplaypen
case parse_int("123") {
  Error(e) -> io.println("That wasn't an Int")
  Ok(i) -> io.println("We parsed the Int")
}
```

This is such a common pattern in Gleam that the `try` syntax exists to make it
more consise.

```rust,noplaypen
try int_a = parse_int(a)
try int_b = parse_int(b)
try int_c = parse_int(c)
Ok(int_a + int_b + int_c)
```

When a variable is declared using `try` Gleam checks to see whether the value
is an Error or an Ok record. If it's an Ok then the inner value is assigned to
the variable:

```rust,noplaypen
try x = Ok(1)
Ok(x + 1)
// -> Ok(2)
```
If it's an Error then the Error is returned immediately:

```rust,noplaypen
try x = Error("failure")
Ok(x + 1)
// -> Error("failure")
```
