import filepath
import frontmatter
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import jot
import lustre/attribute
import lustre/element
import snag
import tom
import website/fs
import website/page
import website/site

pub fn all() -> snag.Result(Site) {
  io.print("Loading pages: ")

  use pages <- result.try(fs.read_directory("./pages"))
  use pages <- result.map(
    list.try_map(pages, fn(path) {
      read(path)
      |> snag.context("Failed to load " <> path)
    }),
  )
  io.print("\n")

  pages
  |> list.fold(Site([], [], []), fn(site, page) {
    case page.meta.path {
      "case-studies/" <> _ -> {
        Site(..site, case_studies: [page, ..site.case_studies])
      }
      "news/" <> _ -> {
        Site(..site, news: [page, ..site.news])
      }
      _ -> {
        Site(..site, other: [page, ..site.other])
      }
    }
  })
}

pub type Target {
  Any
  Erlang
  Javascript
}

pub type Site {
  Site(case_studies: List(Page), news: List(Page), other: List(Page))
}

pub type Page {
  Page(meta: page.PageMeta, content: jot.Document, frontmatter: Dynamic)
}

fn meta_decoder(path: String) -> decode.Decoder(page.PageMeta) {
  use title <- decode.field("title", decode.string)
  use subtitle <- decode.field("subtitle", decode.string)
  use meta_title <- decode.field("meta_title", decode.string)
  use description <- decode.field("description", decode.string)
  use preview_image <- decode.optional_field(
    "preview_image",
    option.None,
    decode.optional(decode.string),
  )
  decode.success(
    page.PageMeta(
      path:,
      title:,
      subtitle:,
      meta_title:,
      description:,
      preview_image:,
      preload_images: [],
    ),
  )
}

fn read(path: String) -> snag.Result(Page) {
  io.print(".")
  use content <- result.try(filepath.join("pages", path) |> fs.read)
  let path = string.remove_suffix(path, ".djot")
  let frontmatter.Extracted(meta, content) = frontmatter.extract(content)

  use toml <- result.try(
    meta |> option.to_result(snag.new("Missing frontmatter")),
  )
  use frontmatter <- result.try(
    tom.parse_to_dynamic(toml)
    |> snag.map_error(string.inspect)
    |> snag.context("Invalid toml syntax in frontmatter"),
  )
  use meta <- result.try(
    decode.run(frontmatter, meta_decoder(path))
    |> snag.map_error(string.inspect)
    |> snag.context("Invalid frontmatter fields"),
  )
  let content = jot.parse(content)
  Ok(Page(meta:, content:, frontmatter:))
}

pub fn target_string(target: Target) -> String {
  case target {
    Javascript -> "JavaScript"
    Erlang -> "Erlang"
    Any -> "Any"
  }
}

pub fn page(page: Page, ctx: site.Context) -> fs.File {
  let headings = page.content |> page.table_of_contents_from_djot
  let layout = case headings {
    [] -> page.page_layout(_, "", page.meta, ctx)
    _ -> page.table_of_contents_page_layout(_, headings, page.meta, ctx)
  }

  let html = jot.document_to_html(page.content)
  [element.unsafe_raw_html("", "article", [attribute.class("prose")], html)]
  |> layout
  |> page.to_html_file(page.meta)
}
// pub fn index_page(guides: List(Page), ctx: site.Context) -> fs.File {
//   let meta =
//     page.PageMeta(
//       path: "guides",
//       title: "Guides",
//       description: "TODO",
//       preload_images: [],
//       subtitle: "",
//       meta_title: "",
//       preview_image: option.None,
//     )
//
//   let guide_icon = fn(target: Target) {
//     html.img([
//       attr.src(
//         "/images/target-"
//         <> case target {
//           Any -> "any"
//           Erlang -> "erlang"
//           Javascript -> "javascript"
//         }
//         <> "-icon.svg",
//       ),
//     ])
//   }
//
//   let guides =
//     list.map(guides, fn(guide) {
//       html.li([], [
//         html.a([class("link"), attr.href(guide.path)], [
//           html.h4([], [html.text(guide.meta.title)]),
//           html.ul([class("link-meta")], [
//             html.li([class("guide-target")], [
//               guide_icon(guide.target),
//               html.text(target_string(guide.target)),
//             ]),
//             html.li([class("guide-tags")], [
//               html.text(
//                 guide.tags
//                 |> string.join(", "),
//               ),
//             ]),
//           ]),
//         ]),
//       ])
//     })
//
//   [
//     html.main([class("page content")], [
//       // html.p([], [html.text("Filter by tag")]),
//       // html.ul(
//       //   [class("tag-picker")],
//       //   list.map(tags, fn(tag) {
//       //     html.li([], [html.button([], [html.text(tag.name)])])
//       //   }),
//       // ),
//       // html.p([], [html.text("Or search by title")]),
//       // html.form([class("tag-search-form")], [
//       //   html.input([attribute.type_("text")]),
//       // ]),
//       html.ul([class("link-cards")], guides),
//     ]),
//   ]
//   |> page.page_layout("", meta, ctx)
//   |> page.to_html_file(meta)
// }
