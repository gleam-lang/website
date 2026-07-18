import atomb
import gleam/dynamic/decode
import gleam/list
import gleam/option
import gleam/result
import gleam/string_tree
import gleam/time/calendar
import gleam/time/timestamp
import lustre/attribute.{class} as attr
import lustre/element
import lustre/element/html
import snag
import tom
import website/fs
import website/page
import website/site

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
        html.a([attr.href(post.meta.path)], [
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
