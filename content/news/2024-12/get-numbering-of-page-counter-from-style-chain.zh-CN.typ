
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-17",
  title: "PR #5589 Get numbering of page counter from style chain",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 改善了 `page` 计数器的 display 行为.",
)
现在 Typst 可以自动处理 `page.numbering` 为 `none` 时的 `counter(page).display()`. 所以我们可以不需要再写
```typ
#set page(footer: context {
  let page-numbering = if page.numbering != none { page.numbering } else { "1" }
  counter(page).display(page-numbering)
})
```
而是可以直接
```typ
#set page(footer: context counter(page).display())
```
