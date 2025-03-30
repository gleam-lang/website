---
author: Louis Pilfold
author-link: https://github.com/lpil
title: Introducing the Gleam package index
subtitle: Find packages for your Gleam projects
tags:
  - Release
---

Gleam is a member of the BEAM family of languages, alongside Erlang, Elixir, and
others. As such Gleam packages are distributed on [Hex.pm][hex], the
package manager for the BEAM ecosystem. Hex provides an excellent experience,
but up until now there has been one small problem: discovering Gleam packages.

There are thousands of packages on Hex, and while Gleam projects can use
packages written in Erlang or Elixir, most of the time we want to use packages
that are either written in Gleam or already have Gleam bindings. Hex does not
currently provide a way to search by language, so finding these packages is more
difficult than it should be.

To solve this problem we have created the [Gleam package index][packages], a
website for exploring the Gleam subset of the Hex repository. ✨

Today it provides a list of all the Gleam packages on Hex as well as a text
search, and future we could add fancy Gleam specific features such as
[searching by type information][elm-search], or [language server integration][lsp]
so packages can be discovered directly from your editor.

[hex]: https://hex.pm/
[packages]: https://packages.gleam.run/
[elm-search]: https://klaftertief.github.io/elm-search/
[lsp]: /news/v0.21-introducing-the-gleam-language-server/

## How does it work?

The package index is a web application written using the
[`gleam_http`][gleam_http] package. It talks to a PostgreSQL database which it
populates with Gleam packages found by crawling the Hex JSON API. All of this is
deployed to [Fly][fly], who kindly sponsor Gleam's development.

[gleam_http]: https://github.com/gleam-lang/http
[fly]: https://fly.io/

In `gleam_http` a web service is a simple function that takes the `Request` type
as an argument and returns the `Response` type. We want some extra data (a
database connection) alongside the request when responding, so we create a
`Context` type that can hold the request and any other data we need.

```gleam
pub type Context {
  Context(db: pgo.Connection, request: Request(BitString))
}

/// This function takes a database connection and returns as
/// service function that will response to individual requests
/// by calling `handle_request`.
///
pub fn make_service(db: pgo.Connection) {
  fn(request) {
    let context = Context(db, request)
    handle_request(context)
  }
}
```

The `handle_request` function calls the appropriate function for the requested
path, passing the context along with it. Thanks to Gleam's pattern matching we
don't need a complex and slow router abstraction, we can use the super fast and
familiar `case` expression, like any other Gleam code.

```gleam
pub fn handle_request(context: Context) {
  let path = request.path_segments(context.request)
  case path {
    [] -> search(context)
    ["styles.css"] -> stylesheet()
    _ -> redirect(to: "/")
  }
}
```

The handler functions are where the logic of responding to requests lives. In
the `search` handler we get the search term (if any) from the request, search
the database for appropriate packages, render HTML from the list of packages,
and return a response with this HTML to the user.

```gleam
fn search(context: Context) -> Response(String) {
  // Search in the database for packages
  let term = get_search_parameter(context.request)
  let assert Ok(packages) = database.search(context.db, term)

  // Render HTML to show the results
  let html = packages_page(packages, term)

  // Return a response
  response.new(200)
  |> response.set_header("content-type", "text/html; charset=utf-8")
  |> response.set_body(html)
}
```

For rendering HTML we are using [Nakai][nakai], a package for writing HTML on
the server (or anywhere) in a somewhat similar style to Elm or React, giving us
fully type checked HTML within Gleam.

[nakai]: https://nakaixo.github.io/

```gleam
fn packages_page(packages: List(Package), term: String) -> String {
  html.Html([], [
    html.head([
      meta([charset("utf-8")]),
      meta([name("viewport"), content("width=device-width, initial-scale=1")]),
      link([rel("stylesheet"), href("/styles.css")]),
      title_text([], "Gleam Packages"),
    ]),
    // ... etc
```

Once the service is written we can serve it using [Mist][mist], Alex Manning's
pure Gleam web server. Mist is a fantastic demonstration of Gleam's maturity and
what the language is capable of, and [in benchmarks][benchmarks] it is
comfortably faster than Cowboy, the most commonly used Erlang web server.

[mist]: https://github.com/rawhat/mist
[benchmarks]: https://github.com/rawhat/http-benchmarks

```gleam
pub fn main() {
  let assert Ok(key) = os.get_env("HEX_API_KEY")
  let db = index.connect()

  // Start syncing new releases every 60 seconds
  let sync = fn() { sync_new_gleam_releases(key, db) }
  let assert Ok(_) = periodically(sync, waiting: 60 * 1000)

  // Start the web server
  let service = web.make_service(db)
  let assert Ok(_) = mist.run_service(3000, service, max_body_limit: 4_000_000)
  io.println("Started listening on http://localhost:3000 ✨")

  // Put the main process to sleep while the web server handles traffic
  process.sleep_forever()
}
```

Here in the main function we start two actors, one that periodically syncs new
releases from the Hex API, and one that runs the web server. I won't go into
detail of the syncing process here, but in short it queries the Hex API for
packages ordered by time of last update, and iterates across pages until it has
found all the packages that have been updated since the last time it ran.

If you'd like to see more of how this project works the source code is available
[on GitHub][source]. I hope you enjoy using the package index, and do let us
know if you have any ideas or suggestions!

[source]: https://github.com/gleam-lang/packages


Happy hacking! 💖
