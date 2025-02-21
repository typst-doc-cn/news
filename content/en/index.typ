
#import "../../typ/templates/index.typ": *

#show: base-template.with(description: "The recent changes about typst.")

#main-title[
  Typstown
][
  The recent changes about typst.
]

#let news-list-content = news-data.map(news-item)

#news-list(news-list-content.join())
