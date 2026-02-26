import filepath
import gleam/bit_array
import gleam/crypto
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile
import snag

pub type File {
  /// A file with some content
  HtmlPage(path: String, content: String)
  /// A file with some content
  File(path: String, content: String)
  /// A directory copied into the output
  Copy(path: String)
}

const dist = "dist/"

const priv = "priv/"

pub fn delete_dist() -> snag.Result(Nil) {
  use _ <- result.try(ensure_directory_exists(dist))
  use files <- result.try(
    simplifile.read_directory(dist)
    |> handle_error("List"),
  )
  files
  |> list.map(filepath.join(dist, _))
  |> simplifile.delete_all
  |> handle_error("Reset")
}

pub fn delete_dist_folders(paths: List(String)) {
  use _ <- result.try(ensure_directory_exists(dist))

  paths
  |> list.map(filepath.join(dist, _))
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
    File(path:, content:) -> {
      path
      |> write_file(<<content:utf8>>)
    }
    Copy(path:) -> {
      copy(path)
    }
  }
  |> ok_dot
}

fn ok_dot(result: Result(a, e)) -> Result(a, e) {
  case result {
    Error(_) -> result
    Ok(_) -> {
      io.print(".")
      result
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
  |> snag.context("Failed determine asset hash for " <> path)
}

pub fn read(path: String) -> snag.Result(String) {
  simplifile.read(path)
  |> snag.map_error(simplifile.describe_error)
  |> snag.context("Failed to read " <> path)
}

fn copy(path: String) -> snag.Result(Nil) {
  let from = filepath.join(priv, path)
  let to = filepath.join(dist, path)
  simplifile.copy(from, to)
  |> handle_error("Copy " <> path)
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
    Ok(False) -> simplifile.create_directory_all(path) |> ok_dot
    Error(error) -> Error(error)
  }
  |> snag.map_error(simplifile.describe_error)
  |> snag.context("Failed to create" <> path <> "/")
}

fn handle_error(
  result: Result(a, simplifile.FileError),
  detail: String,
) -> snag.Result(a) {
  result
  |> snag.map_error(simplifile.describe_error)
  |> snag.context("Failed to " <> string.lowercase(detail))
}
