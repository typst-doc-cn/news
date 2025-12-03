#import "/typ/templates/news.typ": news-template

#show: news-template.with(
  date: "2025-06-22",
  title: "分析 Typst 与中文排版的差距。",
  lang: "zh",
  region: "CN",
  tags: ("gap",),
  description: "这份文档描述了 typst 在中文支持方面的差距，特别是排版和参考文献著录。",
)

各位 typst 写作者和开发者，大家好！

我们起草了一份文档描述 typst 在中文支持方面的差距，特别是排版和参考文献著录。

#link("https://typst-doc-cn.github.io/clreq/")[🔗 Chinese Layout Gap Analysis for Typst. 分析 Typst 与中文排版的差距。]

= 差距

我发现用 typst 写中文存在各种各样的微妙问题，于是才提出整理这份文档。

最臭名昭著的恐怕是下面这个问题。它表面上并不局限于中文，但它直接导致`"一、"`这样的中文编号格式难以使用。中文作者一般要么被迫放弃这种格式，要么使用`show h.where(amount: 0.3em): none`。根据 GitHub 搜索结果，#link("https://github.com/search?q=h.where%28amount%3A+0.3em%29&ref=opensearch&type=code")[19] / #link("https://github.com/search?q=heading%28numbering%3A+%22%E4%B8%80%E3%80%81%22%29&ref=opensearch&type=code")[41] ≈ 46% 的作者都使用了这条诡异的show规则。

#link(
  "https://typst-doc-cn.github.io/clreq/#heading-spacing-to-numbering",
)[🔗 标题编号与内容之间的空隙过宽]

= 隐藏问题

此外，我认为有些基础问题并未在 GitHub Issues 体现出来。

有经验者能当即构造解决方案，于是更倾向报告一些很酷的高级问题；与此同时，普通大众还在基础问题上默默挣扎。并非所有人都有时间精力报告问题，能报告得清楚明确、可复现、可解决的人更是少数。在 typst 中文QQ交流群中，每天都有人问基础问题，然而由于报告存在势垒，很多问题都没转成 GitHub Issues。

另一原因在于字体排印本身的复杂性。下面这个问题是字体不完善所致。（就我所知）目前它从未在 GitHub Issues 报告过，因为错并不在 typst。不过，typst 应该可以改进默认行为，缓解这个问题。

#link("https://typst-doc-cn.github.io/clreq/#cite-number-flying")[🔗 引用编号的数字高于括号]

= 系统梳理

这份文档整理问题的框架参考了#link("https://www.w3.org/TR/clreq-gap/")[W3C针对Web/电子书的 clreq-gap]。每一问题都分好了类并标注了优先级别。

#link("https://typst-doc-cn.github.io/clreq/#summary-0")[🔗 概要]
#link("https://typst-doc-cn.github.io/clreq/#tab-level-table")[🔗 优先级]

希望这能帮你更快地定位已知问题（及其解决方案）。

= 说明

- 文档使用 typst 撰写，并且#link("https://github.com/typst-doc-cn/clreq")[开源]（Apache 2.0）。

- 文档还仅是早期草稿，欢迎讨论指正及补充。

- 在仓库评论时，中英均可；不过在论坛回复时，还请用英语（论坛对此有约定）。

- 之前#link("https://forum.typst.app/t/typst-wish-list-for-a-japanese-user/2783")[日本人列过愿望清单]。也许还可有份日文文档？

- 有些问题也适用于#link("https://github.com/typst/typst/issues/2485")[立陶宛文]、#link("https://github.com/typst/typst/pull/5429")[巴斯克文]等文种。

感谢关注！

---

_本文#link("https://forum.typst.app/t/chinese-layout-gap-analysis-clreq-gap-for-typst/4691")[最初版本]由 #link("https://forum.typst.app/u/y.d.x")[Y.D.X.] 附图发表于论坛。_
