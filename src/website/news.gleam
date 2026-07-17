import atomb
import filepath
import gleam/dynamic/decode
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import gleam/string_tree
import gleam/time/calendar
import gleam/time/timestamp
import jot
import lustre/attribute.{class} as attr
import lustre/element
import lustre/element/html
import snag
import tom
import website/fs
import website/page
import website/site

// pub fn all() -> snag.Result(List(NewsData)) {
//   io.print("Loading news posts: ")
//   let posts = [
//     read(
//       title: "Single file Gleam BEAM programs with escript",
//       subtitle: "Gleam v1.17.0 released!",
//       published: calendar.Date(2026, calendar.June, 2),
//       author: louis,
//       path: "single-file-gleam-beam-programs-with-escript",
//       preview_image: option.Some("v1.17"),
//     ),
//     read(
//       title: "JavaScript source maps",
//       subtitle: "Gleam v1.16.0 released!",
//       published: calendar.Date(2026, calendar.April, 24),
//       author: louis,
//       path: "javascript-source-maps",
//       preview_image: option.Some("v1.16"),
//     ),
//     read(
//       title: "Upgrading Hex security",
//       subtitle: "Gleam v1.15.0 released!",
//       published: calendar.Date(2026, calendar.March, 16),
//       author: louis,
//       path: "upgrading-hex-security",
//       preview_image: option.Some("v1.15"),
//     ),
//     read(
//       title: "Join us at Gleam Gathering",
//       subtitle: "The first ever all Gleam conference!",
//       published: calendar.Date(2026, calendar.February, 11),
//       author: louis,
//       path: "join-us-at-gleam-gathering",
//       preview_image: option.None,
//     ),
//     read(
//       title: "The happy holidays release 2025 🎁",
//       subtitle: "Gleam v1.14.0 released",
//       published: calendar.Date(2025, calendar.December, 25),
//       author: louis,
//       path: "the-happy-holidays-2025-release",
//       preview_image: option.Some("xmas-2025"),
//     ),
//     read(
//       title: "Formalising external APIs",
//       subtitle: "Gleam v1.13.0 released",
//       published: calendar.Date(2025, calendar.October, 19),
//       author: louis,
//       path: "formalising-external-apis",
//       preview_image: option.None,
//     ),
//     read(
//       title: "No more dependency management headaches",
//       subtitle: "Gleam v1.12.0 released",
//       published: calendar.Date(2025, calendar.August, 5),
//       author: louis,
//       path: "no-more-dependency-management-headaches",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam JavaScript gets 30% faster",
//       subtitle: "Gleam v1.11.0 released",
//       published: calendar.Date(2025, calendar.June, 2),
//       author: louis,
//       path: "gleam-javascript-gets-30-percent-faster",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Global rename and find references",
//       subtitle: "Gleam v1.10.0 released",
//       published: calendar.Date(2025, calendar.April, 14),
//       author: louis,
//       path: "global-rename-and-find-references",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Hello echo! Hello git!",
//       subtitle: "Gleam v1.9.0 released",
//       published: calendar.Date(2025, calendar.March, 08),
//       author: louis,
//       path: "hello-echo-hello-git",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam gets “rename variable”",
//       subtitle: "Gleam v1.8.0 released",
//       published: calendar.Date(2025, calendar.February, 07),
//       author: louis,
//       path: "gleam-gets-rename-variable",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Developer Survey 2024 Results",
//       subtitle: "A look at the Gleam community after version one",
//       published: calendar.Date(2025, calendar.February, 06),
//       author: louis,
//       path: "developer-survey-2024-results",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Improved performance and publishing",
//       subtitle: "Gleam v1.7.0 released",
//       published: calendar.Date(2025, calendar.January, 05),
//       author: louis,
//       path: "improved-performance-and-publishing",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Introducing the Gleam roadmap!",
//       subtitle: "A bird's eye view of what's happening in Gleam",
//       published: calendar.Date(2024, calendar.December, 06),
//       author: louis,
//       path: "introducing-the-gleam-roadmap",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Context aware compilation",
//       subtitle: "Gleam v1.6.0 released",
//       published: calendar.Date(2024, calendar.November, 18),
//       author: louis,
//       path: "context-aware-compilation",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Developer Survey 2024",
//       subtitle: "Who are the Gleamlins anyway?",
//       published: calendar.Date(2024, calendar.November, 05),
//       author: louis,
//       path: "developer-survey-2024",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Convenient code actions",
//       subtitle: "Gleam v1.5.0 released",
//       published: calendar.Date(2024, calendar.September, 19),
//       author: louis,
//       path: "convenient-code-actions",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Welcome Lambda!",
//       subtitle: "Gleam's new corporate sponsor",
//       published: calendar.Date(2024, calendar.August, 26),
//       author: louis,
//       path: "welcome-lambda",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Supercharged labels",
//       subtitle: "Gleam v1.4.0 released",
//       published: calendar.Date(2024, calendar.August, 02),
//       author: louis,
//       path: "supercharged-labels",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Auto-imports and tolerant expressions",
//       subtitle: "Gleam v1.3.0 released",
//       published: calendar.Date(2024, calendar.July, 09),
//       author: louis,
//       path: "auto-imports-and-tolerant-expressions",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Fault tolerant Gleam",
//       subtitle: "Gleam v1.2.0 released",
//       published: calendar.Date(2024, calendar.May, 27),
//       author: louis,
//       path: "fault-tolerant-gleam",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam version v1.1",
//       subtitle: "Hot on the heels of v1",
//       published: calendar.Date(2024, calendar.April, 16),
//       author: louis,
//       path: "gleam-v1.1",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam version 1",
//       subtitle: "It's finally here! 🎉",
//       published: calendar.Date(2024, calendar.March, 04),
//       author: louis,
//       path: "gleam-version-1",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam's new interactive language tour",
//       subtitle: "Learn Gleam in your browser!",
//       published: calendar.Date(2024, calendar.January, 19),
//       author: louis,
//       path: "gleams-new-interactive-language-tour",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Multi-target projects",
//       subtitle: "Gleam v0.34 released",
//       published: calendar.Date(2024, calendar.January, 16),
//       author: louis,
//       path: "v0.34-multi-target-projects",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Exhaustive Gleam",
//       subtitle: "Gleam v0.33 released",
//       published: calendar.Date(2023, calendar.December, 18),
//       author: louis,
//       path: "v0.33-exhaustive-gleam",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Polishing syntax for stability",
//       subtitle: "Gleam v0.32 released",
//       published: calendar.Date(2023, calendar.November, 01),
//       author: louis,
//       path: "v0.32-polishing-syntax-for-stability",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Keeping dependencies explicit",
//       subtitle: "Gleam v0.31 released",
//       published: calendar.Date(2023, calendar.September, 25),
//       author: louis,
//       path: "v0.31-keeping-dependencies-explicit",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Local dependencies and enhanced externals",
//       subtitle: "Gleam v0.30 released",
//       published: calendar.Date(2023, calendar.July, 12),
//       author: louis,
//       path: "v0.30-local-dependencies-and-enhanced-externals",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam gets autocompletion",
//       subtitle: "Gleam v0.29 released",
//       published: calendar.Date(2023, calendar.May, 23),
//       author: louis,
//       path: "v0.29-gleam-gets-autocompletion",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Introducing the Gleam package index",
//       subtitle: "Find packages for your Gleam projects",
//       published: calendar.Date(2023, calendar.April, 30),
//       author: louis,
//       path: "introducing-the-gleam-package-index",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Monorepos, fast maps, and more",
//       subtitle: "Gleam v0.28 released",
//       published: calendar.Date(2023, calendar.April, 03),
//       author: louis,
//       path: "v0.28-monorepos-fast-maps-and-more",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Hello panic, goodbye try",
//       subtitle: "Gleam v0.27 released",
//       published: calendar.Date(2023, calendar.March, 01),
//       author: louis,
//       path: "v0.27-hello-panic-goodbye-try",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Incremental compilation, and hello Deno!",
//       subtitle: "Gleam v0.26 released",
//       published: calendar.Date(2023, calendar.January, 19),
//       author: louis,
//       path: "v0.26-incremental-compilation-and-deno",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Developer Survey 2022 Results",
//       subtitle: "What did we learn about the Gleamers?",
//       published: calendar.Date(2022, calendar.December, 16),
//       author: louis,
//       path: "developer-survey-2022-results",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Introducing use expressions!",
//       subtitle: "Gleam v0.25 released",
//       published: calendar.Date(2022, calendar.November, 24),
//       author: louis,
//       path: "v0.25-introducing-use-expressions",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.24 released!",
//       subtitle: "",
//       published: calendar.Date(2022, calendar.October, 25),
//       author: louis,
//       path: "gleam-v0.24-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.23 released!",
//       subtitle: "",
//       published: calendar.Date(2022, calendar.September, 18),
//       author: louis,
//       path: "gleam-v0.23-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.22 released!",
//       subtitle: "",
//       published: calendar.Date(2022, calendar.June, 19),
//       author: louis,
//       path: "gleam-v0.22-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Introducing the Gleam language server!",
//       subtitle: "",
//       published: calendar.Date(2022, calendar.April, 24),
//       author: louis,
//       path: "v0.21-introducing-the-gleam-language-server",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.20 released!",
//       subtitle: "",
//       published: calendar.Date(2022, calendar.February, 23),
//       author: louis,
//       path: "gleam-v0.20-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.19 released!",
//       subtitle: "",
//       published: calendar.Date(2022, calendar.January, 12),
//       author: louis,
//       path: "gleam-v0.19-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.18 released!",
//       subtitle: "",
//       published: calendar.Date(2021, calendar.December, 06),
//       author: louis,
//       path: "gleam-v0.18-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.17 released!",
//       subtitle: "",
//       published: calendar.Date(2021, calendar.September, 20),
//       author: louis,
//       path: "gleam-v0.17-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam compiles to JavaScript!",
//       subtitle: "Gleam v0.16 released",
//       published: calendar.Date(2021, calendar.June, 17),
//       author: louis,
//       path: "v0.16-gleam-compiles-to-javascript",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.15 released!",
//       subtitle: "",
//       published: calendar.Date(2021, calendar.May, 06),
//       author: louis,
//       path: "gleam-v0.15-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.14 released!",
//       subtitle: "",
//       published: calendar.Date(2021, calendar.February, 18),
//       author: louis,
//       path: "gleam-v0.14-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.13 released!",
//       subtitle: "",
//       published: calendar.Date(2021, calendar.January, 13),
//       author: louis,
//       path: "gleam-v0.13-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.12 and Gleam OTP v0.1 released! 🎃",
//       subtitle: "",
//       published: calendar.Date(2020, calendar.October, 31),
//       author: louis,
//       path: "gleam-v0.12-and-gleam-otp-v0.1-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.11 released!",
//       subtitle: "",
//       published: calendar.Date(2020, calendar.August, 28),
//       author: louis,
//       path: "gleam-v0.11-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.10 released!",
//       subtitle: "",
//       published: calendar.Date(2020, calendar.July, 01),
//       author: louis,
//       path: "gleam-v0.10-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.9 released!",
//       subtitle: "",
//       published: calendar.Date(2020, calendar.June, 1),
//       author: louis,
//       path: "gleam-v0.9-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.8 released!",
//       subtitle: "",
//       published: calendar.Date(2020, calendar.May, 7),
//       author: louis,
//       path: "gleam-v0.8-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.7 released!",
//       subtitle: "",
//       published: calendar.Date(2020, calendar.March, 1),
//       author: louis,
//       path: "gleam-v0.7-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.6 released!",
//       subtitle: "",
//       published: calendar.Date(2019, calendar.December, 25),
//       author: louis,
//       path: "gleam-v0.6-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.5 released!",
//       subtitle: "",
//       published: calendar.Date(2019, calendar.December, 16),
//       author: louis,
//       path: "gleam-v0.5-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.4 released!",
//       subtitle: "",
//       published: calendar.Date(2019, calendar.September, 19),
//       author: louis,
//       path: "gleam-v0.4-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Gleam v0.3 released!",
//       subtitle: "",
//       published: calendar.Date(2019, calendar.August, 07),
//       author: louis,
//       path: "gleam-v0.3-released",
//       preview_image: option.None,
//     ),
//     read(
//       title: "Hello, Gleam!",
//       subtitle: "There's a new friendly language in town",
//       published: calendar.Date(2019, calendar.April, 15),
//       author: louis,
//       path: "hello-gleam",
//       preview_image: option.None,
//     ),
//   ]
//   io.print("\n")
//   posts
//   |> result.all()
// }

const louis = Author(name: "Louis Pilfold", url: "https://github.com/lpil")

pub type NewsData {
  NewsData(published: calendar.Date, author: Author)
}

fn news_data_decoder() -> decode.Decoder(NewsData) {
  use published <- decode.field("published", tom.date_decoder())
  use author <- decode.field("author", author_decoder())
  decode.success(NewsData(published:, author:))
}

pub type Author {
  Author(name: String, url: String)
}

fn author_decoder() -> decode.Decoder(Author) {
  use name <- decode.field("name", decode.string)
  use url <- decode.field("url", decode.string)
  decode.success(Author(name:, url:))
}

fn news_post_page(page: #(site.Page, NewsData), ctx: site.Context) -> fs.File {
  let #(page, data) = page
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
          html.time([], [html.text(page.short_human_date(data.published))]),
          html.text(" by "),
          html.a([attr.href(data.author.url)], [html.text(data.author.name)]),
        ]),
        page.share_button(),
      ]),
      element.unsafe_raw_html(
        "",
        "article",
        [class("prose")],
        page.djot_to_html(page.content),
      ),
    ]),
  ]
  |> page.page_layout("", page.meta, ctx)
  |> page.to_html_file(page.meta)
}

pub fn index_page(
  posts: List(#(site.Page, NewsData)),
  ctx: site.Context,
) -> fs.File {
  let meta =
    site.PageMeta(
      path: "news",
      title: "News",
      meta_title: "News | Gleam programming language",
      subtitle: "What's happening in the Gleam world?",
      description: "Check what's happening in the Gleam world: stay up to date with Gleam’s latest releases, feature announcements, and project updates.",
      preload_images: [],
      preview_image: option.Some("news"),
    )

  let list_items =
    list.map(posts, fn(post) {
      let #(post, data) = post
      html.li([], [
        html.a([attr.href("/news/" <> post.meta.path)], [
          html.h2([attr.class("links")], [html.text(post.meta.title)]),
        ]),
        html.p([], [html.text(post.meta.subtitle)]),
        html.ul([class("news-meta")], [
          html.li([], [
            html.img([
              attr.width(16),
              attr.src("/images/date-icon.svg"),
              attr.alt("Date Icon"),
            ]),
            html.text(page.short_human_date(data.published)),
          ]),
          html.li([], [
            html.img([
              attr.width(20),
              attr.src("/images/user-icon.svg"),
              attr.alt("User Icon"),
            ]),
            html.text(data.author.name),
          ]),
        ]),
      ])
    })

  [html.ul([class("news-posts")], list_items)]
  |> page.page_layout("", meta, ctx)
  |> page.to_html_file(meta)
}

pub fn files(
  posts: List(site.Page),
  context: site.Context,
) -> snag.Result(List(fs.File)) {
  use posts <- result.try(
    list.try_map(posts, page.decode_frontmatter(_, news_data_decoder())),
  )
  Ok([
    index_page(posts, context),
    atom_feed(posts),
    ..list.map(posts, news_post_page(_, context))
  ])
}

fn atom_feed(news_posts: List(#(site.Page, NewsData))) -> fs.File {
  let updated = case news_posts {
    [#(_, first), ..] -> to_calendar(first.published)
    _ -> timestamp.system_time()
  }
  let feed =
    atomb.Feed(
      title: "Gleam",
      id: "https://gleam.run/feed.xml",
      updated:,
      subtitle: option.Some(atomb.TextContent(
        atomb.Text,
        "Gleam is a fast, friendly, and functional language for building type-safe, scalable systems!",
      )),
      rights: option.None,
      icon: option.None,
      logo: option.None,
      authors: [],
      links: [
        atomb.Link(href: "https://gleam.run/feed.xml", rel: option.Some("self")),
        atomb.Link(href: "https://gleam.run", rel: option.Some("alternate")),
      ],
      categories: [],
      contributors: [],
      generator: option.Some(atomb.Generator(
        "gleam-lang/website",
        uri: option.Some("https://github.com/gleam-lang/website"),
        version: option.None,
      )),
      entries: news_posts |> list.take(10) |> list.map(atom_feed_entry),
    )
  fs.File("feed.xml", content: atomb.render(feed) |> string_tree.to_string)
}

fn to_calendar(date: calendar.Date) -> timestamp.Timestamp {
  timestamp.from_calendar(
    date,
    calendar.TimeOfDay(0, 0, 0, 0),
    calendar.utc_offset,
  )
}

fn atom_feed_entry(post: #(site.Page, NewsData)) -> atomb.Entry {
  let #(post, data) = post
  let url = "https://gleam.run/" <> post.meta.path
  let published = to_calendar(data.published)
  atomb.Entry(
    id: url,
    title: post.meta.title,
    updated: published,
    published: option.Some(published),
    content: option.Some(atomb.InlineText(
      atomb.Html,
      page.djot_to_html(post.content),
    )),
    summary: option.None,
    categories: [],
    links: [atomb.Link(url, rel: option.Some("alternate"))],
    contributors: [],
    rights: option.None,
    authors: [
      atomb.Person(
        name: data.author.name,
        uri: option.Some(data.author.url),
        email: option.None,
      ),
    ],
  )
}
