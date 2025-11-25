#import "/typ/templates/news.typ": *
#import "/typ/packages/html-toolkit.typ": asset-url

#show: news-template.with(
  date: "2025-10-24",
  title: "Typst 0.14.0 released",
  lang: "zh",
  region: "CN",
  tags: ("update",),
  description: "Typst 0.14.0 发布了。",
)

Typst 0.14.0 发布了。你可以参考#link("https://typst.app/docs/changelog/0.14.0")[官方英文更新日志]或#link(asset-url("/assets/brief-changelog-v0.14.0-rc1.pdf"))[非官方中文更新日志（PDF）]。

注意前者发布于 2025-10-24，而后者由 otter 整理于 2025-10-10。它们互相不是对方的翻译。
