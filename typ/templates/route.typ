/// Convert a news path in `content/…/*.typ` to the URL relative to the base without the leading slash.
#let to-dist(src-path) = {
  let pattern = regex(`^content\/(?<path>.+)\.(?<lang>[a-z]{2}(?:-[A-Z]{2})?)\.typ(?<suffix>#.+)?$`.text)
  let dst = src-path.replace(pattern, ((captures: (path, lang, suffix))) => {
    lang + "/" + path + ".html" + suffix
  })
  assert.ne(src-path, dst, message: "Failed to convert source path to destination path: " + src-path)
  dst
}

#{
  assert.eq(
    to-dist("content/index.en.typ"),
    "en/index.html",
  )
  assert.eq(
    to-dist("content/index.zh-CN.typ"),
    "zh-CN/index.html",
  )
  assert.eq(
    to-dist("content/news/2025-06/gap.en.typ"),
    "en/news/2025-06/gap.html",
  )
  assert.eq(
    to-dist("content/news/2025-06/gap.zh-CN.typ"),
    "zh-CN/news/2025-06/gap.html",
  )
  assert.eq(
    to-dist("content/news/2025-06/gap.en.typ#hash"),
    "en/news/2025-06/gap.html#hash",
  )
}
