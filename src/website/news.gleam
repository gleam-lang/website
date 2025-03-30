import filepath
import gleam/result
import gleam/string
import gleam/time/calendar
import jot
import snag
import website/fs

pub fn all() -> snag.Result(List(NewsPost)) {
  [
    read(
      title: "Hello echo! Hello git!",
      subtitle: "Gleam v1.9.0 released",
      published: calendar.Date(2025, calendar.March, 08),
      author: louis,
      path: "hello-echo-hello-git",
    ),
    read(
      title: "Gleam gets “rename variable”",
      subtitle: "Gleam v1.8.0 released",
      published: calendar.Date(2025, calendar.February, 07),
      author: louis,
      path: "gleam-gets-rename-variable",
    ),
    read(
      title: "Developer Survey 2024 Results",
      subtitle: "A look at the Gleam community after version one",
      published: calendar.Date(2025, calendar.February, 06),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Improved performance and publishing",
      subtitle: "Gleam v1.7.0 released",
      published: calendar.Date(2025, calendar.January, 05),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Introducing the Gleam roadmap!",
      subtitle: "A bird's eye view of what's happening in Gleam",
      published: calendar.Date(2024, calendar.December, 06),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Context aware compilation",
      subtitle: "Gleam v1.6.0 released",
      published: calendar.Date(2024, calendar.November, 18),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Developer Survey 2024",
      subtitle: "Who are the Gleamlins anyway?",
      published: calendar.Date(2024, calendar.November, 05),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Convenient code actions",
      subtitle: "Gleam v1.5.0 released",
      published: calendar.Date(2024, calendar.September, 19),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Welcome Lambda!",
      subtitle: "Gleam's new corporate sponsor",
      published: calendar.Date(2024, calendar.August, 26),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Supercharged labels",
      subtitle: "Gleam v1.4.0 released",
      published: calendar.Date(2024, calendar.August, 02),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Auto-imports and tolerant expressions",
      subtitle: "Gleam v1.3.0 released",
      published: calendar.Date(2024, calendar.July, 09),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Fault tolerant Gleam",
      subtitle: "Gleam v1.2.0 released",
      published: calendar.Date(2024, calendar.May, 27),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam version v1.1",
      subtitle: "Hot on the heels of v1",
      published: calendar.Date(2024, calendar.April, 16),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam version 1",
      subtitle: "It's finally here! 🎉",
      published: calendar.Date(2024, calendar.March, 04),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam's new interactive language tour",
      subtitle: "Learn Gleam in your browser!",
      published: calendar.Date(2024, calendar.January, 19),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Multi-target projects",
      subtitle: "Gleam v0.34 released",
      published: calendar.Date(2024, calendar.January, 16),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Exhaustive Gleam",
      subtitle: "Gleam v0.33 released",
      published: calendar.Date(2023, calendar.December, 18),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Polishing syntax for stability",
      subtitle: "Gleam v0.32 released",
      published: calendar.Date(2023, calendar.November, 01),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Keeping dependencies explicit",
      subtitle: "Gleam v0.31 released",
      published: calendar.Date(2023, calendar.September, 25),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Local dependencies and enhanced externals",
      subtitle: "Gleam v0.30 released",
      published: calendar.Date(2023, calendar.July, 12),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam gets autocompletion",
      subtitle: "Gleam v0.29 released",
      published: calendar.Date(2023, calendar.May, 23),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Introducing the Gleam package index",
      subtitle: "Find packages for your Gleam projects",
      published: calendar.Date(2023, calendar.April, 30),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Monorepos, fast maps, and more",
      subtitle: "Gleam v0.28 released",
      published: calendar.Date(2023, calendar.April, 03),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Hello panic, goodbye try",
      subtitle: "Gleam v0.27 released",
      published: calendar.Date(2023, calendar.March, 01),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Incremental compilation, and hello Deno!",
      subtitle: "Gleam v0.26 released",
      published: calendar.Date(2023, calendar.January, 19),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Developer Survey 2022 Results",
      subtitle: "What did we learn about the Gleamers?",
      published: calendar.Date(2022, calendar.December, 16),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Introducing use expressions!",
      subtitle: "Gleam v0.25 released",
      published: calendar.Date(2022, calendar.November, 24),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.24 released!",
      subtitle: "",
      published: calendar.Date(2022, calendar.October, 25),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.23 released!",
      subtitle: "",
      published: calendar.Date(2022, calendar.September, 18),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.22 released!",
      subtitle: "",
      published: calendar.Date(2022, calendar.June, 19),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Introducing the Gleam language server!",
      subtitle: "",
      published: calendar.Date(2022, calendar.April, 24),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.20 released!",
      subtitle: "",
      published: calendar.Date(2022, calendar.February, 23),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.19 released!",
      subtitle: "",
      published: calendar.Date(2022, calendar.January, 12),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.18 released!",
      subtitle: "",
      published: calendar.Date(2021, calendar.December, 06),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.17 released!",
      subtitle: "",
      published: calendar.Date(2021, calendar.September, 20),
      author: louis,
      path: "todo",
    ),
    read(
      title: "v0.16 - Gleam compiles to JavaScript!",
      subtitle: "",
      published: calendar.Date(2021, calendar.June, 17),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.15 released!",
      subtitle: "",
      published: calendar.Date(2021, calendar.May, 06),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.14 released!",
      subtitle: "",
      published: calendar.Date(2021, calendar.February, 18),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.13 released!",
      subtitle: "",
      published: calendar.Date(2021, calendar.January, 13),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.12 and Gleam OTP v0.1 released! 🎃",
      subtitle: "",
      published: calendar.Date(2020, calendar.October, 31),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.11 released!",
      subtitle: "",
      published: calendar.Date(2020, calendar.August, 28),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.10 released!",
      subtitle: "",
      published: calendar.Date(2020, calendar.July, 01),
      author: louis,
      path: "todo",
    ),
    read(
      title: "Gleam v0.9 released!",
      subtitle: "",
      published: calendar.Date(2020, calendar.June, 1),
      author: louis,
      path: "gleam-v0.9-released",
    ),
    read(
      title: "Gleam v0.8 released!",
      subtitle: "",
      published: calendar.Date(2020, calendar.May, 7),
      author: louis,
      path: "gleam-v0.8-released",
    ),
    read(
      title: "Gleam v0.7 released!",
      subtitle: "",
      published: calendar.Date(2020, calendar.March, 1),
      author: louis,
      path: "gleam-v0.7-released",
    ),
    read(
      title: "Gleam v0.6 released!",
      subtitle: "",
      published: calendar.Date(2019, calendar.December, 25),
      author: louis,
      path: "gleam-v0.6-released",
    ),
    read(
      title: "Gleam v0.5 released!",
      subtitle: "",
      published: calendar.Date(2019, calendar.December, 16),
      author: louis,
      path: "gleam-v0.5-released",
    ),
    read(
      title: "Gleam v0.4 released!",
      subtitle: "",
      published: calendar.Date(2019, calendar.September, 19),
      author: louis,
      path: "gleam-v0.4-released",
    ),
    read(
      title: "Gleam v0.3 released!",
      subtitle: "",
      published: calendar.Date(2019, calendar.August, 07),
      author: louis,
      path: "gleam-v0.3-released",
    ),
    read(
      title: "Hello, Gleam!",
      subtitle: "There's a new friendly language in town",
      published: calendar.Date(2019, calendar.April, 15),
      author: louis,
      path: "hello-gleam",
    ),
  ]
  |> result.all()
}

const louis = Author(name: "Louis Pilfold", url: "https://github.com/lpil")

pub type NewsPost {
  NewsPost(
    title: String,
    subtitle: String,
    published: calendar.Date,
    author: Author,
    path: String,
    content: String,
  )
}

pub type Author {
  Author(name: String, url: String)
}

fn read(
  title title: String,
  subtitle subtitle: String,
  published published: calendar.Date,
  author author: Author,
  path path: String,
) -> snag.Result(NewsPost) {
  filepath.join("posts", path)
  |> string.append(".djot")
  |> fs.read
  |> snag.context("Failed to load content for /news/" <> path)
  |> result.map(jot.to_html)
  |> result.map(NewsPost(_, title:, subtitle:, published:, author:, path:))
}
