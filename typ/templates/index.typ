#import "/typ/templates/template.typ": base-template, news-url

#let main-title(title, description) = {
  html.div(
    class: "title-container",
    {
      html.h1(class: "main-title", title)
      html.div(class: "main-description", description)
    },
  )
}

#let add-rss-feed(item) = none

#let news-data = json(bytes(read("/content/meta/news-list.json")))

#let news-list(news) = {
  html.div(
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
  let href = news-url(href)

  add-rss-feed((
    kind: "news-item",
    data: item,
  ))
  html.div(
    class: "news-item",
    {
      html.h2(
        class: "news-title",
        html.a(href: href, title),
      )

      html.div(
        class: "news-prop",
        {
          "Published At: "
          item.date
          "  "
          "Tags: "
          tags.join(", ")
        },
      )
      // html.div(class: "news-tags", tags)
      html.div(class: "news-description", description)
    },
  )
}
