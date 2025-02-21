
#import "supports-text.typ": *

#let x-target = sys.inputs.at("x-target", default: "light")
#let x-is-dark = x-target.ends-with("dark")
#let x-is-light = x-target.ends-with("light")
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
    let rewrite(data, attr) = {
      let value = data.attrs.at(attr, default: none)
      if value != none and value.starts-with("/") {
        data.attrs.at(attr) = asset-url(value)
      }

      data
    }

    data = rewrite(data, "href")
    data = rewrite(data, "src")

    html.elem(
      data.tag,
      attrs: data.attrs,
      data.children.map(to-html).join(),
    )
  }
}

#let load-html-template(template-path, content, extra-head: none) = {
  let head-data = xml(template-path).at(0).children.at(1)
  let head = to-html(head-data).body

  html.elem(
    "html",
    attrs: (
      "lang": "en",
      "xmlns": "http://www.w3.org/1999/xhtml",
    ),
    {
      html.elem(
        "head",
        {
          head
          extra-head
          context if document.description != none {
            html.elem(
              "meta",
              attrs: (
                "name": "description",
                "content": plain-text(document.description),
              ),
            )
          }
        },
      )
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
#let style = html-elem.with(tag: "style")
#let h1 = html-elem.with(tag: "h1")
#let h2 = html-elem.with(tag: "h2")

#let div-frame(content, attrs: (:)) = html.elem("div", html.frame(content), attrs: attrs)
