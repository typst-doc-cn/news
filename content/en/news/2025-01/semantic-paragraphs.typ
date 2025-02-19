#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-24",
  title: "PR #5746 Semantic paragraphs",
  lang: "en",
  tags: ("pr",),
  description: "This PR introduces rules to distinguish between semantic paragraphs and plain text.",
)

Introduced rules to distinguish between semantic paragraphs and plain text, primarily for HTML output and first-line indent fixes. Specifically:
- Text at the document's root level automatically becomes paragraphs
- Text within containers (like `block`):
  - Becomes a paragraph if the container includes other block-level elements
  - Otherwise, remains as plain text
