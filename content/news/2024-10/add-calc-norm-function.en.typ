#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-10-31",
  title: "PR #4581 Add calc.norm() function to compute euclidean norms",
  lang: "en",
  tags: ("pr",),
  description: "This PR supports norm calculation.",
)

Add `calc.norm()` for calculating norms.

#exp(```typ
positional arguments are components \
#calc.norm(1, 1)

can specify `p` parameter \
#calc.norm(p: 3, 1, 1, 1)
```)
