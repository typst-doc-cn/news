
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-11-04",
  title: "PR #5310 Refactor Parser",
  lang: "en",
  tags: ("pr",),
  description: "This PR refactors the parser, mainly addressing list issues in markup mode and compiler crashes in certain scenarios.",
)

The parser has been refactored, primarily fixing list-related issues in markup mode and compiler crashes in certain scenarios.


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
