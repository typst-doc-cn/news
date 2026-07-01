#import "/typ/templates/news.typ": news-template

#show: news-template.with(
  date: "2026-02-10",
  title: "Typst 参考文献工具与实践",
  lang: "zh",
  region: "CN",
  tags: ("tools", "citation"),
  description: "介绍 Typst 的参考文献原生能力，以及 citext、citrus、csl-sanitizer、hayagriva-gb-tracking 等社区工具。",
)

参考文献管理是学术写作的重要环节。本文将介绍 Typst 在这方面的原生能力，以及社区开发的辅助工具，帮助你更好地处理参考文献，特别是中文文献的引用。

= Typst 原生支持

Typst 内置了完整的参考文献功能，基于 CSL（Citation Style Language）和 Hayagriva 后端：

- *CSL 样式支持*：可通过 `bibliography(style: "...")` 使用数千种 CSL 样式，包括中文期刊和学位论文格式
- *三种标注方式*：支持 numeric（顺序编码）、author-date（著者-出版年）、note（脚注）三种国标规定的标注方法
- *基本引用功能*：`cite()` 函数提供标准的引用插入

Typst 0.14.0 还修复了几个重要问题：现在能识别 CSL 1.0.2 规范的全部元素，脚注格式可以正常使用，引用编号的显示位置也更加准确。

那么，什么时候需要用到额外的工具呢？

= 准备阶段：CSL 样式文件

在使用 CSL 样式之前，你可能需要先处理样式文件本身。

== csl-sanitizer：样式文件检查

#link("https://typst-doc-cn.github.io/csl-sanitizer/")[csl-sanitizer] 是一个 CSL 样式文件检查和清理工具。它的产生源于一个实际问题：Typst 0.13 不识别 CSL 1.0.2 的某些元素，导致`历史研究.csl`等样式无法加载。

虽然 Typst 0.14 已经解决了这个问题，但 csl-sanitizer 仍然有用——它可以帮你检查从各处获取的 CSL 文件是否规范，避免潜在的兼容性问题。根据该项目的调查，#link("https://zotero-chinese.com/styles/")[约 300 个中文 CSL 样式]在去除非标准元素后都能被 Typst 正常加载。

= 引用阶段：增强功能

当你开始在文档中引用文献时，以下工具可以提供 Typst 原生功能之外的增强特性。

== citext：双语文献支持

#link("https://github.com/Shuenhoy/citext")[citext] 解决了一个 Typst 官方尚未支持的需求：双语参考文献（bilingual bibliography）。在某些中文学术规范中，参考文献条目需要同时显示原文和译文信息，这需要 CSL-M 扩展的支持。

citext 通过 QuickJS 和 WebAssembly 调用 citation.js，在官方支持到来之前提供了临时解决方案。它还提供了 `parencite`、`citep`、`citet` 等类似 LaTeX 的引用命令，以及引用排序、相邻引用分组等实用功能。该包主要针对 `gb-t-7714-2015-numeric-bilingual.csl` 样式设计。

== citrus (citeproc-typst)：替代渲染引擎

#link("https://pku-typst.github.io/citeproc-typst/")[citeproc-typst]（在 Typst Universe 上的包名是 *citrus*）提供了另一个 CSL 处理实现。如果你在使用 Typst 内置的 Hayagriva 后端时遇到特定样式的渲染问题，可以尝试这个包作为替代方案。

不同的 CSL 处理器在处理复杂样式时可能有细微差异，多一个选择总是好的。

= 监测与改进

== hayagriva-gb-tracking：跟踪国标支持

#link("https://ydx-2147483647.github.io/hayagriva-gb-tracking/")[hayagriva-gb-tracking] 不是一个直接使用的工具，而是一个文档项目。它系统地跟踪 Hayagriva（Typst 的参考文献后端）对中国国家标准（GB/T 7714）的支持情况，记录已知问题和改进建议。

如果你发现国标格式的引用显示不正确，可以先查看这个项目，了解是否是已知问题，以及是否有临时解决方案。该项目为推动 Typst 更好地支持中文学术规范提供了重要参考。

= 其他社区工具

除了上述主要针对中文需求的工具，国际社区也开发了许多参考文献相关的包。你可以在 #link("https://typst.app/universe/search/?q=bibliography")[Typst Universe] 搜索"bibliography"或"citation"，或查看 #link("https://ydx-2147483647.github.io/best-of-typst/#ref")[best-of-typst 的参考文献分类]获取更全面的列表。

= 如何选择

对于大多数中文学术写作场景：

1. *首先尝试 Typst 原生功能*——从 0.14.0 开始，内置功能已经能满足大部分需求
2. *需要双语参考文献？* 使用 citext
3. *遇到 CSL 样式加载问题？* 用 csl-sanitizer 检查样式文件
4. *内置渲染有问题？* 尝试 citrus (citeproc-typst) 作为替代
5. *发现国标格式问题？* 查看 hayagriva-gb-tracking，了解是否是已知问题

随着 Typst 的持续发展，一些临时性的解决方案可能会被官方功能取代。持续关注 Typst 的更新日志和这些社区项目的动态，能帮助你找到最适合当前需求的解决方案。

---

_感谢所有为 Typst 参考文献生态做出贡献的开发者。_
