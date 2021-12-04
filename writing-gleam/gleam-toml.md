---
title: gleam.toml
layout: page
---

All Gleam projects require a `gleam.toml` configuration file. The `toml` configuration format is
documented at [Toml.io](https://toml.io/).

The `gleam.toml` configuration file allows you to specify the following properties:

## `name`

`string` - *required*

The name of your project. It should start with a lowercase letter and only contain lowercase letters
and underscores.

## `version`

`string` - *optional*

A version string. The version can be in any format.

**Note**: This does not determine the version of the hex.pm package page when publishing your
project. That is determined by the `vsn` entry in the `src/*.app.src` file in your project.

## `description`

`string` - *optional*

A description of your project.

**Note**: This does not determine the description on the hex.pm project page when publishing your
project. That is determined by the `description` entry in the `src/*.app.src` file in your project.

## `repository`

`object` - *optional*

Specifies the online source repository for this project's code.

This enables source links, in the generated documentation, from types, constants & functions to
their defining lines of code in the repository.

```toml
repository = { type = "github", user = "example", repo = "project" }
repository = { type = "gitlab", user = "example", repo = "project" }
repository = { type = "bitbucket", user = "example", repo = "project" }
repository = { type = "custom", url = "https://repo.example.com" }
```

## `links`

`list` - *optional*

A list of links to be included in the side navigation bar of generated
documentation, as well as on Hex.pm if you publish your project. In the format:

```toml
links = [
  { title = "Home page", href = "https://example.com" },
  { title = "Other site", href = "https://another.example.com" },
]
```

## `dependencies`

`table` - *optional*

Specifies what [Hex](https://hex.pm/) packages the project needs to be able to
compile and run.

The keys of this table and the names of the Hex packages, and the values are
[version requirement](https://hexdocs.pm/elixir/Version.html#module-requirements) 
for that package.

```toml
[dependencies]
gleam_stdlib = "~> 0.18"
gleam_http = "~> 2.1
```

## `dev-dependencies`

`table` - *optional*

Specifies any additional [Hex](https://hex.pm/) packages the project needs to be able to
compile and run the tests. These will not be included if the package is published to Hex.

The keys of this table and the names of the Hex packages, and the values are
[version requirement](https://hexdocs.pm/elixir/Version.html#module-requirements) 
for that package.

This table cannot include any keys that are already found in the `dependencies` table.

```toml
[dev-dependencies]
gleeunit = "~> 0.3"
```

## `docs`

`table` - *optional*

Determines what is included in the documentation. Includes `links` and `pages`.

```toml
[docs]
links = ...
pages = ...
```

### `docs.pages`

`list` - *optional*

A set of additional markdown pages to be included in the generated documentation. Useful for
including long form information on aspects of your project that are not covered by module specific
documention.

- `title` provides the name of the link in the sidebar.
- `path` provides the name of the generated html page.
- `source` provides the name of the markdown file.

The README.md file in your project is included by default.

```toml
[docs]
pages = [
  { title = "My Page", path = "my-page.html", source = "./path/to/my-page.md" },
]
```
