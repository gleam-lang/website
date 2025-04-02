// TODO: https://gleam.run/feed.xml
//
import gleam/io
import gleam/list
import gleam/result
import gleam/time/timestamp
import gleave
import snag
import website/fs
import website/news
import website/page
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
  use styles_hash <- result.try(fs.asset_hash("styles/main.css"))
  use news_posts <- result.try(news.all())

  let ctx =
    site.Context(
      hostname: "https://gleam.run",
      time: timestamp.system_time(),
      styles_hash:,
    )

  let files = [
    fs.Directory("fonts"),
    fs.Directory("images"),
    fs.Directory("img"),
    fs.Directory("javascript"),
    fs.Directory("styles"),
    page.home(ctx),
    page.news_index(news_posts, ctx),
    ..list.map(news_posts, page.news_post(_, ctx))
  ]

  io.print("Writing to disc: ")
  let result = list.try_each(files, fs.create)
  io.print("\n")
  result
}
