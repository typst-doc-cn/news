#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-10-31",
  title: "PR #5229 Add a warning for is to anticipate using it as a keyword",
  lang: "en",
  tags: ("pr",),
  description: "This PR makes variable name 'is' trigger a warning.",
)

Now using `is` as a variable name will trigger a warning.

#exp-warn(
  ```typ
  #let is = 1
  ```,
  "`is` will likely become a keyword in future versions and will not be allowed as an identifier

Hint: rename this variable to avoid future errors

Hint: try `is_` instead",
)
