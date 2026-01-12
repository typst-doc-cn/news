#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-31",
  title: "PR #5632 Include images from raw pixmaps and more",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 支持了从原始像素图像中包含图片, 并支持更多编码方式, ICC 等.",
)

`image` 现在可以用 pixmap 创建, 并且可以指定编码方式, ICC 等. 此外, 现在还可以使用 `scaling` 参数指示查看器应该如何缩放图片(平滑或像素化).

#exp(
  ```typ
  #image(
    bytes(range(16).map(x => x * 16)),
    format: (
      encoding: "luma8",
      width: 4,
      height: 4,
    ),
    // auto, "pixelated", "smooth"
    scaling: "pixelated",
    width: 3cm,
    icc: auto,
  )
  ```,
  frame: true,
)
