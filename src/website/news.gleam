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
//       title = "Single file Gleam BEAM programs with escript"
//       meta_title = "Single file Gleam BEAM programs with escript | Gleam programming language"
//       subtitle = "Gleam v1.17.0 released!"
//       description = "News post: Gleam v1.17.0 released!"
//       preview_image = "v1.17"
//     )
//     read(
//       title = "JavaScript source maps"
//       subtitle = "Gleam v1.16.0 released!"
//       preview_image = "v1.16"
//     )
//     read(
//       title = "Upgrading Hex security"
//       subtitle = "Gleam v1.15.0 released!"
//       preview_image = "v1.15"
//     )
//     read(
//       title = "Join us at Gleam Gathering"
//       subtitle = "The first ever all Gleam conference!"
//       
//     )
//     read(
//       title = "The happy holidays release 2025 🎁"
//       subtitle = "Gleam v1.14.0 released"
//       preview_image = "xmas-2025"
//     )
//     read(
//       title = "Formalising external APIs"
//       subtitle = "Gleam v1.13.0 released"
//       
//     )
//     read(
//       title = "No more dependency management headaches"
//       subtitle = "Gleam v1.12.0 released"
//       
//     )
//     read(
//       title = "Gleam JavaScript gets 30% faster"
//       subtitle = "Gleam v1.11.0 released"
//       
//     )
//     read(
//       title = "Global rename and find references"
//       subtitle = "Gleam v1.10.0 released"
//       
//     )
//     read(
//       title = "Hello echo! Hello git!"
//       subtitle = "Gleam v1.9.0 released"
//       
//     )
//     read(
//       title = "Gleam gets “rename variable”"
//       subtitle = "Gleam v1.8.0 released"
//       
//     )
//     read(
//       title = "Developer Survey 2024 Results"
//       subtitle = "A look at the Gleam community after version one"
//       
//     )
//     read(
//       title = "Improved performance and publishing"
//       subtitle = "Gleam v1.7.0 released"
//       
//     )
//     read(
//       title = "Introducing the Gleam roadmap!"
//       subtitle = "A bird's eye view of what's happening in Gleam"
//       
//     )
//     read(
//       title = "Context aware compilation"
//       subtitle = "Gleam v1.6.0 released"
//       
//     )
//     read(
//       title = "Developer Survey 2024"
//       subtitle = "Who are the Gleamlins anyway?"
//       
//     )
//     read(
//       title = "Convenient code actions"
//       subtitle = "Gleam v1.5.0 released"
//       
//     )
//     read(
//       title = "Welcome Lambda!"
//       subtitle = "Gleam's new corporate sponsor"
//       
//     )
//     read(
//       title = "Supercharged labels"
//       subtitle = "Gleam v1.4.0 released"
//       
//     )
//     read(
//       title = "Auto-imports and tolerant expressions"
//       subtitle = "Gleam v1.3.0 released"
//       
//     )
//     read(
//       title = "Fault tolerant Gleam"
//       subtitle = "Gleam v1.2.0 released"
//       
//     )
//     read(
//       title = "Gleam version v1.1"
//       subtitle = "Hot on the heels of v1"
//       
//     )
//     read(
//       title = "Gleam version 1"
//       subtitle = "It's finally here! 🎉"
//       
//     )
//     read(
//       title = "Gleam's new interactive language tour"
//       subtitle = "Learn Gleam in your browser!"
//       
//     )
//     read(
//       title = "Multi-target projects"
//       subtitle = "Gleam v0.34 released"
//       
//     )
//     read(
//       title = "Exhaustive Gleam"
//       subtitle = "Gleam v0.33 released"
//       
//     )
//     read(
//       title = "Polishing syntax for stability"
//       subtitle = "Gleam v0.32 released"
//       
//     )
//     read(
//       title = "Keeping dependencies explicit"
//       subtitle = "Gleam v0.31 released"
//       
//     )
//     read(
//       title = "Local dependencies and enhanced externals"
//       subtitle = "Gleam v0.30 released"
//       
//     )
//     read(
//       title = "Gleam gets autocompletion"
//       subtitle = "Gleam v0.29 released"
//       
//     )
//     read(
//       title = "Introducing the Gleam package index"
//       subtitle = "Find packages for your Gleam projects"
//       
//     )
//     read(
//       title = "Monorepos, fast maps, and more"
//       subtitle = "Gleam v0.28 released"
//       
//     )
//     read(
//       title = "Hello panic, goodbye try"
//       subtitle = "Gleam v0.27 released"
//       
//     )
//     read(
//       title = "Incremental compilation, and hello Deno!"
//       subtitle = "Gleam v0.26 released"
//       
//     )
//     read(
//       title = "Developer Survey 2022 Results"
//       subtitle = "What did we learn about the Gleamers?"
//       
//     )
//     read(
//       title = "Introducing use expressions!"
//       subtitle = "Gleam v0.25 released"
//       
//     )
//     read(
//       title = "Gleam v0.24 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.23 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.22 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Introducing the Gleam language server!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.20 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.19 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.18 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.17 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam compiles to JavaScript!"
//       subtitle = "Gleam v0.16 released"
//       
//     )
//     read(
//       title = "Gleam v0.15 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.14 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.13 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.12 and Gleam OTP v0.1 released! 🎃"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.11 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.10 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.9 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.8 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.7 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.6 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.5 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.4 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Gleam v0.3 released!"
//       subtitle = ""
//       
//     )
//     read(
//       title = "Hello, Gleam!"
//       subtitle = "There's a new friendly language in town"
//       
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
