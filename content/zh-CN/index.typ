
#import "../../typ/templates/index.typ": *

#show: base-template.with(description: "Typst 的近期更新")

#main-title[
  大字报
][
  Typst 的近期更新
]

#let news-list-content = news-data.map(news-item.with(lang: "zh-CN"))

#news-list(news-list-content.join())
