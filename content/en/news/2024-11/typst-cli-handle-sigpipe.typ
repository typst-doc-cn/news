#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-11-29",
  title: "PR #5444 Handle SIGPIPE",
  lang: "en",
  tags: ("pr",),
  description: "This PR fixes issues with Typst CLI when outputting to pipes.",
)

Typst CLI can now output to pipes (previously it would panic directly).
