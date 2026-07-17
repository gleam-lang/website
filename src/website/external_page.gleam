import frontmatter
import gleam/dynamic/decode
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import snag
import tom
import website/case_study
import website/fs
import website/news
import website/page
import website/site.{type Page, Page}

pub fn pages(context: site.Context) -> snag.Result(List(fs.File)) {
  io.print("Loading pages: ")

  use pages <- result.try(fs.all_files("./pages"))
  use pages <- result.try(
    list.try_map(pages, fn(path) {
      read(path)
      |> snag.context("Failed to load " <> path)
    }),
  )
  io.print("\n")

  let Site(case_studies:, news:, other:) =
    list.fold(pages, Site([], [], []), fn(site, page) {
      case page.meta.path {
        "/case-studies/" <> _ -> {
          Site(..site, case_studies: [page, ..site.case_studies])
        }
        "/news/" <> _ -> {
          Site(..site, news: [page, ..site.news])
        }
        _ -> {
          Site(..site, other: [page, ..site.other])
        }
      }
    })

  use case_studies <- result.try(case_study.files(case_studies, context))
  use news <- result.try(news.files(news, context))

  [
    case_studies,
    news,
  ]
  |> list.flatten
  |> Ok
}

pub type Target {
  Any
  Erlang
  Javascript
}

pub type Site {
  Site(case_studies: List(Page), news: List(Page), other: List(Page))
}

fn read(path: String) -> snag.Result(Page) {
  io.print(".")
  use content <- result.try(fs.read(path))
  let path = string.remove_suffix(path, ".djot")
  let assert "./pages" <> path = path as "pages directory prefix"
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
    decode.run(frontmatter, site.page_meta_decoder(path))
    |> snag.map_error(string.inspect)
    |> snag.context("Invalid frontmatter fields"),
  )
  let content = page.parse_djot(content)
  Ok(Page(meta:, content:, frontmatter:))
}

pub fn target_string(target: Target) -> String {
  case target {
    Javascript -> "JavaScript"
    Erlang -> "Erlang"
    Any -> "Any"
  }
}
// pub fn index_page(guides: List(Page), ctx: site.Context) -> fs.File {
//   let meta =
//     page.PageMeta(to_toc_html
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
