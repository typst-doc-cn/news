
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-24",
  title: "PR #5738 Add SymbolElem to improve math character styling and fix $''a''$ vs. $a$",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 添加了 `SymbolElem` 用于改进数学字符样式并修复了数学模式中单字符文本的问题.",
)
// todo: replace '' with real \"
修复了历史非常悠久的 `$"a"$` 不是斜体的问题.

#exp-change(
  ```typ
  $ "a" $
  ```,
  [$ a $],
  [$ "a" $],
)
