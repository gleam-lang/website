---
layout: page
title: The Gleam Language Server Manual
subtitle: Gleam IDE features for all editors
---

The Gleam Language Server is a program that can provide IDE features to text
editors that implement the language server protocol, such as VS Code and Neovim.
This document details the current state of the language server and its features.

- [Project Status](#project-status)
- [Installation](#installation)
  - [Helix](#helix)
  - [Neovim](#neovim)
  - [VS Code](#vs-code)
  - [Zed](#zed)
  - [Other editors](#other-editors)
- [Features](#features)
- [Code Actions](#code-actions)
- [Use outside of Gleam projects](#use-outside-of-gleam-projects)


# Project Status

The Gleam Language Server is an official Gleam project and the newest part of
the Gleam toolchain. It is actively being developed and is rapidly improving,
but it does not have all the features you might find in more mature language
servers for older languages.

If you wish to to see what is currently being worked on you can view 
[the project roadmap](https://github.com/ogs/gleam-lang/projects/4/views/1) on GitHub.


# Installation

The Gleam Language Server is included in the regular `gleam` binary, so if you
have Gleam installed then you have the Gleam language server installed. You may
need to configure your editor to use the language server for Gleam code.

## Helix

Helix supports the language server out-of-the-box. No additional configuration
is required and Helix will automatically start the language server when a Gleam
file is opened.

## Neovim

Neovim's [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) includes
configuration for Gleam. Install `nvim-lspconfig` with your preferred plugin
manager and then add the language server to your `init.lua`.

```lua
require('lspconfig').gleam.setup({})
```

The language server will then be automatically started when you open a Gleam
file.

If you are using [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
you can run `:TSInstall gleam` to get syntax highlighting and other tree-sitter
features.

### What About Mason?
Gleam's toolchain comes bundled with everything in a single binary, including the LSP. 
This means if you install Gleam using Mason, Neovim gets a second version of Gleam, which 
can lead to version conflicts between your editor and your actual build.

Because of this, it is recommended to just add the manual configuration line above using `lspconfig`.

## VS Code

Install the [VS Code Gleam plugin](https://marketplace.visualstudio.com/items?itemName=Gleam.gleam).

The language server will then me automatically started when you open a Gleam
file. If VS Code is unable to run the language server ensure that the `gleam`
binary is included on VS Code's `PATH`, and consider restarting VS Code.

## Zed

Helix supports the language server out-of-the-box. No additional configuration
is required and Helix will automatically start the language server when a Gleam
file is opened.

## Other Editors

Any other editor that supports the Language Server Protocol can use the Gleam
Language Server. Configure your editor to run `gleam lsp` from the root of your
workspace.


# Features

# Code Actions
