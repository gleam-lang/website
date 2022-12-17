---
title: Command line reference
subtitle: Getting Gleam things done in the terminal
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

## `check`

`gleam check`

Verify the types of Gleam code without performing codegen.

## `clean`

`gleam clean`

Remove build artifacts.

## `update`

`gleam update`

Update dependency packages to their latest versions.

## `help`

`gleam help [subcommand]`

Print help message or the help of the given subcommand(s).


## `format`

`gleam format [files]...`

Formats all the gleam files in place in the provided directory tree. Defaults to
the current directory.

- `--check`: Check if the inputs are formatted without changing them.
- `--stdin`: Read source from standard in.

## `lsp`

`gleam lsp`

Run the language server. Typically you would not run this command yourself,
instead your text editor would call it for you as it can speak the language
server protocol.

## `publish`

`gleam publish`

Publish the package to the Hex package manager.

- `--replace`: Replace an existing version. This can only be used shortly after
  publishing and is to be used to correct mistakes during publishing.
- `--yes`: Do not ask for confirmation before publishing.

This command uses this environment variables:

- `HEXPM_USER`: (optional) The Hex username to authenticate with.
- `HEXPM_PASS`: (optional) The Hex password to authenticate with.

## `deps`

### `deps list`

`gleam deps list`

List all the dependencies for the project.


### `deps download`

`gleam deps download`

Download all the project dependency packages.

## `hex`

### `hex retire`

`gleam hex retire <package> <version> <reason> [message]`

Retire an already published package version from the Hex package manager.

- `package`: The name of the package.
- `version`: The version to retire.
- `reason`: One of other, invalid, security, deprecated, or renamed.
- `message`: An optional message explaining why the release was retired.

This command uses this environment variables:

- `HEXPM_USER`: (optional) The Hex username to authenticate with.
- `HEXPM_PASS`: (optional) The Hex password to authenticate with.


### `hex unretire`

`gleam hex unretire <package> <version>`

Un-retire a retired Hex package.

- `package`: The name of the package.
- `version`: The version to un-retire.

This command uses this environment variables:

- `HEXPM_USER`: (optional) The Hex username to authenticate with.
- `HEXPM_PASS`: (optional) The Hex password to authenticate with.

## `docs`

### `docs build`

`gleam docs build`

Builds the HTML documentation for the project.


### `docs publish`

`gleam docs publish`

Publishes the project documentation to [HexDocs](https://hexdocs.pm).

This command uses this environment variables:

- `HEXPM_USER`: (optional) The Hex username to authenticate with.
- `HEXPM_PASS`: (optional) The Hex password to authenticate with.


### `docs remove`

`gleam docs remove`

Removes a version of the published documentation from [HexDocs](https://hexdocs.pm).

- `--package <package>`: The name of the package to remove (required).
- `--version <version>`: The version of the package to remove (required).

This command uses this environment variables:

- `HEXPM_USER`: (optional) The Hex username to authenticate with.
- `HEXPM_PASS`: (optional) The Hex password to authenticate with.


## `export erlang-shipment`

`gleam export erlang-shipment`

Build a directory of precompiled Erlang bytecode and configuration, suitable for
deployment.
