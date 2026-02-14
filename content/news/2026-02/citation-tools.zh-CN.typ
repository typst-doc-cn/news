#import "/typ/templates/news.typ": news-template

#show: news-template.with(
  date: "2026-02-10",
  title: "Typst 中文参考文献工具生态概览",
  lang: "zh",
  region: "CN",
  tags: ("tools", "citation"),
  description: "介绍 Typst 中文参考文献相关工具：citeproc-typst、citext、csl-sanitizer 和 hayagriva-gb-tracking。",
)

Typst 作为一个现代化的排版系统，在参考文献管理方面也在不断发展。特别是对于中文学术写作，参考文献的格式要求往往更为复杂和严格。本文将介绍几个专门为改善 Typst 中文参考文献体验而开发的工具和项目。

= citeproc-typst：CSL 样式支持

#link("https://pku-typst.github.io/citeproc-typst/")[citeproc-typst] 是一个为 Typst 提供 CSL（Citation Style Language）样式支持的工具。CSL 是一种广泛使用的引用样式描述语言，拥有数千种预定义的引用格式，包括各种中文期刊和学位论文的格式要求。

citeproc-typst 使得用户可以在 Typst 中直接使用这些 CSL 样式文件，大大扩展了 Typst 的参考文献格式支持范围，特别是对于需要遵循特定中文学术规范的用户来说，这是一个非常实用的工具。

= citext：中文引用扩展

#link("https://github.com/Shuenhoy/citext")[citext] 项目专注于改善 Typst 中的中文引用体验。它提供了一系列针对中文排版特点优化的引用功能，帮助用户更好地处理中文文献引用中的各种细节问题。

该项目解决了诸如中文引用格式、标点符号处理等在中文学术写作中常见的问题，让中文用户能够更顺畅地使用 Typst 进行学术写作。

= csl-sanitizer：CSL 样式清理工具

#link("https://typst-doc-cn.github.io/csl-sanitizer/")[csl-sanitizer] 是一个用于清理和优化 CSL 样式文件的工具。在使用各种 CSL 样式文件时，有时会遇到格式不规范或存在错误的情况，特别是一些从其他来源获取的 CSL 文件。

csl-sanitizer 可以帮助用户检查和修复这些问题，确保 CSL 样式文件的质量和兼容性。这对于需要使用各种自定义或第三方 CSL 样式的用户来说是一个很有价值的辅助工具。

= hayagriva-gb-tracking：国标引用追踪

#link("https://ydx-2147483647.github.io/hayagriva-gb-tracking/")[hayagriva-gb-tracking] 项目专注于追踪和支持中国国家标准（GB/T）的参考文献格式。Hayagriva 是 Typst 使用的参考文献后端，而 hayagriva-gb-tracking 项目则专门关注如何让它更好地支持中国国标要求。

该项目跟踪 Hayagriva 对国标格式的支持情况，记录存在的问题和改进建议，为改善中文参考文献格式提供了重要的参考和推动力。

= 总结

这些工具共同构成了一个日益完善的 Typst 中文参考文献生态系统：

- *citeproc-typst* 提供了广泛的 CSL 样式支持
- *citext* 优化了中文引用的使用体验
- *csl-sanitizer* 确保了样式文件的质量
- *hayagriva-gb-tracking* 推动了国标格式的支持

对于使用 Typst 进行中文学术写作的用户来说，这些工具都值得关注和尝试。它们不仅解决了实际问题，也展示了开源社区在改善 Typst 中文支持方面的持续努力。

如果你在使用 Typst 处理中文参考文献时遇到问题，不妨试试这些工具。同时，也欢迎为这些项目贡献代码、报告问题或提出改进建议，共同完善 Typst 的中文学术写作体验。

---

_感谢所有为这些项目做出贡献的开发者和维护者。_
