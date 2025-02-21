#let is-meta = sys.inputs.at("x-meta", default: none) != none

/// Don't worry if you don't write a description. We can generate description automatically
/// by text exporting the content.
#let news-template(
  date: none,
  title: none,
  tags: (),
  description: none,
  lang: none,
  region: none,
  content,
) = {
  set document(title: title, description: description)
  set text(lang: lang, region: region)

  if is-meta {
    return [#metadata((
        title: title,
        date: date,
        description: description,
        tags: tags,
      )) <front-matter>]
  }

  import "/typ/templates/template.typ": *
  base-template(
    pre-header: current-title.update(title),
    go-back: news-link("content/index.typ"),
    {
      style(
        // 48rem is from tailwindcss, the medium breakpoint.
        ```css
        @media (width >= 48rem) {
          .exp {
            display: grid;
            grid-template-columns: 50% 50%;
            gap: 0.5em;
          }
        }
        @media (width < 48rem) {
          .exp {
            display: block;
          }
        }
        ```.text,
      )
      h1(class: "main-title", title)
      div(
        class: "news-prop",
        {
          "Published At: " + date
          "  "
          "Tags: " + tags.join(", ")
        },
      )
      div(
        class: "news-body",
        content,
      )
    },
  )
}

#let _exp(left, right) = {
  if is-meta {
    return
  }
  import "/typ/templates/template.typ": *
  block(
    breakable: false,
    html.elem(
      "div",
      (
        left,
        html.elem("div", right, attrs: (style: "padding: 1em;")),
      )
        .map(x => html.elem("div", x))
        .join(),
      attrs: (class: "exp", style: "margin: 1em 0em;"),
    ),
  )
}
#let exp(code, frame: false) = {
  if is-meta {
    return
  }
  _exp(
    code,
    {
      let body = eval(code.text, mode: "markup")
      if frame {
        html.frame(body)
      } else {
        body
      }
    },
  )
}
#let exp-err(code, msg) = {
  _exp(code, "ERR:\n" + msg)
}
#let exp-warn(code, msg) = {
  _exp(code, eval(code.text, mode: "markup") + "WARN:\n" + msg)
}
#let exp-change(code, before, after) = {
  if is-meta {
    return
  }
  _exp(
    code,
    html.elem(
      "div",
      (
        [曾经],
        [现在],
        before,
        after,
      )
        .map(x => html.elem("div", x))
        .join(),
      attrs: {
        (style: "display: grid; grid-template-columns: 1fr 1fr; gap: 0.5em; ")
      },
    ),
  )
}
