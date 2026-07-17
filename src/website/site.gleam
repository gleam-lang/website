import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}
import gleam/time/timestamp.{type Timestamp}
import jot

pub type Context {
  Context(hostname: String, time: Timestamp, styles_hash: String)
}

pub type Page {
  Page(meta: PageMeta, content: jot.Document, frontmatter: Dynamic)
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

pub fn page_meta_decoder(path: String) -> decode.Decoder(PageMeta) {
  use title <- decode.field("title", decode.string)
  use subtitle <- decode.field("subtitle", decode.string)
  use meta_title <- decode.field("meta_title", decode.string)
  use description <- decode.field("description", decode.string)
  use preview_image <- decode.optional_field(
    "preview_image",
    option.None,
    decode.optional(decode.string),
  )
  decode.success(
    PageMeta(
      path:,
      title:,
      subtitle:,
      meta_title:,
      description:,
      preview_image:,
      preload_images: [],
    ),
  )
}
