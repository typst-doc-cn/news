
#import "/typ/templates/html-toolkit.typ": load-html-template

#let is-preview = sys.inputs.at("x-preview", default: none) != none

#show: load-html-template.with(if is-preview {
  "template.html"
} else {
  "template.prod.html"
})


#let div-frame(content, attrs: (:)) = html.elem("div", html.frame(content), attrs: attrs)

#show math.equation: div-frame.with(attrs: ("style": "display: flex; justify-content: center; overflow-x: auto;"))

#html.elem(
  "div",
  attrs: ("class": "container"),
  [
    #html.elem("h2")[
      Personal Information
    ]

    An equation:

    $
      integral f(x) dif x
    $

    An equation that is scrolled horizontally:

    $
      integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x
    $

    #table(
      columns: 2,
      "1", "2",
      "3", "4",
    )
  ],
)

