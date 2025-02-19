
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-23",
  title: "PR #5735 Rework outline",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 对 outline 进行了多项改良.",
)
对 `outline` 进行了多项改良, 具体包括:
- 目录条目现在是 `block` 了, 因此可以通过 `set block(spacing)` 设置目录条目的间隔:
  #_exp(
    ```typ
    #show outline.entry.where(level: 1): set block(spacing: 1.5em)
    #outline()
    = 你好
    = 我好
    ```,
    [
      #show outline.entry.where(level: 1): set block(spacing: 1.5em)
      #outline(target: <5735-heading>)
      = 你好 <5735-heading>
      = 我好 <5735-heading>
    ],
  )
- 修复了目录中多行条目的对齐问题.
- 基于 #link("https://github.com/typst/typst/pull/5733", [PR #5733]), 新增了一系列 `outline.entry` 的函数, 包括
  - `body()`: 条目内容
  - `page()`: 条目页码
  - `prefix()`: 条目的 `supplement` 和编号.
  - `inner()`: 条目的内容, 引导符(比如`repeat(".")`)和页码.
  - `indented(prefix, inner)`: 返回带缩进的 `prefix` + `inner`

