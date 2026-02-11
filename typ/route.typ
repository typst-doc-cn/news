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

/// CLI sets the `x-url-base` to the base URL for assets. This is needed if you host the website on the github pages.
///
/// For example, if you host the website on `https://username.github.io/project/`, you should set `x-url-base` to `/project/`.
/// The base URL for content and assets.
#let _url-base = sys.inputs.at("x-url-base", default: "/")
#assert(
  _url-base.starts-with("/") and _url-base.ends-with("/"),
  message: "x-url-base should start and end with `/`, got " + repr(_url-base),
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
  let href = _url-base + _to-dist(src)
  if x-is-light {
    href.replace(".html", ".light.html")
  } else {
    href
  }
}

/// Converts the path to the asset to the URL.
///
/// - path (str): The path to the asset, starting with `/assets/`.
/// -> str
#let asset-url(path) = {
  assert(path.starts-with("/assets/"), message: "expect `/assets/*`, got " + repr(path))
  _url-base + path.slice(1)
}
