
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-29",
  title: "PR #5773 Resolve bound name of bare import statically",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 改变了无导入列表, 无重命名的 `import` 解析绑定名称的行为.",
)

改变了无导入列表, 无重命名的 `import` 解析绑定名称的行为, 具体来说, 现在的绑定名不再动态解析, 而是必须在 AST 中静态地已知.

#exp-err(
  ```typ
  #import "te" + "st.typ"
  这是一个不静态的 `import`
  ```,
  "cannot determine binding name for this import

Hint: the name must be statically known
Hint: you can rename the import with `as`
Hint: to import specific items from a dynamic source, add a colon followed by an import list
",
)
