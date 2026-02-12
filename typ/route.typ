#import "@preview/lure:0.2.0" as _lure

/// The target for the HTML export.
///
/// Available targets:
/// - `web-light`: Light theme for web.
/// - `web-dark`: Dark theme for web.
/// - `pdf`: PDF export.
#let _x-target = sys.inputs.at("x-target", default: "web-light")
/// Whether the target uses a dark theme.
#let x-is-dark = _x-target.ends-with("dark")
/// Whether the target uses a light theme.
#let x-is-light = _x-target.ends-with("light")

/// The URL base for the project website, including the origin and the base path.
///
/// This parameter is set from CLI. See `scripts/args.ts` for explanation.
#let _site-url-base = sys.inputs.at("x-site-url-base", default: "https://typst-doc-cn.github.io/news/")

/// The base URL for content and assets.
#let _base-path = _lure.parse(_site-url-base).path
#assert(
  _base-path.starts-with("/") and _base-path.ends-with("/"),
  message: "URL base path should start and end with `/`, got " + repr(_base-path),
)

/// Convert a news path in `content/…/*.typ` to the URL relative to the base without the leading slash.
#let _to-dist(src-path) = {
  let pattern = regex(`^/content\/(?<path>.+)\.(?<lang>[a-z]{2}(?:-[A-Z]{2})?)\.typ(?<suffix>#.+)?$`.text)
  let dst = src-path.replace(pattern, ((captures: (path, lang, suffix))) => {
    lang + "/" + path + ".html" + suffix
  })
  assert.ne(src-path, dst, message: "Failed to convert source path to destination path: " + src-path)
  dst
}

#{
  assert.eq(
    _to-dist("/content/index.en.typ"),
    "en/index.html",
  )
  assert.eq(
    _to-dist("/content/index.zh-CN.typ"),
    "zh-CN/index.html",
  )
  assert.eq(
    _to-dist("/content/news/2025-06/gap.en.typ"),
    "en/news/2025-06/gap.html",
  )
  assert.eq(
    _to-dist("/content/news/2025-06/gap.zh-CN.typ"),
    "zh-CN/news/2025-06/gap.html",
  )
  assert.eq(
    _to-dist("/content/news/2025-06/gap.en.typ#hash"),
    "en/news/2025-06/gap.html#hash",
  )
}

/// Converts a source path to a news URL.
#let news-url(src) = {
  assert(src.starts-with("/content/"), message: "expect `/content/*`, got " + repr(src))
  let href = _base-path + _to-dist(src)
  if x-is-light {
    href.replace(".html", ".light.html")
  } else {
    href
  }
}

/// Converts the path to the asset to the URL.
///
/// - path (str): The path to the asset, usually starting with `/assets/`.
/// -> str
#let asset-url(path) = {
  if path == "/feed.xml" {
    // Special case for RSS feed, which is generated outside `/assets/`.
    return _base-path + "feed.xml"
  }

  assert(path.starts-with("/assets/"), message: "expect `/assets/*`, got " + repr(path))
  _base-path + path.slice(1)
}

/// Converts a relative URL to an absolute URL with the origin.
#let make-absolute(url) = _lure.join(_site-url-base, url)
