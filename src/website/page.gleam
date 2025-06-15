import contour
import gleam/int
import gleam/list
import gleam/option
import gleam/string
import gleam/time/calendar
import gleam/time/timestamp
import just/highlight as just
import lustre/attribute.{attribute as attr, class} as attr
import lustre/element.{type Element}
import lustre/element/html
import website/fs
import website/news
import website/site
import website/sponsor

pub type PageMeta {
  PageMeta(
    path: String,
    title: String,
    description: String,
    preload_images: List(String),
  )
}

pub fn redirect_to_tour(from: String, to: String) -> fs.File {
  let to = "https://tour.gleam.run/" <> to
  redirect(from, to)
}

pub fn redirect(from: String, to: String) -> fs.File {
  let content =
    html.body([], [
      html.text("You are being redirected to "),
      html.a([attr.href(to)], [html.text(to)]),
      html.script([], "window.location = \"" <> to <> "\";"),
    ])
    |> element.to_document_string
  fs.File(path: from, content:)
}

pub fn news_post(post: news.NewsPost, ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "news/" <> post.path,
      title: post.title,
      description: post.subtitle,
      preload_images: [],
    )

  [
    html.div([class("post")], [
      html.div([class("post-meta")], [
        html.a([attr.href("/news"), class("meta-button back-button")], [
          html.img([
            attr.width(20),
            attr.src("/images/return-icon.svg"),
            attr.alt("Return Icon"),
          ]),
        ]),
        html.p([class("post-authored")], [
          html.time([], [html.text(short_human_date(post.published))]),
          html.text(" by "),
          html.a([attr.href(post.author.url)], [html.text(post.author.name)]),
        ]),
        html.button(
          [
            attr(
              "onclick",
              "window.navigator.clipboard.writeText('https://gleam.run/news/"
                <> post.path
                <> "')",
            ),
            class("meta-button share-button"),
          ],
          [
            html.img([
              attr.width(20),
              attr.src("/images/share-icon.svg"),
              attr.alt("Return Icon"),
            ]),
            html.text("Share"),
          ],
        ),
      ]),
      html.article(
        [class("prose"), attr("dangerous-unescaped-html", post.content)],
        [],
      ),
    ]),
  ]
  |> page_layout("", meta, ctx)
  |> to_html_file(meta)
}

pub fn installing(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "getting-started/installing",
      title: "Installing Gleam",
      description: "Get ready to start making things",
      preload_images: [],
    )

  [
    html.p([], [
      html.text(
        "To prepare your computer for Gleam development you’ll need to install Gleam,
Erlang, and optionally install any Gleam plugins
for your editor.",
      ),
    ]),
    html.ul([], [
      html.li([], [
        html.a([attr.href("#installing-gleam")], [html.text("Installing Gleam")]),
      ]),
      html.li([], [
        html.a([attr.href("#installing-erlang")], [
          html.text("Installing Erlang"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#installing-rebar3")], [
          html.text("Installing Rebar3"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#editor-plugins")], [html.text("Editor Plugins")]),
      ]),
    ]),
    html.h2([attr.id("installing-gleam")], [html.text("Installing Gleam")]),
    html.h3([attr.id("precompiled-for-amd64-linux-windows-and-macos")], [
      html.text("Precompiled for Linux, Windows, and macOS"),
    ]),
    html.p([], [
      html.text(
        "The easiest way to install Gleam on Linux, Windows, and Apple macOS is to download a prebuilt version of the compiler from the ",
      ),
      html.a([attr.href("https://github.com/gleam-lang/gleam/releases")], [
        html.text("GitHub release page"),
      ]),
      html.text("."),
    ]),
    html.h3([attr.id("macos")], [html.text("macOS")]),
    html.h4([attr.id("using-homebrew")], [html.text("Using Homebrew")]),
    html.p([], [
      html.text("With "),
      html.a([attr.href("https://brew.sh")], [html.text("Homebrew")]),
      html.text(" installed run the following:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "brew update
brew install gleam
",
        ),
      ]),
    ]),
    html.h4([attr.id("using-macports")], [html.text("Using MacPorts")]),
    html.p([], [
      html.text("With "),
      html.a([attr.href("https://www.macports.org/")], [html.text("MacPorts")]),
      html.text(" installed run the following:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "sudo port install gleam
",
        ),
      ]),
    ]),
    html.h3([attr.id("linux")], [html.text("Linux")]),
    html.h4([attr.id("using-homebrew-1")], [html.text("Using Homebrew")]),
    html.p([], [
      html.text("With "),
      html.a([attr.href("https://brew.sh")], [html.text("Homebrew")]),
      html.text(" installed run the following:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "brew update
brew install gleam
",
        ),
      ]),
    ]),
    html.h4([attr.id("asdf-version-manager")], [
      html.text("asdf version manager"),
    ]),
    html.p([], [
      html.a([attr.href("https://github.com/asdf-vm/asdf")], [html.text("asdf")]),
      html.text(
        " is a tool for installing and managing
multiple versions of programming languages at the same time. Install the
",
      ),
      html.a([attr.href("https://github.com/vic/asdf-gleam")], [
        html.text("asdf-gleam plugin"),
      ]),
      html.text(
        " to manage Gleam with
asdf.",
      ),
    ]),
    html.h4([attr.id("alpine-linux")], [html.text("Alpine Linux")]),
    html.p([], [
      html.text(
        "Gleam is available in the Community repository of Alpine Linux as a package ",
      ),
      html.code([], [html.text("gleam")]),
      html.text(". Install it with:"),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "apk add gleam
",
        ),
      ]),
    ]),
    html.h4([attr.id("arch-linux")], [html.text("Arch Linux")]),
    html.p([], [
      html.text("Gleam is available through the "),
      html.a(
        [attr.href("https://wiki.archlinux.org/index.php/Arch_User_Repository")],
        [html.text("Arch User Repository")],
      ),
      html.text(" as package "),
      html.code([], [html.text("gleam")]),
      html.text(". You can use your preferred "),
      html.a([attr.href("https://wiki.archlinux.org/index.php/AUR_helpers")], [
        html.text("helper"),
      ]),
      html.text(" to install it or clone it for manual build from "),
      html.a([attr.href("https://aur.archlinux.org/packages/gleam-git")], [
        html.text("https://aur.archlinux.org/packages/gleam-git"),
      ]),
      html.text("."),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "yay -S gleam
",
        ),
      ]),
    ]),
    html.h4([attr.id("gentoo-linux")], [html.text("Gentoo Linux")]),
    html.p([], [
      html.text(
        "Gleam is available in the official package manager, but may need to be unmasked. Install it with:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "sudo echo \"dev-lang/gleam ~amd64\" >> /etc/portage/package.accept_keywords
emerge --ask dev-lang/gleam
",
        ),
      ]),
    ]),
    html.h4([attr.id("void-linux")], [html.text("Void Linux")]),
    html.p([], [
      html.text(
        "Gleam is available as part of the official packages repository. Install it with:",
      ),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "sudo xbps-install gleam
",
        ),
      ]),
    ]),
    html.h4([attr.id("fedora")], [html.text("Fedora")]),
    html.p([], [
      html.text(
        "You can install Gleam on Fedora using the DNF package manager. Run the following command:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "sudo dnf copr enable frostyx/gleam
sudo dnf install gleam
",
        ),
      ]),
    ]),
    html.h3([attr.id("freebsd")], [html.text("FreeBSD")]),
    html.p([], [
      html.text(
        "Gleam is available in ports, and also in binary packages. You may need
to use the ",
      ),
      html.code([], [html.text("latest")]),
      html.text(" package repo, amend per instructions in "),
      html.code([], [html.text("/etc/pkg/FreeBSD.conf")]),
      html.text(
        ". See below for adjusting your PATH to use latest
Erlang/OTP runtime and not just the standard OTP21:",
      ),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "$ pkg install -r FreeBSD lang/gleam lang/erlang-runtime23
$ export PATH=/usr/local/lib/erlang23/bin:$PATH
",
        ),
      ]),
    ]),
    html.h3([attr.id("openbsd")], [html.text("OpenBSD")]),
    html.p([], [
      html.text(
        "Gleam is available as a binary package. You can install it with:",
      ),
    ]),
    html.pre([], [html.code([], [html.text("doas pkg_add gleam")])]),
    html.h3([attr.id("opensuse")], [html.text("openSUSE")]),
    html.p([], [
      html.text(
        "Gleam is available as part of the official packages repository. Install it with:",
      ),
    ]),
    html.pre([], [html.code([], [html.text("zypper install gleam")])]),
    html.h3([attr.id("android")], [html.text("Android")]),
    html.h4([attr.id("termux")], [html.text("Termux")]),
    html.p([], [
      html.text(
        "Gleam is available as part of the official packages repository. Install it with:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "pkg install gleam
",
        ),
      ]),
    ]),
    html.h3([attr.id("windows")], [html.text("Windows")]),
    html.h4([attr.id("using-scoop")], [html.text("Using Scoop")]),
    html.p([], [
      html.text("With "),
      html.a([attr.href("https://scoop.sh/")], [html.text("Scoop")]),
      html.text(" installed on your computer run the following:"),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "scoop install gleam
",
        ),
      ]),
    ]),
    html.h3([attr.id("build-from-source")], [html.text("Build from source")]),
    html.p([], [
      html.text(
        "The compiler is written in the Rust programming language and so if you wish to
build Gleam from source you will need to ",
      ),
      html.a([attr.href("https://www.rust-lang.org/tools/install")], [
        html.text(
          "install the Rust
compiler",
        ),
      ]),
      html.text("."),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "# Download the Gleam source code git repository
cd /tmp
git clone https://github.com/gleam-lang/gleam.git --branch $THE_LATEST_VERSION
cd gleam

# Build the Gleam compiler. This will take some time!
make install

# Verify the compiler is installed
# Prints \"gleam $VERSION\"
gleam --version
",
        ),
      ]),
    ]),
    html.h2([attr.id("installing-erlang")], [html.text("Installing Erlang")]),
    html.p([], [
      html.text(
        "Gleam compiles to Erlang code, so Erlang needs to be installed to run Gleam
code. Some of the above package managers (e.g. Homebrew) will install Erlang
alongside Gleam automatically.",
      ),
    ]),
    html.p([], [
      html.text(
        "Precompiled builds for many popular operating systems can be downloaded from
the ",
      ),
      html.a(
        [attr.href("https://www.erlang-solutions.com/resources/download.html")],
        [html.text("Erlang solutions website")],
      ),
      html.text("."),
    ]),
    html.p([], [
      html.text(
        "Once Erlang has been installed you can check it is working by typing ",
      ),
      html.code([], [
        html.text(
          "erl
-version",
        ),
      ]),
      html.text(
        " in your computer’s terminal. You will see version information like this if all is well:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-shell")], [
        html.text(
          "erl -version
Erlang (SMP,ASYNC_THREADS) (BEAM) emulator version 12.1.5",
        ),
      ]),
    ]),
    html.h3([attr.id("linux-1")], [html.text("Linux")]),
    html.h4([attr.id("using-homebrew-2")], [html.text("Using Homebrew")]),
    html.p([], [
      html.a([attr.href("https://brew.sh")], [html.text("Homebrew")]),
      html.text(
        " will install Erlang alongside Gleam automatically, though it can be manually installed by running the following:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "brew update
brew install erlang",
        ),
      ]),
    ]),
    html.h4([attr.id("alpine-linux-community-repository")], [
      html.text("Alpine Linux (Community repository)"),
    ]),
    html.pre([], [
      html.code([attr.class("language-shell")], [
        html.text(
          "apk add erlang
",
        ),
      ]),
    ]),
    html.h4([attr.id("arch-linux-community-repository")], [
      html.text("Arch Linux (Community repository)"),
    ]),
    html.pre([], [
      html.code([attr.class("language-shell")], [
        html.text(
          "pacman -S erlang
",
        ),
      ]),
    ]),
    html.h4(
      [
        attr.id(
          "gentoo-linux-already-installed-after-installing-gleam-through-emerge",
        ),
      ],
      [
        html.text(
          "Gentoo Linux (already installed after installing gleam through emerge)",
        ),
      ],
    ),
    html.pre([], [
      html.code([attr.class("language-shell")], [
        html.text(
          "emerge --ask dev-lang/erlang
",
        ),
      ]),
    ]),
    html.h4([attr.id("fedora-1")], [html.text("Fedora")]),
    html.pre([], [
      html.code([attr.class("language-shell")], [
        html.text(
          "dnf install elixir erlang
",
        ),
      ]),
    ]),
    html.h4([attr.id("debian-ubuntu")], [html.text("Debian, Ubuntu")]),
    html.div([], [html.text("Add Erlang Solutions repo key:")]),
    highlighted_shell_pre_code(
      "wget -qO- https://binaries2.erlang-solutions.com/GPG-KEY-pmanager.asc | sudo tee /etc/apt/keyrings/erlang.asc",
    ),
    html.div([], [html.text("We are about to add APT source line in form of:")]),
    html.pre([], [
      html.code([], [
        html.text(
          "deb [signed-by=/etc/apt/keyrings/erlang.asc] http://binaries2.erlang-solutions.com/ubuntu/ $DIST contrib",
        ),
      ]),
    ]),
    html.p([], [
      html.text("We need to determine "),
      html.code([], [html.text("$DIST")]),
      html.text(" first, based on our distro codename (found via "),
      html.code([], [html.text("lsb_release -c")]),
      html.text(" ). Go to "),
      html.a([attr.href("https://binaries2.erlang-solutions.com/")], [
        html.text("binaries2.erlang-solutions.com"),
      ]),
      html.text(", then click to \"debian\" or \"ubuntu\", then \"dist\". "),
      html.text(
        "We will see directories like \"stretch-esl-erlang-27\", \"noble-esl-erlang-27\". Pick one corresponding to our Debian/Ubuntu version and replace ",
      ),
      html.code([], [html.text("$DIST")]),
      html.text(" with it."),
    ]),
    highlighted_shell_pre_code(
      "# Add as APT source
echo 'deb [signed-by=/etc/apt/keyrings/erlang.asc] http://binaries2.erlang-solutions.com/ubuntu/ $DIST contrib' | sudo tee /etc/apt/sources.list.d/erlang.list

# Update apt and install esl-erlang
sudo apt update
sudo apt install esl-erlang
",
    ),
    html.h3([attr.id("macos-1")], [html.text("macOS")]),
    html.h4([attr.id("using-homebrew-3")], [html.text("Using Homebrew")]),
    html.p([], [
      html.a([attr.href("https://brew.sh")], [html.text("Homebrew")]),
      html.text(
        " will install Erlang alongside Gleam automatically,
though it can be manually installed by running the following:",
      ),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "brew update
brew install erlang
",
        ),
      ]),
    ]),
    html.h4([attr.id("using-macports-1")], [html.text("Using MacPorts")]),
    html.p([], [
      html.text("With "),
      html.a([attr.href("https://www.macports.org/")], [html.text("MacPorts")]),
      html.text(" installed run the following:"),
    ]),
    html.pre([], [
      html.code([attr.class("language-sh")], [
        html.text(
          "sudo port install erlang
",
        ),
      ]),
    ]),
    html.h3([attr.id("windows-1")], [html.text("Windows")]),
    html.h4([attr.id("using-chocolatey")], [html.text("Using Chocolatey")]),
    html.p([], [
      html.text("With "),
      html.a([attr.href("https://chocolatey.org/")], [html.text("Chocolatey")]),
      html.text(" installed on your computer run the following:"),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "choco install erlang
",
        ),
      ]),
    ]),
    html.h4([attr.id("using-scoop-1")], [html.text("Using Scoop")]),
    html.p([], [
      html.text("With "),
      html.a([attr.href("https://scoop.sh/")], [html.text("Scoop")]),
      html.text(" installed on your computer run the following:"),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "scoop install erlang
",
        ),
      ]),
    ]),
    html.h3([attr.id("using-version-managers")], [
      html.text("Using version managers"),
    ]),
    html.h4([attr.id("asdf")], [html.text("asdf")]),
    html.p([], [
      html.text(
        "The asdf version manager has a plugin for installing Erlang. Installation and
usage instructions can be found here:",
      ),
    ]),
    html.ul([], [
      html.li([], [
        html.a([attr.href("https://github.com/asdf-vm/asdf")], [
          html.text("https://github.com/asdf-vm/asdf"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("https://github.com/asdf-vm/asdf-erlang")], [
          html.text("https://github.com/asdf-vm/asdf-erlang"),
        ]),
      ]),
    ]),
    html.h2([attr.id("installing-rebar3")], [html.text("Installing rebar3")]),
    html.p([], [
      html.text(
        "When using Erlang based dependencies (such as their web servers and HTTP clients)
the rebar3 Erlang build tool may need to be installed.
Install rebar3 by following the ",
      ),
      html.a([attr.href("https://rebar3.org/docs/getting-started/")], [
        html.text(
          "official rebar3 installation
instructions",
        ),
      ]),
      html.text("."),
    ]),
    html.h2([attr.id("editor-plugins")], [html.text("Editor Plugins")]),
    html.p([], [
      html.text(
        "Gleam plugins are available for several popular editors. If one exists for
your editor of choice consider installing it for syntax highlighting and other
niceties.",
      ),
    ]),
    html.ul([], [
      html.li([], [
        html.strong([], [html.text("Vim")]),
        html.text("- "),
        html.a([attr.href("https://github.com/gleam-lang/gleam.vim")], [
          html.text("https://github.com/gleam-lang/gleam.vim"),
        ]),
      ]),
      html.li([], [
        html.strong([], [html.text("Emacs")]),
        html.text("- "),
        html.a([attr.href("https://github.com/gleam-lang/gleam-mode")], [
          html.text("https://github.com/gleam-lang/gleam-mode"),
        ]),
      ]),
      html.li([], [
        html.strong([], [html.text("Visual Studio Code")]),
        html.text("- "),
        html.a([attr.href("https://github.com/gleam-lang/vscode-gleam")], [
          html.text("https://github.com/gleam-lang/vscode-gleam"),
        ]),
      ]),
      html.li([], [
        html.strong([], [html.text("Sublime Text")]),
        html.text("- "),
        html.a(
          [attr.href("https://github.com/digitalcora/sublime-text-gleam")],
          [html.text("https://github.com/digitalcora/sublime-text-gleam")],
        ),
      ]),
      html.li([], [
        html.strong([], [html.text("Atom")]),
        html.text("- "),
        html.a([attr.href("https://github.com/itsgreggreg/language-gleam")], [
          html.text("https://github.com/itsgreggreg/language-gleam"),
        ]),
      ]),
      html.li([], [
        html.strong([], [html.text("Gedit")]),
        html.text("- "),
        html.a([attr.href("https://github.com/DannyLettuce/gleam_gedit")], [
          html.text("https://github.com/DannyLettuce/gleam_gedit"),
        ]),
      ]),
    ]),
    html.h2([attr.id("what-next")], [html.text("What next?")]),
    html.p([], [
      html.text("Now you have installed Gleam check out the "),
      html.a([attr.href("/book/tour")], [html.text("Language Tour")]),
      html.text(" for an overview of the Gleam language."),
    ]),
  ]
  |> page_layout("", meta, ctx)
  |> to_html_file(meta)
}

pub fn deployment_flyio(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "deployment/fly",
      title: "Deploying on Fly.io",
      description: "Run Gleam all over the world. No ops required.",
      preload_images: [],
    )

  [
    html.p([], [
      html.a([attr.href("https://fly.io")], [html.text("Fly.io")]),
      html.text(
        " is a convenient and easy to use deployment platform. They were also a
sponsor of the Gleam project, thank you Fly!",
      ),
    ]),
    html.h2([attr.id("prepare-your-application")], [
      html.text("Prepare your application"),
    ]),
    html.p([], [
      html.text("Ensure your application is listening on "),
      html.code([], [html.text("0.0.0.0")]),
      html.text(". If you’re using Mist or Wisp you can do this with the "),
      html.code([], [html.text("mist.bind")]),
      html.text(" function, as shown here."),
    ]),
    highlighted_gleam_pre_code(
      "  let assert Ok(_) =
    wisp_mist.handler(handle_request, secret_key_base)
    |> mist.new
    |> mist.bind(\"0.0.0.0\") // <- add this line
    |> mist.port(8000)
    |> mist.start_http
",
    ),
    html.p([], [
      html.text(
        "Take note of what port your application is starting on. We will be using port
8000 for the rest of this guide.",
      ),
    ]),
    html.h2([attr.id("add-a-dockerfile")], [html.text("Add a Dockerfile")]),
    html.p([], [
      html.text(
        "We can use Fly’s support for containers to build the application and prepare it
for deployment.",
      ),
    ]),
    html.p([], [
      html.text("Add a file named "),
      html.code([], [html.text("Dockerfile")]),
      html.text(" with these contents:"),
    ]),
    highlighted_dockerfile_pre_code(
      "FROM erlang:27.1.1.0-alpine AS build
COPY --from=ghcr.io/gleam-lang/gleam:v1.8.0-erlang-alpine /bin/gleam /bin/gleam
COPY . /app/
RUN cd /app && gleam export erlang-shipment

FROM erlang:27.1.1.0-alpine
RUN \\
  addgroup --system webapp && \\
  adduser --system webapp -g webapp
COPY --from=build /app/build/erlang-shipment /app
WORKDIR /app
ENTRYPOINT [\"/app/entrypoint.sh\"]
CMD [\"run\"]
",
    ),
    html.h2([attr.id("set-up-the-flyio-cli")], [
      html.text("Set up the Fly.io CLI"),
    ]),
    html.p([], [
      html.text("Follow the instructions "),
      html.a(
        [attr.href("https://fly.io/docs/getting-started/installing-flyctl/")],
        [html.text("here")],
      ),
      html.text(
        " to install Flyctl, the command-line interface for the Fly.io platform.",
      ),
    ]),
    html.p([], [
      html.text(
        "Once installed use the CLI to sign up (or log in if you already have a Fly.io account).",
      ),
    ]),
    highlighted_shell_pre_code(
      "fly auth signup
# OR
fly auth login
",
    ),
    html.h2([attr.id("deploy-the-application")], [
      html.text("Deploy the application"),
    ]),
    html.p([], [
      html.text(
        "From within the project use the Fly CLI to create and run your application on
their platform.",
      ),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "flyctl launch
",
        ),
      ]),
    ]),
    html.p([], [html.text("The CLI will ask you a series of questions:")]),
    html.ul([], [
      html.li([], [html.text("What the application should be named.")]),
      html.li([], [
        html.text("What Fly organisation should the application belong to."),
      ]),
      html.li([], [
        html.text("What region the application should be deployed to."),
      ]),
      html.li([], [
        html.text(
          "Whether you would like a PostgreSQL database to go with the application.",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Once you have answered these it will build the application using the docker
file. Once deployed you can open it in a web browser by running ",
      ),
      html.code([], [html.text("flyctl open")]),
      html.text("."),
    ]),
    html.p([], [
      html.text("To deploy future versions of the application run "),
      html.code([], [html.text("flyctl deploy")]),
      html.text(" after saving any changes to the source code."),
    ]),
  ]
  |> page_layout("", meta, ctx)
  |> to_html_file(meta)
}

pub fn writing_gleam(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "writing-gleam",
      title: "Writing Gleam",
      description: "Learn to work with Gleam projects",
      preload_images: [],
    )

  [
    html.p([], [
      html.text(
        "This guide shows you how to create and develop a Gleam project.",
      ),
    ]),
    html.p([], [
      html.text("It does not teach the Gleam language itself, so read through "),
      html.a([attr.href("https://tour.gleam.run/")], [
        html.text("the language tour"),
      ]),
      html.text(
        " first if you have not already. You are assumed to already have Gleam and Erlang
installed, so head over to ",
      ),
      html.a([attr.href("/getting-started/installing/")], [
        html.text("the install guide"),
      ]),
      html.text(" if you do not have Gleam installed."),
    ]),
    html.p([], [html.text("Ready? Let’s go!")]),
    html.h2([attr.id("the-project")], [html.text("The project")]),
    html.p([], [
      html.text(
        "In this guide we’re going to make a small command line program for printing
environment variables.",
      ),
    ]),
    html.p([], [html.text("In use it’ll look like this:")]),
    highlighted_shell_pre_code(
      "gleam run get USER
# USER=lucy
",
    ),
    html.h2([attr.id("creating-a-project")], [html.text("Creating a project")]),
    html.p([], [
      html.text("Gleam’s build tool is built into the "),
      html.code([], [html.text("gleam")]),
      html.text(
        " program you installed earlier. It
supports creating new projects, building, testing, and running them, along with
managing dependencies from the ",
      ),
      html.a([attr.href("https://hex.pm/")], [html.text("Hex package manager")]),
      html.text("."),
    ]),
    html.p([], [
      html.text("First create a new Gleam project by running the "),
      html.code([], [html.text("gleam new")]),
      html.text(" command in a terminal. I’m going to call mine "),
      html.code([], [html.text("vars")]),
      html.text("."),
    ]),
    highlighted_shell_pre_code(
      "# Create the project
gleam new vars

# Navigate into the project directory
cd vars
",
    ),
    html.p([], [html.text("You’ll now have a project with this structure:")]),
    html.pre([], [
      html.code([], [
        html.text(
          ".
├── .github/workflows/test.yml
├── .gitignore
├── README.md
├── gleam.toml
├── src/vars.gleam
└── test/vars_test.gleam
",
        ),
      ]),
    ]),
    html.ul([], [
      html.li([], [
        html.code([], [html.text("README.md")]),
        html.text(
          " file is where you’d write introductory documentation for your project in markdown format.",
        ),
      ]),
      html.li([], [
        html.code([], [html.text("gleam.toml")]),
        html.text(" file contains the configuration for the project."),
      ]),
      html.li([], [
        html.code([], [html.text("src/")]),
        html.text(" contains the program source."),
      ]),
      html.li([], [
        html.code([], [html.text("test/")]),
        html.text(" contains additional code for testing the project."),
      ]),
      html.li([], [
        html.code([], [html.text(".gitignore")]),
        html.text(" contains configuration for the "),
        html.code([], [html.text("git")]),
        html.text(" version control system."),
      ]),
      html.li([], [
        html.code([], [html.text(".github/workflows/test.yml")]),
        html.text(" defines a "),
        html.a([attr.href("https://github.com/features/actions")], [
          html.text("GitHub Actions"),
        ]),
        html.text(
          " workflow that will run the project’s tests if you push it to a GitHub repository.",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Altogether this is called a Gleam package, regardless of whether it’s a library
or a program that is run directly.",
      ),
    ]),
    html.h2([attr.id("running-the-project")], [html.text("Running the project")]),
    html.p([], [
      html.text("The entrypoint for the program is the function called "),
      html.code([], [html.text("main")]),
      html.text(" in the module with the same name as the package itself. "),
      html.code([], [html.text("gleam new")]),
      html.text(" will have generated one for you that looks like this:"),
    ]),
    highlighted_gleam_pre_code(
      "// In src/vars.gleam
import gleam/io

pub fn main() {
  io.println(\"Hello from vars!\")
}
",
    ),
    html.p([], [
      html.text("In the terminal run this command to run the project."),
    ]),
    highlighted_shell_pre_code(
      "gleam run
",
    ),
    html.p([], [
      html.text(
        "The Gleam build tool will then download the dependencies (here the standard
library and a test runner), compile all the code, and then run the ",
      ),
      html.code([], [html.text("main")]),
      html.text(" function to print “Hello from vars!” to the terminal."),
    ]),
    html.p([], [
      html.text(
        "If you wanted to run a different module in your package, or a module from a
dependency, you could run ",
      ),
      html.code([], [html.text("gleam run -m modulename")]),
      html.text("."),
    ]),
    html.p([], [
      html.text("You can run "),
      html.code([], [html.text("gleam run --target javascript")]),
      html.text(
        " to run the project on a JavaScript runtime instead of Erlang, though for the rest of this guide we’ll continue with Erlang.",
      ),
    ]),
    html.h2([attr.id("adding-dependencies")], [html.text("Adding dependencies")]),
    html.p([], [
      html.text(
        "Gleam can run in constrained environments like embedded systems or browsers, so
some functionality is not included in the standard library, such as reading
command line inputs and environment variables. For our program to do these we’ll
need to add some dependencies that provide this functionality.",
      ),
    ]),
    html.p([], [
      html.text("The "),
      html.a([attr.href("https://packages.gleam.run/")], [
        html.text("Gleam Package Index"),
      ]),
      html.text(" can be used to find packages. In this case we want to use "),
      html.a([attr.href("https://hexdocs.pm/envoy/")], [html.text("envoy")]),
      html.text(" for environment variables and "),
      html.a([attr.href("https://hexdocs.pm/argv/")], [html.text("argv")]),
      html.text(
        " for reading command line input. Add them to your package with this command:",
      ),
    ]),
    highlighted_shell_pre_code(
      "gleam add envoy argv
",
    ),
    html.p([], [
      html.text("If you look at the "),
      html.code([], [html.text("gleam.toml")]),
      html.text(
        " file you’ll see that the dependencies have been added to the ",
      ),
      html.code([], [html.text("[dependencies]")]),
      html.text(" section."),
    ]),
    highlighted_toml_pre_code(
      "name = \"vars\"
version = \"1.0.0\"

[dependencies]
gleam_stdlib = \">= 0.34.0 and < 2.0.0\"
envoy = \">= 1.0.1 and < 2.0.0\"
argv = \">= 1.0.2 and < 2.0.0\"

[dev-dependencies]
gleeunit = \">= 1.0.0 and < 2.0.0\"
",
    ),
    html.p([], [
      html.text("The "),
      html.code([], [html.text(">= 1.0.1 and < 2.0.0")]),
      html.text(
        " version constraint means that the project wants any version
greater than or equal to 1.0.1, but less than 2.0.0, which will maximise compatibility while
avoiding breaking changes as Hex packages adhere to ",
      ),
      html.a([attr.href("https://semver.org/")], [
        html.text("semantic versioning"),
      ]),
      html.text("."),
    ]),
    html.p([], [
      html.text("There is now also a "),
      html.code([], [html.text("manifest.toml")]),
      html.text(
        " file which locks all the dependency packages
to specific versions. It’s recommended to check this file into your version
control system to ensure that anyone who downloads and runs your project will
get the same versions of the dependencies. This manifest file isn’t uploaded to
Hex so it is not used when other projects depend on your project.",
      ),
    ]),
    html.p([], [
      html.text(
        "If you wish to update the dependencies to the latest versions that are
compatible with your version constraints you can run ",
      ),
      html.code([], [html.text("gleam update")]),
      html.text("."),
    ]),
    html.p([], [
      html.text(
        "You can also use path dependencies to depend on packages on your computer rather than from Hex.",
      ),
    ]),
    highlighted_toml_pre_code(
      "[dependencies]
my_other_package = { path = \"../my_other_package\" }
",
    ),
    html.p([], [html.text("As well as git dependencies.")]),
    highlighted_toml_pre_code(
      "[dependencies]
my_git_library = { git = \"git@github.com:my-project/my-library\", ref = \"a8b3c5d82\" }
latest_stdlib = { git = \"git@github.com:gleam-lang/stdlib\", ref = \"main\" }
",
    ),
    html.p([], [
      html.text("See: "),
      html.a([attr.href("https://gleam.run/writing-gleam/gleam-toml")], [
        html.text("gleam.toml"),
      ]),
      html.text(" definition for more information."),
    ]),
    html.h2([attr.id("using-dependencies")], [html.text("Using dependencies")]),
    html.p([], [
      html.text("The "),
      html.code([], [html.text("argv")]),
      html.text(
        " module from the package of the same name exports a function called ",
      ),
      html.code([], [html.text("load")]),
      html.text(
        " that can be used to read the command line arguments. Update the code in ",
      ),
      html.code([], [html.text("src/vars.gleam")]),
      html.text(" to use this function."),
    ]),
    highlighted_gleam_pre_code(
      "import argv
import envoy
import gleam/io
import gleam/result

pub fn main() {
  case argv.load().arguments {
    [\"get\", name] -> get(name)
    _ -> io.println(\"Usage: vars get <name>\")
  }
}

fn get(name: String) -> Nil {
  let value = envoy.get(name) |> result.unwrap(\"\")
  io.println(format_pair(name, value))
}

fn format_pair(name: String, value: String) -> String {
  name <> \"=\" <> value
}
",
    ),
    html.p([], [
      html.text("Pattern matching is being used to call the "),
      html.code([], [html.text("get")]),
      html.text(
        " function or print a help message based on the command line arguments.",
      ),
    ]),
    html.p([], [
      html.text("The "),
      html.code([], [html.text("get")]),
      html.text("function uses the "),
      html.code([], [html.text("envoy")]),
      html.text(
        " module from the package of the same name to
read the environment variable and print it or a message if it doesn’t exist. A
helper function ",
      ),
      html.code([], [html.text("format_pair")]),
      html.text(" is used to format the output."),
    ]),
    html.p([], [
      html.text("Give it a try! Run "),
      html.code([], [html.text("gleam run get TERM")]),
      html.text(" in the terminal to recompile and run the program."),
    ]),
    html.h2([attr.id("testing-your-code")], [html.text("Testing your code")]),
    html.p([], [
      html.text(
        "This program is so small that you likely don’t need to write any tests for it,
but for the sake of demonstration let’s write some for the ",
      ),
      html.code([], [html.text("format_pair")]),
      html.text(" function."),
    ]),
    html.p([], [
      html.text("To call the "),
      html.code([], [html.text("format_pair")]),
      html.text(" function from a module in the "),
      html.code([], [html.text("test/")]),
      html.text(
        " directory we will need to make it public. We don’t want it to be part of the public API of the package, so we’ll move it to an ",
      ),
      html.em([], [html.text("internal module")]),
      html.text(
        ", which by default are modules
named ",
      ),
      html.code([], [html.text("packagename/internal")]),
      html.text(" and "),
      html.code([], [html.text("packagename/internal/*")]),
      html.text("."),
    ]),
    html.p([], [
      html.text(
        "Public functions in these modules can be imported by other modules, but they’re
considered to be part of the package’s internal implementation and as such are
not documented or expected to give the same stability guarantees as functions in
the public API.",
      ),
    ]),
    highlighted_gleam_pre_code(
      "// in src/vars.gleam
import argv
import envoy
import gleam/io
import gleam/result
import vars/internal

pub fn main() {
  // Omitted for brevity
}

fn get(name: String) -> Nil {
  let value = envoy.get(name) |> result.unwrap(\"\")
  io.println(internal.format_pair(name, value))
}
",
    ),
    highlighted_gleam_pre_code(
      "// in src/vars/internal.gleam
pub fn format_pair(name: String, value: String) -> String {
  name <> \"=\" <> value
}
",
    ),
    html.p([], [
      html.text("Open up the "),
      html.code([], [html.text("test/vars_test.gleam")]),
      html.text(" file and write a test for the "),
      html.code([], [html.text("format_pair")]),
      html.text("."),
    ]),
    highlighted_gleam_pre_code(
      "// in test/vars_test.gleam
import gleeunit
import gleeunit/should
import vars/internal

pub fn main() {
  gleeunit.main()
}

pub fn format_pair_test() {
  let greeting = internal.format_pair(\"hello\", \"world\")
  assert greeting == \"hello=world\"
}
",
    ),
    html.p([], [
      html.text("Running "),
      html.code([], [html.text("gleam test")]),
      html.text(" will call the "),
      html.code([], [html.text("main")]),
      html.text(" function in "),
      html.code([], [html.text("vars_test")]),
      html.text(
        ", which will in
turn run the tests.",
      ),
    ]),
    html.p([], [
      html.text("Your test "),
      html.code([], [html.text("main")]),
      html.text(
        " function can do anything you like, but by default Gleam projects are generated using ",
      ),
      html.a([attr.href("https://hexdocs.pm/gleeunit/")], [
        html.code([], [html.text("gleeunit")]),
      ]),
      html.text(", a simple test runner. With it any public function in the "),
      html.code([], [html.text("test/")]),
      html.text(" directory with a name ending in "),
      html.code([], [html.text("_test")]),
      html.text("will be run as a test."),
    ]),
    html.h2([attr.id("sharing-your-program")], [
      html.text("Sharing your program"),
    ]),
    html.p([], [
      html.text(
        "If your program is a web application that runs on a server you may now wish to
view the ",
      ),
      html.a([attr.href("/documentation/#deployment")], [
        html.text("deployment section"),
      ]),
      html.text(
        " of Gleam’s documentation. The program
we’ve just made is a command line program, so instead we’ll want to bundle it up
into a single file that can be easily shared with others.",
      ),
    ]),
    html.p([], [
      html.text("As we’re using the Erlang target we can do this using "),
      html.em([], [html.text("escript")]),
      html.text(
        ", which is part
of the Erlang runtime. Add the ",
      ),
      html.code([], [html.text("gleescript")]),
      html.text(" package as a dependency."),
    ]),
    highlighted_shell_pre_code(
      "gleam add --dev gleescript
",
    ),
    html.p([], [
      html.text("The "),
      html.code([], [html.text("--dev")]),
      html.text(
        " flag is used to indicate that this package is only used for building,
developing, and testing the project, and should not be included in the final
production builds. The build tool will then add ",
      ),
      html.code([], [html.text("gleescript")]),
      html.text(" to the "),
      html.code([], [html.text("[dev-dependencies]")]),
      html.text(" section rather than the regular "),
      html.code([], [html.text("[dependencies]")]),
      html.text(" section."),
    ]),
    html.p([], [
      html.text("Once added run "),
      html.code([], [html.text("gleam run -m gleescript")]),
      html.text(
        " to compile your package into an escript file, which will be written to ",
      ),
      html.code([], [html.text("./vars")]),
      html.text("."),
    ]),
    highlighted_shell_pre_code(
      "# Compile the program to an escript
gleam build
gleam run -m gleescript

# Run the program
./vars get USER
escript ./vars get USER # On Windows
",
    ),
    html.p([], [
      html.text("This "),
      html.code([], [html.text("vars")]),
      html.text(
        " file can be run on any computer that has a compatible version of
Erlang installed. Typically this will be within a few major versions of the
version of Erlang on the computer used to compile the escript.",
      ),
    ]),
    html.p([], [
      html.text("And that’s it! Get hacking! And do drop by "),
      html.a([attr.href("https://discord.gg/Fm8Pwmy")], [
        html.text("the Gleam Discord server"),
      ]),
      html.text(" to get help or share what you’re working on."),
    ]),
  ]
  |> page_layout("prose", meta, ctx)
  |> to_html_file(meta)
}

pub fn frequently_asked_questions(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "frequently-asked-questions",
      title: "Frequently asked questions",
      description: "What? Why? Where? When? How?",
      preload_images: [],
    )

  [
    html.ul([], [
      html.li([], [
        html.a([attr.href("#why-is-it-called-gleam")], [
          html.text("Why is it called Gleam?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#what-does-gleam-compile-to")], [
          html.text("What does Gleam compile to?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#does-gleam-have-mutable-state")], [
          html.text("Does Gleam have mutable state?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#does-gleam-have-side-effects")], [
          html.text("Does Gleam have side effects?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#will-gleam-have-type-classes")], [
          html.text("Will Gleam have type classes?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#will-gleam-have-metaprogramming")], [
          html.text("Will Gleam have metaprogramming?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#how-is-message-passing-typed")], [
          html.text("How is message passing typed?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#can-gleam-use-erlangs-hot-code-reloading")], [
          html.text("Can Gleam use Erlang’s hot code reloading?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#why-does-division-by-zero-return-zero")], [
          html.text("Why does division by zero return zero?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#how-does-gleam-compare-to")], [
          html.text("How does Gleam compare to…"),
        ]),
        html.ul([], [
          html.li([], [
            html.a([attr.href("#how-does-gleam-compare-to-alpaca")], [
              html.text("Alpaca?"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#how-does-gleam-compare-to-caramel")], [
              html.text("Caramel?"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#how-does-gleam-compare-to-elixir")], [
              html.text("Elixir?"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#how-does-gleam-compare-to-purerl")], [
              html.text("Purerl?"),
            ]),
          ]),
          html.li([], [
            html.a([attr.href("#how-does-gleam-compare-to-rust")], [
              html.text("Rust?"),
            ]),
          ]),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#can-i-use-elixir-code-with-gleam")], [
          html.text("Can I use Elixir code with Gleam?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#why-is-the-compiler-written-in-rust")], [
          html.text("Why is the compiler written in Rust?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#should-i-put-gleam-in-production")], [
          html.text("Should I put Gleam in production?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#what-are-gleam-programmers-called")], [
          html.text("What are Gleam programmers called?"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("#is-it-good")], [html.text("Is it good?")]),
      ]),
    ]),
    html.h2([attr.id("why-is-it-called-gleam")], [
      html.text("Why is it called Gleam?"),
    ]),
    html.p([], [
      html.text(
        "Gleam rhymes with and is a synonym of “beam”, which is the name of the Erlang
virtual machine.",
      ),
    ]),
    html.p([], [
      html.text(
        "It’s also a short and cute word that’s hopefully easy to spell and pronounce
for most people.",
      ),
    ]),
    html.h2([attr.id("what-does-gleam-compile-to")], [
      html.text("What does Gleam compile to?"),
    ]),
    html.p([], [html.text("Gleam compiles to Erlang or JavaScript.")]),
    html.h2([attr.id("will-gleam-have-type-classes")], [
      html.text("Will Gleam have type classes?"),
    ]),
    html.p([], [
      html.text(
        "Type classes are fun and enable creation of very nice, concise APIs, but they can
make it easy to make challenging to understand code, tend to have confusing
error messages, make consuming the code from other languages much harder, have a
high compile time cost, and have a runtime cost unless the compiler performs
full-program compilation and expensive monomorphization. This is unfortunately
not a good fit for Gleam and they are not planned.",
      ),
    ]),
    html.h2([attr.id("will-gleam-have-metaprogramming")], [
      html.text("Will Gleam have metaprogramming?"),
    ]),
    html.p([], [
      html.text(
        "We are open interested in some form of metaprogramming in Gleam so long as it
is not detrimental to Gleam’s readability and fast compilation. If you have
proposal for a metaprogramming design please do share them with us via a ",
      ),
      html.a([attr.href("https://github.com/gleam-lang/gleam/discussions")], [
        html.text(
          "GitHub
discussion",
        ),
      ]),
      html.text("."),
    ]),
    html.h2([attr.id("does-gleam-have-mutable-state")], [
      html.text("Does Gleam have mutable state?"),
    ]),
    html.p([], [
      html.text(
        "All data structures in Gleam are immutable and are implemented using
structural sharing so they can be efficiently updated.",
      ),
    ]),
    html.p([], [
      html.text(
        "If your application needs to hold on to some mutable state then it can be held
by an actor (which immutably wraps mutable state using recursion) or you can
use ETS, the Erlang in-memory key-value database.",
      ),
    ]),
    html.p([], [
      html.text(
        "If you are compiling Gleam to JavaScript the
",
      ),
      html.a(
        [
          attr.href(
            "https://hexdocs.pm/javascript_mutable_reference/index.html",
          ),
        ],
        [html.code([], [html.text("javascript_mutable_reference")])],
      ),
      html.text("library offers mutable references."),
    ]),
    html.h2([attr.id("does-gleam-have-side-effects")], [
      html.text("Does Gleam have side effects?"),
    ]),
    html.p([], [
      html.text(
        "Yes, Gleam is an impure functional language like OCaml or Erlang. Impure
actions like writing to files and printing to the console are possible without
special handling.",
      ),
    ]),
    html.p([], [
      html.text(
        "We may later introduce an effects system for identifying and tracking any
impure code in a Gleam application, though this is still an area of research.",
      ),
    ]),
    html.h2([attr.id("how-is-message-passing-typed")], [
      html.text("How is message passing typed?"),
    ]),
    html.p([], [
      html.text(
        "Type safe message passing is implemented in Gleam as a set of libraries,
rather than being part of the core language itself. This allows us to write safe
concurrent programs that make use of Erlang’s OTP framework while not locking
us in to one specific approach to typing message passing. This lack of lock-in
is important as typing message passing is an area of active research, we may
discover an even better approach at a later date!",
      ),
    ]),
    html.p([], [
      html.text("If you’d like to see more consider checking out "),
      html.a([attr.href("https://github.com/gleam-lang/otp")], [
        html.text(
          "Gleam’s OTP
library",
        ),
      ]),
      html.text("."),
    ]),
    html.h2([attr.id("can-gleam-use-erlangs-hot-code-reloading")], [
      html.text("Can Gleam use Erlang’s hot code reloading?"),
    ]),
    html.p([], [
      html.text(
        "All the usual Erlang code reloading features work, but it is not possible to
type check the upgrades themselves as we have no way knowing the types of the
already running code. This means you would have the usual Erlang amount of
safety rather than what you might have with Gleam otherwise.",
      ),
    ]),
    html.p([], [
      html.text(
        "Generally the OTP libraries for Gleam are optimised for type safety rather than
upgrades, and use records rather than atom modules so the state upgrade
callbacks may be more complex to write.",
      ),
    ]),
    html.h2([attr.id("why-does-division-by-zero-return-zero")], [
      html.text("Why does division by zero return zero?"),
    ]),
    html.p([], [
      html.text(
        "There are three common approaches to handling division by zero in programming
languages:",
      ),
    ]),
    html.ul([], [
      html.li([], [html.text("Throw an exception and crash the program.")]),
      html.li([], [
        html.text("Return a special "),
        html.code([], [html.text("Infinity")]),
        html.text("value."),
      ]),
      html.li([], [
        html.text("Return "),
        html.code([], [html.text("0")]),
        html.text("."),
      ]),
    ]),
    html.p([], [
      html.text(
        "Gleam does not implicitly throw exceptions, so throwing an exception is not
an option. The BEAM VM does not have a ",
      ),
      html.code([], [html.text("Infinity")]),
      html.text(
        "value, so that is not an
option. Therefore Gleam returns ",
      ),
      html.code([], [html.text("0")]),
      html.text("when dividing by zero."),
    ]),
    html.p([], [
      html.text("The standard library provides functions which return a "),
      html.code([], [html.text("Result")]),
      html.text(
        "type for
division by zero which you can use if that is more suitable for your program.",
      ),
    ]),
    html.p([], [
      html.text(
        "For more information on division by zero from a mathematical perspective, see
",
      ),
      html.a([attr.href("https://www.hillelwayne.com/post/divide-by-zero/")], [
        html.text("this article by Hillel Wayne"),
      ]),
      html.text("."),
    ]),
    html.h2([attr.id("how-does-gleam-compare-to-alpaca")], [
      html.text("How does Gleam compare to Alpaca?"),
    ]),
    html.p([], [
      html.a([attr.href("https://github.com/alpaca-lang/alpaca")], [
        html.text("Alpaca"),
      ]),
      html.text(
        "is similar to Gleam in that it is a statically typed language
for the Erlang VM that is inspired by the ML family of languages. It’s a
wonderful project and it was an early inspiration for Gleam!",
      ),
    ]),
    html.p([], [html.text("Here’s a non-exhaustive list of differences:")]),
    html.ul([], [
      html.li([], [
        html.text("Alpaca’s functions are auto-curried, Gleam’s are not."),
      ]),
      html.li([], [
        html.text(
          "Alpaca’s unions can be untagged, with Gleam all variants in a custom type
need a name.",
        ),
      ]),
      html.li([], [
        html.text(
          "Alpaca’s compiler is written in Erlang, Gleam’s is written in Rust.",
        ),
      ]),
      html.li([], [
        html.text(
          "Alpaca’s syntax is closer to ML family languages, Gleam’s is closer to C
family languages.",
        ),
      ]),
      html.li([], [
        html.text(
          "Alpaca compiles to Core Erlang, Gleam compiles to regular Erlang and
optionally JavaScript.",
        ),
      ]),
      html.li([], [
        html.text(
          "Alpaca uses the Erlang build tool, Gleam has its own build tool.",
        ),
      ]),
      html.li([], [
        html.text(
          "Gleam is more actively developed than Alpaca (at time of writing).",
        ),
      ]),
    ]),
    html.h2([attr.id("how-does-gleam-compare-to-caramel")], [
      html.text("How does Gleam compare to Caramel?"),
    ]),
    html.p([], [
      html.a([attr.href("https://github.com/AbstractMachinesLab/caramel")], [
        html.text("Caramel"),
      ]),
      html.text(
        "is similar to Gleam in that it is a statically typed language
for the Erlang VM. It is very cool, especially because of its OCaml heritage!",
      ),
    ]),
    html.p([], [html.text("Here’s a non-exhaustive list of differences:")]),
    html.ul([], [
      html.li([], [
        html.text(
          "Caramel is based off of OCaml and forks the OCaml compiler, Gleam is an
entirely new language, syntax, and compiler.",
        ),
      ]),
      html.li([], [
        html.text("Caramel’s functions are auto-curried, Gleam’s are not."),
      ]),
      html.li([], [
        html.text(
          "Caramel’s compiler is written in OCaml, Gleam’s is written in Rust.",
        ),
      ]),
      html.li([], [
        html.text(
          "Caramel uses OCaml syntax, Gleam has its own syntax that is closer to C
family languages.",
        ),
      ]),
      html.li([], [
        html.text(
          "Gleam is more actively developed than Caramel (at time of writing).",
        ),
      ]),
    ]),
    html.h2([attr.id("how-does-gleam-compare-to-elixir")], [
      html.text("How does Gleam compare to Elixir?"),
    ]),
    html.p([], [
      html.a([attr.href("https://github.com/elixir-lang/elixir")], [
        html.text("Elixir"),
      ]),
      html.text(
        "is another language that runs on the Erlang virtual machine.
It is very popular and a great language!",
      ),
    ]),
    html.p([], [html.text("Here’s a non-exhaustive list of differences:")]),
    html.ul([], [
      html.li([], [
        html.text(
          "Elixir is dynamically typed, Gleam is statically typed. Elixir is integrating a
gradual type system into the language, but it has no user facing features yet.",
        ),
      ]),
      html.li([], [
        html.text(
          "Elixir has a powerful macro system, Gleam has no metaprogramming features.",
        ),
      ]),
      html.li([], [
        html.text(
          "Elixir’s compiler is written in Erlang and Elixir, Gleam’s is written in Rust.",
        ),
      ]),
      html.li([], [
        html.text("Gleam has a more traditional C family style syntax."),
      ]),
      html.li([], [
        html.text(
          "Elixir has a namespace for module functions and another for variables,
Gleam has one unified namespace (so there’s no special ",
        ),
        html.code([], [html.text("fun.()")]),
        html.text("syntax)."),
      ]),
      html.li([], [
        html.text(
          "Gleam standard library is distributed as Hex packages, which makes interoperability
with other BEAM languages easier.",
        ),
      ]),
      html.li([], [
        html.text(
          "Elixir is a larger language, featuring numerous language features not present
in Gleam.",
        ),
      ]),
      html.li([], [
        html.text(
          "Elixir has a robust test framework with excellent support for concurrency,
partitioning, parameterized tests, integrated error reports, and more.
Gleam does not yet.",
        ),
      ]),
      html.li([], [
        html.text(
          "Both languages compile to Erlang but Elixir compiles to Erlang abstract
format, while Gleam compiles to Erlang source. Gleam can also compile to
JavaScript.",
        ),
      ]),
      html.li([], [
        html.text(
          "Elixir has superior BEAM runtime integration, featuring accurate
stack traces and full support for tools such as code coverage, profiling, and
more. Gleam’s support is much weaker due to going via Erlang source.",
        ),
      ]),
      html.li([], [
        html.text(
          "Elixir has better support for the OTP actor framework. Gleam has its own
version of OTP which is type safe, but has a smaller feature set.",
        ),
      ]),
      html.li([], [
        html.text(
          "Elixir has superior deployment tooling, including support for OTP releases and
OTP umbrella applications.",
        ),
      ]),
      html.li([], [
        html.text(
          "Gleam’s editor tooling is superior due to having a more mature official
language server, but Elixir has recently announced an official language server
project which is in active development.",
        ),
      ]),
      html.li([], [
        html.text(
          "Elixir is more mature than Gleam and has a much larger ecosystem.",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "Most importantly both are BEAM languages! I advise using whichever has the
programming style you personally find most enjoyable and productive.",
      ),
    ]),
    html.h2([attr.id("how-does-gleam-compare-to-purerl")], [
      html.text("How does Gleam compare to Purerl?"),
    ]),
    html.p([], [
      html.a([attr.href("https://github.com/purerl/purerl")], [
        html.text("Purerl"),
      ]),
      html.text(
        "is a backend for the PureScript compiler that outputs Erlang.
Both PureScript and Purerl are fantastic!",
      ),
    ]),
    html.p([], [html.text("Here’s a non-exhaustive list of differences:")]),
    html.ul([], [
      html.li([], [
        html.text(
          "Purerl is a backend for the PureScript compiler, Gleam is its own language and
compiler.",
        ),
      ]),
      html.li([], [
        html.text(
          "PureScript has a more sophisticated type system than Gleam, featuring rows,
HKTs, type classes, and more.",
        ),
      ]),
      html.li([], [
        html.text(
          "Purerl’s compiler is written in Haskell, Gleam’s is written in Rust.",
        ),
      ]),
      html.li([], [
        html.text(
          "PureScript has an ML family style syntax, Gleam has a C family style syntax.",
        ),
      ]),
      html.li([], [
        html.text(
          "Purerl code can be difficult to use from other BEAM languages, Gleam code is
designed to be usable from all BEAM languages.",
        ),
      ]),
      html.li([], [
        html.text(
          "PureScript is more mature than Gleam and has a much larger ecosystem,
though not all of it can be used with the Purerl compiler backend.",
        ),
      ]),
    ]),
    html.h2([attr.id("how-does-gleam-compare-to-rust")], [
      html.text("How does Gleam compare to Rust?"),
    ]),
    html.p([], [
      html.a([attr.href("https://github.com/rust-lang/rust")], [
        html.text("Rust"),
      ]),
      html.text(
        "is a language that compiles to native code and gives you full
control of memory use in your program, much like C or C++. Gleam’s compiler is
written in Rust! We’re big fans of the language.",
      ),
    ]),
    html.p([], [
      html.text(
        "Despite having some syntactic similarities, Gleam and Rust are extremely
different language.",
      ),
    ]),
    html.ul([], [
      html.li([], [
        html.text(
          "Rust is a low level programming language, Gleam is a very high level language.",
        ),
      ]),
      html.li([], [
        html.text(
          "Rust is a hybrid functional and imperative language that makes heavy use of
mutable state. Gleam is a functional language where everything is immutable.",
        ),
      ]),
      html.li([], [
        html.text(
          "Rust compiles to native code. Gleam runs on the Erlang VM and JavaScript
runtimes.",
        ),
      ]),
      html.li([], [
        html.text(
          "Rust is a very large language which can be challenging to learn. Gleam is a
small language and is designed to be easy to learn.",
        ),
      ]),
      html.li([], [
        html.text(
          "Rust uses futures with async/await, Gleam uses the actor model on Erlang.",
        ),
      ]),
      html.li([], [
        html.text(
          "Rust features traits and multiple macro systems, Gleam does not.",
        ),
      ]),
    ]),
    html.h2([attr.id("can-i-use-elixir-code-with-gleam")], [
      html.text("Can I use Elixir code with Gleam?"),
    ]),
    html.p([], [
      html.text(
        "Yes! The Gleam build tool has support for Elixir and can compile both Elixir
dependencies and Elixir source files in your Gleam project. Elixir has to be
installed on your computer for this to work.",
      ),
    ]),
    html.p([], [
      html.text(
        "Elixir macros cannot be called from outside of Elixir, so some Elixir APIs
cannot be used directly from Gleam. To use one of these you can write an Elixir
module that uses the macros, and then use that module in your Gleam code.",
      ),
    ]),
    html.h2([attr.id("why-is-the-compiler-written-in-rust")], [
      html.text("Why is the compiler written in Rust?"),
    ]),
    html.p([], [
      html.text(
        "Prototype versions of the Gleam compiler were written in Erlang, but a switch was
made to Rust as the lack of static types was making refactoring a slow and
error prone process. A full Rust rewrite of the prototype resulted in the
removal of a lot of tech debt and bugs, and the performance boost is nice too!",
      ),
    ]),
    html.p([], [
      html.text(
        "The community may one day implement a Gleam compiler written in Gleam, but the
core team are focused on developing other areas of the ecosystem such as
libraries, tooling, and documentation, as this will provide more value overall.",
      ),
    ]),
    html.h2([attr.id("should-i-put-gleam-in-production")], [
      html.text("Should I put Gleam in production?"),
    ]),
    html.p([], [html.text("Yes!")]),
    html.p([], [
      html.text(
        "Gleam is a production-ready programming language and the Erlang and JavaScript runtimes it runs
on are extremely mature and battle-tested. Gleam is ready for mission critical
workloads.",
      ),
    ]),
    html.h2([attr.id("what-are-gleam-programmers-called")], [
      html.text("What are Gleam programmers called?"),
    ]),
    html.p([], [
      html.text("Gleamlins, according to "),
      html.a([attr.href("https://discord.gg/Fm8Pwmy")], [
        html.text("the Gleam Discord server"),
      ]),
      html.text("."),
    ]),
    html.h2([attr.id("is-it-good")], [html.text("Is it good?")]),
    html.p([], [html.text("Yes, I think so. :)")]),
  ]
  |> page_layout("prose", meta, ctx)
  |> to_html_file(meta)
}

pub fn documentation(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "documentation",
      title: "Documentation",
      description: "Learn all about programming in Gleam!",
      preload_images: [],
    )

  [
    html.h2([attr.id("learning-gleam")], [html.text("Learning Gleam")]),
    html.ul([], [
      html.li([], [
        html.p([], [
          html.a([attr.href("https://tour.gleam.run")], [
            html.text("Language tour"),
          ]),
        ]),
        html.p([], [
          html.text(
            "An in-browser interactive introduction that teaches the whole language.",
          ),
        ]),
      ]),
      html.li([], [
        html.p([], [
          html.a([attr.href("/writing-gleam")], [html.text("Writing Gleam")]),
        ]),
        html.p([], [
          html.text("A guide on creating and developing projects in Gleam."),
        ]),
      ]),
      html.li([], [
        html.p([], [
          html.a([attr.href("/getting-started/installing")], [
            html.text("Installing Gleam"),
          ]),
        ]),
        html.p([], [html.text("How to get Gleam on your computer.")]),
      ]),
    ]),
    html.h3([attr.id("unofficial-courses")], [html.text("Unofficial courses")]),
    html.ul([], [
      html.li([], [
        html.p([], [
          html.a([attr.href("https://exercism.org/tracks/gleam")], [
            html.text("Exercism’s Gleam track"),
          ]),
        ]),
        html.p([], [
          html.text(
            "Develop skills in Gleam and 70+ other languages with a unique
            blend of learning, practicing, and mentoring from skilled
            programmers. An educational non-profit and free forever.",
          ),
        ]),
      ]),
      html.li([], [
        html.p([], [
          html.a([attr.href("https://app.codecrafters.io/join?via=lpil")], [
            html.text("CodeCrafters"),
          ]),
        ]),
        html.p([], [
          html.text(
            "Practice writing complex software in Gleam and 20 other languages by
            implementing real-world systems such as Redis from scratch.",
          ),
        ]),
        html.p([], [
          html.em([], [
            html.text(
              "This is a referral link and a portion of any money paid will go
              to supporting Gleam development",
            ),
          ]),
          html.text("."),
        ]),
      ]),
    ]),
    html.h2([attr.id("gleam-references")], [html.text("Gleam references")]),
    html.ul([], [
      html.li([], [
        html.a([attr.href("https://tour.gleam.run/everything/")], [
          html.text("The Gleam Language overview"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("/writing-gleam/command-line-reference")], [
          html.text("The Command line reference"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("/language-server")], [
          html.text("The Gleam language server reference"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("/writing-gleam/gleam-toml")], [
          html.text("The gleam.toml config file reference"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("https://packages.gleam.run")], [
          html.text("The Gleam package index"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("https://hexdocs.pm/gleam_stdlib/")], [
          html.text("The standard library documentation"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("https://github.com/gleam-lang/awesome-gleam")], [
          html.text("The “Awesome Gleam” resource list"),
        ]),
      ]),
    ]),
    html.h2([attr.id("cheatsheets")], [html.text("Cheatsheets")]),
    html.ul([], [
      html.li([], [
        html.a([attr.href("/cheatsheets/gleam-for-elixir-users")], [
          html.text("Gleam for Elixir users"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("/cheatsheets/gleam-for-elm-users")], [
          html.text("Gleam for Elm users"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("/cheatsheets/gleam-for-erlang-users")], [
          html.text("Gleam for Erlang users"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("/cheatsheets/gleam-for-php-users")], [
          html.text("Gleam for PHP users"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("/cheatsheets/gleam-for-python-users")], [
          html.text("Gleam for Python users"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("/cheatsheets/gleam-for-rust-users")], [
          html.text("Gleam for Rust users"),
        ]),
      ]),
    ]),
    html.h2([attr.id("deployment")], [html.text("Deployment")]),
    html.ul([], [
      html.li([], [
        html.a([attr.href("/deployment/linux-server")], [
          html.text("Deploying to a Linux server"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("/deployment/fly")], [
          html.text("Deploying on Fly.io"),
        ]),
      ]),
    ]),
    html.h3([attr.id("community-deployment-guides")], [
      html.text("Community deployment guides"),
    ]),
    html.ul([], [
      html.li([], [
        html.a([attr.href("https://github.com/davlgd/gleam-demo")], [
          html.text("Deploying on Clever Cloud"),
        ]),
      ]),
    ]),
    html.h2([attr.id("about-gleam")], [html.text("About Gleam")]),
    html.ul([], [
      html.li([], [
        html.a([attr.href("/frequently-asked-questions")], [
          html.text("Frequently asked questions"),
        ]),
      ]),
      html.li([], [
        html.a([attr.href("/branding")], [html.text("Gleam’s Branding")]),
      ]),
    ]),
    html.h2([attr.id("community-resources")], [html.text("Community Resources")]),
    html.ul([], [
      html.li([], [
        html.a([attr.href("https://exercism.org/tracks/gleam")], [
          html.text("Exercism’s Gleam track"),
        ]),
        html.text(
          ". Learn Gleam by solving problems and getting feedback from mentors.",
        ),
      ]),
    ]),
  ]
  |> page_layout("", meta, ctx)
  |> to_html_file(meta)
}

pub fn news_index(posts: List(news.NewsPost), ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "news",
      title: "News",
      description: "What's happening in the Gleam world?",
      preload_images: [],
    )

  let list_items =
    list.map(posts, fn(post) {
      html.li([], [
        html.a([attr.href("/news/" <> post.path)], [
          html.h2([attr.class("links")], [html.text(post.title)]),
        ]),
        html.p([], [html.text(post.subtitle)]),
        html.ul([class("news-meta")], [
          html.li([], [
            html.img([
              attr.width(16),
              attr.src("/images/date-icon.svg"),
              attr.alt("Date Icon"),
            ]),
            html.text(short_human_date(post.published)),
          ]),
          html.li([], [
            html.img([
              attr.width(20),
              attr.src("/images/user-icon.svg"),
              attr.alt("User Icon"),
            ]),
            html.text(post.author.name),
          ]),
        ]),
      ])
    })

  [html.ul([class("news-posts")], list_items)]
  |> page_layout("", meta, ctx)
  |> to_html_file(meta)
}

pub fn gleam_toml(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "writing-gleam/gleam-toml",
      title: "gleam.toml",
      description: "Configure your Gleam project",
      preload_images: [],
    )

  let code =
    "# The name of your project (required)
name = \"my_project\"

# The version of your project (required)
version = \"1.0.0\"

# The licences which this project uses, in SPDX format (optional)
licences = [\"Apache-2.0\", \"MIT\"]

# A short description of your project (optional)
# This will be displayed on the package page if the project is published to
# the Hex package repository.
description = \"Gleam bindings to...\"

# The target to default to when compiling or running Gleam code
# Accepted values are \"erlang\" and \"javascript\". Defaults to \"erlang\".
target = \"erlang\"

# The source code repository location (optional)
# This will be used in generated documentation and displayed on Hex.
repository = { type = \"github\", user = \"example\", repo = \"my_project\" }
# `repository` can also be one of these formats
# { type = \"forgejo\",   host = \"example.com\", user = \"example\", repo = \"my_project\" }
# { type = \"gitea\",     host = \"example.com\", user = \"example\", repo = \"my_project\" }
# { type = \"gitlab\",    user = \"example\", repo = \"my_project\" }
# { type = \"sourcehut\", user = \"example\", repo = \"my_project\" }
# { type = \"bitbucket\", user = \"example\", repo = \"my_project\" }
# { type = \"codeberg\",  user = \"example\", repo = \"my_project\" }
# { type = \"custom\",    url = \"https://example.com/my_project\" }
# An optional `path` to this project in the repository can be specified
# if it is not located at the root:
# { type = \"github\", user = \"example\", repo = \"my_project\", path = \"packages/my_project\" }

# Links to any related website (optional)
# This will be displayed in generated documentation and on Hex.
links = [
  { title = \"Home page\", href = \"https://example.com\" },
  { title = \"Other site\", href = \"https://another.example.com\" },
]

# Modules that should be considered \"internal\" and will not be included in
# generated documentation. Note this currently only affects documentation;
# public types and functions defined in these modules are still public.
#
# Items in this list are \"globs\" that are matched against module names. See:
# https://docs.rs/glob/latest/glob/struct.Pattern.html
#
# The default value is as below, with the `name` of your project substituted in
# place of \"my_app\".
internal_modules = [
  \"my_app/internal\",
  \"my_app/internal/*\",
]

# The version of the Gleam compiler that the package requires (optional)
# An error is raised if the version of the compiler used to compile the package
# does not match this requirement.
gleam = \">= 0.30.0\"

# The Hex packages the project needs to compile and run (optional)
# Uses the Hex version requirement format
# https://hexdocs.pm/elixir/Version.html#module-requirements
[dependencies]
gleam_stdlib = \">= 0.18.0 and < 2.0.0\"
gleam_erlang = \">= 0.2.0 and < 2.0.0\"
gleam_http = \">= 2.1.0 and < 3.0.0\"
# Local dependencies can be specified with a path
my_other_project = { path = \"../my_other_project\" }
# Git dependencies can also be used
my_git_library = { git = \"git@github.com:my-project/my-library.git\", ref = \"a8b3c5d82\" }
latest_stdlib = { git = \"git@github.com:gleam-lang/stdlib.git\", ref = \"main\" }

# The Hex packages the project needs for the tests (optional)
# These will not be included if the package is published to Hex.
# This table cannot include any packages that are already found in the
# `dependencies` table.
[dev-dependencies]
gleeunit = \">= 1.0.0 and < 2.0.0\"

# Documentation specific configuration (optional)
[documentation]
# Additional markdown pages to be included in generated HTML docs (optional)
pages = [
  { title = \"My Page\", path = \"my-page.html\", source = \"./path/to/my-page.md\" },
]

# Erlang specific configuration (optional)
[erlang]
# The name of the OTP application module, if the project has one (optional)
# Typically Gleam projects do not use the Erlang/OTP implicit application boot
# system and so typically do not define this.
# If specified the module must implement the OTP application behaviour.
# https://www.erlang.org/doc/man/application.html
application_start_module = \"my_app/application\"

# The names of any OTP applications that need to be started in addition to the
# ones from the project dependencies (optional)
extra_applications = [\"inets\", \"ssl\"]

# JavaScript specific configuration (optional)
[javascript]
# Generate TypeScript .d.ts files
typescript_declarations = true

# Which JavaScript runtime to use with `gleam run`, `gleam test` etc.
runtime = \"node\" # or \"deno\" or \"bun\"

# Configuration specific to the Deno runtime (optional)
# https://deno.land/manual@v1.30.0/basics/permissions#permissions
[javascript.deno]
allow_all = false
allow_sys = false
allow_ffi = false
allow_hrtime = false

# A bool or list of environment variables
allow_env = [\"DATABASE_URL\"]

# A bool or a list of IP addresses or hostnames (optionally with ports)
allow_net = [\"example.com:443\"]

# A bool or a list of paths
allow_run = [\"./bin/migrate.sh\"]
allow_read = [\"./database.sqlite\"]
allow_write = [\"./database.sqlite\"]"

  let content = [
    html.p([], [
      html.text(
        "All Gleam projects require a `gleam.toml` configuration file. The `toml` configuration format is documented at ",
      ),
      html.a([attr.href("https://toml.io/")], [html.text("toml.io")]),
      html.text("."),
      highlighted_toml_pre_code(code),
    ]),
  ]

  content
  |> page_layout("", meta, ctx)
  |> to_html_file(meta)
}

pub fn deployment_linux(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "deployment/linux-server",
      title: "Deploy to a Linux server",
      description: "Run Gleam on a server from any provider",
      preload_images: [],
    )

  [
    html.p([], [
      html.text(
        "This guide will take you through the process of deploying a Gleam backend web
application to a single Linux server. The application will be run by systemd in
a Linux container, and ",
      ),
      html.a([attr.href("https://caddyserver.com/")], [html.text("Caddy")]),
      html.text(
        "will be used to handle
HTTPS.",
      ),
    ]),
    html.h2([attr.id("provision-your-server")], [
      html.text("Provision your server"),
    ]),
    html.p([], [
      html.text(
        "We will be using the most recent LTS version of Ubuntu in this tutorial. You can
use other Linux distributions but there may be slight differences in commands or
additional steps you need to undertake to deploy your application.",
      ),
    ]),
    html.p([], [
      html.text(
        "If you do not have a server already there are a number of companies who can
provide you one for a small monthly fee. You can use ",
      ),
      html.a([attr.href("https://www.vultr.com/?ref=9694426")], [
        html.text("Gleam’s referral link for Vultr"),
      ]),
      html.text(" if you do not already have a preferred server provider."),
    ]),
    html.p([], [
      html.text(
        "We will be using an amd64 server with 1 shared virtual CPU and 1 GB of memory.
You can use a smaller server if you wish, but at least 250MB of memory is
recommended. If your application is to receive a lot of traffic or perform
expensive computation then you may wish to upgrade to a more powerful server.
Be sure to add your SSH public key to the server when creating it. SSH should
never be used with passwords, it is insecure.",
      ),
    ]),
    html.h2([attr.id("configure-your-dns")], [html.text("Configure your DNS")]),
    html.p([], [
      html.text(
        "Once you have your server add an A record pointing to the public IPv4 address of
your server, which can likely be found in the web console of your server
provider.",
      ),
    ]),
    html.p([], [
      html.text(
        "If your server has a public IPv6 address add an AAAA record for the same domain
to that address.",
      ),
    ]),
    html.p([], [
      html.text("We will be using the domain "),
      html.code([], [html.text("example.gleam.run")]),
      html.text(
        "for the rest of this tutorial.
Be sure to replace this with your domain.",
      ),
    ]),
    html.h2([attr.id("prepare-your-application")], [
      html.text("Prepare your application"),
    ]),
    html.p([], [
      html.text("Ensure your application is listening on "),
      html.code([], [html.text("0.0.0.0")]),
      html.text(
        ". If you’re using Mist or Wisp
you can do this with the ",
      ),
      html.code([], [html.text("mist.bind")]),
      html.text(" function, as shown here."),
    ]),
    highlighted_gleam_pre_code(
      "  let assert Ok(_) =
    wisp_mist.handler(handle_request, secret_key_base)
    |> mist.new
    |> mist.bind(\"0.0.0.0\") // <- add this line
    |> mist.port(8000)
    |> mist.start_http
",
    ),
    html.p([], [
      html.text(
        "Take note of what port your application is starting on. We will be using port
8000 for the rest of this guide.",
      ),
    ]),
    html.h2([attr.id("add-a-dockerfile")], [html.text("Add a Dockerfile")]),
    html.p([], [
      html.text("Add a file to the base of your repository called "),
      html.code([], [html.text("Dockerfile")]),
      html.text(" with these contents:"),
    ]),
    highlighted_dockerfile_pre_code(
      "FROM erlang:27.1.1.0-alpine AS build
COPY --from=ghcr.io/gleam-lang/gleam:v1.8.0-erlang-alpine /bin/gleam /bin/gleam
COPY . /app/
RUN cd /app && gleam export erlang-shipment

FROM erlang:27.1.1.0-alpine
RUN \\
  addgroup --system webapp && \\
  adduser --system webapp -g webapp
COPY --from=build /app/build/erlang-shipment /app
WORKDIR /app
ENTRYPOINT [\"/app/entrypoint.sh\"]
CMD [\"run\"]
",
    ),
    html.p([], [
      html.text("Edit the Erlang and Gleam versions on the 2 "),
      html.code([], [html.text("FROM")]),
      html.text("lines and the first "),
      html.code([], [html.text("COPY")]),
      html.text("lines to be the ones you want to use."),
    ]),
    html.p([], [
      html.text("If your application normally needs additional arguments to "),
      html.code([], [html.text("gleam run")]),
      html.text(" to start then edit the "),
      html.code([], [html.text("CMD [\"run\"]")]),
      html.text(" line to include them."),
    ]),
    html.p([], [
      html.text(
        "If you have other requirements (for example, if you are using NIFs and need a C
compiler) you will need to edit this file further to install the required
packages.",
      ),
    ]),
    html.h2([attr.id("build-your-container-on-ci")], [
      html.text("Build your container on CI"),
    ]),
    html.p([], [
      html.text(
        "We will be using GitHub actions to build and publish the container image to the
GitHub container registry using docker each time a git tag starting with ",
      ),
      html.code([], [html.text("v")]),
      html.text(
        "is
pushed to the repo. For example, ",
      ),
      html.code([], [html.text("v1.0.0")]),
      html.text("."),
    ]),
    html.p([], [
      html.text("Create a file at "),
      html.code([], [html.text(".github/workflows/build-container.yml")]),
      html.text(" with these contents:"),
    ]),
    highlighted_yaml_pre_code(
      "name: Build container image
on:
  push:
    tags:
      - v*

jobs:
  push:
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Build image
        run: docker build . --file Dockerfile --tag webapp

      - name: Log in to registry
        run: echo \"${{ secrets.GITHUB_TOKEN }}\" | docker login ghcr.io -u ${{ github.actor }} --password-stdin

      - name: Push image
        run: |
          IMAGE_ID=ghcr.io/gleam-run/example
          TAG=\"$IMAGE_ID\":$(echo \"${{ github.ref }}\" | sed -e 's,.*/\\(.*\\),\\1,')
          docker tag webapp \"$TAG\"
          docker push \"$TAG\"
",
    ),
    html.p([], [
      html.text("Edit "),
      html.code([], [html.text("IMAGE_ID=ghcr.io/gleam-run/example")]),
      html.text(
        "with the name of your GitHub
repository. If you repository is at ",
      ),
      html.code([], [html.text("https://github.com/wibble/wob")]),
      html.text(" it should be "),
      html.code([], [html.text("IMAGE_ID=ghcr.io/wibble/wob")]),
      html.text("."),
    ]),
    html.p([], [
      html.text(
        "After you have pushed these changes push a new git tag to GitHub. This will
trigger the workflow, which you can see in your GitHub repo’s “Actions” tab.",
      ),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "git tag production
git push --tags
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("We’re using the tag "),
      html.code([], [html.text("production")]),
      html.text(", but you can use any tag name you want."),
    ]),
    html.h2([attr.id("secure-the-ssh-service")], [
      html.text("Secure the SSH service"),
    ]),
    html.p([], [
      html.text(
        "SSH into your server using the domain name you configured earlier.",
      ),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "ssh root@example.gleam.run
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "If you are unable to SSH in check you have the correct username and the domain,
and are using the same SSH key you added to the server when creating it.",
      ),
    ]),
    html.p([], [
      html.text(
        "Permitting SSH login with a password is a security risk, so ensure it is
disabled. Open ",
      ),
      html.code([], [html.text("/etc/ssh/sshd_config")]),
      html.text(" in a text editor."),
    ]),
    html.pre([], [html.code([], [html.text("nano /etc/ssh/sshd_config")])]),
    html.p([], [
      html.text("Search for the line "),
      html.code([], [html.text("#PasswordAuthentication yes")]),
      html.text(" and edit it to be "),
      html.code([], [html.text("PasswordAuthentication no")]),
      html.text(". Notice that it does not have a "),
      html.code([], [html.text("#")]),
      html.text(
        "at the start,
while before it may have had one.",
      ),
    ]),
    html.p([], [html.text("Restart the SSH service.")]),
    html.pre([], [
      html.code([], [
        html.text(
          "systemctl restart ssh
",
        ),
      ]),
    ]),
    html.h2([attr.id("secure-the-network-with-a-firewall")], [
      html.text("Secure the network with a firewall"),
    ]),
    html.p([], [
      html.text(
        "The server should only be accessible over HTTP, HTTPS, and SSH, so we will
configure the server to block anything else.",
      ),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "ufw allow ssh
ufw allow http
ufw allow https
ufw enable
",
        ),
      ]),
    ]),
    html.p([], [
      html.code([], [html.text("ufw")]),
      html.text(
        "may prompt for confirmation when enabling it. Accept by entering ",
      ),
      html.code([], [html.text("y")]),
      html.text("."),
    ]),
    html.h2([attr.id("enable-automatic-ubuntu-security-updates")], [
      html.text("Enable automatic Ubuntu security updates"),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "apt install --yes unattended-upgrades
systemctl start unattended-upgrades
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "If you are not using Ubuntu Linux there may be some other way to do this for
your distribution.",
      ),
    ]),
    html.h2([attr.id("install-caddy-and-podman")], [
      html.text("Install Caddy and Podman"),
    ]),
    html.p([], [
      html.text(
        "Caddy is the reverse proxy that we will use to provision TLS certificates and
handle HTTPS traffic. Podman is the container engine we will use to run the
application container.",
      ),
    ]),
    html.p([], [
      html.text("Install them both using "),
      html.code([], [html.text("apt")]),
      html.text(" (or the equivalent if you decided not to use Ubuntu Linux)."),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "apt install --yes podman caddy
",
        ),
      ]),
    ]),
    html.p([], [
      html.text(
        "After this finishes if you visit your domain in a web browser you should see the
default Caddy home page.",
      ),
    ]),
    html.h2([attr.id("define-your-podman-container")], [
      html.text("Define your Podman container"),
    ]),
    html.p([], [
      html.text(
        "If you are using a private GitHub repository you will need create a GitHub
personal access token with ",
      ),
      html.code([], [html.text("read:packages")]),
      html.text(
        "permissions in the GitHub security
settings, and then use it to log in on the server.",
      ),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "echo \"YOUR_GITHUB_PAT\" | podman login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
",
        ),
      ]),
    ]),
    html.p([], [html.text("Create a Podman systemd container file.")]),
    html.pre([], [
      html.code([], [
        html.text(
          "nano /etc/containers/systemd/webapp.container
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Add these contents, changing "),
      html.code([], [html.text("Image=ghcr.io/gleam-lang/example:production")]),
      html.text(" for the name of your GitHub repository."),
    ]),
    highlighted_toml_pre_code(
      "[Unit]
Description=My Gleam web application
After=local-fs.target

[Container]
Image=ghcr.io/gleam-lang/example:production
PublishPort=8000:8000

[Install]
WantedBy=multi-user.target default.target
",
    ),
    html.p([], [
      html.text("You may want to edit the "),
      html.code([], [html.text("[Container]")]),
      html.text(" section to further configure your container."),
    ]),
    html.p([], [
      html.text(
        "If your application is listening on a different port then edit the ",
      ),
      html.code([], [html.text("8000")]),
      html.text(
        "s to
the correct port.",
      ),
    ]),
    html.p([], [
      html.text("Environment variables can be added using the "),
      html.code([], [html.text("Environment=KEY=value")]),
      html.text(" syntax."),
    ]),
    html.p([], [
      html.text(
        "Directories on the server can be made accessible to the application inside the
container using the ",
      ),
      html.code([], [
        html.text("Volume=/path/on/server:/path/in/container:rw,z"),
      ]),
      html.text(" syntax."),
    ]),
    html.p([], [
      html.text("See the "),
      html.a(
        [
          attr.href(
            "https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html",
          ),
        ],
        [html.text("Podman systemd")],
      ),
      html.text(" documentation for more detail."),
    ]),
    html.h2([attr.id("start-the-container")], [html.text("Start the container")]),
    html.p([], [
      html.text("The "),
      html.code([], [html.text(".container")]),
      html.text(" file creates a systemd service, so "),
      html.code([], [html.text("systemctl")]),
      html.text(" can be used to manage the application container."),
    ]),
    html.p([], [
      html.text(
        "Reload the systemd daemon to load the latest version of the file, and then start
the service.",
      ),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "systemctl daemon-reload
systemctl start webapp
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("The status of the systemd service can be viewed with "),
      html.code([], [html.text("systemctl status webapp")]),
      html.text("."),
    ]),
    html.p([], [
      html.text(
        "Check that service is handling HTTP requests by making a request to ",
      ),
      html.code([], [html.text("localhost")]),
      html.text(" on the port that your application is listening on."),
    ]),
    html.pre([], [html.code([], [html.text("curl -I localhost:8000")])]),
    html.h2([attr.id("configure-caddy-to-send-traffic-to-the-application")], [
      html.text("Configure Caddy to send traffic to the application"),
    ]),
    html.p([], [
      html.text("Replace the contents of "),
      html.code([], [html.text("/etc/caddy/Caddyfile")]),
      html.text(
        "with this, making sure to replace
the domain and port with the ones you are using. Keep ",
      ),
      html.code([], [html.text("localhost")]),
      html.text(" the same."),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "example.gleam.run {
        reverse_proxy localhost:8000
}
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("Restart the Caddy service to pick up these changes."),
    ]),
    html.pre([], [html.code([], [html.text("systemctl restart caddy")])]),
    html.p([], [
      html.text(
        "Open your domain in your web browser. You should see your web site, complete
with HTTPS!",
      ),
    ]),
    html.h2([attr.id("future-deployments-and-maintenance")], [
      html.text("Future deployments and maintenance"),
    ]),
    html.p([], [
      html.text(
        "Pushing a new tag to the GitHub repository will cause a new container image to
be built. You can force-push a tag to a new location to create a new container
with the same name.",
      ),
    ]),
    html.p([], [
      html.text("If you have changed the "),
      html.code([], [html.text(".container")]),
      html.text(
        " file you can reload the daemon to pick up
the changes and then restart the service to replace the container with one using
the new configuration.",
      ),
    ]),
    html.pre([], [
      html.code([], [
        html.text(
          "systemctl daemon-reload
systemctl restart webapp
",
        ),
      ]),
    ]),
    html.p([], [
      html.text("The logs can be viewed with "),
      html.code([], [html.text("journalctl -xeu webapp")]),
      html.text("."),
    ]),
  ]
  |> page_layout("", meta, ctx)
  |> to_html_file(meta)
}

pub fn community(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "community",
      title: "The Gleam Community",
      description: "Welcome, friend! It's good to have you",
      preload_images: [],
    )

  let code_of_conduct =
    "https://github.com/gleam-lang/gleam/blob/main/CODE_OF_CONDUCT.md"
  let content = [
    html.article([class("prose")], [
      html.p([], [
        html.text(
          "You can talk to and get help from other Gleam community members in the
        following forums:",
        ),
      ]),
      html.ul([attr.class("community-socials")], [
        html.li([], [
          html.a(
            [attr.href("https://discord.gg/Fm8Pwmy"), attr.target("_blank")],
            [
              html.span([attr.class("community-socials__logo")], [
                html.img([
                  attr.alt("Discord Icon"),
                  attr.src("/images/community/discord.svg"),
                ]),
              ]),
              html.span([], [html.text("Gleam’s web chat on Discord")]),
            ],
          ),
        ]),
        html.li([], [
          html.a(
            [
              attr.href("https://github.com/gleam-lang/gleam/discussions"),
              attr.target("_blank"),
            ],
            [
              html.span([attr.class("community-socials__logo")], [
                html.img([
                  attr.alt("GitHub Icon"),
                  attr.src("/images/community/github.svg"),
                ]),
              ]),
              html.span([], [html.text("Gleam discussions on Github")]),
            ],
          ),
        ]),
      ]),
      html.p([], [
        html.text(
          "You can also subscribe to updates from community newsletter ",
        ),
        html.a([attr.href("https://gleamweekly.com/")], [
          html.text("Gleam Weekly"),
        ]),
        html.text("."),
      ]),
      html.h2([], [html.text("Code of Conduct")]),
      html.p([], [
        html.text(
          "The Gleam community is a space where we treat each other kindly and
        with respect. Please read and adhere to our community ",
        ),
        html.a([attr.href(code_of_conduct)], [html.text("code of conduct")]),
        html.text("."),
      ]),
      html.p([], [
        html.text(
          "If you need help or have encountered anyone violating our code of conduct
        please send a message to us via one of the channels below. We will ensure the
        issue is resolved and your identity will be kept private.",
        ),
      ]),
      html.ul([], [
        html.li([], [
          html.text("Messaging the "),
          html.code([], [html.text("@moderators")]),
          html.text("group on the "),
          html.a([attr.href("https://discord.gg/Fm8Pwmy")], [
            html.text("Gleam Discord chat"),
          ]),
          html.text("."),
        ]),
        html.li([], [
          html.text("Emailing "),
          html.a([attr.href("mailto:hello@gleam.run")], [
            html.text("hello@gleam.run"),
          ]),
          html.text("."),
        ]),
      ]),
    ]),
  ]

  content
  |> page_layout("", meta, ctx)
  |> to_html_file(meta)
}

pub fn branding(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "branding",
      title: "Gleam's branding",
      description: "All pretty and pink 💖",
      preload_images: [],
    )

  let content = [
    html.h2([], [html.text("Gleam's favourite colours")]),
    html.ul([attr.class("colours flat-list")], [
      html.li([], [
        html.span([attr("style", "background-color: #ffaff3")], []),
        html.code([], [html.text("#ffaff3")]),
        html.text("Faff Pink"),
      ]),
      html.li([], [
        html.span([attr("style", "background-color: #fefefc")], []),
        html.code([], [html.text("#fefefc")]),
        html.text("White"),
      ]),
      html.li([], [
        html.span([attr("style", "background-color: #a6f0fc")], []),
        html.code([], [html.text("#a6f0fc")]),
        html.text("Unnamed Blue"),
      ]),
      html.li([], [
        html.span([attr("style", "background-color: #fffbe8")], []),
        html.code([], [html.text("#fffbe8")]),
        html.text("Aged Plastic Yellow"),
      ]),
      html.li([], [
        html.span([attr("style", "background-color: #584355")], []),
        html.code([], [html.text("#584355")]),
        html.text("Unexpected Aubergine"),
      ]),
      html.li([], [
        html.span([attr("style", "background-color: #292d3e")], []),
        html.code([], [html.text("#292d3e")]),
        html.text("Underwater Blue"),
      ]),
      html.li([], [
        html.span([attr("style", "background-color: #2f2f2f")], []),
        html.code([], [html.text("#2f2f2f")]),
        html.text("Charcoal"),
      ]),
      html.li([], [
        html.span([attr("style", "background-color: #1e1e1e")], []),
        html.code([], [html.text("#1e1e1e")]),
        html.text("Black"),
      ]),
      html.li([], [
        html.span([attr("style", "background-color: #151515")], []),
        html.code([], [html.text("#151515")]),
        html.text("Blacker"),
      ]),
    ]),
    html.h2([], [html.text("Lucy, Gleam's starfish mascot")]),
    html.p([], [
      html.text(
        "Lucy is a pink starfish that can glow underwater. She's kind and nice, though
        a bit clumsy sometimes. Strawberry is her favourite ice cream flavour. Lucy
        has a seahorse plushie.",
      ),
    ]),
    html.p([], [
      html.text("✨ Favourite kind of programming language? Functional ones."),
    ]),
    html.p([], [html.text("✨ Favourite colour? all shades of pink.")]),
    html.ul([attr.class("lucys")], [
      html.li([], [
        html.img([
          attr.alt("A five pointed pink cartoon starfish with a simple smile"),
          attr("title", "Lucy"),
          attr.src("/images/lucy/lucy.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy but smiling so much her eyes are scrunched up"),
          attr("title", "Lucy happy"),
          attr.src("/images/lucy/lucyhappy.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy staring at a laptop with a blank expression on her face",
          ),
          attr("title", "Lucy debug fail"),
          attr.src("/images/lucy/lucydebugfail.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy but glowing brightly"),
          attr("title", "Lucy glow"),
          attr.src("/images/lucy/lucyglow.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy holding out an envelope"),
          attr("title", "Lucy mail"),
          attr.src("/images/lucy/lucymail.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy but faded out with a dotted outline, as if she's vanishing",
          ),
          attr("title", "Lucy null"),
          attr.src("/images/lucy/lucynull.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy with her eyes closed"),
          attr("title", "Lucy sleep"),
          attr.src("/images/lucy/lucysleep.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Superlucy, showing off her shimmer power"),
          attr("title", "Superlucy"),
          attr.src("/images/lucy/superlucy.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy but the rainbow colours of the pride flag instead of pink",
          ),
          attr("title", "Lucy pride"),
          attr.src("/images/lucy/lucypride.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy but the colours of the trans pride flag instead of pink",
          ),
          attr("title", "Lucy trans"),
          attr.src("/images/lucy/lucytrans.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy but the colours of the lesbian pride flag instead of pink",
          ),
          attr("title", "Lucy lesbian"),
          attr.src("/images/lucy/lucylesbian.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy but the colours of the sapphic pride flag instead of pink",
          ),
          attr("title", "Lucy sapphic by @hqnna"),
          attr.src("/images/lucy/lucysapphic.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy but the colours of the men-loving-men pride flag instead of pink",
          ),
          attr("title", "Lucy gay"),
          attr.src("/images/lucy/lucygay.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy but the colours of the asexual pride flag instead of pink",
          ),
          attr("title", "Lucy ace"),
          attr.src("/images/lucy/lucyace.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy but the colours of the bisexual pride flag instead of pink",
          ),
          attr("title", "Lucy bi"),
          attr.src("/images/lucy/lucybi.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy but the colours of the pansexual pride flag instead of pink",
          ),
          attr("title", "Lucy pan"),
          attr.src("/images/lucy/lucypan.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy wearing little blue trousers with a 'WASM' on them in the style of the WASM logo",
          ),
          attr("title", "Lucy Wasm by Danielle Maywood"),
          attr.src("/images/lucy/lucywasm.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "Lucy wearing little yellow trousers with a 'JS' on them in the style of the JS logo",
          ),
          attr("title", "Lucy JS by Danielle Maywood"),
          attr.src("/images/lucy/lucyjs.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt(
            "The Erlang logo, but a pink G rather than a red E, the text 'Gleam', Lucy's cute little face on it",
          ),
          attr("title", "Lucy Erlang by Danielle Maywood"),
          attr.src("/images/lucy/lucyerl.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy in the shape of the Nix snowflake-y logo"),
          attr("title", "Lucy Nix by Danielle Maywood"),
          attr.src("/images/lucy/lucynix.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy in the shape of the Nix Flake snowflake-y logo"),
          attr("title", "Lucy Flake by Danielle Maywood and Isaac Harris-Holt"),
          attr.src("/images/lucy/lucyflake.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy in the shape of the robot-y Godot logo"),
          attr("title", "Lucy Godot by Danielle Maywood"),
          attr.src("/images/lucy/lucygodot.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy in the shape of the Elixir drop logo"),
          attr("title", "Lucy Elixir by Jen Stehlik"),
          attr.src("/images/lucy/lucyelixir.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy in the shape of the Rust Ferris logo"),
          attr("title", "Lucy Rust by Jon Charter"),
          attr.src("/images/lucy/lucyrust.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy on a pink background"),
          attr("title", "Lucy social pink by Kayla Washburn"),
          attr.src("/images/lucy/lucypinkbg.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr.alt("Lucy on a rainbow background"),
          attr("title", "Lucy social pride by Kayla Washburn"),
          attr.src("/images/lucy/lucypridebg.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr("style", "height: 16px"),
          attr.alt("tiny Lucy optimized for 16x16px size"),
          attr("title", "Lucy optimized for 16x16px size by Jen Stehlik"),
          attr.src("/images/lucy/lucytiny.svg"),
        ]),
      ]),
      html.li([], [
        html.img([
          attr("style", "height: 16px"),
          attr.alt("tiny black and white Lucy optimized for 16x16px size"),
          attr(
            "title",
            "black and white Lucy optimized for 16x16px size by Jen Stehlik",
          ),
          attr.src("/images/lucy/lucytiny-plain.svg"),
        ]),
      ]),
    ]),
    html.p([], [
      html.text(
        "The original Nix logo of which the Lucy Nix images are modifications of is
        available under under a CC-BY license and is designed by Tim Cuthbertson
        (@timbertson).",
      ),
    ]),
    html.style(
      [],
      "
ul {
  list-style: none;
  padding: 0;
}

.colours li {
  display: flex;
  align-items: center;
  gap: 0.5em;
}

.colours span {
  display: inline-block;
  height: 64px;
  width: 64px;
}

.lucys {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5em;
  justify-content: space-between;
}

.lucys li {
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 1em;
}

.lucys img {
  height: 135px;
}
",
    ),
  ]

  content
  |> page_layout("", meta, ctx)
  |> to_html_file(meta)
}

pub fn short_human_date(date: calendar.Date) -> String {
  string.pad_start(int.to_string(date.day), 2, "0")
  <> " "
  <> calendar.month_to_string(date.month)
  <> ", "
  <> int.to_string(date.year)
}

pub fn page_layout(
  content: List(Element(a)),
  class: String,
  meta: PageMeta,
  ctx: site.Context,
) -> Element(a) {
  [
    header(hero_image: option.None, content: [
      html.h1([], [html.text(meta.title)]),
      html.p([attr.class("hero-subtitle")], [html.text(meta.description)]),
    ]),
    html.main([attr.class("page content " <> class)], content),
  ]
  |> top_layout(meta, ctx)
}

pub fn home(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "",
      title: "Gleam language",
      description: "The Gleam programming language",
      preload_images: ["/images/lucy/lucyhappy.svg"],
    )

  let content = [
    header(
      hero_image: option.Some(#(
        "/images/lucy/lucy.svg",
        "Lucy the star, Gleam's mascot",
      )),
      content: [
        html.div([], [
          html.b([], [html.text("Gleam")]),
          html.text(" is a "),
          html.b([], [html.text("friendly")]),
          html.text(" language for building "),
          html.b([], [html.text("type-safe")]),
          html.text(" systems that "),
          html.b([], [html.text("scale")]),
          html.text("!"),
        ]),
        html.a([attr.href("https://tour.gleam.run/"), attr.class("button")], [
          html.text("Try Gleam"),
        ]),
      ],
    ),
    html.main([attr.role("main")], [
      html.section([attr.class("content home-pair intro")], [
        html.div([], [
          html.p([], [
            html.text(
              "The power of a type system, the expressiveness of functional
              programming, and the reliability of the highly concurrent, fault
              tolerant Erlang runtime, with a familiar and modern syntax.",
            ),
          ]),
        ]),
        highlighted_gleam_pre_code(
          "import gleam/io

pub fn main() {
  io.println(\"hello, friend!\")
}",
        ),
      ]),
      html.section([attr.class("home-top-sponsors")], [
        html.div([attr.class("content")], [
          html.h2([], [html.text("Kindly supported by")]),
          html.ul([], [
            html.li([], [
              html.a(
                [
                  attr.target("_blank"),
                  attr.rel("noopener"),
                  attr.href("https://lambdaclass.com/"),
                  attr.class("sponsor-level1"),
                ],
                [
                  html.img([
                    attr.alt("Lambda Class"),
                    attr.src("/images/sponsors/lambda-class-black.png"),
                  ]),
                ],
              ),
            ]),
          ]),
          html.a(
            [
              attr.target("_blank"),
              attr.rel("noopener"),
              attr.href("https://github.com/sponsors/lpil"),
              attr.class("sponsor-level0"),
            ],
            [html.text("and sponsors like you!")],
          ),
        ]),
      ]),
      html.section([attr.class("content home-pair")], [
        html.div([], [
          html.h2([], [html.text("Reliable and scalable")]),
          html.p([], [
            html.text(
              "Running on the battle-tested Erlang virtual machine that powers
              planet-scale systems such as WhatsApp and Ericsson, Gleam is ready for
              workloads of any size.",
            ),
          ]),
          html.p([], [
            html.text(
              "Thanks to its multi-core actor based concurrency system that can run
              millions of concurrent green threads, fast immutable data
              structures, and a concurrent garbage collector that never stops
              the world, your service can scale and stay lightning fast with ease.",
            ),
          ]),
        ]),
        highlighted_gleam_pre_code(
          "pub fn main() {
  // Run loads of green threads, no problem
  list.range(0, 200_000)
  |> list.each(fn(i) {
    let n = int.to_string(i)
    io.println(\"Hello from \" <> n)
  })
}",
        ),
      ]),
      html.section([attr.class("content home-pair")], [
        html.div([], [
          html.h2([], [html.text("Ready when you are")]),
          html.p([], [
            html.text(
              "Gleam comes with compiler, build tool, formatter, editor integrations,
              and package manager all built in, so creating a Gleam project is just
              running ",
            ),
            html.code([], [html.text("gleam new")]),
          ]),
          html.p([], [
            html.text(
              "As part of the wider BEAM ecosystem, Gleam programs can use thousands of
              published packages, whether they are written in Gleam, Erlang, or
              Elixir.",
            ),
          ]),
        ]),
        html.pre([], [
          html.code([], [
            html.span([attr.class("code-prompt")], [html.text("➜ (main)")]),
            html.text(" gleam add gleam_json\n"),
            html.span([attr.class("code-operator")], [html.text("  Resolving")]),
            html.text(" versions\n"),
            html.span([attr.class("code-operator")], [html.text("Downloading")]),
            html.text(" packages\n"),
            html.span([attr.class("code-operator")], [html.text(" Downloaded")]),
            html.text(" 2 packages in 0.01s\n"),
            html.span([attr.class("code-operator")], [html.text("      Added")]),
            html.text(" gleam_json v0.5.0\n"),
            html.span([attr.class("code-prompt")], [html.text("➜ (main)")]),
            html.text(" gleam test\n"),
            html.span([attr.class("code-operator")], [html.text(" Compiling")]),
            html.text(" thoas\n"),
            html.span([attr.class("code-operator")], [html.text(" Compiling")]),
            html.text(" gleam_json\n"),
            html.span([attr.class("code-operator")], [html.text(" Compiling")]),
            html.text(" app\n"),
            html.span([attr.class("code-operator")], [html.text("  Compiled")]),
            html.text(" in 1.67s\n"),
            html.span([attr.class("code-operator")], [html.text("   Running")]),
            html.text(" app_test.main\n"),
            html.span([attr.class("code-success")], [
              html.text(".\n1 tests, 0 failures"),
            ]),
          ]),
        ]),
      ]),
      html.section([attr.class("content home-pair")], [
        html.div([], [
          html.h2([], [html.text("Here to help")]),
          html.p([], [
            html.text(
              "No null values, no exceptions, clear error messages, and a practical
              type system. Whether you're writing new code or maintaining old code,
              Gleam is designed to make your job as fun and stress-free as possible.",
            ),
          ]),
        ]),
        html.pre([], [
          html.code([], [
            html.span([attr.class("code-error")], [html.text("error:")]),
            html.text(
              " Unknown record field

  ┌─ ./src/app.gleam:8:16
  │
8 │ user.alias
  │ ",
            ),
            html.span([attr.class("code-error")], [
              html.text("    ^^^^^^ Did you mean `name`?"),
            ]),
            html.text(
              "

The value being accessed has this type:
    User

It has these fields:
    .name
",
            ),
          ]),
        ]),
      ]),
      html.section([attr.class("content home-pair")], [
        html.div([], [
          html.h2([], [html.text("Multilingual")]),
          html.p([], [
            html.text(
              "Gleam makes it easy to use code written in other BEAM languages such as
              Erlang and Elixir, so there's a rich ecosystem of thousands of open
              source libraries for Gleam users to make use of.",
            ),
          ]),
          html.p([], [
            html.text(
              "Gleam can additionally compile to JavaScript, enabling you to use your
              code in the browser, or anywhere else JavaScript can run. It also
              generates TypeScript definitions, so you can interact with your Gleam
              code confidently, even from the outside.",
            ),
          ]),
        ]),
        highlighted_gleam_pre_code(
          "@external(erlang, \"Elixir.HPAX\", \"new\")
pub fn new(size: Int) -> Table



pub fn register_event_handler() {
  let el = document.query_selector(\"a\")
  element.add_event_listener(el, fn() {
    io.println(\"Clicked!\")
  })
}",
        ),
      ]),
      html.section([attr.class("home-friendly")], [
        html.div([attr.class("content")], [
          html.h2([], [html.text("Friendly 💜")]),
          html.p([], [
            html.text(
              "As a community, we want to be friendly too. People from around the
              world, of all backgrounds, genders, and experience levels are welcome
              and respected equally. See our community code of conduct for more.",
            ),
          ]),
          html.p([], [
            html.text(
              "Black lives matter. Trans rights are human rights. No nazi bullsh*t.",
            ),
          ]),
        ]),
        html.img([
          attr.alt("a soft wavey boundary between two sections of the website"),
          attr.src("/images/waves.svg"),
          attr.class("home-waves"),
        ]),
      ]),
      html.section([attr.class("home-sponsors")], [
        html.div([attr.class("content")], [
          html.h2([], [html.text("Lovely people")]),
          html.p([], [
            html.text("If you enjoy Gleam consider "),
            html.a([attr.href("https://github.com/sponsors/lpil")], [
              html.text("becoming a sponsor"),
            ]),
            html.text(" (or tell your boss to)"),
          ]),
        ]),
        wall_of_sponsors(),
      ]),
      html.section([attr.class("home-still-here")], [
        html.div([attr.class("content")], [
          html.h2([], [html.text("You're still here?")]),
          html.p([attr.class("go-read")], [
            html.text(
              "Well, that's all this page has to say. Maybe you should go read the language tour!",
            ),
          ]),
          html.a([attr.href("https://tour.gleam.run/"), attr.class("button")], [
            html.text("Let's go!"),
          ]),
          html.hr([]),
          html.h3([], [html.text("Wanna keep in touch?")]),
          html.p([], [html.text("Subscribe to the Gleam newsletter")]),
          html.script(
            [
              attr("data-form", "ebfa5ade-6f63-11ed-8f94-ef3b2b6b307a"),
              attr.src(
                "https://eocampaign1.com/form/ebfa5ade-6f63-11ed-8f94-ef3b2b6b307a.js",
              ),
              attr("async", ""),
            ],
            "",
          ),
          html.p([], [
            html.text(
              "We send emails at most a few times a year, and we'll never share your
              email with anyone else.",
            ),
          ]),
          html.p([attr.class("recaptcha-blerb")], [
            html.text("This site is protected by reCAPTCHA and the Google "),
            html.a([attr.href("https://policies.google.com/privacy")], [
              html.text("Privacy Policy"),
            ]),
            html.text(" and "),
            html.a([attr.href("https://policies.google.com/terms")], [
              html.text("Terms of Service"),
            ]),
            html.text(" apply."),
          ]),
        ]),
      ]),
    ]),
  ]

  content
  |> top_layout(meta, ctx)
  |> to_html_file(meta)
}

fn header(
  hero_image hero_image: option.Option(#(String, String)),
  content content: List(Element(a)),
) -> Element(a) {
  let hero_content = html.div([attr.class("text")], content)
  let hero_content = case hero_image {
    option.Some(#(src, alt)) -> [
      html.div(
        [attr("data-show-pride", ""), class("hero-lucy-container wide-only")],
        [html.img([attr.alt(alt), attr.src(src), attr.class("hero-lucy")])],
      ),
      hero_content,
    ]
    option.None -> [hero_content]
  }

  html.div([attr.class("page-header")], [
    html.nav([attr.class("navbar")], [
      html.div([attr.class("content")], [
        html.div([], [
          html.a([attr.href("/"), attr.class("logo")], [
            html.img([
              attr.alt("Lucy the star, Gleam's mascot"),
              attr.src("/images/lucy/lucy.svg"),
              attr.class("navbar-lucy"),
            ]),
            html.text("Gleam"),
          ]),
        ]),
        html.div([], [
          html.a([attr.href("/news")], [html.text("News")]),
          html.a([attr.href("/community")], [html.text("Community")]),
          html.a([attr.href("https://github.com/sponsors/lpil")], [
            html.text("Sponsor"),
          ]),
        ]),
        html.div([], [
          html.a([attr.href("https://packages.gleam.run")], [
            html.text("Packages"),
          ]),
          html.a([attr.href("/documentation")], [html.text("Docs")]),
          html.a([attr.href("https://github.com/gleam-lang")], [
            html.text("Code"),
          ]),
        ]),
      ]),
    ]),
    html.div([attr.class("hero")], [
      html.div([attr.class("content")], hero_content),
      html.img([
        attr.alt("a soft wavey boundary between two sections of the website"),
        attr.src("/images/waves.svg"),
        attr.class("home-waves"),
      ]),
    ]),
  ])
}

pub fn to_html_file(page_content: Element(a), meta: PageMeta) -> fs.File {
  fs.HtmlPage(
    path: meta.path,
    content: element.to_document_string(page_content),
  )
}

fn top_layout(
  page_content: List(Element(a)),
  page: PageMeta,
  ctx: site.Context,
) -> Element(a) {
  html.html([], [
    html.head([], head_elements(page, ctx)),
    html.body(
      [],
      list.append(page_content, [
        footer(ctx),
        html.script([attr.src("/javascript/main.js"), attr("async", "")], ""),
      ]),
    ),
  ])
}

fn head_elements(page: PageMeta, ctx: site.Context) -> List(element.Element(a)) {
  let metatag = fn(property, content) {
    html.meta([attr("property", property), attr("content", content)])
  }

  [
    html.meta([attr("charset", "utf-8")]),
    html.meta([attr("content", "width=device-width"), attr.name("viewport")]),
    html.link([attr.href("/images/lucy/lucy.svg"), attr.rel("shortcut icon")]),
    html.link([
      attr("title", "Gleam"),
      attr.href(ctx.hostname <> "/feed.xml"),
      attr.rel("alternate"),
      attr.type_("application/atom+xml"),
    ]),
    html.title([], page.title),
    html.meta([attr("content", page.description), attr.name("description")]),
    metatag("og:type", "website"),
    metatag("og:image", ctx.hostname <> "/images/social-image.png"),
    metatag("og:title", page.title),
    metatag("og:description", page.description),
    metatag("og:url", ctx.hostname <> "/" <> page.path),
    metatag("twitter:card", "summary_large_image"),
    metatag("twitter:url", ctx.hostname),
    metatag("twitter:title", page.title),
    metatag("twitter:description", page.description),
    metatag("twitter:image", ctx.hostname <> "/images/social-image.png"),
    html.script(
      [
        attr.src("https://plausible.io/js/plausible.js"),
        attr("data-domain", "gleam.run"),
        attr("defer", ""),
        attr("async", ""),
      ],
      "",
    ),
    html.link([
      attr.href("/styles/main.css?v=" <> ctx.styles_hash),
      attr.rel("stylesheet"),
    ]),
    ..list.map(page.preload_images, fn(href) {
      html.link([attr("as", "image"), attr.href(href), attr.rel("preload")])
    })
  ]
}

fn footer(ctx: site.Context) -> element.Element(a) {
  let footer_links = [
    #("News", "/news"),
    #("Cheat sheets", "/documentation#cheatsheets"),
    #("Discord", "https://discord.gg/Fm8Pwmy"),
    #("Code", "https://github.com/gleam-lang"),
    #("Language tour", "https://tour.gleam.run"),
    #("Playground", "https://playground.gleam.run"),
    #("Documentation", "/documentation"),
    #("Sponsor", "https://github.com/sponsors/lpil"),
    #("Packages", "https://packages.gleam.run/"),
    #("Gleam Weekly", "https://gleamweekly.com/"),
    #("Roadmap", "/roadmap"),
  ]

  let code_of_conduct =
    "https://github.com/gleam-lang/gleam/blob/main/CODE_OF_CONDUCT.md"

  let #(date, _) = timestamp.to_calendar(ctx.time, calendar.utc_offset)

  html.footer([class("footer")], [
    html.div([class("content")], [
      html.div([class("first")], [
        html.a([attr.href("/"), class("logo")], [
          html.img([
            attr.alt("Lucy the star, Gleam's mascot"),
            attr.src("/images/lucy/lucy.svg"),
            class("footer-lucy"),
          ]),
          html.text("Gleam"),
        ]),
      ]),
      html.ul(
        [class("middle")],
        list.map(footer_links, fn(pair) {
          html.li([], [html.a([attr.href(pair.1)], [html.text(pair.0)])])
        }),
      ),
      html.ul([class("last")], [
        html.li([], [
          html.text("© " <> int.to_string(date.year) <> " Louis Pilfold"),
        ]),
        html.li([], [
          html.a([attr.href(code_of_conduct)], [html.text("Code of conduct")]),
        ]),
      ]),
    ]),
  ])
}

fn wall_of_sponsors() -> Element(a) {
  let sponsors = list.shuffle(sponsor.sponsors)

  let sponsors_html =
    list.map(sponsors, fn(sponsor) {
      html.li([], [
        html.a(
          [attr.target("_blank"), attr.rel("noopener"), attr.href(sponsor.url)],
          [
            html.img([
              attr.alt(sponsor.name),
              attr.src(sponsor.avatar),
              attr.class("round"),
              attr("loading", "lazy"),
            ]),
          ],
        ),
      ])
    })

  html.div([attr.class("home-sponsors-list")], [
    html.ul(
      [attr("data-randomise-order", "")],
      list.flatten([
        sponsors_html,
        [html.a([attr("data-expand-sponsors", "")], [])],
      ]),
    ),
  ])
}

pub fn highlighted_gleam_pre_code(code: String) -> Element(a) {
  let html = contour.to_html(code)
  html.pre([], [html.code([attr("dangerous-unescaped-html", html)], [])])
}

pub fn highlighted_javascript_pre_code(code: String) -> Element(a) {
  let html = just.html(code)
  html.pre([], [html.code([attr("dangerous-unescaped-html", html)], [])])
}

fn highlighted_shell_pre_code(code: String) -> Element(c) {
  let html =
    code
    |> string.split("\n")
    |> list.map(fn(line) {
      let t = html.text(line)
      // TODO: real syntax highlighting
      case line {
        "#" <> _ -> html.span([attr.class("hl-comment")], [t])
        _ -> t
      }
    })
    |> list.intersperse(html.text("\n"))
  html.pre([], [html.code([], html)])
}

fn highlighted_toml_pre_code(code: String) -> Element(c) {
  let html =
    code
    |> string.split("\n")
    |> list.map(fn(line) {
      // TODO: real syntax highlighting
      case line {
        "#" <> _ -> [html.span([attr.class("hl-comment")], [html.text(line)])]
        "[" <> _ -> [html.span([attr.class("hl-module")], [html.text(line)])]
        _ ->
          case string.split_once(line, "=") {
            Ok(#(before, after)) -> [
              html.span([attr.class("hl-function")], [html.text(before)]),
              html.text("=" <> after),
            ]
            _ -> [html.text(line)]
          }
      }
    })
    |> list.intersperse([html.text("\n")])
    |> list.flatten
  html.pre([], [html.code([], html)])
}

fn highlighted_dockerfile_pre_code(code: String) -> Element(b) {
  // TODO: real syntax highlighting
  let html =
    code
    |> string.split("\n")
    |> list.map(fn(line) {
      case line {
        "RUN" as command <> rest
        | "FROM" as command <> rest
        | "COPY" as command <> rest
        | "WORKDIR" as command <> rest
        | "ENTRYPOINT" as command <> rest
        | "CMD" as command <> rest -> [
          html.span([attr.class("hl-function")], [html.text(command)]),
          html.text(rest),
        ]
        _ -> [html.text(line)]
      }
    })
    |> list.intersperse([html.text("\n")])
    |> list.flatten
  html.pre([], [html.code([], html)])
}

fn highlighted_yaml_pre_code(code: String) -> Element(d) {
  // TODO: real syntax highlighting
  let html =
    code
    |> string.split("\n")
    |> list.map(fn(line) {
      case string.split_once(line, ": ") {
        Ok(#(before, after)) -> [
          html.span([attr.class("hl-function")], [html.text(before)]),
          html.text(": " <> after),
        ]
        Error(_) ->
          case string.ends_with(line, ":") {
            True -> [html.span([attr.class("hl-function")], [html.text(line)])]
            False -> [html.text(line)]
          }
      }
    })
    |> list.intersperse([html.text("\n")])
    |> list.flatten
  html.pre([], [html.code([], html)])
}
