#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-11-12",
  title: "PR #4729 Add support for page references through new ref.form property",
  lang: "en",
  tags: ("pr",),
  description: "This PR adds support for page number references.",
)

Now you can use `ref(label, from: "page")` to reference the page number of content, similar to `\pageref` in LaTeX.

Note that the Chinese `supplement` for this `ref` still needs improvement (as shown in the image below where the `supplement` remains as "page"). Fixing this issue may require more improvements to `ref`. Related issues include #(2485, 5102).map(str).map(x => link("https://github.com/typst/typst/issues/" + x, "#" + x)).join([, ]).

#_exp(
  ```typ
  #set page(numbering: "1")
  = Hello <hello>
  #ref(<hello>, form: "page")
  ```,
  {
    set block(width: 5.5em, height: 3cm, inset: 0.18cm)
    block(
      fill: luma(230),
      [
        #set text(8pt)
        #show link: set text(black)
        #show link: x => {
          show underline: x => x.body
          x
        }
        #set heading(outlined: false)
        #align(left + top)[
          = Hello <4729-hello>
          #v(-2.5cm)
          #h(0.2cm) #link(<4729-hello>, "page 1")
        ]

        #align(bottom + center)[
          1
        ]
      ],
    )
  },
)
