---
title: Running the project
layout: page
---

We typically run Gleam projects in 3 ways:

- In the tests.
- In the shell.
- In production, using releases.


## Tests

Gleam tests are written using the Erlang test framework eunit.

To write a test add a function to a module in the `test`, giving the function
a name that ends in `_test`. The `gleam/should` module can be used to make
assertions about the behaviour of our code.

```rust
import gleam/should
import my_fantastic_library

pub fn addition_test() {
  my_fantastic_library.hello_world()
  |> should.equal("Hello from my_fantastic_library!")
}
```

Once written the tests can be run using the `rebar3 eunit` command.


## The shell

An interactive Erlang shell can be started using the rebar3 build tool:

```sh
rebar3 shell
# ===> Verifying dependencies...
# ===> Compiling gleam_stdlib
# Erlang/OTP 22 [erts-10.4.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]
# Eshell V10.4.3  (abort with ^G)
# 1>
```

Here we can try out our functions by typing them in:

```sh
1> my_fantastic_library:hello_world().
# <<"Hello from my_fantastic_library">>
```

It's important to remember that this is an Erlang shell rather than a Gleam
shell, so Erlang syntax must be used. Don't forget to put a `.` at the end of
the expression otherwise the shell won't do anything.


## Releases

To be run in production Erlang based applications are build into a deployable
bundle called a release.

At a later date we will have built in support and documentation for release,
but for now please refer to these Erlang docs:

- [Releases - AdoptingErlang.org](https://adoptingerlang.org/docs/production/releases/)
- [Releases - Rebar3.org](https://www.rebar3.org/docs/releases)
