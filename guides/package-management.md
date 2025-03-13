---
title: Package Management
subtitle: Learn to work Gleam's package management
layout: page
---
## Add a dependency

To add a dependency hosted on Hex, we use the `gleam add` CLI command:
```sh
~/repos/playground ❯ gleam add gleam_json
  Resolving versions
Downloading packages
 Downloaded 1 package in 0.00s
      Added gleam_json v2.3.0
```

## Add a git dependency

To add a dependency hosted on git, you can manually add this in your `gleam.toml` file (with `git` being the URL of the dependency, and `ref` being a tag, branch or commit SHA):
```toml
[dependencies]
gleam_stdlib = { git = "https://github.com/gleam-lang/stdlib.git", ref = "957b83b" }
```

## Add a local dependency

To add a local dependency, we can use the following in your `gleam.toml` file:
```toml
[dependencies]
my_other_package = { path = "../my_other_package" }
```
