
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-04",
  title: "PR #5513 HTML foundations",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 添加了 HTML 导出相关功能.",
)
HTML 导出相关功能, 具体支持情况见 #link("https://github.com/typst/typst/issues/5512", [Tracking issue for HTML export]).

与 HTML 导出相关的 PR 还有 #(5522, 5524, 5525, 5530, 5532, 5533, 5594, 5619, 5661, 5665, 5666, 5673, 5676, 5744, 5745).map(str).map(x => link("https://github.com/typst/typst/pull/" + x, "#" + x)).join([, ]).

此外, 还添加了 `set document(description: str)`, 用于为 PDF 和 HTML 输出设置文档描述.
