import gleam/string
import snag
import tom

pub fn parse(toml: String) {
  tom.parse(toml)
  |> snag.map_error(fn(error) {
    case error {
      tom.Unexpected(got:, expected:) ->
        "Expected " <> expected <> ", got " <> got
      tom.KeyAlreadyInUse(key:) ->
        "Key " <> string.join(key, ".") <> " already in use"
    }
  })
  |> snag.context("Failed to parse TOML")
}
