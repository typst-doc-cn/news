
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-08",
  title: "PR #5221 Embed files associated with the document as a whole",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 实现了 PDF 输出中无可见注释的文件嵌入功能",
)

实现了 PDF 输出中无可见注释的文件嵌入功能.

#_exp(
  ```typ
  下面的代码会向 PDF 中嵌入一些附件.
  #pdf.embed("hello.txt")

  可以手动设置多项参数.
  #pdf.embed("changelog.typ", description: "Source code of this document.", mime-type: "text/plain", relationship: "source")

  也可以从 `bytes` 插入, 并且自定义文件名.
  #let data = read("hello.txt", encoding: none)
  #pdf.embed("hello2.txt", data)
  ```,
  [],
)
