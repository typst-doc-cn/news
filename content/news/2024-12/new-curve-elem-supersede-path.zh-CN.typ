
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-17",
  title: "PR #5323 New curve element that supersedes path",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 新增了 `curve` 元素, 取代了之前的 `path`.",
)

新添加了 `curve` 元素替代之前的 `path`.

新的 `curve` 元素支持一条 `curve` 中包含多段不同的 subcurve, 并且可以方便地调整闭合方式, 填充方式等.
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
  // 第一个控制点 auto 相当于前一条曲线的最后一个控制点
  curve.cubic(auto, (15mm, -10mm), (20mm, 0mm), relative: true),
  curve.close(mode: "straight")
)

#curve(
  // 默认起点, 也可以手动指定
  // curve.move(start: (0mm, 0mm)),
  curve.quad((10mm, 0mm), (10mm, 10mm)),
  curve.quad(auto, (10mm, 10mm), relative: true),
  curve.close()
)
```)
