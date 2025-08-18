import filepath
import gleam/io
import gleam/result
import gleam/string
import gleam/time/calendar
import jot
import snag
import website/fs

pub fn all() -> snag.Result(List(CaseStudy)) {
  io.print("Loading case studies: ")
  let posts = [
    read(
      title: "Optimising for maintainability",
      subtitle: "A case study of Gleam in production at Strand",
      description: "A case study of Gleam in production at Strand",
      published: calendar.Date(2025, calendar.July, 11),
      path: "strand",
    ),
  ]
  io.print("\n")
  posts
  |> result.all()
}

pub type CaseStudy {
  CaseStudy(
    title: String,
    subtitle: String,
    description: String,
    published: calendar.Date,
    path: String,
    content: String,
  )
}

fn read(
  title title: String,
  subtitle subtitle: String,
  description description: String,
  published published: calendar.Date,
  path path: String,
) -> snag.Result(CaseStudy) {
  io.print(".")
  filepath.join("case-studies", path)
  |> string.append(".djot")
  |> fs.read
  |> snag.context("Failed to load content for /case-studies/" <> path)
  |> result.map(djot_to_html)
  |> result.map(CaseStudy(_, title:, subtitle:, description:, published:, path:))
}

fn djot_to_html(string: String) -> String {
  jot.parse(string)
  |> jot.document_to_html
}
