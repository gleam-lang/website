---
layout: page
title: Getting started with Gleam
description: Getting your computer ready for Gleam development.
redirect_from:
  - "/getting-started/installing-gleam.html"
  - "/getting-started/installing-erlang.html"
  - "/getting-started/installing-rebar3.html"
  - "/getting-started/editor-support.html"
  - "/book/getting-started/index.html"
  - "/book/getting-started/installing-gleam.html"
  - "/book/getting-started/installing-erlang.html"
  - "/book/getting-started/installing-rebar3.html"
  - "/book/getting-started/editor-support.html"
---

To prepare your computer for Gleam development you'll need to install Gleam,
Erlang, rebar3 the Erlang built tool, and optionally install any Gleam plugins
for your editor.

- [Installing Gleam](#installing-gleam)
- [Installing Erlang](#installing-erlang)
- [Installing rebar3](#installing-rebar3)
- [Editor Plugins](#editor-plugins)
- [GitPod online Gleam development environment](#gitpod-online-gleam-development-environment)


## Installing Gleam

### Precompiled for Linux, Windows, and macOS

The easiest way to install Gleam on Linux, Windows, and Apple macOS is to download a
prebuilt version of the compiler from the [GitHub release
page](https://github.com/gleam-lang/gleam/releases).

### Mac OS X

#### Using Homebrew

With [Homebrew](https://brew.sh) installed run the following:

```sh
brew update
brew install gleam
```

### asdf version manager

[asdf](https://github.com/asdf-vm/asdf) is a tool for installing and managing
multiple version of programming languages at the same time. Install the
[asdf-gleam plugin](https://github.com/vic/asdf-gleam) to manage Gleam with
asdf.

### Arch Linux

Gleam is available through the [Arch User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository)
as package `gleam`. You can use your prefered [helper](https://wiki.archlinux.org/index.php/AUR_helpers)
to install it or clone it for manual build from [https://aur.archlinux.org/gleam.git](https://aur.archlinux.org/gleam.git).

### Build from source

The compiler is written in the Rust programming language and so if you wish to
build Gleam from source you will need to [install the Rust
compiler](https://www.rust-lang.org/tools/install).

```sh
# Download the Gleam source code git repository
cd /tmp
git clone https://github.com/gleam-lang/gleam.git --branch v0.8.0
cd gleam

# Build the Gleam compiler. This will take some time!
make install

# Verify the compiler is installed
# Prints "gleam $VERSION"
gleam --version
```

## Installing Erlang

Gleam compiles to Erlang code, so Erlang needs to be installed to run Gleam
code.

Precompiled builds for many popular operating systems can be downloaded from
the [Erlang solutions website](https://www.erlang-solutions.com/resources/download.html).

Guides for installing Erlang on specific operating systems can be found below,
as well as information on installing multiple versions of Erlang at once using
version management tools.

Once Erlang has been installed you can check it is working by typing `erl
-version` in your computer's terminal. You will see version information like
this if all is well:

```
$ erl -version
Erlang (SMP,ASYNC_THREADS,HIPE) (BEAM) emulator version 10.1
```

#### Linux

##### Debian Linux

```sh
sudo apt-get update
sudo apt-get install erlang
```

##### Ubuntu Linux

```sh
sudo apt-get update
sudo apt-get install erlang
```


#### Mac OS X

##### Using Homebrew

With [Homebrew](https://brew.sh) installed run the following:

```sh
brew update
brew install erlang
```

#### Windows

##### Using Chocolatey

With [Chocolatey](https://chocolatey.org/) installed on your computer run the
following:

```
choco install erlang
```

#### Using version managers

##### asdf

The asdf version manager has a plugin for installing Erlang. Installation and
usage instructions can be found here:

- [https://github.com/asdf-vm/asdf](https://github.com/asdf-vm/asdf)
- [https://github.com/asdf-vm/asdf-erlang](https://github.com/asdf-vm/asdf-erlang)

## Installing rebar3

### Installing on Unix

Latest stable compiled version:
```bash
$ wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3
```

From Source (assuming you have a full Erlang install):

```bash
$ git clone https://github.com/erlang/rebar3.git
$ cd rebar3
$ ./bootstrap
```

Stable versions can also be obtained from the [releases page](https://github.com/erlang/rebar3/releases).

The rebar3 escript can also extract itself with a run script under the user's home directory:

```bash
$ ./rebar3 local install
===> Extracting rebar3 libs to ~/.cache/rebar3/lib...
===> Writing rebar3 run script ~/.cache/rebar3/bin/rebar3...
===> Add to $PATH for use: export PATH=~/.cache/rebar3/bin:$PATH
```

To keep it up to date after you've installed rebar3 this way you can use `rebar3 local upgrade` which
fetches the latest stable release and extracts to the same place as above. A [nightly version can
also be obtained](https://s3.amazonaws.com/rebar3-nightly/rebar3) if desired.


## Editor Plugins

Gleam plugins are available for several popular editors. If one exists for
your editor of choice consider installing it for syntax highlighting and other
niceties.

- **Vim** - [https://github.com/gleam-lang/gleam.vim](https://github.com/gleam-lang/gleam.vim)
- **Emacs** - [https://github.com/gleam-lang/gleam-mode](https://github.com/gleam-lang/gleam-mode)
- **Visual Studio Code** - [https://github.com/rawburt/vscode-gleam-syntax](https://github.com/rawburt/vscode-gleam-syntax)
- **Sublime Text 3** - [https://github.com/molnarmark/sublime-gleam](https://github.com/molnarmark/sublime-gleam)
- **Atom** - [https://github.com/itsgreggreg/language-gleam](https://github.com/itsgreggreg/language-gleam)


## GitPod online Gleam development environment

Gleam can be tested on [Gitpod](https://gitpod.io/#https://github.com/codec-abc/gitpod-gleam). The environment comes with Erlang and Elixir. The port 3000 is also exposed if you want to run a web server.

---

[Language Tour](/book/tour) - In this chapter we explore the fundamentals of the Gleam language, namely its syntax, core data structures, flow control features, and static type system.
