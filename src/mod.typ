
#import "/typ/templates/html-toolkit.typ": *

#let template(content) = {
  show math.equation: set text(fill: color.rgb(235, 235, 235, 90%))
  show math.equation: div-frame.with(attrs: ("style": "display: flex; justify-content: center; overflow-x: auto;"))

  let is-preview = sys.inputs.at("x-preview", default: none) != none

  show: load-html-template.with(if is-preview {
    "/src/template.html"
  } else {
    "/src/template.html"
  })

  content
}


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

#let news-list(news) = {
  div(
    class: "news-list",
    news,
  )
}

#let news-item(date, title, tags, content) = {
  add-rss-feed((
    kind: "news-item",
    date: date,
    title: title,
    tags: tags,
    content: content,
  ))
  div(
    class: "news-item",
    {
      // div(class: "news-date", date)
      h2(class: "news-title", title)
      // div(class: "news-tags", tags)
      div(class: "news-content", content)

      div("Read more...")
    },
  )
}
