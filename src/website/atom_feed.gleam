import atomb
import gleam/list
import gleam/option
import gleam/string_tree
import gleam/time/calendar
import gleam/time/timestamp
import website/fs
import website/news

pub fn file(news_posts: List(news.NewsPost)) -> fs.File {
  let updated = case news_posts {
    [first, ..] -> to_calendar(first.published)
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
      entries: news_posts |> list.take(10) |> list.map(to_entry),
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

fn to_entry(post: news.NewsPost) -> atomb.Entry {
  let url = "https://gleam.run/news/" <> post.path
  let published = to_calendar(post.published)
  atomb.Entry(
    id: url,
    title: post.title,
    updated: published,
    published: option.Some(published),
    content: option.Some(atomb.InlineText(atomb.Html, post.content)),
    summary: option.None,
    categories: [],
    links: [atomb.Link(url, rel: option.Some("alternate"))],
    contributors: [],
    rights: option.None,
    authors: [
      atomb.Person(
        name: post.author.name,
        uri: option.Some(post.author.url),
        email: option.None,
      ),
    ],
  )
}
