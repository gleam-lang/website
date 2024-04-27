---
title: gleam.toml
subtitle: Configure your Gleam project
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

# The target to default to when compiling or running Gleam code
# Accepted values are "erlang" and "javascript". Defaults to "erlang".
target = "erlang"

# The source code repository location (optional)
# This will be used in generated documentation and displayed on Hex.
repository = { type = "github", user = "example", repo = "my_project" }
# `repository` can also be one of these formats
# { type = "forgejo",   host = "example.com", user = "example", repo = "my_project" }
# { type = "gitea",     host = "example.com", user = "example", repo = "my_project" }
# { type = "gitlab",    user = "example", repo = "my_project" }
# { type = "sourcehut", user = "example", repo = "my_project" }
# { type = "bitbucket", user = "example", repo = "my_project" }
# { type = "codeberg",  user = "example", repo = "my_project" }
# { type = "custom",    url = "https://example.com/my_project" }

# Links to any related website (optional)
# This will be displayed in generated documentation and on Hex.
links = [
  { title = "Home page", href = "https://example.com" },
  { title = "Other site", href = "https://another.example.com" },
]

# Modules that should be considered "internal" and will not be included in
# generated documentation. Note this currently only affects documentation;
# public types and functions defined in these modules are still public.
#
# Items in this list are "globs" that are matched against module names. See:
# https://docs.rs/glob/latest/glob/struct.Pattern.html
#
# The default value is as below, with the `name` of your project substituted in
# place of "my_app".
internal_modules = [
  "my_app/internal",
  "my_app/internal/*",
]

# The version of the Gleam compiler that the package requires (optional)
# An error is raised if the version of the compiler used to compile the package
# does not match this requirement.
gleam = ">= 0.30.0"

# The Hex packages the project needs to compile and run (optional)
# Uses the Hex version requirement format
# https://hexdocs.pm/elixir/Version.html#module-requirements
[dependencies]
gleam_stdlib = ">= 0.18.0 and < 2.0.0"
gleam_erlang = ">= 0.2.0 and < 2.0.0"
gleam_http = ">= 2.1.0 and < 3.0.0"
# Local dependencies can be specified with a path
my_other_project = { path = "../my_other_project" }

# The Hex packages the project needs for the tests (optional)
# These will not be included if the package is published to Hex.
# This table cannot include any packages that are already found in the
# `dependencies` table.
[dev-dependencies]
gleeunit = ">= 1.0.0 and < 2.0.0"

# Documentation specific configuration (optional)
[documentation]
# Additional markdown pages to be included in generated HTML docs (optional)
pages = [
  { title = "My Page", path = "my-page.html", source = "./path/to/my-page.md" },
]

# Erlang specific configuration (optional)
[erlang]
# The name of the OTP application module, if the project has one (optional)
# Typically Gleam projects do not use the Erlang/OTP implicit application boot
# system and so typically do not define this.
# If specified the module must implement the OTP application behaviour.
# https://www.erlang.org/doc/man/application.html
application_start_module = "my_app/application"

# The names of any OTP applications that need to be started in addition to the
# ones from the project dependencies (optional)
extra_applications = ["inets", "ssl"]

# JavaScript specific configuration (optional)
[javascript]
# Generate TypeScript .d.ts files
typescript_declarations = true

# Which JavaScript runtime to use with `gleam run`, `gleam test` etc.
runtime = "node" # or "deno" or "bun"

# Configuration specific to the Deno runtime (optional)
# https://deno.land/manual@v1.30.0/basics/permissions#permissions
[javascript.deno]
allow_all = false
allow_sys = false
allow_ffi = false
allow_hrtime = false

# A bool or list of environment variables
allow_env = ["DATABASE_URL"]

# A bool or a list of IP addresses or hostnames (optionally with ports) 
allow_net = ["example.com:443"],

# A bool or a list of paths
allow_run = ["./bin/migrate.sh"],
allow_read = ["./database.sqlite"],
allow_write = ["./database.sqlite"],
```
