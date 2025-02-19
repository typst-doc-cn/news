
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-10-31",
  title: "PR #5229 Add a warning for is to anticipate using it as a keyword",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 使得变量名 is 会触发警告。",
)

现在用 `is` 做变量名的时候会被警告.

#exp-warn(
  ```typ
  #let is = 1
  ```,
  "`is` will likely become a keyword in future versions and will not be allowed as an identifier

Hint: rename this variable to avoid future errors

Hint: try `is_` instead",
)
