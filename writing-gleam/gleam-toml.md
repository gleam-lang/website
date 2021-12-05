---
title: gleam.toml
layout: page
---

All Gleam projects require a `gleam.toml` configuration file. The `toml`
configuration format is documented at [toml.io](https://toml.io/).

```toml
# The name of your project (required)
name = "my_project"

# The version of your project (required)
version = "1.0.0"

# The licences which this project uses, in SPDX format (optional)
licences = ["Apache-2.0", "MIT"]

# A short description of your project (optional)
# This will be displayed on the package page if the project is published to
# the Hex package repository.
description = "Gleam bindings to..."

# The source code repository location (optional)
# This will be used in generated documentation and displayed on Hex.
repository = { type = "github", user = "example", repo = "my_project" }
# It can also be one of these formats
# repository = { type = "gitlab", user = "example", repo = "my_project" }
# repository = { type = "bitbucket", user = "example", repo = "my_project" }
# repository = { type = "custom", url = "https://example.com/my_project" }

# Links to any related website (optional)
# This will be displayed in generated documentation and on Hex.
links = [
  { title = "Home page", href = "https://example.com" },
  { title = "Other site", href = "https://another.example.com" },
]

# The Hex packages the project needs to compile and run (optional)
# Uses the Hex version requirement format
# https://hexdocs.pm/elixir/Version.html#module-requirements
[dependencies]
gleam_stdlib = "~> 0.18"
gleam_erlang = "~> 0.2"
gleam_http = "~> 2.1"

# The Hex packages the project needs for the tests (optional)
# These will not be included if the package is published to Hex.
# This table cannot include any packages that are already found in the
# `dependencies` table.
[dev-dependencies]
gleeunit = "~> 0.3"
gleam_bitwise = "~> 0.3"

# Documentation specific configuration (optional)
[documentation]
# Additional markdown pages to be included in generated HTML docs (optional)
pages = [
  { title = "My Page", path = "my-page.html", source = "./path/to/my-page.md" },
]

# Generated Erlang specific configuration (optional)
[erlang]
# The name of the OTP application module, if the project has one (optional)
# Typically Gleam projects do not use the Erlang/OTP implicit application boot
# system and so typically do not define this.
# If specified the module must implement the OTP application behaviour.
# https://www.erlang.org/doc/man/application.html
application_start_module = "my_app/application"
```
