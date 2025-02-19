
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-11-04",
  title: "PR #5310 Refactor Parser",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 重构了 parser, 主要解决了标记模式下 `list` 的一些问题和某些情况下编译器崩溃的问题.",
)
重构 parser, 主要解决了标记模式下 `list` 的一些问题和某些情况下编译器崩溃的问题.

#exp-change(
  ```typ
  9. foo
    - bar
  10. foo
    - bar
  ```,
  [
    9. foo
      - bar
    10. foo
    - bar
  ],
  [
    9. foo
      - bar
    10. foo
      - bar
  ],
)

#exp-change(
  ```typ
  - foo
  /**/- bar
      /**/- baz
  ```,
  [
    - foo
    - bar
    - baz
  ],
  [
    - foo
      /**/- bar
        /**/- baz
  ],
)

#exp-change(
  ```typ
  - foo
    - bar
  /**/    - baz
  ```,
  [
    - foo
      - bar
    - baz
  ],
  [
    - foo
      - bar
        /**/ - baz
  ],
)

#exp-change(
  ```typ
  - foo
      - bar
    - baz
  ```,
  [
    #set list(marker: [•])
    - foo
      - bar
      - baz
  ],
  [
    - foo
      - bar
      - baz
  ],
)


#exp-change(
  ```typ
  - foo
    - bar
  		- baz
  ```,
  [
    #set list(marker: [•])
    - foo
      - bar
      - baz
  ],
  [
    - foo
      - bar
      - baz
  ],
)
