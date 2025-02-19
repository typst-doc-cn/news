#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-17",
  title: "PR #5323 New curve element that supersedes path",
  lang: "en",
  tags: ("pr",),
  description: "This PR introduces the new `curve` element, replacing the previous `path`.",
)

Added the new `curve` element to replace the previous `path`.

The new `curve` element supports multiple subcurves within a single `curve` and provides convenient ways to adjust closure and filling methods.
#exp(```typ
#set curve(fill: yellow)
#curve(
  fill-rule: "even-odd",
  stroke: black,
  curve.move((10mm, 10mm)),
  curve.line((20mm, 10mm)),
  curve.line((20mm, 20mm)),
  curve.close(),
  curve.move((0mm, 5mm)),
  curve.line((25mm, 5mm)),
  curve.line((25mm, 30mm)),
  curve.close(),
)

#curve(
  stroke: black,
  curve.move((10mm, 10mm)),
  curve.cubic((5mm, 20mm), (15mm, 20mm), (20mm, 0mm), relative: true),
  // First control point 'auto' corresponds to the last control point of the previous curve
  curve.cubic(auto, (15mm, -10mm), (20mm, 0mm), relative: true),
  curve.close(mode: "straight")
)

#curve(
  // Default starting point, can also be specified manually
  // curve.move(start: (0mm, 0mm)),
  curve.quad((10mm, 0mm), (10mm, 10mm)),
  curve.quad(auto, (10mm, 10mm), relative: true),
  curve.close()
)
```)
