
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-09",
  title: "PR #5008 Better math argument parsing",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 改进了数学模式中函数调用的参数解析。",
)

对数学模式中函数调用的参数解析进行了一些调整, 包括:
- `named` 参数现在支持任意标识符(包括连字符 `-` 和下划线 `_`)了
- 现在可以在参数列表中使用 `..` 展开参数了
- 重复传入同一个 `named` 参数现在会报错, 而不是不加提醒地使用后来的值

#exp-change(
  ```typ
  #let func(my-body: none) = my-body
  $ func(my-body: a) $
  ```,
  align(left)[
    ERR: \
    Unknown variable: my
  ],
  [
    $ a $
  ],
)

#exp-change(
  ```typ
  $ mat(..#range(4).chunks(2)) $
  ```,
  [
    $ mat(\..#range(4).chunks(2)) $
  ],
  [
    $ mat(..#range(4).chunks(2)) $
  ],
)

#exp-change(
  ```typ
    #let func(my: none) = my
  $ func(my: a, my: b) $
  ```,
  [
    $ b $
  ],
  align(left)[
    ERR:\
    duplicate argument: my
  ],
)
