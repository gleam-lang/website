import gleam/dynamic/decode
import gleam/list
import gleam/option
import gleam/result
import gleam/set
import gleam/string
import lustre/attribute as attr
import lustre/element/html
import snag
import website/fs
import website/site

pub type TargetSupport {
  SupportsAll
  SupportsErlang
  SupportsJavascript
}

fn target_decoder() -> decode.Decoder(TargetSupport) {
  use variant <- decode.then(decode.string)
  case variant {
    "all" -> decode.success(SupportsAll)
    "erlang" -> decode.success(SupportsErlang)
    "javascript" -> decode.success(SupportsJavascript)
    _ -> decode.failure(SupportsAll, "TargetSupport")
  }
}

fn target_string(target: TargetSupport) -> String {
  case target {
    SupportsJavascript -> "JavaScript"
    SupportsErlang -> "Erlang"
    SupportsAll -> "All targets"
  }
}

fn target_icon(target: TargetSupport) -> String {
  let target = case target {
    SupportsJavascript -> "javascript"
    SupportsErlang -> "erlang"
    SupportsAll -> "all"
  }
  "/images/target-" <> target <> "-icon.svg"
}

pub type GuideData {
  GuideData(target: TargetSupport, tags: List(String))
}

fn guide_data_decoder() -> decode.Decoder(GuideData) {
  use target <- decode.optional_field("target", SupportsAll, target_decoder())
  use tags <- decode.field("tags", decode.list(decode.string))
  let tags = list.sort(tags, string.compare)
  decode.success(GuideData(target:, tags:))
}

pub fn files(
  posts: List(site.Page),
  context: site.Context,
) -> snag.Result(List(fs.File)) {
  use guides <- result.try(
    list.try_map(posts, site.decode_frontmatter(_, guide_data_decoder())),
  )
  let guides =
    list.sort(guides, fn(a, b) {
      string.compare(a.0.meta.title, b.0.meta.title)
    })
  Ok([
    index_page(guides, context),
    ..list.map(posts, site.djot_page(_, context))
  ])
}

fn index_page(
  guides: List(#(site.Page, GuideData)),
  ctx: site.Context,
) -> fs.File {
  let meta =
    site.PageMeta(
      path: "/guides",
      title: "Guides",
      meta_title: "Guides | Gleam programming language",
      subtitle: "How to do things in Gleam",
      description: "How to do various common tasks in the Gleam programming language.",
      preview_image: option.None,
    )

  let guide_icon = fn(target: TargetSupport) {
    html.img([
      attr.src(target_icon(target)),
    ])
  }

  // let tags =
  //   list.fold(guides, set.new(), fn(tags, guide) {
  //     list.fold(guide.1.tags, tags, set.insert)
  //   })
  //   |> set.to_list
  //   |> list.sort(string.compare)

  let guides =
    list.map(guides, fn(guide) {
      html.li([], [
        html.a([attr.class("link"), attr.href(guide.0.meta.path)], [
          html.h4([], [html.text(guide.0.meta.title)]),
          html.ul([attr.class("link-meta")], [
            html.li([attr.class("guide-target")], [
              guide_icon(guide.1.target),
              html.text(target_string(guide.1.target)),
            ]),
            html.li([attr.class("guide-tags")], [
              html.text(guide.1.tags |> string.join(", ")),
            ]),
          ]),
        ]),
      ])
    })

  [
    html.main([attr.class("page content")], [
      // html.p([], [html.text("Filter by tag")]),
      // html.ul(
      //   [attr.class("tag-picker")],
      //   list.map(tags, fn(tag) {
      //     html.li([], [html.button([], [html.text(tag)])])
      //   }),
      // ),
      // html.p([], [html.text("Or search by title")]),
      // html.form([attr.class("tag-search-form")], [
      //   html.input([attr.type_("text")]),
      // ]),
      html.ul([attr.class("link-cards")], guides),
    ]),
  ]
  |> site.page_layout("", meta, ctx)
  |> site.to_html_file(meta)
}
