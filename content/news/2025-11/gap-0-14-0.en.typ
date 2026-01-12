#import "/typ/templates/news.typ": link-news, news-template

#show: news-template.with(
  date: "2025-11-07",
  title: "Changes in Typst v0.14.0 — Chinese Layout Gap Analysis",
  lang: "en",
  tags: ("gap",),
  description: "We recently updated the document to v0.14.0.",
)

#set heading(numbering: (..nums) => numbering("1.1", ..nums.pos().slice(1)))

Hello typst authors and developers!

We recently updated
#link("https://typst-doc-cn.github.io/clreq/")[_Chinese Layout Gap Analysis (clreq-gap) for Typst_]
to v0.14.0. As
#link-news("content/news/2025-06/gap.en.typ")[introduced before],
this is a document describing gaps or shortcomings in typst for the
support of the Chinese script, including text layout and bibliography.

#link("https://typst-doc-cn.github.io/clreq/")[🔗 Chinese Layout Gap Analysis for Typst. 分析 Typst 与中文排版的差距。]

== #link("https://typst-doc-cn.github.io/clreq/#font-fallback-math")[Setting Chinese font in mathematical equations]

Typst v0.14.0 changes the way of setting Chinese font in math.

Setting Chinese font is necessary, because the default math font
(_New Computer Modern Math_) does not cover Chinese characters like
`（定义）`. Without proper configuration, they will either become tofus
□□, or fallback to the Chinese serif font with the
shortest name installed on the system (_KaiTi_ for most people).

In v0.13, text handling is math was quite limited, and the way of
setting Chinese font actually “depended” on several bugs. Thanks to
#link("https://github.com/mkorje")[mkorje] and other contributors, the
situation has
#link("https://typst.app/docs/changelog/0.14.0/#math")[improved significantly in v0.14.0].

- It's now possible to mix multiple math fonts in a single equation.
- Texts (`$"x"$`) and variables (`$x$`) in math are treated more
  equally.
- Font
  #link("https://typst.app/docs/reference/text/text/#parameters-font")[coverages]
  are now respected in math.
- Setting fonts repeatedly with different coverages is now effective.

So the new recommend way to set Chinese font in math is:

```typst
#show math.equation: set text(font: (
  (name: "New Computer Modern Math", covers: "latin-in-cjk"), // Math
  (name: "Source Han Serif SC", covers: regex(".")), // Chinese
  "New Computer Modern Math", // Math
))
$hat(alpha)(f) = f(alpha) "（同上，α–map的“定义”）"$
$ f(alpha) #[或者*任意*内容 _α–map_ $alpha$–map] $
$ cases("Math" 1 I l, "正文 1Il") $
```

+ Use _New Computer Modern Math_ for most characters it contains,
  except a few punctuation marks shared by Latin and Chinese, including
  `“”`.
+ For uncovered characters, use _Source Han Serif SC_.
+ Use _New Computer Modern Math_ for typographic metrics that
  controls complex positioning and spacing in math.

This specific order/repetition/syntax is derived from the following
propositions.

- Typst use the first font without `covers` as the base math font. It
  has to provide math metrics, otherwise “warning: rendering may be
  poor”.
- There should be a math font before the first Chinese font. Otherwise,
  the `{` of
  #link("https://typst.app/docs/reference/math/cases/")[`cases`] will
  use the Chinese font, but it does not support being stretched.
- Punctuation marks shared by Latin and Chinese should use the Chinese
  font.

If you do not use punctuation marks in math, then a simpler solution is as follows.

```typst
#show math.equation: set text(font: (
  "New Computer Modern Math",
  "Noto Serif CJK SC"
))
```

If you prefer to use different fonts for Latin and math, please refer to #link("https://typst-doc-cn.github.io/guide/FAQ/equation-chinese-font.html#typst-0-14")[如何修改公式里的中文字体？] or use the website
#link("https://ydx-2147483647.github.io/typst-set-font/")[Typst set font]
to generate the code. This website is planned to be moved to
#link("https://github.com/typst-doc-cn/")[Typst Chinese community's GitHub organization]
after completion.

== #link("https://typst-doc-cn.github.io/clreq/#bibliography")[Bibliography] improvements

Bibliography has always been a painful area. As shown in the
#link("https://typst-doc-cn.github.io/clreq/#summary-0")[summary],
it has the most red and orange dots. There are basic demands that lack
nice and clean workarounds. Bibliography has the highest degree of
automation, but at the cost of increasing the difficulty to tweak
subtleties. If Typst does not support something natively, it is really hard to
patch it on our own.

The good news is that we are improving it bit by bit, and Typst 0.14.0
has made some leapfrog progress.

=== #link(
  "https://typst-doc-cn.github.io/clreq/#csl-load",
)[All elements in the CSL spec needed by Chinese CSL styles can be loaded]

The
#link("https://docs.citationstyles.org/en/stable/specification.html")[Citation Style Language (CSL)]
is an XML-based format to describe the formatting of citations, notes
and bibliographies. You can use it to customize
#link("https://typst.app/docs/reference/model/bibliography/#parameters-style")[`bibliography.style`].

However Typst v0.13.1 did not recognize certain elements in CSL 1.0.2
Specification. For
#link("https://github.com/typst/citationberg/issues/35")[example], when
you were trying to use `历史研究.csl`, the old Typst would refuse to
load it and throw the following scary error:

#quote(block: true)[
  Failed to load CSL style (unknown variant page, expected one of
  chapter-number, citation-number, collection-number, edition,
  first-reference-note-number, issue, locator, number, number-of-pages,
  number-of-volumes, page-first, part-number, printing, printing-number,
  section, supplement-number, version, volume)
]

It is caused by `<number variable="page"/>` in `历史研究.csl`. Even if
you don't actually use this type of citation, it will prevent you from
loading the CSL.

Typst v0.14.0 no longer throws that error. According to
#link("https://typst-doc-cn.github.io/csl-sanitizer/")[our survey], all
#link("https://zotero-chinese.com/styles/")[\~300 Chinese CSL styles]
can now be loaded by new Typst, after removing non-standard elements.

=== #link(
  "https://typst-doc-cn.github.io/clreq/#cite-number-flying",
)[Citation numbers are no longer flying over their brackets]

As
#link-news("content/news/2025-06/gap.en.typ#:~:text=is%20too%20wide-,Invisible%20issues,-Moreover%2C%20I%20think")[mentioned in the previous post],
the Chinese convention for citation numbers is `[1]`. In Typst v0.13.1,
`1` may fly over `[]`, and the severity depends on the specific
configuration.

Typst v0.14.0 fixes the positioning issue of superscripts in
#link("https://github.com/typst/typst/issues/5777")[\#5777], including
these `[1]` created by the `cite` function. Now both of the #link("https://typst-doc-cn.github.io/clreq/#cite-number-flying")[examples in the document] become sane.

However, that fix triggered another issue about the interaction between
superscripts and CJK-Latin spaces
(#link("https://github.com/typst/typst/issues/7113")[\#7113] and
#link("https://github.com/w3c/clreq/issues/713")[w3c/clreq\#713]).
Fortunately, we managed to correct the behaviour before the release
deadline.

=== #link("https://typst-doc-cn.github.io/clreq/#bib-note")[The footnote citation style is now usable]

The national standard for bibliography in China specifies three citation
styles: numeric 顺序编码, author-date 著者-出版年, and note/footnote
注释/脚注.

In Typst v0.13.1, footnote styles were totally broken, because Typst
didn't pass correct info to CSL. You may get awkward results like `;;.`.

Typst v0.14 now corrects it. Those `;;.` becomes 同上 (meaning: same as
above, ibid.) as expected.

== #link(
  "https://typst-doc-cn.github.io/clreq/#cjk-latin-manual-linebreak",
)[Fixed CJK-Latin-spacing at manual line breaks]

Typst v0.14.0 also fixes a minor issue on text spacing.

#set heading(numbering: none)
== Final notes

- The document is written in typst and hosted
  #link("https://github.com/typst-doc-cn/clreq")[open source] (Apache
  2.0).

  Thanks to the new
  #link("https://typst.app/docs/reference/html/typed/")[Typed HTML API],
  we deleted 1410 lines when updating to v0.14.

- Discussion and contributions are welcomed. You can comment in English
  or Chinese in
  #link("https://github.com/typst-doc-cn/clreq/")[that repo], but please
  use English when replying on the forum (due to forum rules).

Thank you for your attention!

---

_This page was #link("https://forum.typst.app/t/changes-in-typst-v0-14-0-chinese-layout-gap-analysis/6776")[originally posted] by #link("https://forum.typst.app/u/y.d.x")[Y.D.X.] on the forum with screenshots. Based on the suggestion of #link("https://forum.typst.app/u/pg999w")[pg999w], I added a paragraph introducing a concise method for setting Chinese font in mathematical equations._
