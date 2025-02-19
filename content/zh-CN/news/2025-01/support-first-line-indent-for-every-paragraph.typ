
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-27",
  title: "PR #5768 Support first-line-indent for every paragraph",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 支持了对所有段落设置首行缩进.",
)
支持对所有段落设置首行缩进.

#_exp(
  ```typ
  #set par(first-line-indent: (amount: 2em, all: true))
  = 标题
  标题下首段也能缩进了.
  ```,
  [
    #set heading(outlined: false)
    #set par(first-line-indent: (amount: 2em, all: true))
    = 标题
    　　标题下首段也能缩进了.
  ],
)
