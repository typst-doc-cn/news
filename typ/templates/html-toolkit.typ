
#import "@preview/tiaoma:0.2.1"

#let assets-url-base = sys.inputs.at("x-url-base", default: none)
#let url-base = if assets-url-base != none { assets-url-base } else { "/dist/" }
#let assets-url-base = if assets-url-base != none { assets-url-base } else { "/" }

#let news-data = json(bytes(read("/content/meta/news-list.json")))

#let current-title = state("cn-news-title", "")

#let news-item() = {
  let title = current-title.get()
  news-data.find(item => item.title == title)
}

#let news-link(src) = {
  src.replace("content/", url-base).replace(".typ", ".html")
}

#let asset-url(path) = {
  if path != none and path.starts-with("/") {
    assets-url-base + path.slice(1)
  } else {
    path
  }
}

#let to-html(data) = {
  if type(data) == str {
    let data = data.trim()
    if data.len() > 0 {
      data
    }
  } else {
    let href = data.attrs.at("href", default: none)
    if href != none and href.starts-with("/") {
      data.attrs.at("href") = asset-url(href)
    }

    html.elem(
      data.tag,
      attrs: data.attrs,
      data.children.map(to-html).join(),
    )
  }
}

#let load-html-template(template-path, content) = {
  let head-data = xml(template-path).at(0).children.at(1)
  let head = to-html(head-data)

  html.elem(
    "html",
    attrs: (
      "lang": "en",
      "xmlns": "http://www.w3.org/1999/xhtml",
    ),
    {
      head
      html.elem("body", content)
    },
  )
}

#let html-elem(content, ..attrs, tag: "div") = html.elem(
  tag,
  content,
  attrs: attrs.named(),
)

#let a = html-elem.with(tag: "a")
#let span = html-elem.with(tag: "span")
#let div = html-elem.with(tag: "div")
#let h1 = html-elem.with(tag: "h1")
#let h2 = html-elem.with(tag: "h2")

#let div-frame(content, attrs: (:)) = html.elem("div", html.frame(content), attrs: attrs)

#let fa-icon(path, content: none, class: none, ..attrs) = a(
  class: "icon-button"
    + if class != none {
      " "
      class
    },
  ..attrs,
  {
    div(
      style: {
        "flex: 24px; width: 24px; height: 24px; background: currentColor; -webkit-mask-repeat: no-repeat; mask-repeat: no-repeat; mask-image: url(\""
        asset-url(path)
        "\"); "
        "-webkit-mask-image: url(\""
        asset-url(path)
        "\");"
      },
      "",
    )
    content
  },
)

#let header(go-back: none) = {
  div(
    class: "main-header",
    {
      div(
        style: "display: flex; flex-direction: row; gap: 8px;",
        {
          if go-back != none {
            fa-icon("/assets/fa-arrow-left.svg", title: "Go Back", href: go-back)
          }
        },
      )
      div(
        style: "display: flex; flex-direction: row-reverse; gap: 8px;",
        (
          fa-icon("/assets/fa-github.svg", title: "GitHub", href: "https://github.com/typst-doc-cn/news"),
          fa-icon("/assets/fa-moon.svg", title: "Change to Light Theme"),
          fa-icon(
            "/assets/fa-qr-code.svg",
            title: "QR Code",
            class: "qr-code-button",
            content: div(
              class: "qr-code-content",
              context {
                let item = news-item()

                if item != none {
                  let lang = text.lang
                  let region = text.region

                  let locale = if region != none {
                    lang + "-" + region
                  } else {
                    lang
                  }

                  let goal-href = item.content.at(locale)
                  if goal-href != none {
                    html.frame(
                      tiaoma.qrcode({
                        "https://typst-doc-cn.github.io"
                        news-link(goal-href)
                      }),
                    )
                  }
                }
              },
            ),
          ),
          context {
            let item = news-item()

            if item != none {
              let lang = text.lang
              let region = text.region

              let locale = if region != none {
                lang + "-" + region
              } else {
                lang
              }

              let keys = item.content.keys()

              if keys.len() > 1 {
                let index = keys.position(it => it == locale)
                let next-index = calc.rem(index + 1, keys.len())
                let next-locale = keys.at(next-index)

                let goal-href = item.content.at(next-locale)
                if goal-href != none {
                  a(class: "top-text-button", title: "Switch Language", href: news-link(goal-href), locale)
                }
              }
            }
          },
        ).join(),
      )
    },
  )
}

#let footer = {
  div(
    class: "main-footer",
    {
      "© 2023-2025 "
      a(class: "text-link", { "Myriad-Dreamin." }, href: "https://github.com/Myriad-Dreamin")
      " All Rights Reserved. "
      "Powered by "
      a(class: "text-link", " Typst.", href: "https://github.com/typst/typst")
    },
  )
}


#let base-template(pre-header: none, go-back: none, content) = {
  // todo: remove it after the bug is fixed
  show raw.where(block: false): it => html.elem("code", it.text)

  show math.equation: set text(fill: color.rgb(235, 235, 235, 90%))
  show math.equation: div-frame.with(attrs: ("style": "display: flex; justify-content: center; overflow-x: auto;"))

  show: load-html-template.with("/src/template.html")

  pre-header
  header(go-back: go-back)
  div(class: "main-body", content)
  footer
}
