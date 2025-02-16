
#let url-base = sys.inputs.at("x-url-base", default: "/dist/")

#let to-html(data) = {
  if type(data) == str {
    let data = data.trim()
    if data.len() > 0 {
      data
    }
  } else {
    let href = data.attrs.at("href", default: none)
    if href != none and href.starts-with("/") {
      href = url-base + href.slice(1)
      data.attrs.at("href") = href
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
#let div = html-elem.with(tag: "div")
#let h1 = html-elem.with(tag: "h1")
#let h2 = html-elem.with(tag: "h2")

#let div-frame(content, attrs: (:)) = html.elem("div", html.frame(content), attrs: attrs)

#let base-template(content) = {
  show math.equation: set text(fill: color.rgb(235, 235, 235, 90%))
  show math.equation: div-frame.with(attrs: ("style": "display: flex; justify-content: center; overflow-x: auto;"))

  show: load-html-template.with("/src/template.html")

  content
}
