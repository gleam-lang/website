# Assert

Some times we have a function that can technically fail, but in practice we
don't expect it to happen. For example our program may start by opening a
file, if we know that the file is always going to be possible to open, then we
don't want to complicate our program with handing an error that should never
happen.

Other times we have errors that may occur, but we don't have any way of
realistically handling them within our program. For example if we have a web
application that talks to a database when handling each HTTP request and that
database stops responding, then we have a fatal error that cannot be recovered
from. We could detect the error in our code, but what do we do then? We *need*
the database to handle the request.

Lastly we may think errors are possible, but we are writing a quick script or
prototype application, so we want to only spend time on the success path for
now.

For these situations Gleam provides `assert`, a keyword that causes the
program to crash if a pattern does not match.

```gleam
assert Ok(i) = parse_int("123")
i // => 123
```

Here the `assert` keyword has been used to say "this function must return an
`Ok` value" and we haven't had to write any error handling. The inner value
is assigned the variable `i` and the program continues.

```gleam
assert Ok(i) = parse_int("not an int")
```

In this case the `parse_int` function returns an error, so the `Ok(i)`
pattern doesn't match and so the program crashes.

## Surviving crashes

Being fault tolerant and surviving crashes is a key part of Erlang's error
handling strategy, and as an Erlang based language Gleam can also take
advantage of this. To find out more about Erlang fault tolerance see the
[Gleam OTP project][1] and the [Learn You Some Erlang chapter on
supervisors][2].

[1]: https://github.com/gleam-lang/otp
[2]: https://learnyousomeerlang.com/supervisors
