
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-17",
  title: "PR #5305 Support for defining which charset should be covered by a font",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 支持了定义字体覆盖的字符集。",
  redirect-from: (
   // coverage was misspelled previously
    "/content/news/2024-12/support-defining-font-charset-converage.zh-CN.typ",
  ),
)

现在可以手动指定哪些字符使用什么字体.
#exp(```typ
// 只改变数字的字体
#set text(font: (
   (name: "Noto Sans Mono", covers: regex("[0-9]")),
   "Noto Serif"
))
等宽: 110088 \
不等宽: Xyzwls
```)

#exp(```typ
// 中英文字体分别设置 (不需要手动 show 或者 re)
#set text(font: (
   (name: "Times New Roman", covers: "latin-in-cjk"),
   "Noto Sans CJK SC"
))
中文字体和 Latin Font 可以分别设置.
```)
