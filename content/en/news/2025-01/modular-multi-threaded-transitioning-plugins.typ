#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-30",
  title: "PR #5779 Modular, multi-threaded, transitioning plugins",
  lang: "en",
  tags: ("pr",),
  description: "This PR enhances WASM plugins, allowing plugin state forking through mutable plugin function calls.",
)

Several improvements have been made to the plugin system:
- There's no longer a dedicated plugin type. `plugin(...)` now directly returns a `module`. This means we can use `import` with plugins and `.with` with plugin functions.
- Plugins now support multi-threading automatically, requiring no manual intervention from users.
- A new `plugin.transition` API has been introduced for executing non-pure functions. Calling non-pure functions without using `transition` may lead to unpredictable results.

#_exp(
  ```typ #import plugin("mycalc.wasm"): myadd, mymut
  #myadd(3, 5) \
  #mymut.with(3)(5)
  ```,
  [
    8 \
    15
  ],
)

#_exp(
  ```typ #let base = plugin("mut.wasm")
  State before mutation: #base.get() \

  #let mutated = plugin.transition(base.add, "hello")
  State after mutation: #base.get() \
  Returned mutated value: #mutated.get()
  ```,
  [
    State before mutation: [] \
    State after mutation: [] \
    Returned mutated value: [hello]
  ],
)
