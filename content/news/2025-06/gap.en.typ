#import "/typ/templates/news.typ": news-template

#show: news-template.with(
  date: "2025-06-22",
  title: "Chinese Layout Gap Analysis for Typst",
  lang: "en",
  tags: ("gap",),
  description: "A document describing gaps or shortcomings in typst for the support of the Chinese script, including text layout and bibliography.",
)

Hello typst authors and developers!

We have drafted a document describing gaps or shortcomings in typst for the support of the Chinese script, including text layout and bibliography.

#link("https://typst-doc-cn.github.io/clreq/")[🔗 Chinese Layout Gap Analysis for Typst. 分析 Typst 与中文排版的差距。]

= Gaps

I started the document because I noticed a few subtle obstacles when writing Chinese in typst.

The issue below might be the most notorious. While it may not appear to be specific to Chinese, it directly prevents effective use of Chinese numbering styles such as `"一、"`. As a result, Chinese authors are often forced to either abandon this format, or resort to `show h.where(amount: 0.3em): none`. According to GitHub search results, #link("https://github.com/search?q=h.where%28amount%3A+0.3em%29&ref=opensearch&type=code")[19] / #link("https://github.com/search?q=heading%28numbering%3A+%22%E4%B8%80%E3%80%81%22%29&ref=opensearch&type=code")[41] ≈ 46% authors apply this weird show rule.

#link(
  "https://typst-doc-cn.github.io/clreq/#heading-spacing-to-numbering",
)[🔗 Spacing between heading numbering and title is too wide]

= Invisible issues

Moreover, I think the basic issues are kind of underrepresented in GitHub Issues.

Professional guys often create workarounds and tend to report cool advanced issues, while average authors struggle silently with basics. Not all people have time/skill to report clean, reproducible, and fixable issues. There is a Chinese chat group focused on typst, and people are asking basic questions everyday. However, these questions rarely turn into GitHub Issues due to reporting barriers.

Another reason is the complexity of typography. The following issue is caused by an imperfect font. It has not been reported in GitHub Issues (AFAIK), as it is not a fault made by typst. However, we can certainly provide a better default.

#link("https://typst-doc-cn.github.io/clreq/#cite-number-flying")[🔗 Citation numbers are flying over their brackets]

= A structured overview

The document organizes issues using the same framework as the #link("https://www.w3.org/TR/clreq-gap/")[W3C clreq-gap for Web/ebooks]. Each issue is categorized and marked with a priority level.

#link("https://typst-doc-cn.github.io/clreq/#summary-0")[🔗 Summary]
#link("https://typst-doc-cn.github.io/clreq/#tab-level-table")[🔗 Priority levels]

Hope it will help you find previous issues (and workarounds) easier.

= Notes

- The document is written in typst and hosted #link("https://github.com/typst-doc-cn/clreq")[open source] (Apache 2.0).

- It is still an early draft and open for discussion and contributions.

- You can comment in English or Chinese in that repo, but please use English when replying on the forum (due to forum rules).

- There was #link("https://forum.typst.app/t/typst-wish-list-for-a-japanese-user/2783")[a Japanese wish list]. Perhaps there could also be a Japanese document?

- There are also issues shared with #link("https://github.com/typst/typst/issues/2485")[Lithuanian], #link("https://github.com/typst/typst/pull/5429")[Basque], etc.

Thank you for your attention!

---

_This page was #link("https://forum.typst.app/t/chinese-layout-gap-analysis-clreq-gap-for-typst/4691")[originally posted] by #link("https://forum.typst.app/u/y.d.x")[Y.D.X.] on the forum with screenshots._

