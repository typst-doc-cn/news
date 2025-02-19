
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-30",
  title: "PR #5779 Modular, multi-threaded, transitioning plugins",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 增加了对 WASM 插件的修改，允许通过调用可变插件函数来 fork 插件状态。",
)

对插件系统做了一些改进, 具体包括:
- 现在没有专门的插件类型了. `plugin(...)` 会直接返回 `module`. 于是我们可以对插件使用 `import`, 也可以对插件中的函数使用 `.with`.
- 现在支持多线程运行插件, 这一切都是自动完成的, 用户不需要进行任何手动操作.
- 提供了新的 `plugin.transition` API 用于执行非纯函数. 如果不使用 `transition` 调用非纯函数, 可能会导致不可预测的结果.

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
  变化前的 `base`: #base.get() \

  #let mutated = plugin.transition(base.add, "hello")
  变化后的 `base`: #base.get() \
  变化后的返回值 `mutated`: #mutated.get()
  ```,
  [
    变化前的 `base`: [] \
    变化后的 `base`: [] \
    变化后的返回值 `mutated`: [hello]
  ],
)
