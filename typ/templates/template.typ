
#import "@preview/tiaoma:0.2.1"
#import "/typ/packages/html-toolkit.typ": *

/// All metadata of news content.
#let news-data = json(bytes(read("/content/meta/news-list.json")))

/// The current title of the news.
#let current-title = state("cn-news-title", "")

/// Contextually gets the current news item.
///
/// -> The current news item.
#let news-item() = {
  let title = current-title.get()
  news-data.find(item => title in item.title.values())
}

/// Converts a source path to a news link.
#let news-link(src) = {
  src.replace("content/", url-base).replace(".typ", ".html")
}

/// A font-awesome icon.
///
/// - path (str): The path of the icon.
/// - content (content): The extra content of the icon.
/// - class (str): The class of the icon
/// - attrs (dict): The extra attributes of the icon.
/// -> The icon content.
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

/// A QR code button.
#let qrcode-button = fa-icon(
  "/assets/fa-qr-code.svg",
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
)

/// A locale switch button.
#let locale-button = context {
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
}

/// The header of the page.
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
          qrcode-button,
          locale-button,
        ).join(),
      )
    },
  )
}

/// The footer of the page.
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

/// The base of all html templates.
#let base-template(pre-header: none, go-back: none, description: none, content) = {
  // todo: remove it after the bug is fixed
  show raw.where(block: false): it => html.elem("code", it.text)

  show math.equation: set text(fill: color.rgb(235, 235, 235, 90%))
  show math.equation: div-frame.with(attrs: ("style": "display: flex; justify-content: center; overflow-x: auto;"))

  set document(description: description) if description != none

  show: load-html-template.with("/src/template.html")

  pre-header
  header(go-back: go-back)
  div(class: "main-body", content)
  footer
}
