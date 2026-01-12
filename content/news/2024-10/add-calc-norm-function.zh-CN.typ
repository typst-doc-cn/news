
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-10-31",
  title: "PR #4581 Add calc.norm() function to compute euclidean norms",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 支持了范数计算。",
)

添加 `calc.norm()` 用于计算范数.

#exp(```typ
positional 参数为各分量 \
#calc.norm(1, 1)

可以指定 `p` 参数 \
#calc.norm(p: 3, 1, 1, 1)
```)
