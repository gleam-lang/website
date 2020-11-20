---
title: Config file
layout: page
---

All Gleam projects require a `gleam.toml` configuration file. The configuration file allows you to
specify the following properties:

## name (string - required)

The name of your project. It should start with a lowercase letter and only contain lowercase letters
and underscores.

## version (string - optional)

A version string. The version can be in any format.

Note: This does not determine the version of the hex.pm package page when publishing your
project. That is determined by the `vsn` entry in the `src/*.app.src` file in your project.

## description (string - optional)

A description of your project.

Note: This does not determine the description on the hex.pm project page when publishing your
project. That is determined by the `description` entry in the `src/*.app.src` file in your project.

## docs (section - optional)

Determines what is included in the documentation. Includes `links` and `pages`.

```
[docs]
links = ...
pages = ...
```

### pages (list - optional)

A set of additional markdown pages to be included in the generated documentation. Useful for
including long form information on aspects of your project that are not covered by module specific
documention.

- `title` provides the name of the link in the sidebar.
- `path` provides the name of the generated html page.
- `source` provides the name of the markdown file.

The README.md file in your project is included by default.

```
pages = [
  { title = "My Page", path = "my-page.html", source = "./path/to/my-page.md" },
]
```

### links (list - optional)

A list of links to be included in the side navigation bar of the generated documentation. In the
format:

```
links = [
  { title = "Homepage", href = "https://example.com" },
  { title = "Other Site", href = "https://another.example.com" }
]
```
