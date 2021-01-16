---
title: Creating a project
layout: page
---

The `gleam new` command can be used to generate a new Gleam project.

```sh
gleam new my_fantastic_library
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

Regular Gleam code goes in the `src` directory, and the tests for this code
goes in the `test` directory.


## Applications

The default project generated is a library, but we may want to create an
runnable application instead. If we specify an alternate template when
creating a project we can instead generate an application project compatible
with the Erlang OTP framework.

```sh
gleam new my_fantastic_application --template app
```

## Continuous integration

All Gleam projects come preconfigured for GitHub Actions CI. Push your
project to GitHub to have the tests and linting run automatically for new
commits and pull requests.
 
