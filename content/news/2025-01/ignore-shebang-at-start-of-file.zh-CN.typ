
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-23",
  title: "PR #5702 Ignore shebang at start of file",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 使得 Typst 编译器忽略文件首行的 shebang.",
)
`.typ` 文件首行的 shebang (`#!` 开头的一行文字, 用于指定该文件的解释器) 会被 Typst 编译器忽略.

#exp(```typ
#!/usr/bin/typst c
运行此文件会直接产生 PDF 输出
```)
