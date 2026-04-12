import filepath
import frontmatter
import gleam/dict
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import jot
import lustre/attribute.{class} as attr
import lustre/element
import lustre/element/html
import snag
import tom
import website/fs
import website/page
import website/site

pub fn all() -> snag.Result(List(Guide)) {
  io.print("Loading guides: ")

  use all_guides <- result.try(fs.read_directory("./guides"))
  let guides = list.try_map(all_guides, read)

  io.print("\n")

  guides
}

pub type Target {
  Any
  Erlang
  Javascript
}

pub type Guide {
  Guide(
    slug: String,
    title: String,
    subtitle: String,
    tags: List(String),
    target: Target,
    content: jot.Document,
  )
}

fn decode_frontmatter(
  slug: String,
  table: dict.Dict(String, tom.Toml),
) -> snag.Result(Guide) {
  let slug =
    tom.get_string(table, ["slug"])
    |> result.unwrap(slug)
  use title <- result.try(tom.get_string(table, ["title"]) |> toml_to_snag)
  use subtitle <- result.try(
    tom.get_string(table, ["subtitle"]) |> toml_to_snag,
  )
  use raw_tags <- result.try(tom.get_array(table, ["tags"]) |> toml_to_snag)
  use tags <- result.try(
    list.map(raw_tags, tom.as_string)
    |> result.all
    |> toml_to_snag,
  )
  use target <- result.try(
    tom.get_string(table, ["target"])
    |> toml_to_snag
    |> result.map(fn(target) {
      case string.lowercase(target) {
        "erlang" -> Erlang
        "javascript" -> Javascript
        _ -> Any
      }
    }),
  )

  Ok(Guide(
    slug:,
    title:,
    subtitle:,
    tags:,
    target:,
    content: jot.Document([], dict.new(), dict.new(), dict.new()),
  ))
}

fn toml_to_snag(result: Result(a, tom.GetError)) -> snag.Result(a) {
  result.map_error(result, fn(e) { snag.new(string.inspect(e)) })
}

fn read(path: String) -> snag.Result(Guide) {
  let slug = string.remove_suffix(path, ".djot")

  io.print(".")
  use content <- result.try(
    filepath.join("guides", path)
    |> fs.read
    |> snag.context("Failed to load content for /guides/" <> path),
  )
  let frontmatter.Extracted(meta, content) = frontmatter.extract(content)
  use parsed_frontmatter <- result.try(
    tom.parse(option.unwrap(meta, ""))
    |> snag.map_error(string.inspect),
  )
  use guide <- result.try(decode_frontmatter(path, parsed_frontmatter))
  let content = jot.parse(content)
  Ok(Guide(..guide, slug:, content:))
}

pub fn target_string(target: Target) -> String {
  case target {
    Javascript -> "JavaScript"
    Erlang -> "Erlang"
    Any -> "Any"
  }
}

pub fn page(guide: Guide, ctx: site.Context) -> fs.File {
  let meta =
    page.PageMeta(
      path: "guides/" <> guide.slug,
      title: guide.title,
      meta_title: guide.title <> " | Gleam Programming Language",
      subtitle: guide.subtitle,
      description: guide.subtitle,
      preload_images: [],
      preview_image: option.None,
    )

  let table_of_contents =
    guide.content
    |> page.table_of_contents_from_djot

  let layout = case table_of_contents {
    [] -> page.page_layout(_, "", meta, ctx)
    _ -> page.table_of_contents_page_layout(_, table_of_contents, meta, ctx)
  }

  [
    element.unsafe_raw_html(
      "",
      "article",
      [class("prose")],
      jot.document_to_html(guide.content),
    ),
  ]
  |> layout
  |> page.to_html_file(meta)
}

pub fn index_page(guides: List(Guide), ctx: site.Context) -> fs.File {
  let meta =
    page.PageMeta(
      path: "guides",
      title: "Guides",
      description: "TODO",
      preload_images: [],
      subtitle: "",
      meta_title: "",
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

  let guides =
    list.map(guides, fn(guide) {
      html.li([], [
        html.a([class("link"), attr.href("/guides/" <> guide.slug)], [
          html.h4([], [html.text(guide.title)]),
          html.ul([class("link-meta")], [
            html.li([class("guide-target")], [
              guide_icon(guide.target),
              html.text(target_string(guide.target)),
            ]),
            html.li([class("guide-tags")], [
              html.text(
                guide.tags
                |> string.join(", "),
              ),
            ]),
          ]),
        ]),
      ])
    })

  [
    html.main([class("page content")], [
      // html.p([], [html.text("Filter by tag")]),
      // html.ul(
      //   [class("tag-picker")],
      //   list.map(tags, fn(tag) {
      //     html.li([], [html.button([], [html.text(tag.name)])])
      //   }),
      // ),
      // html.p([], [html.text("Or search by title")]),
      // html.form([class("tag-search-form")], [
      //   html.input([attribute.type_("text")]),
      // ]),
      html.ul([class("link-cards")], guides),
    ]),
  ]
  |> page.page_layout("", meta, ctx)
  |> page.to_html_file(meta)
}
