
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-24",
  title: "PR #5746 Semantic paragraphs",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 引入了一些区分语义段落和普通文本的规则.",
)
引入了一些区分语义段落和普通文本的规则, 主要用于 HTML 输出和首行缩进的修复, 具体来说
- 文档顶层的文本都会自动成为段落
- 容器(比如 `block`)中的文本
  - 如果容器内还有其他块级元素元素, 那该文本会成为段落
  - 否则, 不会

