#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-11-29",
  title: "PR #5480 Add support for interpreting f32 in float.{from-bytes, to-bytes}",
  lang: "en",
  tags: ("pr",),
  description: "This PR adds f32 support for `float.from-bytes` and `float.to-bytes`.",
)

Now `float.from-bytes` and `float.to-bytes` support `f32`.

#exp(```typ
#range(4).map(x => float.to-bytes(1.5, size: 4).at(x)) \
#float.from-bytes(bytes((0, 0, 192, 63)))
```)
