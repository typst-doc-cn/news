
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


#let class-it(class: none, tag: "div", content) = {
  if class == none {
    content
  } else {
    html.elem(
      tag,
      content,
      attrs: {
        if class != none {
          ("class": class)
        } else {
          (:)
        }
      },
    )
  }
}

#let div = class-it.with(tag: "div")
#let h1 = class-it.with(tag: "h1")
#let h2 = class-it.with(tag: "h2")

#let div-frame(content, attrs: (:)) = html.elem("div", html.frame(content), attrs: attrs)
