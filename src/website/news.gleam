import filepath
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import gleam/time/calendar
import jot
import lustre/attribute.{class} as attr
import lustre/element
import lustre/element/html
import snag
import website/fs
import website/page.{PageMeta}
import website/site

pub fn all() -> snag.Result(List(NewsPost)) {
  io.print("Loading news posts: ")
  let posts = [
    read(
      title: "Formalising external APIs",
      subtitle: "Gleam v1.13.0 released",
      published: calendar.Date(2025, calendar.October, 16),
      author: louis,
      path: "formalising-external-apis",
    ),
    read(
      title: "No more dependency management headaches",
      subtitle: "Gleam v1.12.0 released",
      published: calendar.Date(2025, calendar.August, 5),
      author: louis,
      path: "no-more-dependency-management-headaches",
    ),
    read(
      title: "Gleam JavaScript gets 30% faster",
      subtitle: "Gleam v1.11.0 released",
      published: calendar.Date(2025, calendar.June, 2),
      author: louis,
      path: "gleam-javascript-gets-30-percent-faster",
    ),
    read(
      title: "Global rename and find references",
      subtitle: "Gleam v1.10.0 released",
      published: calendar.Date(2025, calendar.April, 14),
      author: louis,
      path: "global-rename-and-find-references",
    ),
    read(
      title: "Hello echo! Hello git!",
      subtitle: "Gleam v1.9.0 released",
      published: calendar.Date(2025, calendar.March, 08),
      author: louis,
      path: "hello-echo-hello-git",
    ),
    read(
      title: "Gleam gets “rename variable”",
      subtitle: "Gleam v1.8.0 released",
      published: calendar.Date(2025, calendar.February, 07),
      author: louis,
      path: "gleam-gets-rename-variable",
    ),
    read(
      title: "Developer Survey 2024 Results",
      subtitle: "A look at the Gleam community after version one",
      published: calendar.Date(2025, calendar.February, 06),
      author: louis,
      path: "developer-survey-2024-results",
    ),
    read(
      title: "Improved performance and publishing",
      subtitle: "Gleam v1.7.0 released",
      published: calendar.Date(2025, calendar.January, 05),
      author: louis,
      path: "improved-performance-and-publishing",
    ),
    read(
      title: "Introducing the Gleam roadmap!",
      subtitle: "A bird's eye view of what's happening in Gleam",
      published: calendar.Date(2024, calendar.December, 06),
      author: louis,
      path: "introducing-the-gleam-roadmap",
    ),
    read(
      title: "Context aware compilation",
      subtitle: "Gleam v1.6.0 released",
      published: calendar.Date(2024, calendar.November, 18),
      author: louis,
      path: "context-aware-compilation",
    ),
    read(
      title: "Developer Survey 2024",
      subtitle: "Who are the Gleamlins anyway?",
      published: calendar.Date(2024, calendar.November, 05),
      author: louis,
      path: "developer-survey-2024",
    ),
    read(
      title: "Convenient code actions",
      subtitle: "Gleam v1.5.0 released",
      published: calendar.Date(2024, calendar.September, 19),
      author: louis,
      path: "convenient-code-actions",
    ),
    read(
      title: "Welcome Lambda!",
      subtitle: "Gleam's new corporate sponsor",
      published: calendar.Date(2024, calendar.August, 26),
      author: louis,
      path: "welcome-lambda",
    ),
    read(
      title: "Supercharged labels",
      subtitle: "Gleam v1.4.0 released",
      published: calendar.Date(2024, calendar.August, 02),
      author: louis,
      path: "supercharged-labels",
    ),
    read(
      title: "Auto-imports and tolerant expressions",
      subtitle: "Gleam v1.3.0 released",
      published: calendar.Date(2024, calendar.July, 09),
      author: louis,
      path: "auto-imports-and-tolerant-expressions",
    ),
    read(
      title: "Fault tolerant Gleam",
      subtitle: "Gleam v1.2.0 released",
      published: calendar.Date(2024, calendar.May, 27),
      author: louis,
      path: "fault-tolerant-gleam",
    ),
    read(
      title: "Gleam version v1.1",
      subtitle: "Hot on the heels of v1",
      published: calendar.Date(2024, calendar.April, 16),
      author: louis,
      path: "gleam-v1.1",
    ),
    read(
      title: "Gleam version 1",
      subtitle: "It's finally here! 🎉",
      published: calendar.Date(2024, calendar.March, 04),
      author: louis,
      path: "gleam-version-1",
    ),
    read(
      title: "Gleam's new interactive language tour",
      subtitle: "Learn Gleam in your browser!",
      published: calendar.Date(2024, calendar.January, 19),
      author: louis,
      path: "gleams-new-interactive-language-tour",
    ),
    read(
      title: "Multi-target projects",
      subtitle: "Gleam v0.34 released",
      published: calendar.Date(2024, calendar.January, 16),
      author: louis,
      path: "v0.34-multi-target-projects",
    ),
    read(
      title: "Exhaustive Gleam",
      subtitle: "Gleam v0.33 released",
      published: calendar.Date(2023, calendar.December, 18),
      author: louis,
      path: "v0.33-exhaustive-gleam",
    ),
    read(
      title: "Polishing syntax for stability",
      subtitle: "Gleam v0.32 released",
      published: calendar.Date(2023, calendar.November, 01),
      author: louis,
      path: "v0.32-polishing-syntax-for-stability",
    ),
    read(
      title: "Keeping dependencies explicit",
      subtitle: "Gleam v0.31 released",
      published: calendar.Date(2023, calendar.September, 25),
      author: louis,
      path: "v0.31-keeping-dependencies-explicit",
    ),
    read(
      title: "Local dependencies and enhanced externals",
      subtitle: "Gleam v0.30 released",
      published: calendar.Date(2023, calendar.July, 12),
      author: louis,
      path: "v0.30-local-dependencies-and-enhanced-externals",
    ),
    read(
      title: "Gleam gets autocompletion",
      subtitle: "Gleam v0.29 released",
      published: calendar.Date(2023, calendar.May, 23),
      author: louis,
      path: "v0.29-gleam-gets-autocompletion",
    ),
    read(
      title: "Introducing the Gleam package index",
      subtitle: "Find packages for your Gleam projects",
      published: calendar.Date(2023, calendar.April, 30),
      author: louis,
      path: "introducing-the-gleam-package-index",
    ),
    read(
      title: "Monorepos, fast maps, and more",
      subtitle: "Gleam v0.28 released",
      published: calendar.Date(2023, calendar.April, 03),
      author: louis,
      path: "v0.28-monorepos-fast-maps-and-more",
    ),
    read(
      title: "Hello panic, goodbye try",
      subtitle: "Gleam v0.27 released",
      published: calendar.Date(2023, calendar.March, 01),
      author: louis,
      path: "v0.27-hello-panic-goodbye-try",
    ),
    read(
      title: "Incremental compilation, and hello Deno!",
      subtitle: "Gleam v0.26 released",
      published: calendar.Date(2023, calendar.January, 19),
      author: louis,
      path: "v0.26-incremental-compilation-and-deno",
    ),
    read(
      title: "Developer Survey 2022 Results",
      subtitle: "What did we learn about the Gleamers?",
      published: calendar.Date(2022, calendar.December, 16),
      author: louis,
      path: "developer-survey-2022-results",
    ),
    read(
      title: "Introducing use expressions!",
      subtitle: "Gleam v0.25 released",
      published: calendar.Date(2022, calendar.November, 24),
      author: louis,
      path: "v0.25-introducing-use-expressions",
    ),
    read(
      title: "Gleam v0.24 released!",
      subtitle: "",
      published: calendar.Date(2022, calendar.October, 25),
      author: louis,
      path: "gleam-v0.24-released",
    ),
    read(
      title: "Gleam v0.23 released!",
      subtitle: "",
      published: calendar.Date(2022, calendar.September, 18),
      author: louis,
      path: "gleam-v0.23-released",
    ),
    read(
      title: "Gleam v0.22 released!",
      subtitle: "",
      published: calendar.Date(2022, calendar.June, 19),
      author: louis,
      path: "gleam-v0.22-released",
    ),
    read(
      title: "Introducing the Gleam language server!",
      subtitle: "",
      published: calendar.Date(2022, calendar.April, 24),
      author: louis,
      path: "v0.21-introducing-the-gleam-language-server",
    ),
    read(
      title: "Gleam v0.20 released!",
      subtitle: "",
      published: calendar.Date(2022, calendar.February, 23),
      author: louis,
      path: "gleam-v0.20-released",
    ),
    read(
      title: "Gleam v0.19 released!",
      subtitle: "",
      published: calendar.Date(2022, calendar.January, 12),
      author: louis,
      path: "gleam-v0.19-released",
    ),
    read(
      title: "Gleam v0.18 released!",
      subtitle: "",
      published: calendar.Date(2021, calendar.December, 06),
      author: louis,
      path: "gleam-v0.18-released",
    ),
    read(
      title: "Gleam v0.17 released!",
      subtitle: "",
      published: calendar.Date(2021, calendar.September, 20),
      author: louis,
      path: "gleam-v0.17-released",
    ),
    read(
      title: "Gleam compiles to JavaScript!",
      subtitle: "Gleam v0.16 released",
      published: calendar.Date(2021, calendar.June, 17),
      author: louis,
      path: "v0.16-gleam-compiles-to-javascript",
    ),
    read(
      title: "Gleam v0.15 released!",
      subtitle: "",
      published: calendar.Date(2021, calendar.May, 06),
      author: louis,
      path: "gleam-v0.15-released",
    ),
    read(
      title: "Gleam v0.14 released!",
      subtitle: "",
      published: calendar.Date(2021, calendar.February, 18),
      author: louis,
      path: "gleam-v0.14-released",
    ),
    read(
      title: "Gleam v0.13 released!",
      subtitle: "",
      published: calendar.Date(2021, calendar.January, 13),
      author: louis,
      path: "gleam-v0.13-released",
    ),
    read(
      title: "Gleam v0.12 and Gleam OTP v0.1 released! 🎃",
      subtitle: "",
      published: calendar.Date(2020, calendar.October, 31),
      author: louis,
      path: "gleam-v0.12-and-gleam-otp-v0.1-released",
    ),
    read(
      title: "Gleam v0.11 released!",
      subtitle: "",
      published: calendar.Date(2020, calendar.August, 28),
      author: louis,
      path: "gleam-v0.11-released",
    ),
    read(
      title: "Gleam v0.10 released!",
      subtitle: "",
      published: calendar.Date(2020, calendar.July, 01),
      author: louis,
      path: "gleam-v0.10-released",
    ),
    read(
      title: "Gleam v0.9 released!",
      subtitle: "",
      published: calendar.Date(2020, calendar.June, 1),
      author: louis,
      path: "gleam-v0.9-released",
    ),
    read(
      title: "Gleam v0.8 released!",
      subtitle: "",
      published: calendar.Date(2020, calendar.May, 7),
      author: louis,
      path: "gleam-v0.8-released",
    ),
    read(
      title: "Gleam v0.7 released!",
      subtitle: "",
      published: calendar.Date(2020, calendar.March, 1),
      author: louis,
      path: "gleam-v0.7-released",
    ),
    read(
      title: "Gleam v0.6 released!",
      subtitle: "",
      published: calendar.Date(2019, calendar.December, 25),
      author: louis,
      path: "gleam-v0.6-released",
    ),
    read(
      title: "Gleam v0.5 released!",
      subtitle: "",
      published: calendar.Date(2019, calendar.December, 16),
      author: louis,
      path: "gleam-v0.5-released",
    ),
    read(
      title: "Gleam v0.4 released!",
      subtitle: "",
      published: calendar.Date(2019, calendar.September, 19),
      author: louis,
      path: "gleam-v0.4-released",
    ),
    read(
      title: "Gleam v0.3 released!",
      subtitle: "",
      published: calendar.Date(2019, calendar.August, 07),
      author: louis,
      path: "gleam-v0.3-released",
    ),
    read(
      title: "Hello, Gleam!",
      subtitle: "There's a new friendly language in town",
      published: calendar.Date(2019, calendar.April, 15),
      author: louis,
      path: "hello-gleam",
    ),
  ]
  io.print("\n")
  posts
  |> result.all()
}

const louis = Author(name: "Louis Pilfold", url: "https://github.com/lpil")

pub type NewsPost {
  NewsPost(
    title: String,
    subtitle: String,
    published: calendar.Date,
    author: Author,
    path: String,
    content: String,
  )
}

pub type Author {
  Author(name: String, url: String)
}

fn read(
  title title: String,
  subtitle subtitle: String,
  published published: calendar.Date,
  author author: Author,
  path path: String,
) -> snag.Result(NewsPost) {
  io.print(".")
  filepath.join("posts", path)
  |> string.append(".djot")
  |> fs.read
  |> snag.context("Failed to load content for /news/" <> path)
  |> result.map(djot_to_html)
  |> result.map(NewsPost(_, title:, subtitle:, published:, author:, path:))
}

fn djot_to_html(string: String) -> String {
  page.parse_djot(string)
  |> jot.document_to_html
}

pub fn page(post: NewsPost, ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "news/" <> post.path,
      title: post.title,
      subtitle: post.subtitle,
      description: "News post: " <> post.subtitle,
      meta_title: post.title <> " | Gleam programming language",
      preload_images: [],
      preview_image: option.None,
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
          html.time([], [html.text(page.short_human_date(post.published))]),
          html.text(" by "),
          html.a([attr.href(post.author.url)], [html.text(post.author.name)]),
        ]),
        page.share_button(),
      ]),
      element.unsafe_raw_html("", "article", [class("prose")], post.content),
    ]),
  ]
  |> page.page_layout("", meta, ctx)
  |> page.to_html_file(meta)
}

pub fn index_page(posts: List(NewsPost), ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "news",
      title: "News",
      meta_title: "News | Gleam programming language",
      subtitle: "What's happening in the Gleam world?",
      description: "Check what's happening in the Gleam world: stay up to date with Gleam’s latest releases, feature announcements, and project updates.",
      preload_images: [],
      preview_image: option.None,
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
            html.text(page.short_human_date(post.published)),
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
  |> page.page_layout("", meta, ctx)
  |> page.to_html_file(meta)
}
