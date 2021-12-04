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
├── README.md
├── src
│   └── my_fantastic_library.gleam
└── test
    └── my_fantastic_library_test.gleam

2 directories, 7 files
```

Regular Gleam code goes in the `src` directory, and the tests for this code
goes in the `test` directory.

You can run your project with the `gleam run` command and test it with the
`gleam test` command.


## Continuous integration

All Gleam projects come preconfigured for GitHub Actions CI. Push your
project to GitHub to have the tests and linting run automatically for new
commits and pull requests.
 
