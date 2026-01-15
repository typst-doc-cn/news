
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-11-29",
  title: "PR #5480 Add support for interpreting f32 in float.{from-bytes, to-bytes}",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 为 `float.from-bytes` 和 `float.to-bytes` 添加了对 `f32` 的支持.",
)

现在 `float.from-bytes` 和 `float.to-bytes` 支持 `f32` 了.

#exp(```typ
#range(4).map(x => float.to-bytes(1.5, size: 4).at(x)) \
#float.from-bytes(bytes((0, 0, 192, 63)))
```)
