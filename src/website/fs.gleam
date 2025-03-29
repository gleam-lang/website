import filepath
import gleam/bit_array
import gleam/crypto
import gleam/function
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile
import snag

pub type File {
  /// A file with some content
  HtmlPage(path: String, content: String)
  /// A directory copied into the output
  Directory(path: String)
}

const dist = "dist/"

const priv = "priv/"

pub fn delete_dist() -> snag.Result(Nil) {
  dist
  |> list.wrap
  |> simplifile.delete_all
  |> handle_error("Reset")
}

pub fn create(file: File) -> snag.Result(Nil) {
  case file {
    HtmlPage(path:, content:) -> {
      path
      |> filepath.join("index.html")
      |> write_file(<<content:utf8>>)
    }
    Directory(path:) -> {
      copy_directory(path)
    }
  }
}

pub fn asset_hash(path: String) -> snag.Result(String) {
  let path = filepath.join(priv, path)
  simplifile.read_bits(path)
  |> snag.map_error(simplifile.describe_error)
  |> snag.context("Failed to read " <> path)
  |> result.map(crypto.hash(crypto.Sha256, _))
  |> result.map(bit_array.base64_url_encode(_, False))
}

fn copy_directory(path: String) -> snag.Result(Nil) {
  let from = filepath.join(priv, path)
  let to = filepath.join(dist, path)
  simplifile.copy_directory(from, to)
  |> handle_error("Copy " <> path <> "/")
}

fn write_file(path: String, content: BitArray) -> snag.Result(Nil) {
  let qualified_path = dist |> filepath.join(path)
  let parent = filepath.directory_name(qualified_path)
  use _ <- result.try(ensure_directory_exists(parent))
  use _ <- result.try(
    simplifile.write_bits(qualified_path, content)
    |> handle_error("Create " <> path),
  )
  Ok(Nil)
}

fn ensure_directory_exists(path: String) -> Result(Nil, snag.Snag) {
  case simplifile.is_directory(path) {
    Ok(True) -> Ok(Nil)
    Ok(False) ->
      path
      |> simplifile.create_directory_all
      |> handle_error("Create " <> path <> "/")
    Error(error) ->
      error
      |> simplifile.describe_error
      |> snag.error
      |> snag.context("Failed to create" <> path <> "/")
  }
}

fn handle_error(
  result: Result(a, simplifile.FileError),
  detail: String,
) -> snag.Result(a) {
  result
  |> snag.map_error(simplifile.describe_error)
  |> snag.context("Failed to " <> string.lowercase(detail))
  |> function.tap(fn(_) { io.println(detail) })
}
