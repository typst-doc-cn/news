
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-09",
  title: "PR #5459 Fix multiline annotations in over- elems in math changing the baseline",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 修复数学模式下 `overbrace` 等 `over-` 函数的多行标注导致基线偏移的问题.",
)
修复数学模式下 `overbrace` 等 `over-` 函数的多行标注导致基线偏移的问题.

#exp(```typ
$ S = overbrace(beta (alpha) S I, "one line") - overbrace(mu (N), "two" \  "line") $
```)

