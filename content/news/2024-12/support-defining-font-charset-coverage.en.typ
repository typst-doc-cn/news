#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-17",
  title: "PR #5305 Support for defining which charset should be covered by a font",
  lang: "en",
  tags: ("pr",),
  description: "This PR adds support for defining character sets covered by fonts.",
  redirect-from: (
    // coverage was misspelled previously
    "content/news/2024-12/support-defining-font-charset-converage.en.typ",
  ),
)

Now you can manually specify which characters use which fonts.
#exp(```typ
// Only change the font for numbers
#set text(font: (
   (name: "Noto Sans Mono", covers: regex("[0-9]")),
   "Noto Serif"
))
Monospace: 110088 \
Variable-width: Xyzwls
```)

#exp(```typ
// Set different fonts for Chinese and English (no need for manual show or re)
#set text(font: (
   (name: "Times New Roman", covers: "latin-in-cjk"),
   "Noto Sans CJK SC"
))
Chinese font and Latin Font can be set separately.
```)
