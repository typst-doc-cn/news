
#let to-html(data) = {
  if type(data) == str {
    let data = data.trim()
    if data.len() > 0 {
      data
    }
  } else {
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

#load-html-template("/src/template.html", [])


#let class-it(content, ..attrs, tag: "div") = html.elem(
  tag,
  content,
  attrs: attrs.named(),
)

#let a = class-it.with(tag: "a")
#let div = class-it.with(tag: "div")
#let h1 = class-it.with(tag: "h1")
#let h2 = class-it.with(tag: "h2")

#let div-frame(content, attrs: (:)) = html.elem("div", html.frame(content), attrs: attrs)

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
