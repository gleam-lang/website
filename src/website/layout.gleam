import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/time/calendar
import gleam/time/timestamp
import lustre/attribute.{attribute as attr, class} as attr
import lustre/element.{type Element}
import lustre/element/html
import website/site

pub fn base_layout(
  page_content: List(Element(a)),
  page: site.PageMeta,
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

pub fn with_header(
  content: List(Element(a)),
  class: String,
  meta: site.PageMeta,
  ctx: site.Context,
) -> Element(a) {
  [
    header(hero_image: option.None, content: [
      html.h1([], [html.text(meta.title)]),
      html.p([attr.class("hero-subtitle")], [html.text(meta.subtitle)]),
    ]),
    html.main([attr.class("page content " <> class)], content),
  ]
  |> base_layout(meta, ctx)
}

// Page elements

fn head_elements(
  page: site.PageMeta,
  ctx: site.Context,
) -> List(element.Element(a)) {
  let metatag = fn(property, content) {
    html.meta([attr("property", property), attr("content", content)])
  }
  let preview_image = case page.preview_image {
    option.None -> ctx.hostname <> "/images/preview/site.png"
    option.Some(name) -> ctx.hostname <> "/images/preview/" <> name <> ".png"
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
    html.title([], page.meta_title),
    html.meta([attr("content", page.description), attr.name("description")]),
    metatag("og:type", "website"),
    metatag("og:image", preview_image),
    metatag("og:title", page.meta_title),
    metatag("og:description", page.description),
    metatag("og:url", ctx.hostname <> "/" <> page.path),
    metatag("twitter:card", "summary_large_image"),
    metatag("twitter:url", ctx.hostname),
    metatag("twitter:title", page.meta_title),
    metatag("twitter:description", page.description),
    metatag("twitter:image", preview_image),
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

pub fn header(
  hero_image hero_image: Option(#(String, String)),
  content content: List(Element(a)),
) -> Element(a) {
  let hero_content = html.div([attr.class("text")], content)
  let hero_content = case hero_image {
    option.Some(#(src, alt)) -> [
      html.div(
        [attr("data-show-pride", ""), class("hero-lucy-container wide-only")],
        [html.img([attr.alt(alt), attr.src(src), attr.class("hero-lucy")])],
      ),
      html.div([class("text-left")], [hero_content]),
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
          html.a([attr.href("/sponsor")], [html.text("Sponsor")]),
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
    #("Case studies", "/case-studies"),
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
