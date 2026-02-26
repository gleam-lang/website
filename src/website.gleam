import argv
import gleam/io
import gleam/list
import gleam/result
import gleam/time/timestamp
import gleave
import snag
import website/cheatsheet
import website/fs
import website/install
import website/page
import website/roadmap
import website/site
import website/sponsor

pub fn main() -> Nil {
  let result = case argv.load().arguments {
    ["update-sponsors"] -> sponsor.update_list()
    _ -> build_site()
  }

  case result {
    Ok(_) -> Nil
    Error(error) -> {
      io.println_error(snag.pretty_print(error))
      gleave.exit(127)
    }
  }
}

pub fn build_site() -> snag.Result(Nil) {
  use styles_hash <- result.try(fs.asset_hash("styles/main.css"))
  let ctx =
    site.Context(
      hostname: "https://gleam.run",
      time: timestamp.system_time(),
      styles_hash:,
    )

  use sponsors <- result.try(sponsor.sponsors_from_toml())
  use files <- result.try(page.pages(ctx))

  let page_files = [
    site.home(sponsors, ctx),
    site.branding(ctx),
    site.community(ctx),
    site.documentation(ctx),
    site.sponsor(sponsors, ctx),
    roadmap.page(ctx),
    cheatsheet.erlang(ctx),
    cheatsheet.elixir(ctx),
    cheatsheet.python(ctx),
    cheatsheet.php(ctx),
    cheatsheet.elm(ctx),
    cheatsheet.rust(ctx),
  ]

  let files =
    list.flatten([
      static_files(),
      install.pages(ctx),
      page_files,
      redirect_files(),
      files,
    ])

  let files = [site.sitemap(files, ctx), ..files]

  io.print("Writing to disc: ")
  use _ <- result.try(fs.delete_dist())
  let result = list.try_each(files, fs.create)
  io.print("\n")
  result
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
    site.redirect(
      "writing-gleam/command-line-reference/index.html",
      "/command-line-reference",
    ),
    site.redirect("getting-started/installing/index.html", "/install"),
    site.redirect_to_tour("book/index.html", ""),
    site.redirect_to_tour("book/print.html", ""),
    site.redirect_to_tour("book/tour/index.html", ""),
    site.redirect_to_tour("book/tour/use.html", "advanced-features/use/"),
    site.redirect_to_tour("book/tour/functions.html", "functions/functions"),
    site.redirect_to_tour("book/tour/expression-blocks.html", "basics/blocks/"),
    site.redirect_to_tour("book/tour/constants.html", "basics/constants/"),
    site.redirect_to_tour("book/tour/custom-types.html", "basics/custom-types/"),
    site.redirect_to_tour("book/tour/bools.html", "basics/bools/"),
    site.redirect_to_tour("book/tour/bit-strings.html", "data-types/bit-arrays"),
    site.redirect_to_tour("book/tour/bit-arrays.html", "data-types/bit-arrays"),
    site.redirect_to_tour("book/tour/strings.html", "data-types/strings/"),
    site.redirect_to_tour("book/tour/result.html", "data-types/results/"),
    site.redirect_to_tour("book/tour/modules.html", "basics/hello-world/"),
    site.redirect_to_tour("book/tour/lists.html", "basics/lists/"),
    site.redirect_to_tour("book/tour/let-bindings.html", "basics/assignments/"),
    site.redirect_to_tour("book/tour/ints-and-floats.html", "basics/ints/"),
    site.redirect_to_tour("book/tour/type-aliases.html", "basics/type-aliases/"),
    site.redirect_to_tour("book/tour/tuples.html", "data-types/tuples/"),
    site.redirect_to_tour("book/tour/todo.html", "advanced-features/todo/"),
    site.redirect_to_tour(
      "book/tour/assert.html",
      "advanced-features/let-assert/",
    ),
    site.redirect_to_tour(
      "book/tour/type-annotations.html",
      "basics/assignments/",
    ),
    site.redirect_to_tour(
      "book/tour/todo-and-panic.html",
      "advanced-features/todo/",
    ),
    site.redirect_to_tour(
      "book/tour/external-functions.html",
      "advanced-features/externals/",
    ),
    site.redirect_to_tour(
      "book/tour/external-types.html",
      "advanced-features/externals/",
    ),
    site.redirect_to_tour(
      "book/tour/comments.html",
      "functions/documentation-comments/",
    ),
    site.redirect_to_tour(
      "book/tour/case-expressions.html",
      "flow-control/case-expressions/",
    ),
  ]
}
