#import "../../typ/templates/index.typ": base-template, main-title, news-data, news-item, news-list

#show: base-template.with(description: "Typst 信息汇总")

#main-title[
  泰普斯屯
][
  Typst信息汇总
]

#let news-list-content = news-data.map(news-item.with(lang: "zh-CN"))

#news-list(news-list-content.join())
