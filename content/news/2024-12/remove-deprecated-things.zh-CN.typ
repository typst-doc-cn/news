
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-12-17",
  title: "PR #5591 Remove deprecated things and compatibility behaviours",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 删除了上个版本就已经警告 deprecated 的内容.",
)
彻底删除上个版本就已经警告 deprecated 的内容, 具体来说, 包含:
- `style`
- `state.display`
- `measure` 的 `styles` 参数
- `state.at`, `counter.at`, `query` 的 `location` 参数
- `counter.display` 的兼容性行为(自动 `context`)
- `locate` 的兼容性行为(自动 `context`)
- 类型和字符串的兼容性行为(比如 `int == "integer"`)
- `outline.indent` 的 `bool` 支持
