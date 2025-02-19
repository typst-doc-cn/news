#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-09",
  title: "PR #5008 Better math argument parsing",
  lang: "en",
  tags: ("pr",),
  description: "This PR improves argument parsing for function calls in math mode.",
)

Several adjustments have been made to argument parsing for function calls in math mode, including:
- `named` parameters now support any identifier (including hyphens `-` and underscores `_`)
- The `..` spread operator can now be used in argument lists
- Passing the same `named` parameter multiple times now results in an error, rather than silently using the latter value

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
