#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-06",
  title: "PR #5651 Allow adding and joining arguments",
  lang: "en",
  tags: ("pr",),
  description: "This PR adds support for adding and joining arguments.",
)

Now `arguments` can also be `add`ed and `join`ed.
#exp(```typ
#{ arguments(1) + arguments(2) } \
#{ (arguments(1), arguments(2)).join() }
```)
