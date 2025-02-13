
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2021-09-01",
  title: "PR #5779 Modular, multi-threaded, transitioning plugins",
  tags: ("pr",),
  description: "This PR adds changes about the WASM plugins to allow fork state of plugin by calling mutable plugin functions.",
)

A number of improvements have been made to the plugin system, including.
news-template now has no specialized plugin type. `plugin(...) ` will return `module` directly. So we can use import on plugins, and we can use
`with` .
news-template now supports multi-threaded running of plugins, which is done automatically without any manual action on the part of the user.
news-template provides a new plugin.transition API for executing non-pure functions. If you don't use transition to call non-pure functions, it may lead to unpredictable results.
lead to unpredictable results.

Translated with DeepL.com (free version)
