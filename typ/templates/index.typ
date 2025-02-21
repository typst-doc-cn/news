
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

#let news-item(item, lang: "en") = {
  let (date, title, description, tags) = item
  let description = description.at(lang)
  let tags = tags.at(lang)
  let title = title.at(lang)

  let href = item.content.at(
    lang,
    default: item.content.en,
  )
  let href = news-link(href)

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
