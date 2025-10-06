import gleam/option.{type Option}
import gleam/time/timestamp.{type Timestamp}

pub type Context {
  Context(hostname: String, time: Timestamp, styles_hash: String)
}

pub type PageMeta {
  PageMeta(
    path: String,
    title: String,
    subtitle: String,
    meta_title: String,
    description: String,
    /// Render-critical to pre-load using meta-tags
    preview_image: Option(String),
    /// Social media share preview image name
    preload_images: List(String),
  )
}

pub type Create {
  Directory(path: String)
  Page(path: String, content: BitArray)
}
