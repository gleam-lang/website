---
title: Using the project
layout: page
redirect_from:
  - "/writing-gleam/running-the-project/index.html"
---

## Running the program

Your Gleam program can be run with the `gleam run` terminal command.

It will run the `main` function in the module with the same name as your
project. This function is generated for you by default for new projects.


## Running the tests

The tests for your project can be run by the `gleam test` command.

This command will run the `main` function in the module with the same name as
your project but with `_test` added to the end. For example, if your project is
called `satsuma` it will run `satsuma_test.main`.

You may want to use a test framework such as [gleeunit][gleeunit] to help you
write and run your test code.

[gleeunit]: https://github.com/lpil/gleeunit


## The Erlang shell

An interactive Erlang shell can be started using the `gleam shell` command.

```sh
gleam shell
#   Compiling my_project
#    Compiled in 0.53s
#     Running Erlang shell
# Erlang/OTP 24 [erts-12.1.5] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]
# 
# Eshell V12.1.5  (abort with ^G)
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
