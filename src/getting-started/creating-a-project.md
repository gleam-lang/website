# Creating a project

## Installing the rebar3 build tool

**Note**: Gleam's tooling is very young and in a state of flux. Expect rough
edges and breaking changes to come.

The Gleam compiler can build Gleam projects that are managed with the standard
Erlang build tool, rebar3. If you don't have rebar3 installed please [install
it now](https://www.rebar3.org/).

[rebar_gleam]: https://github.com/gleam-lang/rebar_gleam#installation

## Generating a project

Now a project can be generated like so:

```sh
gleam new my_fantastic_library --description "Getting started with Gleam!"
cd my_fantastic_library
```

You'll now have a project with this structure:

```
.
├── gleam.toml
├── LICENSE
├── README.md
├── rebar.config
├── src
│   ├── my_fantastic_library.app.src
│   └── my_fantastic_library.gleam
└── test
    └── my_fantastic_library_test.gleam

2 directories, 7 files
```

The project is managed and built using rebar3, the standard Erlang build tool.
Here are some commonly used rebar3 commands that you can use with your new
project:

```sh
# Run an interactive shell with your code loaded (Erlang syntax)
rebar3 shell
1> my_fantastic_library:hello_world().
<<"Hello, from my_fantastic_library!">>

# Run the eunit tests
rebar3 eunit
```

More information can be found on the [rebar3 documentation website](https://www.rebar3.org/docs).

## Applications

The default project generated is a library, but you may want to create an
application instead. If you specify an alternate template when creating a
project you can instead generate an application project compatible with the
Erlang OTP framework.

```sh
gleam new my_fantastic_application --template app
```


## What next?

Want to see some Gleam code? See the [example projects](./example-projects.html).

Looking to learn the language? Check out the [language tour](../tour).

Need ideas for a project? We have a [list of libraries][libraries] that need
writing.

[libraries]: https://github.com/gleam-lang/suggestions/issues?q=is%3Aopen+is%3Aissue+label%3Aarea%3Alibraries
