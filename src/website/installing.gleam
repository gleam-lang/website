import gleam/dict
import gleam/list
import gleam/option
import gleam/order.{type Order}
import gleam/result
import gleam/string
import jot
import lustre/attribute
import lustre/element
import lustre/element/html
import website/fs
import website/page
import website/site

pub fn methods() -> List(InstallationMethod) {
  [
    InstallationMethod(
      name: "apk package manager",
      slug: "apk",
      installs: InstallsGleamAndErlang,
      systems: [LinuxDistro(AlpineLinux)],
      priority: HighPriority,
      content: "
Gleam can be installed with apk by running this command:

```
sudo apk add gleam erlang rebar3
```
",
    ),

    InstallationMethod(
      name: "apk package manager",
      slug: "apk",
      installs: InstallsErlang,
      systems: [LinuxDistro(AlpineLinux)],
      priority: HighPriority,
      content: "
Erlang can be installed with apk by running this command:

```
sudo apk add erlang rebar3
```
",
    ),

    InstallationMethod(
      name: "pacman package manager",
      slug: "pacman",
      installs: InstallsGleamAndErlang,
      systems: [LinuxDistro(ArchLinux)],
      priority: HighPriority,
      content: "
Gleam can be installed with pacman by running this command:

```
sudo pacman -S gleam erlang rebar3
```
",
    ),

    InstallationMethod(
      name: "pacman package manager",
      slug: "pacman",
      installs: InstallsErlang,
      systems: [LinuxDistro(ArchLinux)],
      priority: HighPriority,
      content: "
Erlang can be installed with pacman by running this command:

```
sudo pacman -S erlang rebar3
```
",
    ),

    InstallationMethod(
      name: "emerge package manager",
      slug: "emerge",
      installs: InstallsGleamAndErlang,
      systems: [LinuxDistro(GentooLinux)],
      priority: HighPriority,
      content: "
Gleam is available via emerge, but may need to be unmasked. Install it with
these commands:

```
sudo echo 'dev-lang/gleam ~amd64' >> /etc/portage/package.accept_keywords
emerge --ask dev-lang/gleam
```
",
    ),
    InstallationMethod(
      name: "emerge package mananger",
      slug: "emerge",
      installs: InstallsErlang,
      systems: [LinuxDistro(GentooLinux)],
      priority: HighPriority,
      content: "
Erlang is available via emerge, but may need to be unmasked. Install it with
these commands:

```
sudo echo 'dev-lang/erlang ~amd64' >> /etc/portage/package.accept_keywords
sudo echo 'dev-util/rebar ~amd64' >> /etc/portage/package.accept_keywords
emerge --ask dev-lang/erlang
emerge --ask dev-util/rebar
```
",
    ),

    InstallationMethod(
      name: "xbps package manager",
      slug: "xbps",
      installs: InstallsGleamAndErlang,
      systems: [LinuxDistro(VoidLinux)],
      priority: HighPriority,
      content: "
Gleam can be installed with xbps by running this command:

```
sudo xbps-install gleam
```
",
    ),
    InstallationMethod(
      name: "xbps package manager",
      slug: "xbps",
      installs: InstallsErlang,
      systems: [LinuxDistro(VoidLinux)],
      priority: HighPriority,
      content: "
Erlang can be installed with xbps by running this command:

```
sudo xbps-install erlang rebar3
```
",
    ),

    InstallationMethod(
      name: "zypper package manager",
      slug: "zypper",
      installs: InstallsGleamAndErlang,
      systems: [LinuxDistro(OpenSuseLinux)],
      priority: HighPriority,
      content: "
Gleam can be installed with zypper by running this command:

```
sudo zypper install gleam
```
",
    ),

    InstallationMethod(
      name: "zypper package manager",
      slug: "zypper",
      installs: InstallsErlang,
      systems: [LinuxDistro(OpenSuseLinux)],
      priority: HighPriority,
      content: "
Erlang can be installed with zypper by running this command:

```
sudo zypper install erlang erlang-rebar3
```
",
    ),

    InstallationMethod(
      name: "pkg package manager",
      slug: "pkg",
      installs: InstallsGleamAndErlang,
      systems: [FreeBsd],
      priority: HighPriority,
      content: "
Gleam can be installed with pkg by running this command:

```
sudo pkg install gleam erlang rebar3
```
",
    ),
    InstallationMethod(
      name: "pkg package manager",
      slug: "pkg",
      installs: InstallsErlang,
      systems: [FreeBsd],
      priority: HighPriority,
      content: "
Erlang can be installed with pkg by running this command:

```
sudo pkg install erlang rebar3
```
",
    ),

    InstallationMethod(
      name: "pkg package manager",
      slug: "pkg",
      installs: InstallsGleamAndErlang,
      systems: [OpenBsd],
      priority: HighPriority,
      content: "
Gleam can be installed with pkg_add by running this command:

```
doas pkg_add install gleam erlang erl27-rebar3
```
",
    ),
    InstallationMethod(
      name: "pkg package manager",
      slug: "pkg",
      installs: InstallsErlang,
      systems: [OpenBsd],
      priority: HighPriority,
      content: "
Erlang can be installed with pkg_add by running this command:

```
doas pkg_add install erlang erl27-rebar3
```
",
    ),

    InstallationMethod(
      name: "Termux pkg package manager",
      slug: "termux",
      installs: InstallsGleamAndErlang,
      systems: [Android],
      priority: HighPriority,
      content: "
Gleam can be installed with [Termux](https://termux.dev/)'s pkg by running this command:

```
pkg install gleam && pkg install erlang
```
",
    ),
    InstallationMethod(
      name: "Termux pkg package manager",
      slug: "termux",
      installs: InstallsErlang,
      systems: [Android],
      priority: HighPriority,
      content: "
Erlang can be installed with [Termux](https://termux.dev/)'s pkg by running this command:

```
pkg install erlang
```
",
    ),

    InstallationMethod(
      name: "winget package manager",
      slug: "winget",
      installs: InstallsGleamAndErlang,
      systems: [Windows],
      priority: HighPriority,
      content: "
Gleam can be installed with [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
by running this command:

```
winget install --id Gleam.Gleam
```
",
    ),
    InstallationMethod(
      name: "winget package manager",
      slug: "winget",
      installs: InstallsErlang,
      systems: [Windows],
      priority: HighPriority,
      content: "
Erlang can be installed with [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
by running this command:

```
winget install --id Erlang.ErlangOTP
```
",
    ),

    InstallationMethod(
      name: "Scoop package manager",
      slug: "scoop",
      installs: InstallsGleamAndErlang,
      systems: [Windows],
      priority: MediumPriority,
      content: "
Gleam can be installed with [Scoop](https://scoop.sh/) by running these
commands:

```
scoop bucket add main
scoop install main/gleam
scoop install main/erlang
scoop install main/rebar3
```
",
    ),
    InstallationMethod(
      name: "Scoop package manager",
      slug: "scoop",
      installs: InstallsErlang,
      systems: [Windows],
      priority: MediumPriority,
      content: "
Erlang can be installed with [Scoop](https://scoop.sh/) by running these
commands:

```
scoop bucket add main
scoop install main/erlang
scoop install main/rebar3
```
",
    ),

    InstallationMethod(
      name: "Homebrew package manager",
      slug: "homebrew",
      installs: InstallsGleamAndErlang,
      systems: [Linux],
      priority: MediumPriority,
      content: "
Gleam can be installed with [Homebrew](https://brew.sh/) using this command:

```txt
brew install gleam
```
",
    ),
    InstallationMethod(
      name: "Homebrew package manager",
      slug: "homebrew",
      installs: InstallsErlang,
      systems: [Linux],
      priority: MediumPriority,
      content: "
Erlang can be installed with [Homebrew](https://brew.sh/) using this command:

```txt
brew install erlang
```
",
    ),

    InstallationMethod(
      name: "Homebrew package manager",
      slug: "homebrew",
      installs: InstallsErlang,
      systems: [MacOs],
      priority: HighPriority,
      content: "
Erlang can be installed with [Homebrew](https://brew.sh/) using this command:

```txt
brew install erlang
```
",
    ),

    InstallationMethod(
      name: "MacPorts package manager",
      slug: "macports",
      installs: InstallsGleamAndErlang,
      systems: [MacOs],
      priority: MediumPriority,
      content: "
Gleam can be installed with [MacPorts](https://www.macports.org/) by running
this command:

```
sudo port install gleam
```
",
    ),
    InstallationMethod(
      name: "MacPorts package manager",
      slug: "macports",
      installs: InstallsErlang,
      systems: [MacOs],
      priority: MediumPriority,
      content: "
Erlang can be installed with [MacPorts](https://www.macports.org/) by running
these commands:

```
sudo port install erlang
sudo port install rebar3
```
",
    ),

    InstallationMethod(
      name: "asdf version manager",
      slug: "asdf",
      installs: InstallsGleamAndErlang,
      systems: [MacOs, Linux],
      priority: MediumPriority,
      content: "Gleam can be installed with [asdf](https://asdf-vm.com/guide/getting-started.html)
by running these commands:

```txt
asdf install gleam latest
asdf install erlang latest
asdf install rebar3 latest
asdf global gleam latest
asdf global erlang latest
asdf global rebar3 latest
```

Installing with asdf can take a long time as it builds Erlang from source. On MacOS the
[pre-build Erlang plugin](https://github.com/michallepicki/asdf-erlang-prebuilt-macos)
can be used to skip this work.
",
    ),
    InstallationMethod(
      name: "asdf version manager",
      slug: "asdf",
      installs: InstallsErlang,
      systems: [MacOs, Linux],
      priority: MediumPriority,
      content: "Erlang can be installed with [asdf](https://asdf-vm.com/guide/getting-started.html)
by running these commands:

```txt
asdf install erlang latest
asdf install rebar3 latest
asdf global erlang latest
asdf global rebar3 latest
```

Installing with asdf can take a long time as it builds Erlang from source. On MacOS the
[pre-build Erlang plugin](https://github.com/michallepicki/asdf-erlang-prebuilt-macos)
can be used to skip this work.
",
    ),

    InstallationMethod(
      name: "Precompiled executable from GitHub",
      slug: "github",
      installs: InstallsGleam,
      systems: [Linux, MacOs, Windows],
      priority: LowPriority,
      content: "
The core team provides precompiled `gleam` binaries. Navigate to the
[GitHub release](https://github.com/gleam-lang/gleam/releases) page for Gleam
version you want to install. Under \"assets\" locate and download the tarball
and sha256 checksum files for your operating system and processor archecture.

```
wget https://github.com/gleam-lang/gleam/releases/download/v1.14.0/gleam-v1.14.0-aarch64-unknown-linux-musl.tar.gz

wget https://github.com/gleam-lang/gleam/releases/download/v1.14.0/gleam-v1.14.0-aarch64-unknown-linux-musl.tar.gz.sha256
```

Verify the checksum is correct. If this command shows a warning then delete
both files and start again.

```
sha256sum -c gleam-v1.14.0-x86_64-unknown-linux-musl.tar.gz.sha256
```

Extract the `gleam` program from the tarball.

```
tar xf gleam-v1.14.0-x86_64-unknown-linux-musl.tar.gz
```

Make the binary executable and place it in a directory on your `PATH`.

```
chmod +x gleam
mv gleam ~/.local/bin/
```
",
    ),

    InstallationMethod(
      name: "Compile from source",
      slug: "source",
      installs: InstallsGleam,
      systems: [Linux, MacOs, Windows],
      priority: LowPriority,
      content: "
The Gleam toolchain can be compiled with Cargo, Rust's build tool. The most
recent stable version of Rust needs to be installed, as other versions may not
be able to compile Gleam.

Clone the Gleam source code repository at the version you want.

```
git clone https://github.com/gleam-lang/gleam.git --branch v1.14.0
cd gleam
```

Compile and install Gleam.

```
cargo install --path cargo-bin --force --locked
```
",
    ),

    InstallationMethod(
      name: "Neovim",
      slug: "nvim",
      installs: InstallsEditorSupport,
      systems: [Linux, MacOs, Windows, FreeBsd, OpenBsd, Android],
      priority: MediumPriority,
      content: "
Neovim’s [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) includes
configuration for Gleam. Install `nvim-lspconfig` with your preferred plugin
manager and then add the language server to your `init.lua`.

On Nvim 0.11+ and nvim-lspconfig 2.1+:

```lua
vim.lsp.enable('gleam')
```

On Nvim <= 0.10:

```lua
require('lspconfig').gleam.setup({})
```

The language server will then be automatically started when you open a Gleam file.

If you are using [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
you can run `:TSInstall gleam` to get syntax highlighting and other tree-sitter
features.
",
    ),

    InstallationMethod(
      name: "VS Code",
      slug: "vscode",
      installs: InstallsEditorSupport,
      systems: [Linux, MacOs, Windows, FreeBsd, OpenBsd, Android],
      priority: MediumPriority,
      content: "
Install the [VS Code Gleam plugin](https://marketplace.visualstudio.com/items?itemName=Gleam.gleam).

The language server will then automatically started when you open a Gleam file.
If VS Code is unable to run the language server ensure that the `gleam` binary
is included on VS Code’s `PATH`, and consider restarting VS Code.
",
    ),

    InstallationMethod(
      name: "Helix",
      slug: "helix",
      installs: InstallsEditorSupport,
      systems: [Linux, MacOs, Windows, FreeBsd, OpenBsd, Android],
      priority: MediumPriority,
      content: "
Helix supports the language server out-of-the-box. No additional configuration
is required and Helix will automatically start the language server when a Gleam
file is opened.
",
    ),

    InstallationMethod(
      name: "Zed",
      slug: "zed",
      installs: InstallsEditorSupport,
      systems: [Linux, MacOs, Windows, FreeBsd, OpenBsd, Android],
      priority: MediumPriority,
      content: "
The [`zed-gleam`](https://github.com/gleam-lang/zed-gleam) plugin provides
syntax highlighting and Language Server support for Gleam.

To install the plugin open a Gleam file in Zed and accept the prompt that
appears.
",
    ),

    InstallationMethod(
      name: "Sublime Text",
      slug: "sublime-text",
      installs: InstallsEditorSupport,
      systems: [Linux, MacOs, Windows],
      priority: MediumPriority,
      content: "
The [`sublime-text-gleam`](https://github.com/digitalcora/sublime-text-gleam)
package provides Gleam syntax highlighting is available on package control, to
install it:

1. Open the command palette (Ctrl/Cmd+Shift+P)
2. Select Package Control: Install Package
3. Select Gleam

The LSP package can be configured to use the Gleam language server. Open
\"Preferences: LSP Settings\" in the command palette, and then add this config:

```json
{
  \"clients\": {
    \"gleam\": {
      \"enabled\": true,
      \"command\": [\"gleam\", \"lsp\"],
      \"selector\": \"source.gleam\"
    }
  },
  \"lsp_format_on_save\": true
}
```

For more information see the documentation for
[`sublime-text-gleam`](https://github.com/digitalcora/sublime-text-gleam).
",
    ),

    InstallationMethod(
      name: "Emacs",
      slug: "emacs",
      installs: InstallsEditorSupport,
      systems: [Linux, MacOs, Windows, FreeBsd, OpenBsd, Android],
      priority: MediumPriority,
      content: "
[`gleam-ts-mode`](https://github.com/gleam-lang/gleam-mode) is a major mode for
Emacs 29 or higher.

If you are using MELPA you can install it like so:

```lisp
(use-package gleam-ts-mode
  :mode (rx \".gleam\" eos))
```

See the documentation for the mode for other installation methods and
considerations.
",
    ),

    InstallationMethod(
      name: "Vim",
      slug: "vim",
      installs: InstallsEditorSupport,
      systems: [Linux, MacOs, Windows, FreeBsd, OpenBsd, Android],
      priority: MediumPriority,
      content: "
Vim has built in syntax highlighting and `:make` commands for Gleam.

If you are using a plugin to add Language Server Protocol support for Vim then
configure it to run `gleam lsp` from the root of your workspace.
",
    ),

    InstallationMethod(
      name: "Other editors",
      slug: "other-editors",
      installs: InstallsEditorSupport,
      systems: [Linux, MacOs, Windows, FreeBsd, OpenBsd, Android],
      priority: LowPriority,
      content: "
Any other editor that supports the Language Server Protocol can use the Gleam
Language Server. Configure your editor to run `gleam lsp` from the root of your
workspace.
",
    ),
  ]
}

pub type Priority {
  HighPriority
  MediumPriority
  LowPriority
}

pub type OperatingSystem {
  Android
  FreeBsd
  Linux
  LinuxDistro(LinuxDistribution)
  MacOs
  OpenBsd
  Windows
}

pub type LinuxDistribution {
  AlpineLinux
  ArchLinux
  GentooLinux
  OpenSuseLinux
  VoidLinux
}

pub type Editor {
  Atom
  Emacs
  Gedit
  Neovim
  SublimeText
  VisualStudioCode
  Zed
}

pub type Component {
  InstallsGleam
  InstallsErlang
  InstallsGleamAndErlang
  InstallsEditorSupport
}

pub type InstallStep {
  GleamStep
  ErlangStep
  EditorStep
}

pub type InstallationMethod {
  InstallationMethod(
    name: String,
    slug: String,
    installs: Component,
    systems: List(OperatingSystem),
    priority: Priority,
    content: String,
  )
}

fn step_slug(step: InstallStep) -> String {
  case step {
    GleamStep -> "gleam"
    ErlangStep -> "erlang"
    EditorStep -> "editor"
  }
}

fn operating_system_slug(os: OperatingSystem) -> String {
  case os {
    Android -> "android"
    FreeBsd -> "freebsd"
    Linux -> "linux"
    MacOs -> "macos"
    OpenBsd -> "openbsd"
    Windows -> "windows"
    LinuxDistro(distro) -> linux_distro_slug(distro)
  }
}

fn linux_distro_slug(distro: LinuxDistribution) -> String {
  case distro {
    AlpineLinux -> "alpine-linux"
    ArchLinux -> "arch-linux"
    GentooLinux -> "gentoo-linux"
    OpenSuseLinux -> "opensuse-linux"
    VoidLinux -> "void-linux"
  }
}

fn linux_distro_name(distro: LinuxDistribution) -> String {
  case distro {
    AlpineLinux -> "Alpine Linux"
    ArchLinux -> "Arch Linux"
    GentooLinux -> "Gentoo Linux"
    OpenSuseLinux -> "OpenSUSE Linux"
    VoidLinux -> "Void Linux"
  }
}

fn operating_system_name(os: OperatingSystem) -> String {
  case os {
    Android -> "Android"
    FreeBsd -> "FreeBSD"
    Linux -> "Linux"
    MacOs -> "MacOS"
    OpenBsd -> "OpenBSD"
    Windows -> "Windows"
    LinuxDistro(distro) -> linux_distro_name(distro)
  }
}

pub fn pages(ctx: site.Context) -> List(fs.File) {
  let methods =
    list.fold(methods(), dict.new(), fn(methods, method) {
      list.fold(method.systems, methods, fn(methods, system) {
        dict.upsert(methods, system, fn(list) {
          [method, ..option.unwrap(list, [])]
        })
      })
    })

  let #(linux_distros, systems) = dict.keys(methods) |> partition_systems
  let systems = list.sort(systems, compare_operating_system)
  let linux_distros = list.sort(linux_distros, compare_linux_distros)
  let pages = [
    which_operating_system_page(systems, ctx),
    which_linux_distro_page(linux_distros, ctx),
  ]
  let linux_methods = dict.get(methods, Linux) |> result.unwrap([])

  dict.fold(methods, pages, fn(pages, system, methods) {
    system_pages(pages, system, methods, linux_methods, ctx)
  })
}

fn compare_linux_distros(a: LinuxDistribution, b: LinuxDistribution) -> Order {
  string.compare(linux_distro_slug(a), linux_distro_slug(b))
}

fn compare_operating_system(a: OperatingSystem, b: OperatingSystem) -> Order {
  compare_priority(operating_system_priority(a), operating_system_priority(b))
  |> order.break_tie(string.compare(
    operating_system_slug(a),
    operating_system_slug(b),
  ))
}

fn operating_system_priority(system: OperatingSystem) -> Priority {
  case system {
    Linux | LinuxDistro(_) | Windows | MacOs -> HighPriority
    Android | FreeBsd | OpenBsd -> MediumPriority
  }
}

fn compare_priority(a: Priority, b: Priority) -> Order {
  case a, b {
    HighPriority, HighPriority
    | MediumPriority, MediumPriority
    | LowPriority, LowPriority
    -> order.Eq

    HighPriority, _ -> order.Lt
    _, HighPriority -> order.Gt
    MediumPriority, _ -> order.Lt
    _, MediumPriority -> order.Gt
  }
}

fn system_pages(
  pages: List(fs.File),
  system: OperatingSystem,
  methods: List(InstallationMethod),
  linux_methods: List(InstallationMethod),
  ctx: site.Context,
) -> List(fs.File) {
  let methods = case system {
    LinuxDistro(_) -> list.append(methods, linux_methods)
    _ -> methods
  }
  let methods =
    list.sort(methods, fn(a, b) {
      compare_priority(a.priority, b.priority)
      |> order.break_tie(string.compare(a.slug, b.slug))
    })

  let pages = [
    what_method_page(system, GleamStep, methods, ctx),
    what_method_page(system, ErlangStep, methods, ctx),
    what_method_page(system, EditorStep, methods, ctx),
    ..pages
  ]

  list.fold(methods, pages, fn(pages, method) {
    [method_page(system, method, ctx), ..pages]
  })
}

fn method_page(
  system: OperatingSystem,
  method: InstallationMethod,
  ctx: site.Context,
) -> fs.File {
  let name = operating_system_name(system)
  let install_step = method_step(method.installs)
  let path = method_path(install_step, system, method)
  let meta =
    page.PageMeta(
      path:,
      title: method.name,
      meta_title: method.name <> " | Gleam programming language",
      subtitle: case method.installs {
        InstallsGleam | InstallsGleamAndErlang -> "Installing Gleam on " <> name
        InstallsErlang -> "Installing Erlang on " <> name
        InstallsEditorSupport -> "Installing Gleam editor support on " <> name
      },
      description: "Installing Gleam on " <> name,
      preload_images: [],
      preview_image: option.None,
    )

  let nav = case method.installs {
    InstallsGleam -> {
      let path = method_selection_path(ErlangStep, system)
      nav_button("Continue to install Erlang", path)
    }
    InstallsGleamAndErlang | InstallsErlang -> {
      let path = method_selection_path(EditorStep, system)
      nav_button("Continue to install editor support", path)
    }
    InstallsEditorSupport ->
      nav_button("Learn Gleam!", "https://tour.gleam.run")
  }

  let content = jot.parse(method.content) |> jot.document_to_html
  [
    html.article([attribute.class("prose")], [
      element.unsafe_raw_html("", "div", [], content),
      html.nav([attribute.class("text-center")], [nav]),
    ]),
  ]
  |> page.page_layout("", meta, ctx)
  |> page.to_html_file(meta)
}

fn method_step(installs: Component) -> InstallStep {
  case installs {
    InstallsGleam | InstallsGleamAndErlang -> GleamStep
    InstallsErlang -> ErlangStep
    InstallsEditorSupport -> EditorStep
  }
}

fn nav_button(text: String, href: String) {
  html.a([attribute.href(href), attribute.class("button")], [element.text(text)])
}

fn what_method_page(
  system: OperatingSystem,
  step: InstallStep,
  methods: List(InstallationMethod),
  ctx: site.Context,
) -> fs.File {
  let name = operating_system_name(system)
  let title = case step {
    GleamStep -> "Installing Gleam on " <> name
    ErlangStep -> "Installing Erlang on " <> name
    EditorStep -> "Installing editor support"
  }
  let path = method_selection_path(step, system)
  let subtitle = case step {
    GleamStep | ErlangStep -> "What method would you like to use?"
    EditorStep -> "What's your editor of choice?"
  }

  let meta =
    page.PageMeta(
      path:,
      title:,
      meta_title: title,
      subtitle:,
      description: "Documentation and guides on how to prepare your computer for Gleam development",
      preload_images: [],
      preview_image: option.None,
    )

  let methods =
    list.filter(methods, fn(method) {
      case step, method.installs {
        GleamStep, InstallsGleam -> True
        GleamStep, InstallsGleamAndErlang -> True
        ErlangStep, InstallsErlang -> True
        EditorStep, InstallsEditorSupport -> True
        _, _ -> False
      }
    })

  let method_html = fn(method: InstallationMethod) {
    let path = method_path(step, system, method)
    let badge = case method.priority {
      HighPriority -> html.i([], [html.text(" (recommended!)")])
      MediumPriority | LowPriority -> element.none()
    }

    html.li([], [
      html.a([attribute.href(path)], [html.text(method.name)]),
      badge,
    ])
  }

  [
    html.ul([], list.map(methods, method_html)),
  ]
  |> page.page_layout("", meta, ctx)
  |> page.to_html_file(meta)
}

fn system_choice(
  text text: String,
  href href: String,
  image image: String,
) -> element.Element(a) {
  html.li([], [
    html.a([attribute.href(href)], [
      html.img([attribute.src("/images/" <> image)]),
      html.text(text),
    ]),
  ])
}

const which_distro_path = "/install/linux"

fn method_selection_path(step: InstallStep, system: OperatingSystem) -> String {
  "/install/" <> operating_system_slug(system) <> "/" <> step_slug(step)
}

fn method_path(
  step: InstallStep,
  system: OperatingSystem,
  method: InstallationMethod,
) -> String {
  method_selection_path(step, system) <> "/" <> method.slug
}

fn operating_system_path(system: OperatingSystem) -> String {
  case system {
    Linux | LinuxDistro(_) -> which_distro_path
    Android | FreeBsd | MacOs | OpenBsd | Windows ->
      method_selection_path(GleamStep, system)
  }
}

fn which_linux_distro_page(
  distros: List(LinuxDistribution),
  ctx: site.Context,
) -> fs.File {
  let meta =
    page.PageMeta(
      path: which_distro_path,
      title: "Installing Gleam",
      meta_title: "Installing the Gleam Programming Language",
      subtitle: "What Linux distribution do you use?",
      description: "Get your computer ready for Gleam development",
      preload_images: [],
      preview_image: option.None,
    )

  let distro_html = fn(distro) {
    system_choice(
      linux_distro_name(distro),
      method_selection_path(GleamStep, LinuxDistro(distro)),
      linux_distro_slug(distro) <> ".svg",
    )
  }

  [
    html.ul([], [
      system_choice(
        "Any other Linux",
        method_selection_path(GleamStep, Linux),
        "linux.svg",
      ),
      ..list.map(distros, distro_html)
    ]),
  ]
  |> page.page_layout("", meta, ctx)
  |> page.to_html_file(meta)
}

fn which_operating_system_page(
  systems: List(OperatingSystem),
  ctx: site.Context,
) -> fs.File {
  let meta =
    page.PageMeta(
      path: "install",
      title: "Installing Gleam",
      meta_title: "Installing the Gleam Programming Language",
      subtitle: "What operating system do you use?",
      description: "Get your computer ready for Gleam development",
      preload_images: [],
      preview_image: option.None,
    )

  let system_html = fn(system) {
    system_choice(
      operating_system_name(system),
      operating_system_path(system),
      operating_system_slug(system) <> ".svg",
    )
  }

  let start =
    [html.ul([], list.map(systems, system_html))]
    |> page.page_layout("", meta, ctx)
    |> page.to_html_file(meta)
  start
}

fn partition_systems(all_systems: List(OperatingSystem)) {
  all_systems
  |> list.map(fn(system) {
    case system {
      LinuxDistro(distro) -> Ok(distro)
      _ -> Error(system)
    }
  })
  |> result.partition
}
