import gleam/time/timestamp.{type Timestamp}

pub type Context {
  Context(hostname: String, time: Timestamp, styles_hash: String)
}

pub type Create {
  Directory(path: String)
  Page(path: String, content: BitArray)
}
