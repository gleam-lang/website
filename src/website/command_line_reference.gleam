import lustre/attribute as attr
import lustre/element/html
import website/fs
import website/page
import website/site

pub fn page(ctx: site.Context) -> fs.File {
  let meta =
    page.PageMeta(
      path: "command-line-reference",
      title: "Command line reference",
      description: "Getting things done in the terminal",
      preload_images: [],
    )

  [
    html.p([], [
      html.text("The "),
      html.code([], [html.text("gleam")]),
      html.text(
        " command uses subcommands to access different parts of the functionality:",
      ),
    ]),
    html.h2([attr.id("add")], [html.code([], [html.text("add")])]),
    html.p([], [html.code([], [html.text("gleam add [OPTIONS] <PACKAGES>...")])]),
    html.p([], [html.text("Add new project dependencies")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.code([], [html.text("--dev")])]),
          html.td([], [html.text("Add the packages as dev-only dependencies")]),
        ]),
      ]),
    ]),
    html.h2([attr.id("build")], [html.code([], [html.text("build")])]),
    html.p([], [html.code([], [html.text("gleam build [OPTIONS]")])]),
    html.p([], [html.text("Build the project")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.code([], [html.text("-t, --target <TARGET>")])]),
          html.td([], [html.text("The platform to target")]),
        ]),
        html.tr([], [
          html.td([], [html.code([], [html.text("--warnings-as-errors")])]),
          html.td([], [html.text("Emit compile time warnings as errors")]),
        ]),
      ]),
    ]),
    html.h2([attr.id("check")], [html.code([], [html.text("check")])]),
    html.p([], [html.code([], [html.text("gleam check [OPTIONS]")])]),
    html.p([], [html.text("Type check the project")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.code([], [html.text("-t, --target <TARGET>")])]),
          html.td([], [html.text("The platform to target")]),
        ]),
      ]),
    ]),
    html.h2([attr.id("clean")], [html.code([], [html.text("clean")])]),
    html.p([], [html.code([], [html.text("gleam clean")])]),
    html.p([], [html.text("Clean build artifacts")]),
    html.h2([attr.id("deps")], [html.code([], [html.text("deps")])]),
    html.p([], [html.code([], [html.text("gleam deps <SUBCOMMAND>")])]),
    html.p([], [html.text("Work with dependency packages")]),
    html.h3([attr.id("deps-download")], [
      html.code([], [html.text("deps download")]),
    ]),
    html.p([], [html.code([], [html.text("gleam deps download")])]),
    html.p([], [html.text("Download all dependency packages")]),
    html.h3([attr.id("deps-list")], [html.code([], [html.text("deps list")])]),
    html.p([], [html.code([], [html.text("gleam deps list")])]),
    html.p([], [html.text("List all dependency packages")]),
    html.h3([attr.id("deps-update")], [
      html.code([], [html.text("deps update")]),
    ]),
    html.p([], [html.code([], [html.text("gleam deps update")])]),
    html.p([], [
      html.text("Update dependency packages to their latest versions"),
    ]),
    html.h2([attr.id("docs")], [html.code([], [html.text("docs")])]),
    html.p([], [html.code([], [html.text("gleam docs <SUBCOMMAND>")])]),
    html.p([], [html.text("Render HTML documentation")]),
    html.h3([attr.id("docs-build")], [html.code([], [html.text("docs build")])]),
    html.p([], [html.code([], [html.text("gleam docs build [OPTIONS]")])]),
    html.p([], [html.text("Render HTML docs locally")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.code([], [html.text("--open")])]),
          html.td([], [html.text("Opens the docs in a browser after rendering")]),
        ]),
      ]),
    ]),
    html.h3([attr.id("docs-publish")], [
      html.code([], [html.text("docs publish")]),
    ]),
    html.p([], [html.code([], [html.text("gleam docs publish")])]),
    html.p([], [html.text("Publish HTML docs to HexDocs")]),
    html.p([], [html.text("This command uses this environment variables:")]),
    html.ul([], [
      html.li([], [
        html.text(
          "HEXPM_USER: (optional) The Hex username to authenticate with.",
        ),
      ]),
      html.li([], [
        html.text(
          "HEXPM_PASS: (optional) The Hex password to authenticate with.",
        ),
      ]),
    ]),
    html.h3([attr.id("docs-remove")], [
      html.code([], [html.text("docs remove")]),
    ]),
    html.p([], [
      html.code([], [
        html.text("gleam docs remove --package <PACKAGE> --version <VERSION>"),
      ]),
    ]),
    html.p([], [html.text("Remove HTML docs from HexDocs")]),
    html.p([], [html.text("This command uses this environment variables:")]),
    html.ul([], [
      html.li([], [
        html.text(
          "HEXPM_USER: (optional) The Hex username to authenticate with.",
        ),
      ]),
      html.li([], [
        html.text(
          "HEXPM_PASS: (optional) The Hex password to authenticate with.",
        ),
      ]),
    ]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [
            html.code([], [
              html.text("--package <PACKAGE> The name of the package"),
            ]),
          ]),
          html.td([], []),
        ]),
        html.tr([], [
          html.td([], [
            html.code([], [
              html.text("--version <VERSION> The version of the docs to remove"),
            ]),
          ]),
          html.td([], []),
        ]),
      ]),
    ]),
    html.h2([attr.id("export")], [html.code([], [html.text("export")])]),
    html.p([], [html.code([], [html.text("gleam export <SUBCOMMAND>")])]),
    html.p([], [html.text("Export something useful from the Gleam project")]),
    html.h3([attr.id("export-erlang-shipment")], [
      html.code([], [html.text("export erlang-shipment")]),
    ]),
    html.p([], [html.code([], [html.text("gleam export erlang-shipment")])]),
    html.p([], [html.text("Precompiled Erlang, suitable for deployment")]),
    html.h3([attr.id("export-hex-tarball")], [
      html.code([], [html.text("export hex-tarball")]),
    ]),
    html.p([], [html.code([], [html.text("gleam export hex-tarball")])]),
    html.p([], [
      html.text(
        "The package bundled into a tarball, suitable for publishing to Hex",
      ),
    ]),
    html.h3([attr.id("export-javascript-prelude")], [
      html.code([], [html.text("export javascript-prelude")]),
    ]),
    html.p([], [html.code([], [html.text("gleam export javascript-prelude")])]),
    html.p([], [html.text("The JavaScript prelude module")]),
    html.h3([attr.id("export-package-interface")], [
      html.code([], [html.text("export package-interface")]),
    ]),
    html.p([], [
      html.code([], [html.text("gleam export package-interface --out <OUTPUT>")]),
    ]),
    html.p([], [
      html.text(
        "Information on the modules, functions, and types in the project in JSON format",
      ),
    ]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.code([], [html.text("--out <OUTPUT>")])]),
          html.td([], [html.text("The path to write the JSON file to")]),
        ]),
      ]),
    ]),
    html.h3([attr.id("export-typescript-prelude")], [
      html.code([], [html.text("export typescript-prelude")]),
    ]),
    html.p([], [html.code([], [html.text("gleam export typescript-prelude")])]),
    html.p([], [html.text("The TypeScript prelude module")]),
    html.h2([attr.id("fix")], [html.code([], [html.text("fix")])]),
    html.p([], [html.code([], [html.text("gleam fix")])]),
    html.p([], [html.text("Rewrite deprecated Gleam code")]),
    html.h2([attr.id("format")], [html.code([], [html.text("format")])]),
    html.p([], [html.code([], [html.text("gleam format [OPTIONS] [FILES]...")])]),
    html.p([], [html.text("Format source code")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.code([], [html.text("--check")])]),
          html.td([], [
            html.text("Check if inputs are formatted without changing them"),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.code([], [html.text("--stdin")])]),
          html.td([], [html.text("Read source from STDIN")]),
        ]),
      ]),
    ]),
    html.h2([attr.id("help")], [html.code([], [html.text("help")])]),
    html.p([], [html.code([], [html.text("gleam help [SUBCOMMAND]...")])]),
    html.p([], [
      html.text("Print this message or the help of the given subcommand(s)"),
    ]),
    html.h2([attr.id("hex")], [html.code([], [html.text("hex")])]),
    html.p([], [html.code([], [html.text("gleam hex <SUBCOMMAND>")])]),
    html.p([], [html.text("Work with the Hex package manager")]),
    html.h3([attr.id("hex-retire")], [html.code([], [html.text("hex retire")])]),
    html.p([], [
      html.code([], [
        html.text("gleam hex retire <PACKAGE> <VERSION> <REASON> [MESSAGE]"),
      ]),
    ]),
    html.p([], [html.text("Retire a release from Hex")]),
    html.p([], [html.text("This command uses this environment variables:")]),
    html.ul([], [
      html.li([], [
        html.text(
          "HEXPM_USER: (optional) The Hex username to authenticate with.",
        ),
      ]),
      html.li([], [
        html.text(
          "HEXPM_PASS: (optional) The Hex password to authenticate with.",
        ),
      ]),
    ]),
    html.h3([attr.id("hex-unretire")], [
      html.code([], [html.text("hex unretire")]),
    ]),
    html.p([], [
      html.code([], [html.text("gleam hex unretire <PACKAGE> <VERSION>")]),
    ]),
    html.p([], [html.text("Un-retire a release from Hex")]),
    html.p([], [html.text("This command uses this environment variables:")]),
    html.ul([], [
      html.li([], [
        html.text(
          "HEXPM_USER: (optional) The Hex username to authenticate with.",
        ),
      ]),
      html.li([], [
        html.text(
          "HEXPM_PASS: (optional) The Hex password to authenticate with.",
        ),
      ]),
    ]),
    html.h2([attr.id("lsp")], [html.code([], [html.text("lsp")])]),
    html.p([], [html.code([], [html.text("gleam lsp")])]),
    html.p([], [html.text("Run the language server, to be used by editors")]),
    html.h2([attr.id("new")], [html.code([], [html.text("new")])]),
    html.p([], [
      html.code([], [html.text("gleam new [OPTIONS] <PROJECT_ROOT>")]),
    ]),
    html.p([], [html.text("Create a new project")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.code([], [html.text("--name <NAME>")])]),
          html.td([], [html.text("Name of the project")]),
        ]),
        html.tr([], [
          html.td([], [html.code([], [html.text("--skip-git")])]),
          html.td([], [
            html.text(
              "Skip git initialization and creation of .gitignore, .git/* and .github/* files",
            ),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.code([], [html.text("--skip-github")])]),
          html.td([], [html.text("Skip creation of .github/* files")]),
        ]),
        html.tr([], [
          html.td([], [html.code([], [html.text("--template <TEMPLATE>")])]),
          html.td([], [html.text("[default: lib] [possible values: lib]")]),
        ]),
      ]),
    ]),
    html.h2([attr.id("publish")], [html.code([], [html.text("publish")])]),
    html.p([], [html.code([], [html.text("gleam publish [OPTIONS]")])]),
    html.p([], [html.text("Publish the project to the Hex package manager")]),
    html.p([], [html.text("This command uses this environment variables:")]),
    html.ul([], [
      html.li([], [
        html.text(
          "HEXPM_USER: (optional) The Hex username to authenticate with.",
        ),
      ]),
      html.li([], [
        html.text(
          "HEXPM_PASS: (optional) The Hex password to authenticate with.",
        ),
      ]),
    ]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.code([], [html.text("--replace")])]),
          html.td([], []),
        ]),
        html.tr([], [
          html.td([], [html.code([], [html.text("-y, --yes")])]),
          html.td([], []),
        ]),
      ]),
    ]),
    html.h2([attr.id("remove")], [html.code([], [html.text("remove")])]),
    html.p([], [html.code([], [html.text("gleam remove <PACKAGES>...")])]),
    html.p([], [html.text("Remove project dependencies")]),
    html.h2([attr.id("run")], [html.code([], [html.text("run")])]),
    html.p([], [
      html.code([], [html.text("gleam run [OPTIONS] [ARGUMENTS]...")]),
    ]),
    html.p([], [html.text("Run the project")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.code([], [html.text("-m, --module <MODULE>")])]),
          html.td([], [html.text("The module to run")]),
        ]),
        html.tr([], [
          html.td([], [html.code([], [html.text("--runtime <RUNTIME>")])]),
          html.td([], []),
        ]),
        html.tr([], [
          html.td([], [html.code([], [html.text("-t, --target <TARGET>")])]),
          html.td([], [html.text("The platform to target")]),
        ]),
      ]),
    ]),
    html.h2([attr.id("shell")], [html.code([], [html.text("shell")])]),
    html.p([], [html.code([], [html.text("gleam shell")])]),
    html.p([], [html.text("Start an Erlang shell")]),
    html.h2([attr.id("test")], [html.code([], [html.text("test")])]),
    html.p([], [
      html.code([], [html.text("gleam test [OPTIONS] [ARGUMENTS]...")]),
    ]),
    html.p([], [html.text("Run the project tests")]),
    html.table([], [
      html.thead([], [
        html.tr([], [
          html.th([], [html.text("Option")]),
          html.th([], [html.text("Description")]),
        ]),
      ]),
      html.tbody([], [
        html.tr([], [
          html.td([], [html.code([], [html.text("--runtime <RUNTIME>")])]),
          html.td([], []),
        ]),
        html.tr([], [
          html.td([], [html.code([], [html.text("-t, --target <TARGET>")])]),
          html.td([], [html.text("The platform to target")]),
        ]),
      ]),
    ]),
    html.h2([attr.id("update")], [html.code([], [html.text("update")])]),
    html.p([], [html.code([], [html.text("gleam update")])]),
    html.p([], [
      html.text("Update dependency packages to their latest versions"),
    ]),
  ]
  |> page.page_layout("roadmap", meta, ctx)
  |> page.to_html_file(meta)
}
