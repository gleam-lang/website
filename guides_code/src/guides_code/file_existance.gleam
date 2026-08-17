import simplifile

pub fn main() -> Nil {
  let _ =
    echo simplifile.is_directory("gleam.toml") as "is_directory gleam.toml"
  let _ =
    echo simplifile.is_directory("src/gleam-toml.link")
      as "is_directory src/gleam-toml.link"
  let _ = echo simplifile.is_directory("src") as "is_directory src"
  let _ = echo simplifile.is_directory("wibble") as "is_directory wibble"

  let _ = echo simplifile.is_file("gleam.toml") as "is_file gleam.toml"
  let _ =
    echo simplifile.is_file("src/gleam-toml.link")
      as "is_file src/gleam-toml.link"
  let _ = echo simplifile.is_file("src") as "is_file src"
  let _ = echo simplifile.is_file("wibble") as "is_file wibble"

  let _ = echo simplifile.is_symlink("gleam.toml") as "is_symlink gleam.toml"
  let _ =
    echo simplifile.is_symlink("src/gleam-toml.link")
      as "is_symlink src/gleam-toml.link"
  let _ = echo simplifile.is_symlink("src") as "is_symlink src"
  let _ = echo simplifile.is_symlink("wibble") as "is_symlink wibble"

  Nil
}
