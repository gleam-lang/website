// TODO: https://gleam.run/feed.xml
//
import gleam/list
import gleam/result
import gleam/time/timestamp
import snag
import website/fs
import website/page
import website/site

pub fn main() -> Nil {
  let assert Ok(_) = build_site()
  Nil
}

fn build_site() -> snag.Result(Nil) {
  use styles_hash <- result.try(fs.asset_hash("styles/main.css"))

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
  ]

  list.try_each(files, fs.create)
}
