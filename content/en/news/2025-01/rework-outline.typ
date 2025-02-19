#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-23",
  title: "PR #5735 Rework outline",
  lang: "en",
  tags: ("pr",),
  description: "This PR implements several improvements to the outline.",
)

Several improvements have been made to the `outline`, including:
- Outline entries are now `block`s, allowing spacing between entries to be set using `set block(spacing)`:
  #_exp(
    ```typ
    #show outline.entry.where(level: 1): set block(spacing: 1.5em)
    #outline()
    = Hello
    = World
    ```,
    [
      #show outline.entry.where(level: 1): set block(spacing: 1.5em)
      #outline(target: <5735-heading>)
      = Hello <5735-heading>
      = World <5735-heading>
    ],
  )
- Fixed alignment issues with multi-line entries in the table of contents.
- Based on #link("https://github.com/typst/typst/pull/5733", [PR #5733]), added several new `outline.entry` functions, including:
  - `body()`: entry content
  - `page()`: entry page number
  - `prefix()`: entry's `supplement` and numbering
  - `inner()`: entry's content, leader (like `repeat(".")`), and page number
  - `indented(prefix, inner)`: returns indented `prefix` + `inner`
