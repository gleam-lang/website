import contour
import gleam/dict
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/int
import gleam/list
import gleam/option.{type Option}
import gleam/order
import gleam/pair
import gleam/result
import gleam/string
import gleam/time/calendar
import gleam/time/timestamp.{type Timestamp}
import houdini
import jot
import just
import lustre/attribute.{attribute as attr, class} as attr
import lustre/element.{type Element}
import lustre/element/html
import pearl
import snag
import tear
import website/fs
import website/sponsor

pub type Context {
  Context(hostname: String, time: Timestamp, styles_hash: String)
}

pub type Page {
  Page(meta: PageMeta, content: jot.Document, frontmatter: Dynamic)
}

pub type PageMeta {
  PageMeta(
    path: String,
    title: String,
    subtitle: String,
    meta_title: String,
    description: String,
    /// Social media share preview image name
    preview_image: Option(String),
  )
}

pub fn redirect_to_tour(from: String, to: String) -> fs.File {
  let to = "https://tour.gleam.run/" <> to
  redirect(from, to)
}

pub fn redirect(from: String, to: String) -> fs.File {
  let content =
    html.html([], [
      html.head([], [
        html.meta([attr.http_equiv("refresh"), attr.content("0;url=" <> to)]),
      ]),
      html.body([], [
        html.text("You are being redirected to "),
        html.a([attr.href(to)], [html.text(to)]),
      ]),
    ])
    |> element.to_document_string
  fs.NonPageFile(path: from, content:)
}

pub type ContentLink {
  ContentLink(title: String, href: String, children: List(ContentLink))
}

pub fn table_of_contents_from_djot(
  document: jot.Document,
) -> List(ContentLink) {
  document.content
  |> list.fold(from: [], over: _, with: fn(accumulator, block) {
    case block {
      jot.Heading(attributes:, level: 2, ..) ->
        case dict.get(attributes, "id") {
          Ok(href) -> {
            let text = jot.inner_text(block)
            [ContentLink(text, "#" <> href, []), ..accumulator]
          }
          _ -> accumulator
        }

      jot.Heading(attributes:, level: 3, ..) ->
        case dict.get(attributes, "id"), accumulator {
          Ok(href), [first, ..rest] -> {
            let text = jot.inner_text(block)
            let content_link = ContentLink(text, "#" <> href, [])
            let children = [content_link, ..first.children]
            [ContentLink(..first, children:), ..rest]
          }
          _, _ -> accumulator
        }
      _ -> accumulator
    }
  })
  |> reverse_content_links([])
}

fn reverse_content_links(
  links: List(ContentLink),
  accumulator: List(ContentLink),
) -> List(ContentLink) {
  case links {
    [] -> accumulator
    [link, ..links] -> {
      let children = reverse_content_links(link.children, [])
      let link = ContentLink(..link, children:)
      reverse_content_links(links, [link, ..accumulator])
    }
  }
}

pub fn base_layout(
  page_content: List(Element(a)),
  page: PageMeta,
  ctx: Context,
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

pub fn table_of_contents_page_layout(
  content: List(Element(a)),
  table_of_contents: List(ContentLink),
  meta: PageMeta,
  ctx: Context,
) {
  [
    header(hero_image: option.None, content: [
      html.h1([], [html.text(meta.title)]),
      html.p([attr.class("hero-subtitle")], [html.text(meta.subtitle)]),
    ]),
    html.main([attr.class("page toc-layout")], [
      html.nav([class("table-of-contents")], [
        html.h4([], [html.text("Table of Contents")]),
        html.ul(
          [],
          list.map(table_of_contents, fn(item) {
            html.li([], [
              html.a([attr.href(item.href)], [html.text(item.title)]),
              case item.children {
                [] -> element.none()
                _ ->
                  html.ul(
                    [],
                    list.map(item.children, fn(item) {
                      html.li([], [
                        html.a([attr.href(item.href)], [html.text(item.title)]),
                      ])
                    }),
                  )
              },
            ])
          }),
        ),
      ]),
      ..content
    ]),
  ]
  |> base_layout(meta, ctx)
}

pub fn page_layout(
  content: List(Element(a)),
  class: String,
  meta: PageMeta,
  ctx: Context,
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

fn head_elements(page: PageMeta, ctx: Context) -> List(element.Element(a)) {
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
    html.link([
      attr("as", "image"),
      attr.href("/images/lucy/lucyhappy.svg"),
      attr.rel("preload"),
    ]),
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
    // html.aside([attr.class("page-banner")], [
    //   element.text("Have your say in the "),
    //   html.a([attr.href("https://developer-survey.gleam.run/")], [
    //     element.text("Gleam Developer Survey"),
    //   ]),
    // ]),
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
          html.a([attr.href("/install")], [
            html.text("Install"),
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

fn footer(ctx: Context) -> element.Element(a) {
  let footer_links = [
    #("News", "/news"),
    #("Code", "https://github.com/gleam-lang"),
    #("Discord", "https://discord.gg/Fm8Pwmy"),
    #("Merch store", "https://shop.gleam.run/en-gbp"),
    #("Language tour", "https://tour.gleam.run"),
    #("Playground", "https://playground.gleam.run"),
    #("Documentation", "/documentation"),
    #("Sponsor", "/sponsor"),
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

pub fn sitemap(files: List(fs.File), ctx: Context) -> fs.File {
  let meta =
    PageMeta(
      path: "/sitemap",
      title: "Sitemap",
      subtitle: "All the pages of the Gleam website",
      meta_title: "Sitemap",
      description: "All the pages of the Gleam website",
      preview_image: option.None,
    )

  let pages =
    files
    |> list.filter_map(fn(page) {
      case page {
        fs.NonPageFile(..) | fs.Copy(..) -> Error(Nil)

        fs.HtmlPage(path:, title:, ..) -> {
          let path =
            string.split(path, "/")
            |> list.filter(fn(segment) { segment != "" })
          Ok(#(path, title))
        }
      }
    })

  let tree = make_sitemap_tree(pages, new_sitemap_entry())

  [
    html.ul([], [sitemap_html("", #("", tree))]),
  ]
  |> page_layout("", meta, ctx)
  |> to_html_file(meta)
}

fn sitemap_html(parent: String, data: #(String, SitemapTree)) -> Element(a) {
  let #(segment, tree) = data
  let segment = case dict.is_empty(tree.children) {
    True -> segment
    False -> segment <> "/"
  }
  let path = parent <> segment
  let page_link = case tree.title {
    option.Some(title) ->
      element.fragment([
        html.text(" "),
        html.a([attr.href(path)], [html.text(title)]),
      ])
    option.None -> element.none()
  }
  let children =
    tree.children
    |> dict.to_list
    |> list.sort(fn(a, b) {
      int.compare(dict.size(a.1.children), dict.size(b.1.children))
      |> order.break_tie(string.compare(a.0, b.0))
    })
    |> list.map(sitemap_html(path, _))
  html.li([], [
    html.code([], [html.text(segment)]),
    page_link,
    html.ul([], children),
  ])
}

fn make_sitemap_tree(
  pages: List(#(List(String), String)),
  tree: SitemapTree,
) -> SitemapTree {
  case pages {
    [] -> tree

    [#([], title), ..pages] -> {
      make_sitemap_tree(pages, SitemapEntry(..tree, title: option.Some(title)))
    }

    [#([segment, ..segments], title), ..pages] -> {
      let subtree =
        dict.get(tree.children, segment) |> result.unwrap(new_sitemap_entry())
      let subtree = make_sitemap_tree([#(segments, title)], subtree)
      let children = dict.insert(tree.children, segment, subtree)
      make_sitemap_tree(pages, SitemapEntry(..tree, children:))
    }
  }
}

fn new_sitemap_entry() -> SitemapTree {
  SitemapEntry(option.None, dict.new())
}

type SitemapTree {
  SitemapEntry(
    title: option.Option(String),
    children: dict.Dict(String, SitemapTree),
  )
}

pub fn sponsor(sponsors: List(sponsor.Sponsor), ctx: Context) -> fs.File {
  let meta =
    PageMeta(
      path: "/sponsor",
      title: "Sponsorship and donations",
      subtitle: "Support Gleam's development by sponsoring us!",
      meta_title: "Sponsor | Gleam Programming Language",
      description: "Everything we bring to the language is possible thanks to our sponsors. See how to become one of them and support Gleam.",
      preview_image: option.Some("sponsor"),
    )

  let sponsees = [
    sponsor_card(
      name: "Louis Pilfold",
      title: "Creator of Gleam",
      avatar: "https://avatars.githubusercontent.com/u/6134406?v=4",
      links: [#("GitHub Sponsors", "https://github.com/sponsors/lpil")],
    ),
    sponsor_card(
      name: "Hayleigh Thompson",
      title: "Lustre Maintainer",
      avatar: "https://avatars.githubusercontent.com/u/9001354?v=4",
      links: [
        #("GitHub Sponsors", "https://github.com/sponsors/hayleigh-dot-dev"),
      ],
    ),
    sponsor_card(
      name: "Giacomo \"Jak\" Cavalieri",
      title: "Real Life Squirrel",
      avatar: "https://avatars.githubusercontent.com/u/20598369?v=4",
      links: [
        #("GitHub Sponsors", "https://github.com/sponsors/giacomocavalieri"),
      ],
    ),
    sponsor_card(
      name: "Surya \"Gears\" Rose",
      title: "Compiler Extraordinaire",
      avatar: "https://avatars.githubusercontent.com/u/40563462?v=4",
      links: [
        #("GitHub Sponsors", "https://github.com/sponsors/GearsDatapacks"),
      ],
    ),
  ]

  let wise_quick_pay =
    "https://wise.com/pay/business/otternonsenseltd?description=Gleam%20Sponsorship"
  let wise_uk =
    "Wise Payments Limited, 1st Floor, Worship Square, 65 Clifton Street, London, EC2A 4JE, United Kingdom"
  let wise_eu = "Wise, Rue du Trône 100, 3rd floor, Brussels, 1050, Belgium"
  let wise_usa =
    "Community Federal Savings Bank, 89-16 Jamaica Ave, Woodhaven, NY, 11421, United States"

  let bank_transfer_section = [
    html.h2([class("text-center")], [
      html.text("Donating by bank transfer"),
    ]),
    html.article([], [
      html.p([], [
        html.text(
          "Otter Nonsense Ltd is the legal entity behind Gleam development, for which Louis Pilfold is the managing director.",
        ),
        html.text(" You can donate directly using our "),
        html.a([attr.href(wise_quick_pay)], [
          html.text("Wise Quick Pay Link"),
        ]),
        html.text(
          ", by making a bank transfer, or by placing a standing order to any of the accounts listed here.",
        ),
      ]),

      html.details([], [
        html.summary([], [html.text("GBP account (domestic)")]),
        html.p([], [html.text("For sending GBP from within the UK.")]),
        html.dl([], [
          definition("Name", "Otter Nonsense Ltd"),
          definition("Account number", "67043610"),
          definition("Sort code", "23-14-70"),
          definition("Bank", wise_uk),
        ]),
      ]),
      html.details([], [
        html.summary([], [html.text("GBP account (international)")]),
        html.p([], [html.text("For sending GBP from outside the UK.")]),
        html.dl([], [
          definition("Name", "Otter Nonsense Ltd"),
          definition("IBAN", "GB53 TRWI 2314 7067 0436 10"),
          definition("Swift/BIC", "TRWIGB2LXXX"),
          definition("Bank", wise_uk),
        ]),
      ]),

      html.details([], [
        html.summary([], [html.text("EUR account")]),
        html.p([], [
          html.text(
            "If you're sending money from a bank in SEPA, you can use these details to make a domestic transfer. If you're sending from somewhere else, make an international Swift transfer.",
          ),
        ]),
        html.dl([], [
          definition("Name", "Otter Nonsense Ltd"),
          definition("IBAN", "BE49 9671 6861 5971"),
          definition("Swift/BIC", "TRWIBEB1XXX"),
          definition("Bank", wise_eu),
        ]),
      ]),

      html.details([], [
        html.summary([], [html.text("USD account (domestic)")]),
        html.p([], [html.text("For sending USD from within the USA.")]),
        html.dl([], [
          definition("Name", "Otter Nonsense Ltd"),
          definition("Account number", "8310615778"),
          definition("Account type", "Checking"),
          definition("Routing number (for wire and ACH)", "026073150"),
          definition("Bank", wise_usa),
        ]),
      ]),
      html.details([], [
        html.summary([], [html.text("USD account (international)")]),
        html.p([], [html.text("For sending USD from outside the USA.")]),
        html.dl([], [
          definition("Name", "Otter Nonsense Ltd"),
          definition("Account number", "8310615778"),
          definition("Swift/BIC", "CMFGUS33"),
          definition("Bank", wise_usa),
        ]),
      ]),

      html.p([], [
        html.text(
          "Your bank may charge fees for international transfers, and there is a fee for card payments with the Wise Quick Pay Link. If we do not have a bank account for your local currency place use the GBP account, as it will save us from making an extra currency conversion afterwards.",
        ),
      ]),

      html.p([], [
        html.text(
          "If your organisation would like to be an ongoing sponsor and your finance team requires us to submit monthly invoices please get in touch at ",
        ),
        html.a([attr.href("mailto:hello@gleam.run")], [
          html.text("hello@gleam.run"),
        ]),
        html.text("."),
      ]),
    ]),
  ]

  let project_sponsor_links = [
    #("Github Sponsors", "https://github.com/sponsors/gleam-lang"),
    #("Bank Transfer", "#sponsor-bank-transfer"),
    #("Liberapay", "https://liberapay.com/gleam/"),
  ]

  let sponsees_section = [
    html.h3([], [
      html.text(
        "What does “sponsoring” mean exactly? Where is the money going?",
      ),
    ]),
    html.p([], [
      html.text(
        "Sponsoring Gleam means funding the people who are making it: financially supporting the Gleam project or core team members. In both cases, your contribution helps fund further Gleam development.",
      ),
    ]),
    html.p([], [
      html.text("If you choose to support "),
      html.a([attr.href("https://github.com/sponsors/gleam-lang")], [
        html.text("the main project"),
      ]),
      html.text(" or "),
      html.a([attr.href("https://github.com/sponsors/lpil")], [
        html.text(" Louis' profile "),
      ]),
      html.text(
        ", you’re helping to cover pay for the core team, hiring contractors, and keeping essential infrastructure like the package index running, among other things.",
      ),
    ]),
    html.p([], [
      html.text(
        "Sponsoring other core team members directly supports their input into the language.",
      ),
    ]),
    html.p([], [
      html.text("Everything we bring to the language, like "),
      html.a([attr.href("/news/gleam-javascript-gets-30-percent-faster/")], [
        html.text("compiled JS getting 30% faster"),
      ]),
      html.text(
        ", is possible thanks to the support of our sponsors! Check out our full ",
      ),
      html.a([attr.href("/roadmap")], [html.text("roadmap")]),
      html.text(" to see what we have planned next."),
    ]),
  ]
  let github_fees =
    "https://docs.github.com/en/sponsors/sponsoring-open-source-contributors/about-sponsorships-fees-and-taxes#sponsorship-fees"
  let liberapay_fee = "https://liberapay.com/about/faq#fees"
  let faqs_section = [
    html.h2([class("text-center")], [
      html.text("Frequently Asked Questions"),
    ]),
    html.article([], [
      html.h3([], [html.text("What’s the minimum to become a sponsor?")]),
      html.p([], [
        html.text(
          "There’s no such thing as a donation too small (or too big)! Whatever feels right for you, feels right for us.",
        ),
      ]),
      html.p([], [
        html.text(
          "Even if it’s just $1/month, it’s one dollar more towards the development of Gleam! Also, the fact that you’re sponsoring Gleam is visible on your GitHub profile, giving the language additional exposure and serving as a signal that you care about it and might encourage others to sponsor Gleam as well 🩷",
        ),
      ]),

      html.h3([], [html.text("How much of my sponsorship goes to Gleam?")]),
      html.p([], [
        html.text(
          "GitHub Sponsors does not charge any fees for sponsorships from personal accounts. 100% of your contribution goes directly towards Gleam development!",
        ),
      ]),

      html.p([], [
        html.text(
          "If you are sponsoring from an organisation account then GitHub Sponsors will charge a 6% ",
        ),
        html.a([attr.href(github_fees)], [element.text("transfer fee")]),
        html.text("."),
      ]),
      html.p([], [
        html.text("Liberapay charges a "),
        html.a([attr.href(liberapay_fee)], [element.text("transfer fee")]),
        html.text(" of between 3% and 5%, depending on payment method used."),
      ]),
      html.p([], [
        html.text(
          "For bank transfers your bank may charge a fee, and it may vary depending on the location and currency of the account you are transferring to. If the cost is the same for all the accounts we prefer to receive money to the GBP account, to minimise the number of currency conversions.",
        ),
      ]),

      html.h3([], [html.text("Can I sponsor multiple team members?")]),
      html.p([], [
        html.text(
          "Yes! You can sponsor whichever and however many team members you like.",
        ),
      ]),

      html.h3([], [html.text("Can my company sponsor Gleam?")]),
      html.p([], [
        html.text(
          "Absolutely! Companies are welcome to sponsor Gleam! You can also contact Louis directly at ",
        ),
        html.a([attr.href("mailto:hello@gleam.run")], [
          html.text("hello@gleam.run"),
        ]),
        html.text(
          " to get in touch about larger sponsorships, invoicing, feature funding, or consulting opportunities.",
        ),
      ]),

      html.h3([], [
        html.text("Do I have to commit for a certain period of time?"),
      ]),
      html.p([], [
        html.text(
          "All the sponsorship options allow you to select a one-time donation or an ongoing, monthly support (that you can pause at any time) - whatever works for you! That said, steady monthly contributions help us plan our budget more effectively and keep the roadmap predictable.",
        ),
      ]),

      html.h3([], [html.text("How can I change or cancel my sponsorship?")]),
      html.p([], [
        html.text(
          "If you are using Github Sponsors or Liberapay you can manage, pause, or cancel your sponsorship anytime through their sponsor's dashboards. If you want to edit a standing order or other regular bank transfer you will need to do this via your bank's app or website.",
        ),
      ]),
    ]),
  ]

  let featured_section = [
    html.h2([], [html.text("Kindly supported by")]),
    ..list.index_map(sponsor.featured(), fn(level, index) {
      html.ul(
        [class("sponsor-level" <> int.to_string(index + 1))],
        list.map(level, fn(sponsor) {
          let image =
            html.img([
              attr.alt(sponsor.name),
              attr.src(sponsor.image),
            ])
          html.li([], [
            html.a([attr.href(sponsor.website)], [image]),
          ])
        }),
      )
    })
  ]
  let content = [
    html.section([class("sponsor-project")], [
      html.img([attr.src("/images/lucy/lucy.svg")]),
      html.article([], [
        html.h3([], [html.text("The Gleam Project")]),
        html.p([], [
          html.text(
            "Gleam is a truly open-source community project and, unlike most programming languages, it is not owned by any particular tech corporation or academic institution. That means we depend entirely on sponsorship, from both individuals and companies.",
          ),
        ]),
        html.div(
          [class("sponsor-btn-group")],
          list.map(project_sponsor_links, fn(link) {
            html.a([attr.href(link.1)], [html.text(link.0)])
          }),
        ),
      ]),
    ]),
    html.p([class("text-center")], [
      html.text("Or sponsor some of our core team members!"),
    ]),
    html.section([], [html.ul([class("sponsees")], sponsees)]),

    html.article([class("content prose")], sponsees_section),

    html.section([class("sponsor-faqs")], [
      html.div([class("prose content")], faqs_section),
    ]),

    html.section(
      [class("sponsor-bank-transfer"), attr.id("sponsor-bank-transfer")],
      [html.div([class("prose content")], bank_transfer_section)],
    ),

    html.section([class("sponsor-featured")], [
      html.div([attr.class("content")], featured_section),
      html.img([
        attr.alt("a soft wavey boundary between two sections of the website"),
        attr.src("/images/waves.svg"),
        attr.role("divider"),
        attr.class("home-waves"),
      ]),
    ]),
    html.section([attr.class("home-sponsors"), attr.id("home-sponsors")], [
      html.div([attr.class("content")], [
        html.h2([], [html.text("Lovely people")]),
        html.p([], [
          html.text(
            "Here's some of the wonderful people already supporting Gleam",
          ),
        ]),
      ]),
      wall_of_sponsors(sponsors),
    ]),
  ]

  [
    header(hero_image: option.None, content: [
      html.h1([], [html.text(meta.title)]),
      html.p([attr.class("hero-subtitle")], [html.text(meta.subtitle)]),
    ]),
    ..content
  ]
  |> base_layout(meta, ctx)
  |> to_html_file(meta)
}

fn definition(dt: String, dd: String) -> Element(a) {
  element.fragment([
    html.dt([], [html.text(dt)]),
    html.dd([], [html.text(dd)]),
  ])
}

fn sponsor_card(
  name name: String,
  avatar avatar: String,
  title title: String,
  links links: List(#(String, String)),
) -> Element(a) {
  html.li([class("sponsee")], [
    html.img([attr.src(avatar)]),
    html.div([], [
      html.h4([], [html.text(name)]),
      html.p([], [html.text(title)]),
    ]),
    element.fragment(
      list.map(links, fn(link) {
        html.a([class("sponsor-button"), attr.href(link.1)], [
          html.text(link.0),
        ])
      }),
    ),
  ])
}

pub fn documentation(ctx: Context) -> fs.File {
  let meta =
    PageMeta(
      path: "/documentation",
      title: "Documentation",
      meta_title: "Documentation | Gleam programming language",
      subtitle: "Learn all about programming in Gleam!",
      description: "All about programming in Gleam: find the docs you need.",
      preview_image: option.Some("documentation"),
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
          html.text("The command line reference"),
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

    html.h2([attr.id("guides")], [html.text("Guides")]),
    html.ul([], [
      html.li([], [
        html.a([attr.href("/writing-gleam")], [
          html.text("Developing Gleam projects using the Gleam build tool"),
        ]),
      ]),
      html.li([], [
        html.a(
          [attr.href("/documentation/conventions-patterns-and-anti-patterns")],
          [html.text("Conventions, patterns, and anti-patterns in Gleam code")],
        ),
      ]),
      html.li([], [
        html.a([attr.href("/documentation/externals")], [
          html.text("Using code written in other languages from Gleam"),
        ]),
      ]),
    ]),

    html.h2([attr.id("security")], [html.text("Security")]),
    html.ul([], [
      html.li([], [
        html.a([attr.href("/documentation/source-bill-of-materials")], [
          html.text("Generating a Source Bill of Materials for a Gleam project"),
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

pub fn djot_to_html(document: jot.Document) -> String {
  jot.document_to_html(document)
}

pub fn djot_page(page: Page, ctx: Context) -> fs.File {
  let html = [
    element.unsafe_raw_html(
      "",
      "article",
      [class("prose")],
      djot_to_html(page.content),
    ),
  ]
  case table_of_contents_from_djot(page.content) {
    [] -> page_layout(html, "", page.meta, ctx)
    headings -> table_of_contents_page_layout(html, headings, page.meta, ctx)
  }
  |> to_html_file(page.meta)
}

type CommunityTalk {
  CommunityTalk(
    thumbnail: String,
    title: String,
    link: String,
    author: String,
    event: String,
  )
}

pub fn community(ctx: Context) -> fs.File {
  let meta =
    PageMeta(
      path: "/community",
      title: "The Gleam Community",
      meta_title: "The Gleam Community",
      subtitle: "Welcome, friend! It's good to have you",
      description: "Welcome, friend! It's good to have you. Come check where all the Gleamlins hang out and join us 🩷",
      preview_image: option.Some("community"),
    )

  let code_of_conduct =
    "https://github.com/gleam-lang/gleam/blob/main/CODE_OF_CONDUCT.md"

  let talks = [
    CommunityTalk(
      thumbnail: "https://img.youtube.com/vi/E6_JqYMeNqs/mqdefault.jpg",
      title: "Gleam and the value of small",
      link: "https://www.youtube.com/watch?v=E6_JqYMeNqs",
      author: "Giacomo Cavalieri",
      event: "Ubuntu Summit 26.04",
    ),
    CommunityTalk(
      thumbnail: "https://img.youtube.com/vi/LgfzH_WBlr4/mqdefault.jpg",
      title: "Panel Discussion",
      link: "https://www.youtube.com/watch?v=LgfzH_WBlr4",
      author: "Gleam Core Team",
      event: "Gleam Gathering 2026",
    ),
    CommunityTalk(
      thumbnail: "https://img.youtube.com/vi/6I0IbJtUC3U/mqdefault.jpg",
      title: "Gleam's Journey on the BEAM",
      link: "https://www.youtube.com/watch?v=6I0IbJtUC3U",
      author: "Hayleigh Thompson & Louis Pilfold",
      event: "Code BEAM Europe 2024",
    ),
  ]

  let content = [
    html.section([class("content")], [
      html.p([], [
        html.text(
          "If you’d like to get involved in the Gleam community and chat to other members about what they’re up to, you can join our Discord community chat, contribute on GitHub, follow us on social media, and subscribe to Gleam Weekly",
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
              html.div([], [
                html.h3([], [html.text("Discord Community")]),
                html.p([], [html.text("Lively and friendly, just like Gleam!")]),
              ]),
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
              html.div([], [
                html.h3([], [html.text("Gleam on GitHub")]),
                html.p([], [html.text("Chat and contribute!")]),
              ]),
            ],
          ),
        ]),
      ]),
      html.ul([class("community-secondary-links")], [
        html.li([], [
          html.a([attr.href("https://bsky.app/profile/gleam.run")], [
            html.span([class("icon")], [
              html.img([attr.src("/images/community/bluesky.svg")]),
            ]),
            html.div([], [
              html.p([], [html.text("Bluesky")]),
              html.h4([], [html.text("@gleam.run")]),
            ]),
          ]),
        ]),
        html.li([], [
          html.a([attr.href("https://reddit.com/r/gleamlang")], [
            html.span([class("icon")], [
              html.img([attr.src("/images/community/reddit.svg")]),
            ]),
            html.div([], [
              html.p([], [html.text("Reddit")]),
              html.h4([], [html.text("/r/gleamlang")]),
            ]),
          ]),
        ]),
        html.li([], [
          html.a([attr.href("https://twitter.com/gleamlang")], [
            html.span([class("icon")], [
              html.img([attr.src("/images/community/twitter.svg")]),
            ]),
            html.div([], [
              html.p([], [html.text("Twitter/X")]),
              html.h4([], [html.text("@gleamlang")]),
            ]),
          ]),
        ]),
      ]),
      html.div([class("gleam-weekly-shoutout")], [
        html.img([
          attr.src("/images/lucy/lucymail.svg"),
          attr.alt("Lucy (the Gleam mascot) holding a letter"),
        ]),
        html.p([], [
          html.text("Check out the community-made "),
          html.a([attr.href("https://gleamweekly.com")], [
            html.text("Gleam Weekly newsletter"),
          ]),
          html.text(
            " if you want to get the latest Gleam news delivered right to your inbox!",
          ),
        ]),
      ]),
    ]),
    html.article([class("content prose")], [
      html.h2([], [html.text("Participating in the community")]),
      html.p([], [
        html.text(
          "The Gleam community is a space where we treat each other kindly and
          with respect. We ensure that the community is safe, friendly, and open to
          everyone. Please read and adhere to our community ",
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
    html.section([class("community-talks")], [
      html.div([class("content")], [
        html.h2([], [html.text("Recent Conference Recordings and Talks")]),
        html.ul(
          [class("featured-talks")],
          list.map(talks, fn(talk) {
            html.li([], [
              html.a([class("community-talk"), attr.href(talk.link)], [
                html.figure(
                  [
                    class("talk-thumbnail"),
                    attr.style(
                      "background-image",
                      "url(" <> talk.thumbnail <> ")",
                    ),
                  ],
                  [],
                ),
                html.h4([], [html.text(talk.title)]),
                html.h5([], [html.text(talk.author)]),
                html.p([], [
                  html.img([
                    attr.src("/images/date-icon.svg"),
                    attr.width(16),
                    attr.alt("Calendar Icon"),
                  ]),
                  html.text(talk.event),
                ]),
              ]),
            ])
          }),
        ),
      ]),
    ]),
  ]

  [
    header(hero_image: option.None, content: [
      html.h1([], [html.text(meta.title)]),
      html.p([attr.class("hero-subtitle")], [html.text(meta.subtitle)]),
    ]),
    ..content
  ]
  |> base_layout(meta, ctx)
  |> to_html_file(meta)
}

pub fn branding(ctx: Context) -> fs.File {
  let meta =
    PageMeta(
      path: "/branding",
      title: "Gleam's branding",
      meta_title: "Branding and Lucy mascot | Gleam programming language",
      subtitle: "All pretty and pink 💖",
      description: "Meet Gleam's mascot, check branding guidelines, and see how we keep everything pretty and pink 💖",
      preview_image: option.Some("branding"),
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
          attr.alt(
            "Lucy in the shape of the maple leaf and dressed in Canadian flag",
          ),
          attr("title", "Lucy maple by Tolek"),
          attr.src("/images/lucy/lucymaple.svg"),
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

pub fn home(sponsors: List(sponsor.Sponsor), ctx: Context) -> fs.File {
  let meta =
    PageMeta(
      path: "/",
      title: "Gleam programming language",
      meta_title: "Gleam programming language",
      subtitle: "",
      description: "Discover a friendly language for scalable, type-safe systems. Gleam comes with compiler, build tool, formatter, editor integrations, and package manager all built in.",
      preview_image: option.None,
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
      html.section([class("home-top-sponsors")], [
        html.div([attr.class("content")], [
          html.h2([], [html.text("Kindly supported by")]),
          element.fragment(
            list.index_map(sponsor.featured(), fn(level, index) {
              html.ul(
                [class("sponsor-level" <> int.to_string(index + 1))],
                list.map(level, fn(sponsor) {
                  html.li([], [
                    html.a(
                      [
                        attr.target("_blank"),
                        attr.rel("noopener"),
                        attr.href(sponsor.website),
                      ],
                      [
                        html.img([
                          attr.alt(sponsor.name),
                          attr.src(sponsor.image),
                        ]),
                      ],
                    ),
                  ])
                }),
              )
            }),
          ),
          html.a(
            [
              attr.target("_blank"),
              attr.rel("noopener"),
              attr.href("/sponsor#home-sponsors"),
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
  let subject = process.new_subject()

  // Spawn a child green thread
  process.spawn(fn() {
    // Send a message back to the parent
    process.send(subject, \"Hello, Joe!\")
  })

  // Wait for the message to arrive
  echo process.receive(subject, 100)
}
",
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
          element.unsafe_raw_html(
            "",
            "p",
            [],
            "Black lives matter. Trans rights are human rights. No nazi bullsh*t.
            <!-- Hello! If you make a PR changing this I will ban you. -->
            ",
          ),
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
            html.a([attr.href("/sponsor")], [
              html.text("becoming a sponsor"),
            ]),
            html.text(" (or tell your boss to)"),
          ]),
        ]),
        wall_of_sponsors(sponsors),
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
  |> base_layout(meta, ctx)
  |> to_html_file(meta)
}

pub fn to_html_file(page_content: Element(a), meta: PageMeta) -> fs.File {
  fs.HtmlPage(
    path: meta.path,
    title: meta.title,
    content: element.to_document_string(page_content),
  )
}

fn wall_of_sponsors(sponsors: List(sponsor.Sponsor)) -> Element(a) {
  let sponsors = list.shuffle(sponsors)

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
  html.pre([], [element.unsafe_raw_html("", "code", [], html)])
}

pub fn highlighted_javascript_pre_code(code: String) -> Element(a) {
  let html = just.highlight_html(code)
  html.pre([], [element.unsafe_raw_html("", "code", [], html)])
}

pub fn highlighted_erlang_pre_code(code: String) -> Element(a) {
  let html = pearl.highlight_html(code)
  html.pre([], [element.unsafe_raw_html("", "code", [], html)])
}

fn highlight_shell_html(code: String) -> String {
  // TODO: real syntax highlighting
  code
  |> string.split("\n")
  |> list.map(fn(line) {
    let escaped = houdini.escape(line)
    case line {
      "#" <> _ -> "<span class=hl-comment>" <> escaped <> "</span>"
      _ -> escaped
    }
  })
  |> string.join("\n")
}

fn highlight_toml_html(code: String) -> String {
  code
  |> string.split("\n")
  |> list.map(fn(line) {
    // TODO: real syntax highlighting
    case line {
      "#" <> _ -> "<span class=hl-comment>" <> line <> "</span>"
      "[" <> _ -> "<span class=hl-module>" <> line <> "</span>"
      _ ->
        case string.split_once(line, "=") {
          Ok(#(before, after)) ->
            "<span class=hl-function>" <> before <> "</span>=" <> after
          _ -> line
        }
    }
  })
  |> string.join("\n")
}

fn highlight_yaml_html(code: String) -> String {
  // TODO: real syntax highlighting
  code
  |> string.split("\n")
  |> list.map(fn(line) {
    let escaped = houdini.escape(line)
    case string.split_once(line, ": ") {
      Ok(#(before, after)) ->
        "<span class=hl-function>"
        <> houdini.escape(before)
        <> "</span>: "
        <> houdini.escape(after)
      Error(_) ->
        case string.ends_with(line, ":") {
          True -> "<span class=hl-function>" <> escaped <> "</span>"
          False -> escaped
        }
    }
  })
  |> string.join("\n")
}

pub fn share_button() -> Element(a) {
  html.button(
    [
      attr(
        "onclick",
        "window.navigator.clipboard.writeText(document.location.href)",
      ),
      attr.data("tooltip-position", "right"),
      attr.data("tooltip-trigger", "click"),
      attr.aria_label("Copy post URL to clipboard"),
      class("tooltip-container meta-button share-button"),
    ],
    [
      html.img([
        attr.width(20),
        attr.src("/images/share-icon.svg"),
        attr.alt("Share Icon"),
      ]),
      html.text("Share"),
      html.span(
        [
          class("tooltip"),
          attr.id("share-tooltip"),
          attr.role("status"),
          attr.aria_hidden(True),
        ],
        [html.text("Copied the post URL!")],
      ),
    ],
  )
}

pub fn decode_frontmatter(
  page: Page,
  decoder: decode.Decoder(t),
) -> Result(#(Page, t), snag.Snag) {
  decode.run(page.frontmatter, decoder)
  |> result.map(pair.new(page, _))
  |> snag.map_error(string.inspect)
  |> snag.context("Failed to decode additional metadata for " <> page.meta.path)
}

pub fn parse_djot(string: String) -> jot.Document {
  let document = jot.parse(string)
  let content =
    list.map(document.content, fn(container) {
      case container {
        jot.Codeblock(language: option.Some("gleam"), content:, ..) -> {
          let content = contour.to_html(content)
          jot.RawBlock("<pre><code>" <> content <> "</code></pre>")
        }
        jot.Codeblock(language: option.Some("erlang"), content:, ..) -> {
          let content = pearl.highlight_html(content)
          jot.RawBlock("<pre><code>" <> content <> "</code></pre>")
        }
        jot.Codeblock(language: option.Some("elixir"), content:, ..) -> {
          let content = tear.highlight(content) |> tear.to_html
          jot.RawBlock("<pre><code>" <> content <> "</code></pre>")
        }
        jot.Codeblock(language: option.Some("json"), content:, ..)
        | jot.Codeblock(language: option.Some("ts"), content:, ..)
        | jot.Codeblock(language: option.Some("typescript"), content:, ..)
        | jot.Codeblock(language: option.Some("js"), content:, ..)
        | jot.Codeblock(language: option.Some("javascript"), content:, ..) -> {
          let content = just.highlight_html(content)
          jot.RawBlock("<pre><code>" <> content <> "</code></pre>")
        }
        // Lua syntax is close enough to JavaScript for us to reuse the
        // highlighting. We have very little Lua code, so it's ok that it's not
        // perfect.
        jot.Codeblock(language: option.Some("lua"), content:, ..) -> {
          let content = just.highlight_html(content)
          jot.RawBlock("<pre><code>" <> content <> "</code></pre>")
        }
        jot.Codeblock(language: option.Some("diff"), content:, ..) -> {
          let content =
            string.split(content, "\n")
            |> list.map(fn(line) {
              case line {
                "+" <> _ -> "<span class=hl-addition>" <> line <> "</span>"
                "-" <> _ -> "<span class=hl-deletion>" <> line <> "</span>"
                _ -> line
              }
            })
            |> string.join("\n")
          jot.RawBlock("<pre><code>" <> content <> "</code></pre>")
        }
        jot.Codeblock(language: option.Some("yaml"), content:, ..) -> {
          let content = highlight_yaml_html(content)
          jot.RawBlock("<pre><code>" <> content <> "</code></pre>")
        }
        jot.Codeblock(language: option.Some("toml"), content:, ..) -> {
          let content = highlight_toml_html(content)
          jot.RawBlock("<pre><code>" <> content <> "</code></pre>")
        }
        jot.Codeblock(language: option.Some("cli"), content:, ..) -> {
          let content = highlight_html_cli(content)
          jot.RawBlock(
            "<pre><code class=language-cli>" <> content <> "</code></pre>",
          )
        }
        jot.Codeblock(language: option.Some("sh"), content:, ..)
        | jot.Codeblock(language: option.Some("shell"), content:, ..)
        | jot.Codeblock(language: option.Some("bash"), content:, ..) -> {
          let content = highlight_shell_html(content)
          jot.RawBlock("<pre><code>" <> content <> "</code></pre>")
        }
        jot.Codeblock(language: option.Some("containerfile"), content:, ..) -> {
          let content = highlight_containerfile_html(content)
          jot.RawBlock("<pre><code>" <> content <> "</code></pre>")
        }

        jot.Codeblock(language: option.Some("python"), ..)
        | jot.Codeblock(language: option.Some("caddyfile"), ..)
        | jot.Codeblock(language: option.Some("lisp"), ..)
        | jot.Codeblock(language: option.Some("systemd"), ..)
        | jot.Codeblock(language: option.Some("markdown"), ..)
        | jot.Codeblock(language: option.Some("md"), ..)
        | jot.Codeblock(language: option.Some("txt"), ..)
        | jot.Codeblock(language: option.Some("text"), ..) -> container

        jot.Codeblock(language: option.Some(language), ..) -> {
          panic as { "Unsupported codeblock language " <> language }
        }
        _ -> container
      }
    })
  jot.Document(..document, content:)
}

fn highlight_containerfile_html(code: String) -> String {
  // TODO: real syntax highlighting
  code
  |> string.split("\n")
  |> list.map(fn(line) {
    case line {
      "#" <> _ -> "<span class=hl-comment>" <> houdini.escape(line) <> "</span>"

      "RUN" as command <> rest
      | "ENV" as command <> rest
      | "ARG" as command <> rest
      | "USER" as command <> rest
      | "FROM" as command <> rest
      | "COPY" as command <> rest
      | "WORKDIR" as command <> rest
      | "ENTRYPOINT" as command <> rest
      | "CMD" as command <> rest ->
        "<span class=hl-function>"
        <> houdini.escape(command)
        <> "</span>"
        <> houdini.escape(rest)

      _ -> line
    }
  })
  |> string.join("\n")
}

fn highlight_html_cli(content: String) -> String {
  let highlight = fn(text, class) {
    "<span class=code-" <> class <> ">" <> text <> "</span>"
  }
  content
  |> string.split(" ")
  |> list.map(fn(word) {
    case word {
      "gleam" -> highlight(word, "operator")
      "--" <> _ -> highlight(word, "keyword")
      "\\\n" -> highlight(word, "comment")
      "|" -> highlight(word, "comment")
      _ -> word
    }
  })
  |> string.join(" ")
}
