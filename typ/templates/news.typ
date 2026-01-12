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

  let locale = if region != none {
    lang + "-" + region
  } else if lang != none {
    lang
  } else {
    "en"
  }

  import "/typ/templates/template.typ": base-template, current-title, news-link
  base-template(
    pre-header: current-title.update(title),
    go-back: news-link("content/" + locale + "/index.typ"),
    {
      html.style(
        // 48rem is from tailwindcss, the medium breakpoint.
        ```css
        @media (width >= 48rem) {
          .exp {
            width: 100%;
            display: grid;
            grid-template-columns: 50% 50%;
            gap: 1.5em;
          }
        }

        @media (width < 48rem) {
          .exp {
            display: block;
          }
        }

        .frame {
          box-shadow: 0 0 0.5em rgba(0, 0, 0, 0.1);
          border-radius: 0.5em;
          background: #fff;
          padding: 0.5em;
          width: fit-content;
          max-width: 100%;
          margin: auto;
          object-fit: contain;
        }
        ```.text,
      )
      html.h1(class: "main-title", title)
      html.div(
        class: "news-prop",
        {
          "Published At: " + date
          "  "
          "Tags: " + tags.join(", ")
        },
      )
      html.div(
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
  block(
    breakable: false,
    html.div(
      (
        left,
        right,
      )
        .map(x => html.div(x, style: "padding-bottom: 1em;"))
        .join(),
      class: "exp",
    ),
  )
}

#let exp(code, ..args, frame: false) = {
  if is-meta {
    return
  }
  _exp(
    code,
    {
      let body = if args.pos().len() == 0 {
        eval(code.text, mode: "markup")
      } else {
        args.at(0)
      }
      if frame {
        html.div(html.frame(body), class: "frame")
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
    html.div(
      (
        context if text.lang == "zh" {
          "曾经"
        } else {
          "Before"
        },
        context if text.lang == "zh" {
          "现在"
        } else {
          "After"
        },
        html.div(html.frame(before), class: "frame"),
        html.div(html.frame(after), class: "frame"),
      )
        .map(html.div)
        .join(),
      style: "display: grid; grid-template-columns: 1fr 1fr; gap: 0.5em; text-align: center; overflow-x: auto;",
    ),
  )
}
