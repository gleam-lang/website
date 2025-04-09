import gleam/list
import gleam/time/calendar
import lustre/attribute as attr
import lustre/element
import lustre/element/html
import website/fs
import website/page
import website/site

const in_progress = [
  "JavaScript sourcemaps", "OTP named process support",
  "Generating `case` expressions using a decision tree on JavaScript",
  "Language server extract const code action",
  "Removing Instantly Invoked Function Expressions from generated JavaScript code",
]

const planned = [
  "Dead code detection improvements", "Hex private package support",
  "Language server constant expression completion", "Language server renaming",
  "Mutual tail call optimisation on JavaScript", "Test keyword `assert`",
  "API key generation when Hex rate limits reached",
  "Lifting constant expressions into global scope on JavaScript",
]

const research = [
  "OTP release building", "Erlang stack trace line numbers",
  "Inter-module inlining", "Test discovery functionality",
  "Build tool watch mode",
]

const done = [
  Release(
    version: "v1.9",
    date: calendar.Date(2025, calendar.March, 08),
    items: [
      "Custom CA certificate support", "Debug keyword `echo`",
      "Hex search integration",
      "Improved dependency versions conflict error messages",
      "Unaligned bit array support on JavaScript",
      "Langauge server jump to type definition",
      "Langauge server convert call to pipeline code action",
      "Langauge server convert pipeline to call code action",
      "Langauge server generate JSON encoder code action",
      "Langauge server inline variable code action",
      "Langauge server interpolate string code action",
    ],
  ),
  Release(
    version: "v1.8",
    date: calendar.Date(2025, calendar.February, 07),
    items: [
      "Language server label completion",
      "Fault tolerant parsing of `case` expressions",
      "Fault tolerant analysis of pipelines", "Support OTP27 doc attributes",
      "Langauge server generate function code action",
      "Langauge server pattern match on value code action",
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
      "Language server quality and unqualify code actions",
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
      "Language server lable shorthand conversion code action",
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
      description: "What's coming next?",
      preload_images: [],
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
