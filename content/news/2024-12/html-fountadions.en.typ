#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-04",
  title: "PR #5513 HTML foundations",
  lang: "en",
  tags: ("pr",),
  description: "This PR adds HTML export functionality.",
)

Added HTML export functionality. For detailed support information, see the #link("https://github.com/typst/typst/issues/5512", [Tracking issue for HTML export]).

Other PRs related to HTML export include #(5522, 5524, 5525, 5530, 5532, 5533, 5594, 5619, 5661, 5665, 5666, 5673, 5676, 5744, 5745).map(str).map(x => link("https://github.com/typst/typst/pull/" + x, "#" + x)).join([, ]).

Additionally, `set document(description: str)` was added to set document descriptions for both PDF and HTML outputs.
