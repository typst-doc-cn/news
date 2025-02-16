
#let assets-url-base = sys.inputs.at("x-url-base", default: none)
#let url-base = if assets-url-base != none { assets-url-base } else { "/dist/" }
#let assets-url-base = if assets-url-base != none { assets-url-base } else { "/" }

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

#let header = {
  div(
    class: "main-header",
    {
      span(
        style: "float: right;",
        // filter with currentColor
        a(
          class: "icon-button",
          href: "https://github.com/typst-doc-cn/news",
          {
            div(
              style: {
                "width: 24px; height: 24px; background: currentColor; mask-image: url(\""
                asset-url("/assets/fa-github.svg")
                "\"); "
                "-webkit-mask-image: url(\""
                asset-url("/assets/fa-github.svg")
                "\");"
              },
              "",
            )
          },
        ),
      )
    },
  )
}

#let footer = {
  div(
    class: "main-footer",
    {
      "© 2023-2025 "
      a({ "Myriad-Dreamin." }, href: "https://github.com/Myriad-Dreamin")
      " All Rights Reserved. "
      "Powered by "
      a(" Typst.", href: "https://github.com/typst/typst")
    },
  )
}


#let base-template(content) = {
  show math.equation: set text(fill: color.rgb(235, 235, 235, 90%))
  show math.equation: div-frame.with(attrs: ("style": "display: flex; justify-content: center; overflow-x: auto;"))

  show: load-html-template.with("/src/template.html")

  header
  div(class: "main-body", content)
  footer
}
