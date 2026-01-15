#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-09",
  title: "PR #5671 Revamp data loading and deprecate decode functions",
  lang: "en",
  tags: ("pr",),
  description: "This PR restructures data loading for various formats and deprecates decode functions.",
)

The APIs for several functions that accept paths have been restructured:

- `image`, `cbor`, `csv`, `json`, `toml`, `xml`, and `yaml` now accept either paths or `bytes` as input, making their `.decode` functions deprecated
- `plugin`, `bibliography`, `bibliography.style`, `cite.style`, `raw.theme`, and `raw.syntaxes` now accept both path parameters and `bytes` (some also accept mixed arrays of both types). These functions didn't have `.decode` variants before, so this update increases their flexibility
