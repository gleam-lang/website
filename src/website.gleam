import gleam/io
import gleam/list
import gleam/result
import gleam/time/timestamp
import gleave
import snag
import website/atom_feed
import website/fs
import website/language_server
import website/news
import website/page
import website/roadmap
import website/site

pub fn main() -> Nil {
  case build_site() {
    Ok(_) -> Nil
    Error(error) -> {
      io.println_error(snag.pretty_print(error))
      gleave.exit(127)
    }
  }
}

fn build_site() -> snag.Result(Nil) {
  use _ <- result.try(fs.delete_dist())
  use styles_hash <- result.try(fs.asset_hash("styles/main.css"))
  use news_posts <- result.try(news.all())

  let ctx =
    site.Context(
      hostname: "https://gleam.run",
      time: timestamp.system_time(),
      styles_hash:,
    )

  let page_files = [
    page.home(ctx),
    page.branding(ctx),
    page.community(ctx),
    page.gleam_toml(ctx),
    page.writing_gleam(ctx),
    page.documentation(ctx),
    page.deployment_linux(ctx),
    page.deployment_flyio(ctx),
    page.frequently_asked_questions(ctx),
    page.news_index(news_posts, ctx),
    language_server.page(ctx),
    roadmap.page(ctx),
  ]

  let files = [
    static_files(),
    page_files,
    news_files(news_posts, ctx),
    redirect_files(),
  ]

  io.print("Writing to disc: ")
  let result =
    files
    |> list.flatten
    |> list.try_each(fs.create)
  io.print("\n")
  result
}

fn news_files(
  news_posts: List(news.NewsPost),
  ctx: site.Context,
) -> List(fs.File) {
  [atom_feed.file(news_posts), ..list.map(news_posts, page.news_post(_, ctx))]
}

fn static_files() -> List(fs.File) {
  [
    fs.Copy("fonts"),
    fs.Copy("images"),
    fs.Copy("img"),
    fs.Copy("javascript"),
    fs.Copy("styles"),
    fs.Copy("funding.json"),
  ]
}

fn redirect_files() -> List(fs.File) {
  [
    page.redirect_to_tour("book/index.html", ""),
    page.redirect_to_tour("book/print.html", ""),
    page.redirect_to_tour("book/tour/index.html", ""),
    page.redirect_to_tour("book/tour/use.html", "advanced-features/use/"),
    page.redirect_to_tour("book/tour/functions.html", "functions/functions"),
    page.redirect_to_tour("book/tour/expression-blocks.html", "basics/blocks/"),
    page.redirect_to_tour("book/tour/constants.html", "basics/constants/"),
    page.redirect_to_tour("book/tour/custom-types.html", "basics/custom-types/"),
    page.redirect_to_tour("book/tour/bools.html", "basics/bools/"),
    page.redirect_to_tour("book/tour/bit-strings.html", "data-types/bit-arrays"),
    page.redirect_to_tour("book/tour/bit-arrays.html", "data-types/bit-arrays"),
    page.redirect_to_tour("book/tour/strings.html", "data-types/strings/"),
    page.redirect_to_tour("book/tour/result.html", "data-types/results/"),
    page.redirect_to_tour("book/tour/modules.html", "basics/hello-world/"),
    page.redirect_to_tour("book/tour/lists.html", "basics/lists/"),
    page.redirect_to_tour("book/tour/let-bindings.html", "basics/assignments/"),
    page.redirect_to_tour("book/tour/ints-and-floats.html", "basics/ints/"),
    page.redirect_to_tour("book/tour/type-aliases.html", "basics/type-aliases/"),
    page.redirect_to_tour("book/tour/tuples.html", "data-types/tuples/"),
    page.redirect_to_tour("book/tour/todo.html", "advanced-features/todo/"),
    page.redirect_to_tour(
      "book/tour/assert.html",
      "advanced-features/let-assert/",
    ),
    page.redirect_to_tour(
      "book/tour/type-annotations.html",
      "basics/assignments/",
    ),
    page.redirect_to_tour(
      "book/tour/todo-and-panic.html",
      "advanced-features/todo/",
    ),
    page.redirect_to_tour(
      "book/tour/external-functions.html",
      "advanced-features/externals/",
    ),
    page.redirect_to_tour(
      "book/tour/external-types.html",
      "advanced-features/externals/",
    ),
    page.redirect_to_tour(
      "book/tour/comments.html",
      "functions/documentation-comments/",
    ),
    page.redirect_to_tour(
      "book/tour/case-expressions.html",
      "flow-control/case-expressions/",
    ),
  ]
}
