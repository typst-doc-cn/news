#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-09",
  title: "PR #5459 Fix multiline annotations in over- elems in math changing the baseline",
  lang: "en",
  tags: ("pr",),
  description: "This PR fixes the baseline shift issue caused by multiline annotations in `over-` functions like `overbrace` in math mode.",
)

Fixed the baseline shift issue caused by multiline annotations in `over-` functions like `overbrace` in math mode.

#exp(```typ
$ S = overbrace(beta (alpha) S I, "one line") - overbrace(mu (N), "two" \  "line") $
```)


