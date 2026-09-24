import gleam/string
import gleeunit
import simplifile
import website/install

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn gleam_tag_matches_compiler_test() {
  let assert Ok(fingerprint) = simplifile.read("build/dev/erlang/fingerprint")
  let assert [version, ..] = string.split(fingerprint, " ")

  assert install.gleam_tag == "v" <> version
    as "The source-installation tag must match the Gleam compiler version."
}
