
#import "/typ/templates/template.typ": *

#let main-title(title, description) = {
  div(
    class: "title-container",
    {
      h1(class: "main-title", title)
      div(class: "main-description", description)
    },
  )
}

#let add-rss-feed(item) = none

#let news-data = json(bytes(read("/content/meta/news-list.json")))

#let news-list(news) = {
  div(
    class: "news-list",
    news,
  )
}

#let news-item(item) = {
  let (date, title, description) = item
  let tags = ("PR",)

  let href = item.content.en.replace("content/", url-base).replace(".typ", ".html")

  add-rss-feed((
    kind: "news-item",
    data: item,
  ))
  div(
    class: "news-item",
    {
      h2(
        class: "news-title",
        a(href: href, title),
      )

      div(
        class: "news-prop",
        {
          "Published At: "
          item.date
          "  "
          "Tags: "
          tags.join(", ")
        },
      )
      // div(class: "news-tags", tags)
      div(class: "news-description", description)
    },
  )
}
