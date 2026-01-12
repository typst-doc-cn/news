#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-23",
  title: "PR #5728 Support syntactically directly nested list, enum, and term list",
  lang: "en",
  tags: ("pr",),
  description: "This PR adds support for directly nested lists, enums, and terms.",
)

Optimized the syntax for nested `list`, `enum`, and `terms` elements.

Previously, to create nested elements, we had to use line breaks and indentation, like this:
#exp(```
+ first main
+
  - first sub
  - second sub
```)

Now, the extra line break is no longer needed:
#exp(```
+ first main
+ - first sub
  - second sub
```)
