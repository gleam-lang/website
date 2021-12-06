---
title: Command line reference
layout: page
---

The `gleam` command uses subcommands to access different parts of the functionality:

## `new`

`gleam new <name> [project-root]`

Creates a folder with the necessary files for starting a new gleam project with
the given `name`.  The `project-root` defaults to the value of `name`.

- `--name <name>`: The name of the project (optional). Defaults to the name of
  the project root directory if not given.
- `--description <description>`: A description of the project (optional).


## `build`

`gleam build`

Builds the given gleam project.


## `run`

`gleam run [arguments]...`

Run the project. Any arguments will be passed to the program.


## `test`

`gleam test [arguments]...`

Run the project's tests. Any arguments will be passed to the program.


## `add`

`gleam add <package>`

Add a new dependency package to the project.

- `--dev`: Add the package to `dev-dependency` as a development only dependency.


## `shell`

`gleam shell`

Run an Erlang shell with the project loaded.


## `format`

`gleam format [files]...`

Formats all the gleam files in place in the provided directory tree. Defaults to
the current directory.

- `--check`: Check if the inputs are formatted without changing them.
- `--stdin`: Read source from standard in.


## `publish`

`gleam publish`

Publish the package to the Hex package manager.


### `hex list`

`gleam hex list`

List all the dependencies for the project.


### `hex download`

`gleam hex download`

Download all the project dependency packages.


### `docs build`

`gleam docs build`

Builds the HTML documentation for the project.


### `docs publish`

`gleam docs publish`

Publishes the project documentation to [HexDocs](hexdocs.pm).


### `docs remove`

`gleam docs remove`

Removes a version of the published documentation from [HexDocs](hexdocs.pm).

- `--package <package>`: The name of the package to remove (required).
- `--version <version>`: The version of the package to remove (required).
