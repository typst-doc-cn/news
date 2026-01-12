#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-31",
  title: "PR #5632 Include images from raw pixmaps and more",
  lang: "en",
  tags: ("pr",),
  description: "This PR adds support for including images from raw pixmaps and introduces additional encoding options, ICC profiles, and more.",
)

`image` can now be created from pixmaps and supports specification of encoding formats, ICC profiles, and more. Additionally, you can now use the `scaling` parameter to control how viewers should scale the image (smooth or pixelated).

#exp(```typ
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
```)
