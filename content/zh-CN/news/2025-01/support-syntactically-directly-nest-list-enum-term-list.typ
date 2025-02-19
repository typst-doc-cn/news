
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-23",
  title: "PR #5728 Support syntactically directly nested list, enum, and term list",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 支持了直接嵌套的 list, enum 和 terms.",
)
优化了嵌套 `list`, `enum`, `terms` 的写法.

之前, 为了产生嵌套的上述元素, 我们必须使用换行和缩进, 比如
#exp(```
+ first main
+
  - first sub
  - second sub
```)

现在不需要额外的换行了.
#exp(```
+ first main
+ - first sub
  - second sub
```)
