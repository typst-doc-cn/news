#import "@preview/tiaoma:0.3.0"
#import "@preview/zebraw:0.6.1": zebraw, zebraw-init
#import "/typ/packages/html-toolkit.typ": div-frame, load-html-template, preload-css
#import "/typ/route.typ": asset-url, news-url, x-is-dark, x-is-light

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

/// A font-awesome icon.
///
/// - path (str): The path of the icon.
/// - content (content): The extra content of the icon.
/// - class (str): The class of the icon
/// - attrs (dict): The extra attributes of the icon.
/// -> The icon content.
#let fa-icon(path, content: none, class: none, ..attrs) = {
  assert.eq(attrs.pos(), (), message: "fa-icon only supports named attributes.")
  let attrs = attrs.named()
  let unknown-keys = attrs.keys().filter(k => not ("title", "href", "onclick").contains(k))
  assert.eq(unknown-keys, (), message: "fa-icon does not support some attributes: " + repr(unknown-keys))

  // We can't use `html.a` here, because it does not support `onclick`.
  html.elem(
    "a",
    attrs: (
      class: "icon-button"
        + if class != none {
          " "
          class
        },
      ..attrs,
    ),
    {
      html.div(
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
}

/// A QR code button.
/// Returns `none` if unavailable (e.g., on the main index page).
#let qrcode-button = context {
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
      fa-icon(
        "/assets/fa-qr-code.svg",
        class: "qr-code-button",
        content: html.div(
          class: "qr-code-content",
          html.frame(
            tiaoma.qrcode({
              "https://typst-doc-cn.github.io"
              news-url(goal-href)
            }),
          ),
        ),
      )
    }
  }
}

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
        html.a(class: "top-text-button", title: "Switch Language", href: news-url(goal-href), locale)
      }
    }
  }
}

/// The header of the page.
#let header(go-back: none) = {
  html.div(
    class: "main-header",
    {
      html.div(
        style: "display: flex; flex-direction: row; gap: 8px;",
        {
          if go-back != none {
            fa-icon("/assets/fa-arrow-left.svg", title: "Go Back", href: go-back)
          }
        },
      )
      html.div(style: "display: flex; flex-direction: row-reverse; gap: 8px;", {
        fa-icon("/assets/fa-github.svg", title: "GitHub", href: "https://github.com/typst-doc-cn/news")
        fa-icon(
          if x-is-dark {
            "/assets/fa-moon.svg"
          } else {
            "/assets/fa-sun.svg"
          },
          class: "theme-button",
          title: "Change to Light Theme",
          onclick: "javascript:window.toggleTheme()",
        )
        qrcode-button
        locale-button
      })
    },
  )
}

/// The footer of the page.
#let footer = {
  html.div(
    class: "main-footer",
    {
      "© 2023-2026 "
      html.a(class: "text-link", { "Myriad-Dreamin." }, href: "https://github.com/Myriad-Dreamin")
      " All Rights Reserved. "
      "Powered by "
      html.a(class: "text-link", " Typst.", href: "https://github.com/typst/typst")
    },
  )
}

/// Fonts.
#let main-font-cn = ("Noto Sans CJK SC", "Source Han Serif SC")
#let code-font-cn = ("Noto Sans CJK SC",)

#let main-font = (
  (name: "Libertinus Serif", covers: "latin-in-cjk"),
  ..main-font-cn,
)

#let code-font = (
  "BlexMono Nerd Font Mono",
  // typst-book's embedded font
  "DejaVu Sans Mono",
  ..code-font-cn,
)

/// The base of all html templates.
#let base-template(pre-header: none, go-back: none, description: none, content) = {
  // Renders the math equations with scrollable div.
  show math.equation: set text(fill: color.rgb(235, 235, 235, 90%)) if x-is-dark
  show math.equation: div-frame.with(style: "display: flex; justify-content: center; overflow-x: auto;")
  /// The description of the document.
  set document(description: description) if description != none
  /// Wraps the following content with the HTML template.
  show: load-html-template.with(
    "/src/template.html",
    extra-head: {
      /// Theme-specific CSS.
      if x-is-dark {
        preload-css("/assets/dark.css")
      } else {
        preload-css("/assets/light.css")
      }
    },
  )

  /// HTML code block supported by zebraw.
  show: zebraw-init.with(
    ..if x-is-dark {
      (
        background-color: (rgb("#292e42"), rgb("#24283b")),
        highlight-color: rgb("#3d59a1"),
        comment-color: rgb("#394b70"),
        lang-color: rgb("#3d59a1"),
      )
    } else if x-is-light {
      (
        background-color: (rgb("#fafafa"), rgb("#f3f3f3")),
      )
    },
    lang: true,
  )
  show: zebraw.with(
    block-width: 100%,
    wrap: false,
  )
  set raw(theme: "/assets/tokyo-night.tmTheme") if x-is-dark
  show raw: set text(fill: rgb("#c0caf5")) if x-is-dark

  set text(font: main-font)

  /// The HTML content.
  pre-header
  header(go-back: go-back)
  html.div(class: "main-body", content)
  footer
}
