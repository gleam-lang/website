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
