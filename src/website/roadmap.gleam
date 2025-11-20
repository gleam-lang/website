import gleam/list
import gleam/option
import gleam/time/calendar
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import website/fs
import website/page
import website/site

const in_progress = [
  "Function inlining to improve performance and stack usage",
  "Dependency version conflict resolution assistant",
  "Security related package management features",
  "External type annotation for better integration with BEAM and JavaScript static type checkers",
]

const planned = [
  "New OTP application initialisation interface",
  "Code linking syntax for documentation comments",
  "JavaScript record performance improvements",
  "Hex private package support",
  "Mutual tail call optimisation on JavaScript",
  "API key generation when Hex rate limits reached",
  "Lifting constant expressions into global scope on JavaScript",
  "Dependency package licence compliance checks",
]

const research = [
  "OTP release building",
  "Erlang stack trace line numbers",
  "Test discovery functionality",
  "Build tool watch mode",
  "FFI type correctness safeguards in development",
  "Improved ergonomics for cross-target packages",
]

const done = [
  Release(
    version: "v1.13",
    date: calendar.Date(2025, calendar.October, 19),
    items: [
      "Bit array pattern matching compilation improvements",
      "Dependency version change information printing",
      "Improved type name selection in language server and documentation",
      "Unified JavaScript API for Gleam data types",
      "Unused recursive function argument detection",
      "Language server \"add omitted labels\" code action",
      "Language server \"extract function\" code action",
      "Language server \"collapse nested case\" code action",
      "Language server \"remove unreachable clauses\" code action",
      "Language server \"pattern match on value\" code action improvements",
      "Language server inter-module \"generate function\" code action",
    ],
  ),
  Release(
    version: "gleam_otp v1.0",
    date: calendar.Date(2025, calendar.October, 3),
    items: [
      "Dynamic process supervision",
    ],
  ),
  Release(
    version: "v1.12",
    date: calendar.Date(2025, calendar.August, 5),
    items: [
      "Custom messages for `echo`",
      "JSDoc comments in generated JavaScript",
      "Dead code elimination for definitions",
      "Redundant comparison detection",
      "Generated code size improvements for record updates",
      "Calculation support in bit array pattern size segments",
      "Alerting for when new major dependency versions are available",
      "Improved error messages for dependency version conflicts",
      "Programmer choice support for list formatting",
      "Endianness for UTF bit array segments",
      "Same-module Erlang small function inlining",
      "Version git tag prefix for monorepos",
      "Redundant comparison detection",
      "Language server \"remove block\" code action",
    ],
  ),
  Release(
    version: "gleam_erlang v1.0, gleam_otp v1.0",
    date: calendar.Date(2025, calendar.June, 12),
    items: [
      "Named process support", "Improved actor API", "Improved supervision API",
      "Improved process API", "Improved selective receive API",
      "Improved atom API",
    ],
  ),
  Release(
    version: "v1.11",
    date: calendar.Date(2025, calendar.June, 2),
    items: [
      "Generating `case` expressions using a decision tree on JavaScript",
      "Test keyword `assert`", "Language server constant expression completion",
      "\"gleam dev\" command", "Side-effectless unused expression detection",
      "Hyperlinks to referenced types in generated HTML documentation",
      "UTF8 and UTF16 JavaScript bit array support",
      "Windows ARM precompiled binaries", "Bit array truncation warnings",
      "Record labels in exhaustiveness errors",
      "Language server \"fill labels\" code action for pattern",
      "Language server \"generate variant\" code action",
      "Language server \"remove unused imports\" code action complete",
    ],
  ),
  Release(
    version: "v1.10",
    date: calendar.Date(2025, calendar.April, 14),
    items: [
      "Bit array exhaustiveness analysis",
      "Dead code detection, including reference loops",
      "Fault tolerant analysis of binary operators",
      "JavaScript performance improvement via immediately invoked function expression removal",
      "Software Bill of Materials (SBoM) and Supply-chain Levels for Software Artifacts (SLSA) Provenance information in container images",
      "`gleam export package-information` command",
      "Language server find references", "Language server rename constant",
      "Language server rename custom type variant",
      "Language server rename function", "Language server rename type",
      "Language server \"extract constant\" code action",
      "Language server \"fill unused fields\" code action",
      "Language server \"remove echo\" code action",
      "Language server \"wrap in block\" code action",
      "Optional float annotations for float literals in bit arrays",
    ],
  ),
  Release(
    version: "v1.9",
    date: calendar.Date(2025, calendar.March, 08),
    items: [
      "Custom CA certificate support", "Debug keyword `echo`",
      "Hex search integration",
      "Improved dependency version conflict error messages",
      "Unaligned bit array support on JavaScript",
      "Language server jump to type definition",
      "Language server convert call to pipeline code action",
      "Language server convert pipeline to call code action",
      "Language server generate JSON encoder code action",
      "Language server inline variable code action",
      "Language server interpolate string code action",
    ],
  ),
  Release(
    version: "v1.8",
    date: calendar.Date(2025, calendar.February, 07),
    items: [
      "Language server label completion",
      "Fault tolerant parsing of `case` expressions",
      "Fault tolerant analysis of pipelines", "Support OTP27 doc attributes",
      "Language server generate function code action",
      "Language server pattern match on value code action",
      "Language server rename variable code action",
    ],
  ),
  Release(
    version: "v1.7",
    date: calendar.Date(2025, calendar.January, 05),
    items: [
      "Custom message syntax for `let assert`",
      "Custom type construction codegen monomorphisation",
      "Custom type constructor deprecation",
      "Custom type update type re-specialisation",
      "External file subdirectory support",
      "Language server `let` to `case` code action",
      "Language server convert to/from `use` code action",
      "Language server extract variable code action",
      "Language server code action to generate dynamic decoder",
      "Local Hex API key encryption",
    ],
  ),
  Release(
    version: "v1.6",
    date: calendar.Date(2024, calendar.November, 19),
    items: [
      "BEAM bytecode compilation daemon",
      "Bit array construction optimisation on JavaScript",
      "Context aware type error printing", "Custom type variant inference",
      "JavaScript `gleam new` template",
      "Language server add missing function annotations code action",
      "Language server context aware type hover display",
      "Language server qualify and unqualify code actions",
      "Monorepo support for HTML documentation",
      "Optional Hex dependency support", "Specific packages `gleam update`",
      "Unsafe JavaScript number warnings",
    ],
  ),
  Release(
    version: "v1.5",
    date: calendar.Date(2024, calendar.September, 19),
    items: [
      "Bit array UTF-8 segment inference",
      "Compilation flag `--no-print-progress`",
      "Context aware anonymous function inference",
      "Context aware inexhaustive case expression errors",
      "Gleam version requirement detection", "Improved panic printing on Erlang",
      "Language server add missing case patterns code action",
      "Language server local variable autocompletion",
      "Language server missing import fix code action",
    ],
  ),
  Release(
    version: "v1.4",
    date: calendar.Date(2024, calendar.August, 02),
    items: [
      "Bit array options `little`, `big`, `signed`, and `unsigned` JavaScript support.",
      "Compilation warning persistence",
      "Constant expression concat operator support",
      "Further fault tolerant compilation", "Label shorthand syntax",
      "Language server add labels code action",
      "Language server assert to case code action",
      "Language server case correction code action",
      "Language server document symbols",
      "Language server field access completion",
      "Language server label shorthand conversion code action",
      "Language server signature help",
    ],
  ),
  Release(
    version: "v1.3",
    date: calendar.Date(2024, calendar.July, 05),
    items: [
      "`gleam add` and `gleam remove`", "Arithmetic guards",
      "Erlang/OTP 27 support", "Fault tolerant expression compilation",
      "Language server automatic import insertion",
      "Language server unused field hovering",
      "Purity hints for JavaScript bundlers",
    ],
  ),
  Release(
    version: "v1.2",
    date: calendar.Date(2024, calendar.May, 27),
    items: [
      "`gleam hex revert`", "Erlang module collision prevention",
      "Fault tolerant compilation",
      "Language server import autocompletion and hover",
      "Redundant `let assert` detection", "Unreachable code detection",
    ],
  ),
  Release(
    version: "v1.1",
    date: calendar.Date(2024, calendar.April, 16),
    items: [
      "Bun JavaScript runtime support", "Internal types and values",
      "Language server compilation batching", "Language server go-to definition",
      "Language server import autocompletion", "Nested tuple indexing",
      "Target related dead code elimination",
    ],
  ),
]

type Release {
  Release(version: String, date: calendar.Date, items: List(String))
}

pub fn page(ctx: site.Context) -> fs.File {
  let meta =
    page.PageMeta(
      path: "roadmap",
      title: "Gleam's Development Roadmap",
      meta_title: "Gleam's Development Roadmap",
      subtitle: "What's coming next?",
      description: "See what's been released, what's being worked on, and what's coming in the future!",
      preload_images: [],
      preview_image: option.None,
    )

  let changelog = "https://github.com/gleam-lang/gleam/tree/main/CHANGELOG.md"
  let changelogs = "https://github.com/gleam-lang/gleam/tree/main/changelog"
  let issues = "https://github.com/gleam-lang/gleam/issues"

  let list = fn(items, formatter) {
    html.ul(
      [attr.class("roadmap-list")],
      list.map(items, fn(item) { html.li([], [formatter(item)]) }),
    )
  }
  let section = fn(title, blurb, items) {
    element.fragment([
      html.h2([], [html.text(title)]),
      html.p([], [html.text(blurb)]),
      list(items, html.text),
    ])
  }

  [
    html.p([], [
      html.text(
        "The highlights of what's been released, what's being worked on, and what's
  coming in future! To see all the details please see the ",
      ),
      html.a([attr.href(changelog)], [html.text("current changelogs")]),
      html.text(", the "),
      html.a([attr.href(changelogs)], [html.text("historical changelogs")]),
      html.text(", and the "),
      html.a([attr.href(issues)], [html.text("issue tracker")]),
      html.text("."),
    ]),
    section(
      "In progress",
      "Features that are currently being worked on, or complete but not yet released.",
      in_progress,
    ),
    section(
      "Planned",
      "Features that will be implemented, but work has not yet started.",
      planned,
    ),
    section(
      "Research",
      "Features that likely will be added in future, but we have some outstanding
  design questions to resolve.",
      research,
    ),
    html.h2([], [html.text("Done")]),
    html.ol(
      [attr.class("roadmap-release-list")],
      list.map(done, fn(release) {
        let title =
          release.version <> " - " <> page.short_human_date(release.date)
        html.li([], [
          html.h3([], [html.text(title)]),
          html.ul(
            [attr.class("roadmap-list")],
            list.map(release.items, fn(item) { html.li([], [html.text(item)]) }),
          ),
        ])
      }),
    ),
  ]
  |> page.page_layout("roadmap", meta, ctx)
  |> page.to_html_file(meta)
}
