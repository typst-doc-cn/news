
#import "mod.typ": *

#show: template

#main-title[
  Broadsheet
][
  The recent changes about typst.
]

#let news-list-content = news-data.map(news-item)

#news-list(news-list-content.join())
