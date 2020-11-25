---
title: Command line reference
layout: page
---

The `gleam` command uses subcommands to access different parts of the functionality:

## `new`

`gleam new <name> [project-root]`

Creates a folder with the necessary files for starting a new gleam project with the given `name`.
The `project-root` defaults to the value of `name`.

- `--description <description>`: Provide a description which is inserted to the `src/<name>.src.app`
  file in the new project.
- `--template <lib|app>`: Indicate whether to generate a project for a library (`lib`) or
  application (`app`). Defaults to `lib`.

## `build`

`gleam build [project-root]`

Builds the given gleam project. Defaults to the current directory.

**Note:** This does not download `gleam` packages. The best experience is to use
[rebar3](https://rebar3.org/) which will download any dependencies and in turn call `gleam build` as
part of its build process. For more information see [Running the project](../running-the-project).

## `format`

`gleam format [files]...`

Formats all the gleam files inplace in the provided directory tree. Defaults to the current
directory.

- `--check`: Check if the inputs are formatted without changing them.
- `--stdin`: Read source from standard in

## `docs`

Contains all the documentation commands.

### `docs build`

`gleam docs build [project-root]`

Builds the documentation for a gleam project. Defaults to the current directory.

- `--to <directory>`: The directory for the generated documentation. Defaults to
  `<project-root>/gen/docs`.

### `docs publish`

`gleam docs publish [project-root]`

Publishes the project documentation to [HexDocs](hexdocs.pm). Defaults to the current directory.

- `--publish`: The version to publish (**required**).

### `docs remove`

`gleam docs remove`

Removes a version of the published documentation from [HexDocs](hexdocs.pm).

- `--package <package>`: The name of the package to remove (**required**).
- `--version <version>`: The version of the package to remove (**required**).

### `docs help`

`gleam docs help`

Prints an overview of the `gleam docs` commands or the details of a specific command if a command
name is given. For example: `gleam docs help build`.

## `help`

`gleam help`

Prints an overview of the `gleam` commands or the details of a specific command if a command name is
given. For example: `gleam help format`.
