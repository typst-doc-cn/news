#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-29",
  title: "PR #5773 Resolve bound name of bare import statically",
  lang: "en",
  tags: ("pr",),
  description: "This PR changes how binding names are resolved for `import` statements without import lists or renaming.",
)

The behavior for resolving binding names in `import` statements without import lists or renaming has been changed. Specifically, binding names are no longer resolved dynamically but must be statically known in the AST.

#exp-err(
  ```typ
  #import "te" + "st.typ"
  This is a non-static `import`
  ```,
  "cannot determine binding name for this import

Hint: the name must be statically known
Hint: you can rename the import with `as`
Hint: to import specific items from a dynamic source, add a colon followed by an import list
",
)
