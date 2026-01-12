#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-27",
  title: "PR #5768 Support first-line-indent for every paragraph",
  lang: "en",
  tags: ("pr",),
  description: "This PR adds support for first-line indentation on all paragraphs.",
)

Added support for first-line indentation on all paragraphs.

#_exp(
  ```typ
  #set par(first-line-indent: (amount: 2em, all: true))
  = Heading
  First paragraph after heading can now be indented.
  ```,
  [
    #set heading(outlined: false)
    #set par(first-line-indent: (amount: 2em, all: true))
    = Heading
    First paragraph after heading can now be indented.
  ],
)
