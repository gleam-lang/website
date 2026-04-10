import filepath
import frontmatter
import gleam/dict
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import jot
import lustre/attribute.{attribute}
import lustre/element/svg
import snag
import tom
import website/fs

pub fn all() -> snag.Result(List(Guide)) {
  io.print("Loading guides: ")
  let guides = [read("deploying-to-linux")]

  io.print("\n")

  guides
  |> result.all()
}

pub type Target {
  Any
  Beam
  Javascript
}

pub type Guide {
  Guide(
    slug: String,
    title: String,
    subtitle: String,
    tags: List(String),
    target: Target,
    content: jot.Document,
  )
}

fn decode_frontmatter(
  slug: String,
  table: dict.Dict(String, tom.Toml),
) -> snag.Result(Guide) {
  let slug =
    tom.get_string(table, ["slug"])
    |> result.unwrap(slug)
  use title <- result.try(tom.get_string(table, ["title"]) |> toml_to_snag)
  use subtitle <- result.try(
    tom.get_string(table, ["subtitle"]) |> toml_to_snag,
  )
  use raw_tags <- result.try(tom.get_array(table, ["tags"]) |> toml_to_snag)
  use tags <- result.try(
    list.map(raw_tags, tom.as_string)
    |> result.all
    |> toml_to_snag,
  )
  use target <- result.try(
    tom.get_string(table, ["target"])
    |> toml_to_snag
    |> result.map(fn(target) {
      case string.lowercase(target) {
        "beam" -> Beam
        "javascript" -> Javascript
        _ -> Any
      }
    }),
  )

  Ok(Guide(
    slug:,
    title:,
    subtitle:,
    tags:,
    target:,
    content: jot.Document([], dict.new(), dict.new(), dict.new()),
  ))
}

fn toml_to_snag(result: Result(a, tom.GetError)) -> snag.Result(a) {
  result.map_error(result, fn(e) { snag.new(string.inspect(e)) })
}

fn read(path: String) -> snag.Result(Guide) {
  io.print(".")
  use content <- result.try(
    filepath.join("guides", path)
    |> string.append(".djot")
    |> fs.read
    |> snag.context("Failed to load content for /guides/" <> path),
  )
  let frontmatter.Extracted(meta, content) = frontmatter.extract(content)
  use parsed_frontmatter <- result.try(
    tom.parse(option.unwrap(meta, ""))
    |> snag.map_error(string.inspect),
  )
  use guide <- result.try(decode_frontmatter(path, parsed_frontmatter))
  let content = jot.parse(content)
  Ok(Guide(..guide, slug: path, content:))
}

pub fn target_string(target: Target) -> String {
  case target {
    Javascript -> "JavaScript"
    Beam -> "BEAM"
    Any -> "Any"
  }
}

pub fn target_icon(target: Target, i: Int) {
  svg.svg(
    [
      attribute("xmlns", "http://www.w3.org/2000/svg"),
      attribute("fill", "none"),
      attribute("viewBox", "0 0 17 16"),
      attribute("height", "20"),
      attribute("width", "20"),
      attribute("stroke-width", "1"),
      attribute("stroke", case target {
        Any -> "#FFAFF3"
        Beam -> "#FF5C80"
        Javascript -> "#FDCB6E"
      }),
    ],
    [
      case i {
        0 ->
          svg.g([attribute.id("targetIcon")], [
            svg.path([
              attribute("stroke-linejoin", "round"),
              attribute("stroke-linecap", "round"),
              attribute(
                "d",
                "M9.06024 1.33334H8.76691C8.41329 1.33334 8.07415 1.47382 7.8241 1.72387C7.57405 1.97392 7.43358 2.31305 7.43358 2.66668V2.78668C7.43334 3.02049 7.37161 3.25014 7.2546 3.45257C7.13759 3.655 6.9694 3.8231 6.76691 3.94001L6.48024 4.10668C6.27755 4.2237 6.04762 4.28531 5.81358 4.28531C5.57953 4.28531 5.3496 4.2237 5.14691 4.10668L5.04691 4.05334C4.74095 3.87685 4.37747 3.82897 4.03624 3.92022C3.69502 4.01146 3.40394 4.23437 3.22691 4.54001L3.08024 4.79334C2.90375 5.0993 2.85587 5.46279 2.94711 5.80401C3.03836 6.14523 3.26127 6.43631 3.56691 6.61334L3.66691 6.68001C3.86843 6.79635 4.03599 6.9634 4.15294 7.16456C4.2699 7.36573 4.33217 7.59399 4.33358 7.82668V8.16668C4.33451 8.40162 4.27334 8.63265 4.15627 8.83635C4.0392 9.04005 3.87038 9.2092 3.66691 9.32668L3.56691 9.38668C3.26127 9.56371 3.03836 9.85479 2.94711 10.196C2.85587 10.5372 2.90375 10.9007 3.08024 11.2067L3.22691 11.46C3.40394 11.7657 3.69502 11.9886 4.03624 12.0798C4.37747 12.171 4.74095 12.1232 5.04691 11.9467L5.14691 11.8933C5.3496 11.7763 5.57953 11.7147 5.81358 11.7147C6.04762 11.7147 6.27755 11.7763 6.48024 11.8933L6.76691 12.06C6.9694 12.1769 7.13759 12.345 7.2546 12.5475C7.37161 12.7499 7.43334 12.9795 7.43358 13.2133V13.3333C7.43358 13.687 7.57405 14.0261 7.8241 14.2762C8.07415 14.5262 8.41329 14.6667 8.76691 14.6667H9.06024C9.41386 14.6667 9.753 14.5262 10.0031 14.2762C10.2531 14.0261 10.3936 13.687 10.3936 13.3333V13.2133C10.3938 12.9795 10.4555 12.7499 10.5726 12.5475C10.6896 12.345 10.8578 12.1769 11.0602 12.06L11.3469 11.8933C11.5496 11.7763 11.7795 11.7147 12.0136 11.7147C12.2476 11.7147 12.4775 11.7763 12.6802 11.8933L12.7802 11.9467C13.0862 12.1232 13.4497 12.171 13.7909 12.0798C14.1321 11.9886 14.4232 11.7657 14.6002 11.46L14.7469 11.2C14.9234 10.8941 14.9713 10.5306 14.88 10.1893C14.7888 9.84812 14.5659 9.55704 14.2602 9.38001L14.1602 9.32668C13.9568 9.2092 13.788 9.04005 13.6709 8.83635C13.5538 8.63265 13.4926 8.40162 13.4936 8.16668V7.83334C13.4926 7.5984 13.5538 7.36738 13.6709 7.16367C13.788 6.95997 13.9568 6.79082 14.1602 6.67334L14.2602 6.61334C14.5659 6.43631 14.7888 6.14523 14.88 5.80401C14.9713 5.46279 14.9234 5.0993 14.7469 4.79334L14.6002 4.54001C14.4232 4.23437 14.1321 4.01146 13.7909 3.92022C13.4497 3.82897 13.0862 3.87685 12.7802 4.05334L12.6802 4.10668C12.4775 4.2237 12.2476 4.28531 12.0136 4.28531C11.7795 4.28531 11.5496 4.2237 11.3469 4.10668L11.0602 3.94001C10.8578 3.8231 10.6896 3.655 10.5726 3.45257C10.4555 3.25014 10.3938 3.02049 10.3936 2.78668V2.66668C10.3936 2.31305 10.2531 1.97392 10.0031 1.72387C9.753 1.47382 9.41386 1.33334 9.06024 1.33334Z",
              ),
            ]),
            svg.path([
              attribute("stroke-linejoin", "round"),
              attribute("stroke-linecap", "round"),
              attribute(
                "d",
                "M8.91357 10C10.0181 10 10.9136 9.10457 10.9136 8C10.9136 6.89543 10.0181 6 8.91357 6C7.809 6 6.91357 6.89543 6.91357 8C6.91357 9.10457 7.809 10 8.91357 10Z",
              ),
            ]),
          ])
        _ ->
          svg.use_([
            attribute.href("#targetIcon"),
            attribute("x", "0"),
            attribute("y", "0"),
          ])
      },
    ],
  )
}
