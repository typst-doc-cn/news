#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-23",
  title: "PR #5702 Ignore shebang at start of file",
  lang: "en",
  tags: ("pr",),
  description: "This PR makes the Typst compiler ignore shebang lines at the start of files.",
)

A shebang line (starting with `#!`, used to specify the interpreter for the file) at the beginning of a `.typ` file will now be ignored by the Typst compiler.

#exp(```typ
#!/usr/bin/typst c
Running this file will directly produce PDF output
```)
