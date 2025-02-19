
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-09",
  title: "PR #5671 Revamp data loading and deprecate decode functions",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 重构了多种格式的数据加载并弃用了 decode 函数。",
)

重构了多种支持传入路径的函数的 API, 具体为:

- `image`, `cbor`, `csv`, `json`, `toml`, `xml`, `yaml` 现在支持传入路径或 `bytes`, 因此它们的 `.decode` 函数已被弃用
- `plugin`, `bibliography`, `bibliography.style`, `cite.style`, `raw.theme` 和 `raw.syntaxes` 现在除了接受路径参数外, 还接受 `bytes` (其中一些还接受两种类型的混合数组). 这些功能之前没有 `.decode` 变体, 因此这次更新提高了灵活性
