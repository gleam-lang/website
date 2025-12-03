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
      title: "No room for error",
      subtitle: "Gleam in production at Uncover",
      description: "A case study of Gleam in production at Uncover",
      published: calendar.Date(2025, calendar.December, 3),
      preview_image: "uncover",
      path: "uncover",
      featured_quote: "The only bugs we've seen in our Gleam codebase are mistakes in business logic - nothing that would actually crash in production. That's a breath of fresh air compared to the rest of our backend codebase",
      company: Company(
        name: "Uncover",
        description: "Uncover is a solution crafted to unleash the full power of marketing data in a single easy-to-use platform.",
        website_url: "https://www.uncover.co/",
        gleaming_since: calendar.Date(2024, calendar.April, 1),
        founded: calendar.Date(2020, month: calendar.September, day: 1),
      ),
    ),
    read(
      title: "Optimising for maintainability",
      subtitle: "A case study of Gleam in production at Strand",
      description: "A case study of Gleam in production at Strand",
      published: calendar.Date(2025, calendar.July, 11),
      preview_image: "strand",
      path: "strand",
      featured_quote: "Almost by accident, what we launched as a prototype became a business-critical application",
      company: Company(
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
  Company(
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
    company: CompanyDetails,
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
  company company: CompanyDetails,
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
    company:,
  ))
}

fn djot_to_html(string: String) -> String {
  jot.parse(string)
  |> jot.document_to_html
}
