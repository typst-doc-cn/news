
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-06",
  title: "PR #5651 Allow adding and joining arguments",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 支持了 add 和 join 参数.",
)

现在 `arguments` 也可以 `add` 和 `join` 了.
#exp(```typ
#{ arguments(1) + arguments(2) } \
#{ (arguments(1), arguments(2)).join() }
```)
