import gleam/dynamic/decode
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/time/calendar
import lustre/attribute.{class} as attr
import lustre/element
import lustre/element/html
import snag
import tom
import website/fs
import website/site

pub type Company {
  Company(
    name: String,
    description: String,
    website_url: String,
    gleaming_since: calendar.Date,
    founded: calendar.Date,
  )
}

fn company_decoder() -> decode.Decoder(Company) {
  use name <- decode.field("name", decode.string)
  use description <- decode.field("description", decode.string)
  use website_url <- decode.field("website_url", decode.string)
  use gleaming_since <- decode.field("gleaming_since", tom.date_decoder())
  use founded <- decode.field("founded", tom.date_decoder())
  decode.success(Company(
    name:,
    description:,
    website_url:,
    gleaming_since:,
    founded:,
  ))
}

pub type CaseStudyData {
  CaseStudy(published: calendar.Date, featured_quote: String, company: Company)
}

fn data_decoder() -> decode.Decoder(CaseStudyData) {
  use published <- decode.field("published", tom.date_decoder())
  use featured_quote <- decode.field("featured_quote", decode.string)
  use company <- decode.field("company", company_decoder())
  decode.success(CaseStudy(published:, featured_quote:, company:))
}

pub fn files(
  pages: List(site.Page),
  context: site.Context,
) -> snag.Result(List(fs.File)) {
  use studies <- result.try(
    list.try_map(pages, site.decode_frontmatter(_, data_decoder())),
  )
  Ok([index_page(studies, context), ..list.map(studies, study_page(_, context))])
}

fn study_page(page: #(site.Page, CaseStudyData), ctx: site.Context) -> fs.File {
  let #(page, data) = page
  [
    html.div([class("")], [
      html.blockquote([class("case-study-quote")], [
        html.text(data.featured_quote),
      ]),
      html.ul([class("case-study-meta")], [
        html.li([], [
          html.h4([], [html.text(data.company.name)]),
          html.p([], [html.text(data.company.description)]),
          html.p([], [
            html.a([attr.href(data.company.website_url)], [
              html.text("Visit Website"),
            ]),
          ]),
        ]),
        html.li([], [
          html.h4([], [html.text("Founded")]),
          html.p([], [
            html.text(data.company.founded.year |> int.to_string),
          ]),
        ]),
        html.li([], [
          html.h4([], [html.text("Using Gleam Since")]),
          html.p([], [
            html.time([], [
              html.text(
                calendar.month_to_string(data.company.gleaming_since.month)
                <> ", "
                <> int.to_string(data.company.gleaming_since.year),
              ),
            ]),
          ]),
        ]),
        html.li([], [
          html.h4([], [html.text("Published")]),
          html.p([], [
            html.time([], [html.text(site.short_human_date(data.published))]),
          ]),
        ]),
        site.share_button(),
      ]),

      element.unsafe_raw_html(
        "",
        "article",
        [class("post prose")],
        site.djot_to_html(page.content),
      ),
      html.section([class("page-cta")], [
        html.img([
          attr.src("/images/lucy/lucy.svg"),
          attr.alt("Lucy the star, Gleam's mascot"),
        ]),
        html.div([], [
          html.h4([], [html.text("Ready to start your Gleam journey?")]),
          html.p([], [
            html.text("Check out the "),
            html.a([attr.href("https://tour.gleam.run")], [
              html.text("language tour"),
            ]),
            html.text(" and "),
            html.a([attr.href("/documentation/")], [html.text("documentation")]),
            html.text("."),
          ]),
          html.p([], [
            html.text("Already using it in production? "),
            html.a([attr.href("/community/")], [
              html.text("Share your story with us"),
            ]),
            html.text(", we'd love to hear all about it!"),
          ]),
        ]),
      ]),
    ]),
  ]
  |> site.page_layout("", page.meta, ctx)
  |> site.to_html_file(page.meta)
}

pub fn index_page(
  studies: List(#(site.Page, CaseStudyData)),
  ctx: site.Context,
) -> fs.File {
  let meta =
    site.PageMeta(
      path: "/case-studies",
      title: "Case Studies",
      meta_title: "Case Studies | Gleam programming language",
      subtitle: "Analysis of Gleam in production",
      description: "Experience reports and outcome analysis of Gleam in production for business software.",
      preview_image: option.None,
    )

  let list_items =
    list.map(studies, fn(case_study) {
      let #(page, data) = case_study
      html.li([], [
        html.a([attr.href(page.meta.path)], [
          html.img([
            class("cover-img"),
            attr.src(
              "/images/preview/"
              <> option.unwrap(page.meta.preview_image, "")
              <> ".png",
            ),
            attr.alt("Case study cover image for " <> data.company.name),
          ]),
        ]),
        html.article([], [
          html.a([attr.href(page.meta.path)], [
            html.h2([attr.class("links")], [html.text(page.meta.title)]),
          ]),
          html.blockquote([], [
            html.p([], [html.text("\"" <> data.featured_quote <> "\"")]),
          ]),
          html.ul([class("case-meta")], [
            html.li([], [
              html.img([
                attr.width(16),
                attr.src("/images/date-icon.svg"),
                attr.alt("Date Icon"),
              ]),
              html.text(
                "Using Gleam since "
                <> calendar.month_to_string(data.company.gleaming_since.month)
                <> " "
                <> int.to_string(data.company.gleaming_since.year),
              ),
            ]),
          ]),
        ]),
      ])
    })

  [
    html.ul([class("case-studies")], list_items),
    html.section([class("page-cta")], [
      html.img([
        attr.src("/images/lucy/lucy.svg"),
        attr.alt("Lucy the star, Gleam's mascot"),
      ]),
      html.div([], [
        html.h4([], [html.text("Using Gleam in production, or ready to start?")]),
        html.p([], [
          html.text(
            "We'd love to hear from you! Whether you've got a mature Gleam project you would like to share here, or you want some expert help adopting Gleam for your company, get in touch at ",
          ),
          html.a([attr.href("mailto:hello@gleam.run")], [
            html.text("hello@gleam.run"),
          ]),
        ]),
      ]),
    ]),
  ]
  |> site.page_layout("", meta, ctx)
  |> site.to_html_file(meta)
}
