import gleam/list
import gleam/option
import gleam/set
import gleam/string
import lustre/attribute.{class} as attr
import lustre/element/html
import website/fs
import website/site.{PageMeta}

pub type Guide {
  Guide(tags: List(String), title: String, path: String, target: Target)
}

pub type Target {
  Any
  Erlang
  Javascript
}

pub fn target_string(target: Target) -> String {
  case target {
    Javascript -> "JavaScript"
    Erlang -> "Erlang"
    Any -> "Any"
  }
}

const guides = [
  Guide(
    title: "Using the Gleam build tool",
    target: Any,
    tags: ["basic"],
    path: "/writing-gleam",
  ),
  Guide(
    title: "Conventions, patterns and anti-patterns",
    target: Any,
    tags: ["basic", "patterns"],
    path: "/documentation/conventions-patterns-and-anti-patterns",
  ),
  Guide(
    title: "Using external functions",
    target: Any,
    tags: ["basic", "ffi"],
    path: "/documentation/externals",
  ),
]

pub fn index(ctx: site.Context) -> fs.File {
  let meta =
    PageMeta(
      path: "guides",
      title: "Guides",
      subtitle: "",
      meta_title: "",
      description: "TODO",
      preview_image: option.None,
    )

  let guide_icon = fn(target: Target) {
    html.img([
      attr.src(
        "/images/target-"
        <> case target {
          Any -> "any"
          Erlang -> "erlang"
          Javascript -> "javascript"
        }
        <> "-icon.svg",
      ),
    ])
  }

  let #(tags, guides) =
    list.fold(guides, #(set.new(), []), fn(acc, guide) {
      let #(tags, guides) = acc
      let tags =
        list.fold(guide.tags, tags, fn(tag_acc, tag) {
          set.insert(tag_acc, tag)
        })

      #(tags, [
        html.li([], [
          html.a([class("link"), attr.href(guide.path)], [
            html.h4([], [html.text(guide.title)]),
            html.ul([class("link-meta")], [
              html.li([class("guide-target")], [
                guide_icon(guide.target),
                html.text(target_string(guide.target)),
              ]),
              html.li([class("guide-tags")], [
                html.img([
                  attr.src("/images/tag-icon.svg"),
                  attr.alt("Tag icon"),
                ]),
                html.text(
                  guide.tags
                  |> string.join(", "),
                ),
              ]),
            ]),
          ]),
        ]),
        ..guides
      ])
    })

  let tags = set.to_list(tags)

  [
    html.h5([class("tag-filter-label")], [html.text("Filter by tag")]),
    html.ul(
      [class("tag-picker")],
      list.map(tags, fn(tag) {
        html.li([], [html.button([], [html.text(tag)])])
      }),
    ),
    html.h5([class("tag-filter-label")], [html.text("Or search by title")]),
    html.form([class("tag-search-form")], [
      html.input([
        attr.type_("text"),
        attr.placeholder("eg. external, patterns, http"),
      ]),
      html.img([
        class("search-icon"),
        attr.src("/images/search-icon.svg"),
        attr.alt("Search icon"),
        attr.aria_hidden(True),
      ]),
    ]),
    html.ul([class("link-cards")], guides),
  ]
  |> site.page_layout("", meta, ctx)
  |> site.to_html_file(meta)
}
