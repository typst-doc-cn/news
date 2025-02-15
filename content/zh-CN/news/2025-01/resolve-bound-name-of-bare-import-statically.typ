
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2021-09-01",
  title: "PR #5773 Resolve bound name of bare import statically",
  tags: ("pr",),
  description: "This PR forbids inwarranted dynamic imports, making imported names of modules determined at syntax stage.",
)

#lorem(70)
