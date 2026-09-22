import gleam/string
import gleeunit
import gleeunit/should
import simplifile
import website/install

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn gleam_tag_matches_compiler_test() {
  let assert Ok(fingerprint) = simplifile.read("build/dev/erlang/fingerprint")
  let assert [version, ..] = string.split(fingerprint, " ")

  install.gleam_tag
  |> should.equal("v" <> version)
}
