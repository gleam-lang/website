---
layout: page
title: Installing Gleam
description: Getting your computer ready for Gleam development.
redirect_from:
  - "/getting-started/installing-gleam.html"
  - "/getting-started/installing-erlang.html"
  - "/getting-started/installing-rebar3.html"
  - "/getting-started/editor-support.html"
  - "/book/getting-started/installing-gleam.html"
  - "/book/getting-started/installing-erlang.html"
  - "/book/getting-started/installing-rebar3.html"
  - "/book/getting-started/editor-support.html"
---

To prepare your computer for Gleam development you'll need to install Gleam,
Erlang, and optionally install any Gleam plugins
for your editor.

- [Installing Gleam](#installing-gleam)
- [Installing Erlang](#installing-erlang)
- [Installing Rebar3](#installing-rebar3)
- [Editor Plugins](#editor-plugins)


## Installing Gleam

### Precompiled for amd64 Linux, Windows, and macOS

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

#### Using MacPorts

With [MacPorts](https://www.macports.org/) installed run the following:

```sh
sudo port install gleam
```

### Using the Nix package manager

```sh
nix profile install gleam
```


### asdf version manager

[asdf](https://github.com/asdf-vm/asdf) is a tool for installing and managing
multiple version of programming languages at the same time. Install the
[asdf-gleam plugin](https://github.com/vic/asdf-gleam) to manage Gleam with
asdf.

### Arch Linux

Gleam is available through the [Arch User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository)
as package `gleam`. You can use your prefered [helper](https://wiki.archlinux.org/index.php/AUR_helpers)
to install it or clone it for manual build from [https://aur.archlinux.org/packages/gleam-git](https://aur.archlinux.org/packages/gleam-git).

### FreeBSD

Gleam is available in ports, and also in binary packages. You may need
to use the `latest` package repo, amend per instructions in
`/etc/pkg/FreeBSD.conf`. See below for adjusting your PATH to use latest
Erlang/OTP runtime and not just the standard OTP21:

```
$ pkg install -r FreeBSD lang/gleam lang/erlang-runtime23
$ export PATH=/usr/local/lib/erlang23/bin:$PATH
```

### OpenBSD

For OpenBSD -current, Gleam is available as a binary package. You can install it with:

```
$ doas pkg_add gleam
```

### Void Linux

Gleam is available as part of the official packages repository. Install it with:

```
sudo xbps-install gleam
```

### Windows

#### Using Chocolatey

With [Chocolatey](https://chocolatey.org/) installed on your computer run the following from an Administator PowerShell:

```
choco install gleam
```

#### Using Scoop

With [Scoop](https://scoop.sh/) installed on your computer run the following:

```
scoop install gleam
```


### Build from source

The compiler is written in the Rust programming language and so if you wish to
build Gleam from source you will need to [install the Rust
compiler](https://www.rust-lang.org/tools/install).

```sh
# Download the Gleam source code git repository
cd /tmp
git clone https://github.com/gleam-lang/gleam.git --branch $THE_LATEST_VERSION
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

Once Erlang has been installed you can check it is working by typing `erl
-version` in your computer's terminal. You will see version information like
this if all is well:

```shell
erl -version
Erlang (SMP,ASYNC_THREADS) (BEAM) emulator version 12.1.5
```

#### Linux

#### Alpine Linux (Community repository)

```shell
apk add erlang
```

#### Arch Linux (Community repository)

```shell
pacman -S erlang
```

#### Fedora

```shell
dnf install elixir erlang
```

##### Debian, Ubuntu, Raspberry Pi OS

```shell
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
sudo dpkg -i erlang-solutions_2.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
```


#### Mac OS X

##### Using Homebrew

With [Homebrew](https://brew.sh) installed run the following:

```sh
brew update
brew install erlang
```

#### Using MacPorts

With [MacPorts](https://www.macports.org/) installed run the following:

```sh
sudo port install erlang
```

#### Windows

##### Using Chocolatey

With [Chocolatey](https://chocolatey.org/) installed on your computer run the
following:

```
choco install erlang
```

##### Using Scoop

With [Scoop](https://scoop.sh/) installed on your computer run the following:

```
scoop install erlang
```

#### Using version managers

##### asdf

The asdf version manager has a plugin for installing Erlang. Installation and
usage instructions can be found here:

- [https://github.com/asdf-vm/asdf](https://github.com/asdf-vm/asdf)
- [https://github.com/asdf-vm/asdf-erlang](https://github.com/asdf-vm/asdf-erlang)

## Installing rebar3

When using Erlang based dependencies (such as their web servers and HTTP clients)
the rebar3 Erlang build tool may need to be installed.
Install rebar3 by following the [official rebar3 installation
instructions][rebar3-install].

[rebar3-install]: https://rebar3.org/docs/getting-started/

## Editor Plugins

Gleam plugins are available for several popular editors. If one exists for
your editor of choice consider installing it for syntax highlighting and other
niceties.

- **Vim** - [https://github.com/gleam-lang/gleam.vim](https://github.com/gleam-lang/gleam.vim)
- **Emacs** - [https://github.com/gleam-lang/gleam-mode](https://github.com/gleam-lang/gleam-mode)
- **Visual Studio Code** - [https://github.com/gleam-lang/vscode-gleam](https://github.com/gleam-lang/vscode-gleam)
- **Sublime Text** - [https://github.com/digitalcora/sublime-text-gleam](https://github.com/digitalcora/sublime-text-gleam)
- **Atom** - [https://github.com/itsgreggreg/language-gleam](https://github.com/itsgreggreg/language-gleam)
- **Gedit** - [https://github.com/DannyLettuce/gleam_gedit](https://github.com/DannyLettuce/gleam_gedit)


## What next?

Now you have installed Gleam check out the [Language Tour](/book/tour) for an
overview of the Gleam language.
