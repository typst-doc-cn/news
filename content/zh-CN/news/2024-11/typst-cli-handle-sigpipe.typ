
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-11-29",
  title: "PR #5444 Handle SIGPIPE",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 修复了 Typst CLI 在输出到管道时的问题.",
)

Typst CLI 现在可以输出到管道了(之前会直接 panic).
