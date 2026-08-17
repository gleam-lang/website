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

  let tags =
    list.fold(guides, set.new(), fn(tags, guide) {
      list.fold(guide.1.tags, tags, set.insert)
    })
    |> set.to_list
    |> list.sort(string.compare)

  let guides =
    list.map(guides, fn(guide) {
      let #(page, guide) = guide
      html.li([], [
        html.a([attr.class("link"), attr.href(page.meta.path)], [
          html.h4([], [html.text(page.meta.title)]),
          html.ul([attr.class("link-meta")], [
            html.li([attr.class("guide-target")], [
              guide_icon(guide.target),
              html.text(target_string(guide.target)),
            ]),
            html.li([attr.class("guide-tags")], [
              html.text(guide.tags |> string.join(", ")),
            ]),
          ]),
        ]),
      ])
    })

  [
    html.main([attr.class("page content")], [
      html.h5([attr.class("guide-filter-label")], [html.text("Filter by tag")]),
      html.ul(
        [attr.class("tag-picker")],
        list.map(tags, fn(tag) {
          html.li([], [html.button([], [html.text(tag)])])
        }),
      ),
      html.h5([attr.class("guide-filter-label")], [
        html.text("Or search by title"),
      ]),
      html.form([attr.class("guide-search-form")], [
        html.input([
          attr.type_("text"),
          attr.placeholder("eg. external, patterns, http"),
        ]),
        html.img([
          attr.class("search-icon"),
          attr.src("/images/search-icon.svg"),
          attr.alt("Search icon"),
          attr.aria_hidden(True),
        ]),
      ]),
      html.ul([attr.class("link-cards guides-list")], guides),
      html.script([], filter_script),
    ]),
  ]
  |> site.page_layout("", meta, ctx)
  |> site.to_html_file(meta)
}

const filter_script = "
function updateDisplayedGuides(tags, filterValue) {
	const search = filterValue.trim().toLowerCase();

	for (const guide of document.querySelectorAll(\".link-cards>li\")) {
		const tagsEl = guide.querySelector(\".guide-tags\");
		const guideTags = tagsEl ? tagsEl.textContent : \"\";

		// Guide must include every active tag
		const matchesTags = tags.every((tag) => guideTags.includes(tag));

		// Guide must match the search string somewhere in its text
		const matchesSearch =
			search.length === 0 || guide.textContent.toLowerCase().includes(search);

		guide.style.display = matchesTags && matchesSearch ? \"\" : \"none\";
	}

  if ([...document.querySelectorAll(\".link-cards>li\")].every(child => window.getComputedStyle(child).display === 'none'))
    document.querySelector('.guides-list').classList.add('empty')
  else
    document.querySelector('.guides-list').classList.remove('empty')
}

const filter = new Proxy(
	{ value: \"\" },
	{
		set(target, prop, value) {
			target[prop] = value;
			updateDisplayedGuides(tags, filter.value);
			return true;
		},
	},
);

const tags = new Proxy([], {
	set(target, prop, value) {
		target[prop] = value;
		updateDisplayedGuides(tags, filter.value);
		return true;
	},
});

for (const button of document.querySelectorAll(\".tag-picker button\")) {
	const tag = button.textContent;
	button.addEventListener(\"click\", () => {
		if (tags.includes(tag)) {
			tags.splice(tags.indexOf(tag), 1);
			button.classList.remove(\"active\");
			return;
		}
		tags.push(tag);
		button.classList.add(\"active\");
	});
}

const searchInput = document.querySelector(\".guide-search-form input\");

searchInput.addEventListener(\"input\", () => {
	filter.value = searchInput.value;
});
"
