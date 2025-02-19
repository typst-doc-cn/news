#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-17",
  title: "PR #5589 Get numbering of page counter from style chain",
  lang: "en",
  tags: ("pr",),
  description: "This PR improves the display behavior of the `page` counter.",
)

Typst can now automatically handle `counter(page).display()` when `page.numbering` is `none`. This means we no longer need to write:
```typ
#set page(footer: context {
  let page-numbering = if page.numbering != none { page.numbering } else { "1" }
  counter(page).display(page-numbering)
})
```
Instead, we can simply write:
```typ
#set page(footer: context counter(page).display())
```
