
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2024-11-12",
  title: "PR #4729 Add support for page references through new ref.form property",
  lang: "zh",
  region: "CN",
  tags: ("pr",),
  description: "此 PR 支持创建页码引用。",
)

添加 `calc.norm()` 用于计算范数.


现在可以用 `ref(label, from: "page")` 引用内容的页码, 类似于 LaTeX 中的 `\pageref`.

需要注意的是, 目前该 `ref` 的中文 `supplement` 还有待改进(如下图中的 `supplement` 仍为 page). 修复本问题可能需要对 `ref` 做更多改进, 相关 issue 有 #(2485, 5102).map(str).map(x => link("https://github.com/typst/typst/issues/" + x, "#" + x)).join([, ]).

#_exp(
  ```typ
  #set page(numbering: "1")
  = 你好 <hello>
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
          = 你好 <4729-hello>
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
