import frontmatter
import gleam/dynamic/decode
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import snag
import tom
import website/fs
import website/page/case_study
import website/page/news
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
  let other = list.map(other, site.djot_page(_, context))

  [
    case_studies,
    news,
    other,
  ]
  |> list.flatten
  |> Ok
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
    decode.run(frontmatter, page_meta_decoder(path))
    |> snag.map_error(string.inspect)
    |> snag.context("Invalid frontmatter fields"),
  )
  let content = site.parse_djot(content)
  Ok(Page(meta:, content:, frontmatter:))
}

fn page_meta_decoder(path: String) -> decode.Decoder(site.PageMeta) {
  use title <- decode.field("title", decode.string)
  use subtitle <- decode.field("subtitle", decode.string)
  use meta_title <- decode.field("meta_title", decode.string)
  use description <- decode.field("description", decode.string)
  use preview_image <- decode.optional_field(
    "preview_image",
    option.None,
    decode.optional(decode.string),
  )
  decode.success(site.PageMeta(
    path:,
    title:,
    subtitle:,
    meta_title:,
    description:,
    preview_image:,
  ))
}
