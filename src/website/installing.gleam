import gleam/dict
import gleam/list
import gleam/option
import gleam/result
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
      name: "Install with apk",
      slug: "apk",
      installs: InstallsGleamAndErlang,
      systems: [LinuxDistro(AlpineLinux)],
      content: "
Gleam can be installed with apk by running this command:

```
sudo apk add gleam erlang rebar3
```
",
    ),

    InstallationMethod(
      name: "Install with pacman",
      slug: "pacman",
      installs: InstallsGleamAndErlang,
      systems: [LinuxDistro(ArchLinux)],
      content: "
Gleam can be installed with pacman by running this command:

```
sudo pacman -S gleam erlang rebar3
```
",
    ),

    InstallationMethod(
      name: "Install with emerge",
      slug: "emerge",
      installs: InstallsGleamAndErlang,
      systems: [LinuxDistro(GentooLinux)],
      content: "
Gleam is available via emerge, but may need to be unmasked. Install it with
this command:

```
sudo echo 'dev-lang/gleam ~amd64' >> /etc/portage/package.accept_keywords
emerge --ask dev-lang/gleam
```
",
    ),

    InstallationMethod(
      name: "Install with xbps",
      slug: "xbps",
      installs: InstallsGleamAndErlang,
      systems: [LinuxDistro(VoidLinux)],
      content: "
Gleam can be installed with xbps by running this command:

```
sudo xbps-install gleam
```
",
    ),

    InstallationMethod(
      name: "Install with zypper",
      slug: "zypper",
      installs: InstallsGleamAndErlang,
      systems: [LinuxDistro(OpenSuseLinux)],
      content: "
Gleam can be installed with zypper by running this command:

```
sudo zypper install gleam
```
",
    ),

    InstallationMethod(
      name: "Install with pkg",
      slug: "pkg",
      installs: InstallsGleamAndErlang,
      systems: [FreeBsd],
      content: "
Gleam cann be installed with pkg by running this command:

```
sudo pkg install gleam erlang rebar3
```
",
    ),

    InstallationMethod(
      name: "Install with pkg",
      slug: "pkg",
      installs: InstallsGleamAndErlang,
      systems: [OpenBsd],
      content: "
Gleam cann be installed with pkg_add by running this command:

```
doas pkg_add install gleam erlang erl27-rebar3
```
",
    ),

    InstallationMethod(
      name: "Install with termux pkg",
      slug: "termux",
      installs: InstallsGleamAndErlang,
      systems: [Android],
      content: "
Gleam can be installed with [Termux](https://termux.dev/)'s pkg by running this command:

```
pkg install gleam && pkg install erlang
```
",
    ),

    InstallationMethod(
      name: "Install with winget",
      slug: "winget",
      installs: InstallsGleamAndErlang,
      systems: [Windows],
      content: "
Gleam can be installed with [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/)
by running this command:

```
winget install --id Gleam.Gleam
```
",
    ),

    InstallationMethod(
      name: "Install with Scoop",
      slug: "scoop",
      installs: InstallsGleamAndErlang,
      systems: [Windows],
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
      name: "Install with Homebrew",
      slug: "homebrew",
      installs: InstallsGleamAndErlang,
      systems: [MacOs, Linux],
      content: "Gleam can be installed with [Homebrew](https://brew.sh/) using this command:

```txt
brew install gleam
```
",
    ),
    InstallationMethod(
      name: "Install with MacPorts",
      slug: "macports",
      installs: InstallsGleamAndErlang,
      systems: [MacOs],
      content: "
Gleam can be installed with [MacPorts](https://www.macports.org/) by running
this command:

```
sudo port install gleam
```
",
    ),

    InstallationMethod(
      name: "Install with asdf version manager",
      slug: "asdf",
      installs: InstallsGleam,
      systems: [MacOs, Linux],
      content: "Gleam can be installed with [asdf](https://asdf-vm.com/guide/getting-started.html)
by running these commands:

```txt
asdf install gleam latest
asdf install erlang latest
asdf install rebar3 latest
asdf global install gleam
asdf global install erlang
asdf global install rebar3
```

Installing with asdf can take a long time as it builds Erlang from source. On MacOS the
[pre-build Erlang plugin](https://github.com/michallepicki/asdf-erlang-prebuilt-macos)
can be used to skip this work.
",
    ),

    InstallationMethod(
      name: "Install from GitHub",
      slug: "github",
      installs: InstallsGleam,
      systems: [Linux, MacOs, Windows],
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
      name: "Compile from source with Cargo",
      slug: "source",
      installs: InstallsGleam,
      systems: [Linux, MacOs, Windows],
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
  ]
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
  let pages = [start_page(systems, ctx), linux_distros_page(linux_distros, ctx)]
  let linux_methods = dict.get(methods, Linux) |> result.unwrap([])

  dict.fold(methods, pages, fn(pages, system, methods) {
    system_pages(pages, system, methods, linux_methods, ctx)
  })
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
  let item = case step {
    GleamStep -> "Gleam"
    ErlangStep -> "Erlang"
    EditorStep -> "Gleam editor support"
  }
  let path = method_selection_path(step, system)
  let meta =
    page.PageMeta(
      path:,
      title: "Installing " <> item <> " on " <> name,
      meta_title: "Installing " <> item <> " on " <> name,
      subtitle: "What method would you like to use?",
      description: "Documentation on installation methods you can use to install "
        <> item,
      preload_images: [],
      preview_image: option.None,
    )

  let methods =
    list.filter(methods, fn(method) {
      case step, method.installs {
        GleamStep, InstallsGleam -> True
        GleamStep, InstallsGleamAndErlang -> True
        ErlangStep, InstallsErlang -> True
        EditorStep, _ -> False
        _, _ -> False
      }
    })

  let method_html = fn(method: InstallationMethod) {
    let path = method_path(step, system, method)
    html.li([], [
      html.a([attribute.href(path)], [html.text(method.name)]),
    ])
  }

  [
    html.ul([], list.map(methods, method_html)),
  ]
  |> page.page_layout("", meta, ctx)
  |> page.to_html_file(meta)
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

fn linux_distros_page(
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

  let li = fn(name, href) {
    html.li([], [
      html.a([attribute.href(href)], [html.text(name)]),
    ])
  }
  let distro_html = fn(distro) {
    li(
      linux_distro_name(distro),
      method_selection_path(GleamStep, LinuxDistro(distro)),
    )
  }

  [
    html.ul([], [
      li("Any other Linux", method_selection_path(GleamStep, Linux)),
      ..list.map(distros, distro_html)
    ]),
  ]
  |> page.page_layout("", meta, ctx)
  |> page.to_html_file(meta)
}

fn start_page(systems: List(OperatingSystem), ctx: site.Context) -> fs.File {
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
    let path = operating_system_path(system)
    html.li([], [
      html.a([attribute.href(path)], [html.text(operating_system_name(system))]),
    ])
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
