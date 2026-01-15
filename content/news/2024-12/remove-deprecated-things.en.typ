#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-17",
  title: "PR #5591 Remove deprecated things and compatibility behaviours",
  lang: "en",
  tags: ("pr",),
  description: "This PR removes previously deprecated content that was warned about in the last version.",
)

Completely removed content that was marked as deprecated with warnings in the previous version, specifically including:
- `style`
- `state.display`
- `styles` parameter in `measure`
- `location` parameter in `state.at`, `counter.at`, and `query`
- Compatibility behavior of `counter.display` (automatic `context`)
- Compatibility behavior of `locate` (automatic `context`)
- Compatibility behavior between types and strings (e.g., `int == "integer"`)
- `bool` support in `outline.indent`
