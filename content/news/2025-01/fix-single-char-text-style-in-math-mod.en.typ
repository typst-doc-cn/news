#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-24",
  title: "PR #5738 Add SymbolElem to improve math character styling and fix $''a''$ vs. $a$",
  lang: "en",
  tags: ("pr",),
  description: "This PR adds `SymbolElem` to improve math character styling and fixes issues with single-character text in math mode.",
)
// todo: replace '' with real \"
Fixed the long-standing issue where `$"a"$` was not italicized.

#exp-change(
  ```typ
  $ "a" $
  ```,
  [$ a $],
  [$ "a" $],
)
