#import "/typ/templates/news.typ": news-template

#show: news-template.with(
  date: "2025-11-07",
  title: "中文排版差距分析：Typst v0.14.0 更新",
  lang: "zh",
  region: "CN",
  tags: ("gap",),
  description: "我们最近把文档更新到了 v0.14.0。",
)

#let news-link(dest, body) = context if target() == "html" {
  // template.typ uses HTML features, which are not supported by typst.ts compiler.query(…).
  // Therefore, we have to make this import conditional.
  import "/typ/templates/template.typ": news-link
  link(news-link(dest), body)
} else {
  "Placeholder for "
  repr((dest: dest, body: body))
}

#set heading(numbering: (..nums) => numbering("1.1", ..nums.pos().slice(1)))

各位 typst 写作者和开发者，大家好！

我们最近把#link("https://typst-doc-cn.github.io/clreq/")[《Typst 与中文排版的差距分析（clreq-gap for typst）》]更新到了 v0.14.0。
#news-link("content/zh/news/2025-06/gap.typ")[之前介绍过]，这份文档描述 typst 在中文支持方面的差距，特别是排版和参考文献著录。

#link("https://typst-doc-cn.github.io/clreq/")[🔗 Chinese Layout Gap Analysis for Typst. 分析 Typst 与中文排版的差距。]

== #link("https://typst-doc-cn.github.io/clreq/#font-fallback-math")[设置数学公式内的中文字体]

typst v0.14.0 修改了设置数学公式内中文字体的方式。

由于默认数学字体（New Computer Modern Math）不支持`（定义）`这样的中文字符，必须设置中文字体。若不设置，这些字符要么变成豆腐块□□，要么回落到系统安装的名称最短且标注为 serif 的字体（通常是 KaiTi）。

之前 v0.13 时，在数学公式内处理文本有很多局限性，设置中文字体的方法其实“依赖”一些 bug。最近归功于 #link("https://github.com/mkorje")[mkorje] 等人的贡献，#link("https://typst.app/docs/changelog/0.14.0/#math")[情况在 v0.14.0 有很大改善]。

- 支持在单个公式内混用多种数学字体了。
- 对数学公式内文本（`$"x"$`）和变量（`$x$`）的处理方式更一致了。
- 字体的#link("https://typst.app/docs/reference/text/text/#parameters-font")[字符覆盖范围设置]在数学公式内也有效了。
- 给同一字体多次设置不同的覆盖范围，也能正常生效了。

因此，现在推荐这样设置数学公式内的中文字体：

```typst
#show math.equation: set text(font: (
  (name: "New Computer Modern Math", covers: "latin-in-cjk"), // 数学
  (name: "Source Han Serif SC", covers: regex(".")), // 中文
  "New Computer Modern Math", // 数学
))
$hat(alpha)(f) = f(alpha) "（同上，α–map的“定义”）"$
$ f(alpha) #[或者*任意*内容 _α–map_ $alpha$–map] $
$ cases("Math" 1 I l, "正文 1Il") $
```

+ 若 New Computer Modern Math 有相应字符，并且该字符不是`“”`等中西共用标点，则使用 New Computer Modern Math。
+ 对于以上未覆盖的字符，使用 Source Han Serif SC。
+ 由 New Computer Modern Math 提供数学排版所需的各种定位和间距数据。

之所以需要这种特定重复和顺序，是考虑到以下几点情况。

- typst会将首个没有`covers`的字体作为数学基准字体。这个字体必须提供数学排版数据，不然会提示“warning: rendering may be poor”。
- 首个中文字体之前必须有数学字体，不然#link("https://typst.app/docs/reference/math/cases/")[`cases`]中的`{`会使用中文字体，导致无法拉伸。
- 中西共用标点应当使用中文字体。

如果你不会在数学公式内使用标点，那么设置可以如下简化。

```typst
#show math.equation: set text(font: (
  "New Computer Modern Math",
  "Noto Serif CJK SC"
))
```

如需分别设置拉丁字母和数学符号的字体，请参考#link("https://typst-doc-cn.github.io/guide/FAQ/equation-chinese-font.html#typst-0-14")[如何修改公式里的中文字体？]，或者使用网站
#link("https://ydx-2147483647.github.io/typst-set-font/")[Typst set font]
生成代码。这个网站计划在完成后移动到
#link("https://github.com/typst-doc-cn/")[Typst 中文社区的 GitHub 组织下]。

== #link("https://typst-doc-cn.github.io/clreq/#bibliography")[参考文献]方面的改进

参考文献方面一直是重灾区。如#link("https://typst-doc-cn.github.io/clreq/#summary-0")[概要]所示，这里红点和橙点最多。有些基础需求还缺乏简洁方案。参考文献在一篇文档中自动化程度最高，但代价是小修小补异常困难。一旦typst 缺少内置支持，我们自己很难修补回来。

好消息是这方面一直在慢慢改进，而 Typst 0.14.0 有些关键进展。

=== #link(
  "https://typst-doc-cn.github.io/clreq/#csl-load",
)[CSL规范中，中文CSL样式需要的所有元素都能被加载了]

#link("https://docs.citationstyles.org/en/stable/specification.html")[Citation Style Language (CSL)]
基于 XML，用于描述引用、注释、参考文献著录表的格式。你可以用它定制#link("https://typst.app/docs/reference/model/bibliography/#parameters-style")[`bibliography.style`]。

然而 Typst v0.13.1 不识别 CSL 1.0.2 规范的某些元素。#link("https://github.com/typst/citationberg/issues/35")[例如]旧版 Typst 会拒绝加载`历史研究.csl`，并抛出以下谜之错误：

#quote(block: true)[
  Failed to load CSL style (unknown variant page, expected one of
  chapter-number, citation-number, collection-number, edition,
  first-reference-note-number, issue, locator, number, number-of-pages,
  number-of-volumes, page-first, part-number, printing, printing-number,
  section, supplement-number, version, volume)
]

这是因为`历史研究.csl`用了`<number variable="page"/>`。即使你实际没有这种引用，这个问题也会导致完全无法加载CSL。

Typst v0.14.0 不再抛出以上错误。根据#link("https://typst-doc-cn.github.io/csl-sanitizer/")[我们的调查]，全部
#link("https://zotero-chinese.com/styles/")[\~300 个中文CSL样式]在去除非标准元素后全都能被新版 Typst 加载了。

=== #link(
  "https://typst-doc-cn.github.io/clreq/#cite-number-flying",
)[引用编号的数字不会再高于括号]

#news-link("content/zh/news/2025-06/gap.typ#:~:text=空隙过宽-,隐藏问题,-此外，我认为")[之前提到]，中文习惯的引用编号格式是`[1]`。在 Typst v0.13.1，`1`可能向上飘出`[]`，严重程度取决于具体设置。

Typst v0.14.0 在 #link("https://github.com/typst/typst/issues/5777")[\#5777] 修复了上标的定位问题，所以`cite`函数生成的`[1]`也一同修复了。现在#link("https://typst-doc-cn.github.io/clreq/#cite-number-flying")[文档中的两个例子]都正常了。

然而，这处修改触发了另一个问题，关于上标与中西间距相互作用（#link("https://github.com/typst/typst/issues/7113")[\#7113] 及 #link("https://github.com/w3c/clreq/issues/713")[w3c/clreq\#713]）。不过还好，我们赶在版本发布前改正了。

=== #link("https://typst-doc-cn.github.io/clreq/#bib-note")[脚注引用格式基本可用了]

参考文献著录规则国标规定了三种标注方法：numeric 顺序编码、author-date 著者-出版年、note/footnote 注释/脚注。

之前在 Typst v0.13.1 时，脚注格式完全无法使用，因为 Typst 没给 CSL 传入正确信息。你可能会得到`;;.`这种可笑结果。

现在 Typst v0.14 改正了，这些`;;.`变成了期望的“同上”（ibid.）。

== #link(
  "https://typst-doc-cn.github.io/clreq/#cjk-latin-manual-linebreak",
)[人为换行时不再多余中西间距]

Typst v0.14.0 还修复了文本间距调整方面的一个小问题。

#set heading(numbering: none)
== 最后说明

- 文档使用 typst 撰写，并且#link("https://github.com/typst-doc-cn/clreq")[开源]（Apache 2.0）。

  归功于新的 #link("https://typst.app/docs/reference/html/typed/")[HTML类型化API]，升级到 v0.14 时删除了 1410 行代码。

- 欢迎讨论及贡献。在仓库评论时，中英均可；不过在论坛回复时，还请用英语（论坛对此有约定）。

感谢关注！

---

_本文#link("https://forum.typst.app/t/changes-in-typst-v0-14-0-chinese-layout-gap-analysis/6776")[最初版本]由 #link("https://forum.typst.app/u/y.d.x")[Y.D.X.] 附图发表于论坛。根据 #link("https://forum.typst.app/u/pg999w")[pg999w] 的建议，后来增加了一段介绍设置数学公式内中文字体的简单方法。_
