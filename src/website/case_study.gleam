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
      preview_image: "strand",
      path: "strand",
      featured_quote: "Almost by accident, what we launched as a prototype became a business-critical application",
      company_details: CompanyDetails(
        name: "Strand",
        description: "Outstanding creative services for IT companies seeking to tell and sell the business benefits of their solutions",
        website_url: "https://strand-uk.com",
        gleaming_since: calendar.Date(2024, calendar.January, 1),
        founded: calendar.Date(1994, month: calendar.January, day: 1),
      ),
    ),
  ]
  io.print("\n")
  posts
  |> result.all()
}

pub type CompanyDetails {
  CompanyDetails(
    name: String,
    description: String,
    website_url: String,
    gleaming_since: calendar.Date,
    founded: calendar.Date,
  )
}

pub type CaseStudy {
  CaseStudy(
    title: String,
    subtitle: String,
    description: String,
    published: calendar.Date,
    path: String,
    content: String,
    preview_image: String,
    featured_quote: String,
    company_details: CompanyDetails,
  )
}

fn read(
  title title: String,
  subtitle subtitle: String,
  description description: String,
  published published: calendar.Date,
  preview_image preview_image: String,
  path path: String,
  featured_quote featured_quote: String,
  company_details company_details: CompanyDetails,
) -> snag.Result(CaseStudy) {
  io.print(".")
  filepath.join("case-studies", path)
  |> string.append(".djot")
  |> fs.read
  |> snag.context("Failed to load content for /case-studies/" <> path)
  |> result.map(djot_to_html)
  |> result.map(CaseStudy(
    _,
    title:,
    subtitle:,
    description:,
    published:,
    path:,
    preview_image:,
    featured_quote:,
    company_details:,
  ))
}

fn djot_to_html(string: String) -> String {
  jot.parse(string)
  |> jot.document_to_html
}
