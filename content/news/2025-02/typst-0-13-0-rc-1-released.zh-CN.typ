#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-02-06",
  title: "Typst 0.13.0, RC 1 released",
  lang: "zh",
  region: "CN",
  tags: ("update",),
  description: "Typst 0.13.0, RC 1 版本发布了.",
)

Typst 0.13.0, RC 1 版本发布了. changelog 见 #link("https://typst.app/docs/changelog/0.13.0", "这里").

#if not is-meta [
  以下是一份中文的简要更新日志:


  #set table(stroke: white)

  #show table: set align(center)

  #show link: underline.with(stroke: 0.8pt)
  #show link: set text(blue)

  #show regex("ERR:"): set text(red, weight: "bold")
  #show regex("WARN:"): set text(orange.darken(10%), weight: "bold")

  #let fix = text(green.darken(30%), "fix")
  #let breaking = text(red, "breaking")
  #let feature = text(yellow.darken(15%), "feature")


  #let graybox = box.with(
    fill: luma(25%),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )
  #show raw.where(block: false): it => {
    graybox(it.text)
  }

  #let pr(no, title, type: ()) = {
    let tags = (type,).flatten().map(graybox).join([ ]) + [ ]
    if (no != none) {
      heading(link("https://github.com/typst/typst/pull/" + str(no), [\##no #tags] + title), level: 1)
    } else {
      heading(tags + title, level: 1)
    }
  }


  #align(
    center,
    text(
      2em,
      strong[
        Typst 0.13.0-rc1 简要更新日志
      ],
    ),
  )

  #show outline.entry: it => link(
    it.element.location(),
    it.indented(it.prefix(), it.body()),
  )
  #outline(target: <highlight>, title: "Highlight")

  #pr(
    4273,
    [Support Greek Numbering],
    type: feature,
  )

  支持希腊字母 `numbering`.

  #pr(
    4581,
    [Add `calc.norm()` function to compute euclidean norms],
    type: feature,
  )

  添加 `calc.norm()` 用于计算范数.

  #exp(
    frame: true,
    ```typ
    positional 参数为各分量 \
    #calc.norm(1, 1)

    可以指定 `p` 参数 \
    #calc.norm(p: 3, 1, 1, 1)
    ```,
  )

  #pr(
    4729,
    [Add support for page references through new `ref.form` property],
    type: (feature,),
  )
  现在可以用 `ref(label, from: "page")` 引用内容的页码, 类似于 LaTeX 中的 `\pageref`.

  需要注意的是, 目前该 `ref` 的中文 `supplement` 还有待改进(如下图中的 `supplement` 仍为 page). 修复本问题可能需要对 `ref` 做更多改进, 相关 issue 有 #(2485, 5102).map(str).map(x => link("https://github.com/typst/typst/issues/" + x, "#" + x)).join([, ]).

  #exp(
    frame: true,
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

  #pr(
    4889,
    [Disable justification in `raw(block: true, ...)`],
    type: fix,
  )
  默认情况下关闭行间 `raw` 中文本的两端对齐, 可以保证代码块的文字等宽.


  #pr(
    4985,
    [Top and bottom (⊤ and ⊥) have different spacing around them],
    type: fix,
  )

  把 "⊤" 和 "⊥" 的默认 math class 修改为 `normal` 以修复其两侧的空格表现异常的问题.

  #pr(
    5008,
    [Better math argument parsing],
    type: (breaking, feature),
  ) <highlight>
  对数学模式中函数调用的参数解析进行了一些调整, 包括:
  - `named` 参数现在支持任意标识符(包括连字符 `-` 和下划线 `_`)了
  - 现在可以在参数列表中使用 `..` 展开参数了
  - 重复传入同一个 `named` 参数现在会报错, 而不是不加提醒地使用后来的值

  #exp-change(
    ```typ
    #let func(my-body: none) = my-body
    $ func(my-body: a) $
    ```,
    align(left)[
      ERR: \
      Unknown variable: my
    ],
    [
      $ a $
    ],
  )

  #exp-change(
    ```typ
    $ mat(..#range(4).chunks(2)) $
    ```,
    [
      $ mat(\..#range(4).chunks(2)) $
    ],
    [
      $ mat(..#range(4).chunks(2)) $
    ],
  )

  #exp-change(
    ```typ
      #let func(my: none) = my
    $ func(my: a, my: b) $
    ```,
    [
      $ b $
    ],
    align(left)[
      ERR:\
      duplicate argument: my
    ],
  )

  #pr(
    5202,
    [Add `math.accent` support for `flac` and `dtls` OpenType features],
    type: (feature, fix),
  )
  让数学模式的 `accent` 支持 OpenType 特性 `flac` 和 `dtls`. 具体来说, 在使用支持这些特性的字体排版数学公式时, 如果公式中出现较大的上下标, 或者部分 `accent` 符号时, 字符会按字体设计的方式略微变形, 提供更好的视觉效果.

  #exp-change(
    ```typ
    $
    f'(x)
    $
    ```,
    [
      $
        f zws^(zws') (x)
      $
    ],
    [
      $
        f'(x)
      $
    ],
  )


  #pr(
    5221,
    [Embed files associated with the document as a whole],
    type: (feature,),
  ) <highlight>
  实现了 PDF 输出中无可见注释的文件嵌入功能.

  #exp(
    frame: true,
    ```typ
    下面的代码会向 PDF 中嵌入一些附件.
    #pdf.embed("hello.txt")

    可以手动设置多项参数.
    #pdf.embed("changelog.typ", description: "Source code of this document.", mime-type: "text/plain", relationship: "source")

    也可以从 `bytes` 插入, 并且自定义文件名.
    #let data = read("hello.txt", encoding: none)
    #pdf.embed("hello2.txt", data)
    ```,
    [],
  )


  #pr(
    5229,
    [Add a warning for `is` to anticipate using it as a keyword],
    type: (feature,),
  )
  现在用 `is` 做变量名的时候会被警告.

  #exp-warn(
    ```typ
    #let is = 1
    ```,
    "`is` will likely become a keyword in future versions and will not be allowed as an identifier

  Hint: rename this variable to avoid future errors

  Hint: try `is_` instead",
  )


  #pr(
    5258,
    [Space between function name and parameter list should not be allowed in set rule],
    type: (breaking, fix),
  )

  `set` 不再允许在函数名和括号之间加空格了.

  #exp-err(
    ```typ
    #set page (numbering: "1.")
    ```,
    "expected argument list
  Hint: there may not be any spaces before the argument list",
  )

  #pr(
    5295,
    [Fix clipping with outset],
    type: (fix),
  )

  修复了 `box` 和 `block` 同时使用 `outset` 和 `clip: true` 时裁剪区域偏右下的问题.

  #exp(
    frame: true,
    ```typ
    #block(
      clip: true,
      outset: 1em,
      fill: yellow,
      width: 2cm,
      height: 2cm,
    )[
      #place(dx: -2em, dy: -2em, top + left, square())
      #place(dx: +2em, dy: -2em, top + right, square())
      #place(dx: -2em, dy: +2em, bottom + left, square())
      #place(dx: +2em, dy:+ 2em, bottom + right, square())
    ]
    ```,
  )

  #pr(
    5305,
    [Support for defining which charset should be covered by a font],
    type: (feature),
  ) <highlight>
  现在可以手动指定哪些字符使用什么字体.
  #exp(
    frame: true,
    ```typ
    // 只改变数字的字体
    #set text(font: (
      (name: "BlexMono Nerd Font Mono", covers: regex("[0-9]")),
      "Libertinus Serif"
    ))
    等宽: 110088 \
    不等宽: Xyzwls
    ```,
  )

  #exp(
    frame: true,
    ```typ
    // 中英文字体分别设置 (不需要手动 show 或者 re)
    #set text(font: (
      (name: "Libertinus Serif", covers: "latin-in-cjk"),
      "Noto Sans CJK SC"
    ))
    中文字体和 Latin Font 可以分别设置.
    ```,
  )


  #pr(
    5310,
    [Refactor Parser],
    type: (fix),
  ) <highlight>
  重构 parser, 主要解决了标记模式下 `list` 的一些问题和某些情况下编译器崩溃的问题.

  #exp-change(
    ```typ
    9. foo
      - bar
    10. foo
      - bar
    ```,
    [
      9. foo
        - bar
      10. foo
      - bar
    ],
    [
      9. foo
        - bar
      10. foo
        - bar
    ],
  )

  #exp-change(
    ```typ
    - foo
    /**/- bar
        /**/- baz
    ```,
    [
      - foo
      - bar
      - baz
    ],
    [
      - foo
        /**/- bar
        /**/- baz
    ],
  )

  #exp-change(
    ```typ
    - foo
      - bar
    /**/    - baz
    ```,
    [
      - foo
        - bar
      - baz
    ],
    [
      - foo
        - bar
          /**/ - baz
    ],
  )

  #exp-change(
    ```typ
    - foo
        - bar
      - baz
    ```,
    [
      #set list(marker: [•])
      - foo
        - bar
        - baz
    ],
    [
      - foo
        - bar
        - baz
    ],
  )


  #exp-change(
    ```typ
    - foo
      - bar
        - baz
    ```,
    [
      #set list(marker: [•])
      - foo
        - bar
        - baz
    ],
    [
      - foo
        - bar
        - baz
    ],
  )


  #pr(
    5316,
    [Make `math.bold` compatible with Greek digamma],
    type: fix,
  )
  数学环境中的 `bold` 现在可以加粗希腊字母 digamma (Ϝ, ϝ) 了.
  #exp(
    frame: true,
    ```typ
    $ Ϝ ϝ bold(Ϝ ϝ) $
    ```,
  )

  #pr(
    5323,
    [New `curve` element that supersedes `path`],
    type: feature,
  ) <highlight>
  新添加了 `curve` 元素替代之前的 `path`.

  新的 `curve` 元素支持一条 `curve` 中包含多段不同的 subcurve, 并且可以方便地调整闭合方式, 填充方式等.
  #exp(
    frame: true,
    ```typ
    #set curve(fill: yellow)
    #curve(
      fill-rule: "even-odd",
      stroke: black,
      curve.move((10mm, 10mm)),
      curve.line((20mm, 10mm)),
      curve.line((20mm, 20mm)),
      curve.close(),
      curve.move((0mm, 5mm)),
      curve.line((25mm, 5mm)),
      curve.line((25mm, 30mm)),
      curve.close(),
    )

    #curve(
      stroke: black,
      curve.move((10mm, 10mm)),
      curve.cubic((5mm, 20mm), (15mm, 20mm), (20mm, 0mm), relative: true),
      // 第一个控制点 auto 相当于前一条曲线的最后一个控制点
      curve.cubic(auto, (15mm, -10mm), (20mm, 0mm), relative: true),
      curve.close(mode: "straight")
    )

    #curve(
      // 默认起点, 也可以手动指定
      // curve.move(start: (0mm, 0mm)),
      curve.quad((10mm, 0mm), (10mm, 10mm)),
      curve.quad(auto, (10mm, 10mm), relative: true),
      curve.close()
    )
    ```,
  )

  #pr(
    5354,
    [Fix unstoppable empty footnote loop],
    type: fix,
  )

  修复了之前给 `footnote.entry` 写 `show` 会导致编译器卡死的问题.

  #pr(
    5394,
    [Fix unnecessary hyphenation],
    type: fix,
  )
  修复了布局时的某个计算精度问题, 防止某些时候出现错误的断行.

  #exp-change(
    ```typ
    #set par(justify: true)
    #table(columns: 1, [Formal])
    ```,
    {
      table(
        columns: 41.59pt, // measured
        align(left)[For-\ mal],
      )
    },
    {
      table(
        columns: 1,
        [Formal],
      )
    },
  )

  #pr(
    5411,
    [Timings for `state.at` and `state.get`],
    type: feature,
  )
  现在 `state.at` 和 `state.get` 添加了计时数据, 便于观察使用了很多 `state` 的包或者文档的编译性能.


  #pr(
    5414,
    [Convert unopened square-brackets into a hard error],
    type: breaking,
  )
  现在在标记模式下直接使用 `]` 会报错.


  #exp-err(
    ```typ
    ]
    ```,
    "unexpected closing bracket

  Hint: try using a backslash escape: \]",
  )

  #pr(
    5444,
    [Handle SIGPIPE],
    type: (fix),
  )
  Typst CLI 现在可以输出到管道了(之前会直接 panic).

  #pr(
    5451,
    [Fix sizing of quadratic shapes (square/circle)],
    type: fix,
  )

  修复了 `square` 和 `circle` 的 `height` 或者 `width` 参数超出其 `size` 时, 大小仍为 `size` 的值的问题.

  #exp-change(
    ```typ
    #square(height: 2cm)
    #square(size: 2cm)
    ```,
    [
      #square()
      #square(size: 2cm)
    ],
    [
      #square(height: 2cm)
      #square(size: 2cm)
    ],
  )

  #pr(
    5457,
    [Fix `path` with infinite length causing panic],
    type: fix,
  )

  修复了无穷长度的 `path` 会导致编译器崩溃的问题(现在会报错, 而不是直接崩溃).

  #exp-err(
    ```typ
    #path((0pt, 0pt), (float.inf * 1pt, 0pt))
    ```,
    "cannot create path with infinite length",
  )

  #pr(
    5458,
    [Tags shouldn't affect row height in equations],
    type: fix,
  )
  修复了在数学公式中插入 `metadata` 会轻微影响元素高度的问题.

  #exp-change(
    ```typ
    #box($ - - $, fill: silver)
    #box($ #metadata(none) - - $, fill: silver) \
    #box($ a \ - - $, fill: silver)
    #box($ a \ #metadata(none) - - $, fill: silver)
    #box($ - - \ a $, fill: silver)
    #box($ #metadata(none) - - \ a $, fill: silver)
    ```,
    [懒得画了, 反正会不一样],
    [
      #box($ - - $, fill: silver)
      #box($ #metadata(none) - - $, fill: silver)
      #box($ a \ - - $, fill: silver)
      #box($ a \ #metadata(none) - - $, fill: silver)
      #box($ - - \ a $, fill: silver)
      #box($ #metadata(none) - - \ a $, fill: silver)
    ],
  )

  #pr(
    5459,
    [Fix multiline annotations in over- elems in math changing the baseline],
    type: fix,
  ) <highlight>
  修复数学模式下 `overbrace` 等 `over-` 函数的多行标注导致基线偏移的问题.

  #exp-change(
    ```typ
    $ S = overbrace(beta (alpha) S I, "one line") - overbrace(mu (N), "two" \  "line") $
    ```,
    $ overbrace(beta (alpha) S I, "one line") - std.box(overbrace(mu (N), "two" \  "line"), baseline: #0.5em) $,
    $ overbrace(beta (alpha) S I, "one line") - overbrace(mu (N), "two" \  "line") $,
  )

  #pr(
    5473,
    [Ignore leading and trailing ignorant fragments in `math.lr`],
    type: fix,
  )
  修复 `math.lr` 无法正常调整被套起来(比如用 `box` 或者 `context`)的括号大小的问题.

  #exp-change(
    ```typ
    #show "(": it => context it
    $ (1 / 2) $
    ```,
    $ \( lr(1/2\)) $,
    $ (1 / 2) $,
  )

  #pr(
    5477,
    [Fix weak spacing being ignored unconditionally in `math.lr`],
    type: fix,
  )
  修复 `math.lr` 会吞掉其内部的某些 `weak h` 的问题.

  #exp-change(
    ```typ
    $ lr(\[x #h(1em, weak: true)a) $
    ```,
    $ [x a $,
    $ [x #h(1em) a $,
  )

  #pr(
    5480,
    [Add support for interpreting f32 in float.{from-bytes, to-bytes}],
    type: feature,
  )
  现在 `float.from-bytes` 和 `float.to-bytes` 支持 `f32` 了.

  #exp(
    frame: true,
    ```typ
    #range(4).map(x => float.to-bytes(1.5, size: 4).at(x)) \
    #float.from-bytes(bytes((0, 0, 192, 63)))
    ```,
  )

  #pr(
    5481,
    [Let decimal constructor accept decimal values],
    type: feature,
  )
  现在可以用 `decimal` 创建 `decimal` 了.

  #exp(
    frame: true,
    ```typ
    #decimal(decimal(3))
    ```,
  )

  #pr(
    5483,
    [Use extended shape information for glyph `text_like`-ness],
    type: fix,
  )
  修复了 `math.lr` 的上下标在某些情况下位置没有被拉伸的问题.

  #exp-change(
    ```typ
    $ lr(|,size: #3em)_a^b $
    ```,
    $ lr(|,size: #3em)zws_a^b $,
    $ lr(|,size: #3em)_a^b $,
  )

  #pr(
    5492,
    [Make `math.italic` compatible with ħ],
    type: fix,
  )
  `math.italic` 现在也能让 ħ 变成斜体(ℏ)了.

  #exp-change(
    ```typ
    $ ħ $
    ```,
    $ upright(ħ) $,
    $ ħ $,
  )

  #pr(
    5497,
    [Forbid footnote migration in pending floats],
    type: fix,
  )

  修复了待定浮动元素中的脚注迁移导致的编译器崩溃问题.

  #pr(
    5498,
    [Fix infinite loop with footnote which never fits],
    type: fix,
  )
  修复了过大的 `footnote` 在布局时导致死循环和 OOM 的问题.

  #pr(
    5502,
    [Fix text fill within `clip: true` blocks in PNG export],
    type: fix,
  )
  修复了在 `clip` 为 `true` 的 `block` 内的半透明文本填充色无法正确设置的问题.

  #exp-change(
    ```typ
    #block(clip: false, {
      text(fill: blue.transparentize(50%), "Hello, World")
    })
    #block(clip: true, {
      text(fill: blue.transparentize(50%), "Hello, World")
    })
    ```,
    [#block(
        clip: false,
        {
          text(fill: blue.transparentize(50%), "Hello, World")
        },
      )
      #block(
        clip: true,
        {
          text(fill: blue.darken(55%), "Hello, World")
        },
      )],
    [#block(
        clip: false,
        {
          text(fill: blue.transparentize(50%), "Hello, World")
        },
      )
      #block(
        clip: true,
        {
          text(fill: blue.transparentize(50%), "Hello, World")
        },
      )],
  )

  #pr(
    5505,
    [Improve `symbol` repr],
    type: feature,
  )
  改进了 `symbol` 的 `repr`, 现在会显示更多信息.

  #exp-change(
    ```typ
    #repr(sym.amp) \
    #repr(sym.amp.inv) \
    #repr(sym.smash)
    ```,
    ["&" \ "⅋" \ "⨳"],
    [#repr(sym.amp) \
      #repr(sym.amp.inv) \
      #repr(sym.smash)],
  )

  #pr(
    5513,
    [HTML foundation 等],
    type: feature,
  ) <highlight>
  HTML 导出相关功能, 具体支持情况见 #link("https://github.com/typst/typst/issues/5512", [Tracking issue for HTML export]).

  与 HTML 导出相关的 PR 还有 #(5522, 5524, 5525, 5530, 5532, 5533, 5594, 5619, 5661, 5665, 5666, 5673, 5676, 5744, 5745).map(str).map(x => link("https://github.com/typst/typst/pull/" + x, "#" + x)).join([, ]).

  此外, 还添加了 `set document(description: str)`, 用于为 PDF 和 HTML 输出设置文档描述.

  #exp(
    frame: true,
    ```typ
    以下代码可以给文档设置描述
    #set document(description: "简单的 0.13.0-rc1 更新日志")
    ```,
    [以下代码可以给文档设置描述],
  )

  #pr(
    5526,
    [Ensure par and align interrupt cite groups and lists],
    type: fix,
  )

  确保对 `par` 和 `align` 样式的更改不仅会中断段落, 还会中断列表和引用. 用于修复嵌套在 `align` 或者 `par` 内的 `cite` 和 `list` 导致样式错误, 现在这样做会导致警告, 且隐藏嵌套的元素.

  #exp-change(
    ```typ
    + a
    #par[+ b]
    + c
    ```,
    align(left)[
      + a
      + b
      + c
    ],
    align(left)[
      + a
      #v(0.77em)
      + c
      WARN: \
      block may not occur inside of a paragraph and was ignored
    ],
  )

  #pr(
    5528,
    [Add missing functions to the gradient object],
    type: feature,
  )
  给 `radial` 和 `conic` 渐变添加了多个获取属性的函数, 包括 `gradient.center()`, `gradient.radius()`, `gradient.focal_center()`, `gradient.focal_radius()`.

  #exp(
    frame: true,
    ```typ
    #let rad = gradient.radial(..color.map.viridis)
    #rad.center() \
    #rad.radius() \
    #rad.focal-center() \
    #rad.focal-radius() \

    #let con = gradient.conic(..color.map.viridis)
    #con.center()
    ```,
  )

  #pr(
    5545,
    [Fix multiple footnotes in footnote entry],
    type: fix,
  )
  修复了在 `footnote` 内引用多个 `footnote` 时, 只有第一个引用的 `entry` 显示的问题.
  #exp-change(
    ```typ
    你好#footnote[这是一个引用了#footnote[第二个脚注] 和  #footnote[第三个脚注]的脚注]
    ```,
    align(left)[
      你好 #super([1])
      #line(length: 3em)
      #super([1]) 这是一个引用了#super([2]) 和 #super([3])的脚注 \
      #super([2]) 第二个脚注
    ],
    align(left)[
      你好 #super([1])
      #line(length: 3em)
      #super([1]) 这是一个引用了#super([2]) 和 #super([3])的脚注 \
      #super([2]) 第二个脚注 \
      #super([3]) 第三个脚注 \
    ],
  )

  #pr(
    5548,
    [Forbid base prefix for numbers with a unit],
    type: (breaking, fix),
  )
  禁止在有单位的值中使用 如 `0x`, `0b` 等进制前缀.

  #exp-err(
    ```typ
    #0b0011pt
    ```,
    "invalid base-2 prefix

  Hint: numbers with a unit cannot have a base prefix",
  )

  #pr(
    5550,
    [Fix language-dependant figure caption separator in outline],
    type: fix,
  )
  现在目录中的 `figure` 条目中, `caption` 和 `numbering` 的分隔符(对于中文来说, 就是空格)也会跟随语言改变.

  #exp-change(
    ```typ
    #set text(lang: "zh")
    #outline(target: selector(figure))
    #figure(rect(), caption: [A rectangle])
    ```,
    [
      #set text(lang: "zh")
      #outline(target: <_>)
      #align(left)[
        @5550-fig-a: 矩形 #box(width: 1fr, repeat([.], gap: 0.16em)) 1
      ]
      #figure(rect(), caption: [矩形])<5550-fig-a>
    ],
    [
      #set text(lang: "zh")
      #outline(target: selector(<5550-fig-b>))
      #figure(rect(), caption: [矩形]) <5550-fig-b>
    ],
  )

  #pr(
    5562,
    [Fix crash due to consecutive weak spacing],
    type: fix,
  )

  修复某些情况下连续弱空格导致的崩溃.

  #exp-change(
    ```typ
    #set par(justify: true)
    #set heading(numbering: "I.")
    = #h(0.3em, weak: true) test
    ```,
    [Compiler crashed],
    [
      #set par(justify: true)
      #set heading(numbering: "I.", outlined: false)

      = #h(0.3em, weak: true) test
    ],
  )

  #pr(
    5563,
    [Add reversed numbering],
    type: feature,
  )
  支持 `enum` 的反向编号.

  #exp(
    frame: true,
    ```typ
    #set enum(reversed: true)
    + 你好
    + 你好吗
    + 你好哦
    ```,
  )


  #pr(
    5564,
    [Add timezone to PDF's default timestamp],
    type: feature,
  )
  添加了一个 CLI 参数 `--creation-timestamp`:
  + 如果 `document.date` 被设置为 `none` 或者 `datetime(...)`, 输出 PDF 的元数据会使用设置的值
  + 如果`document.date` 为默认值 `auto`
    + 如果设置了 `--creation-timestamp`, 输出 PDF 的时区将设置为 UTC
    + 否则, 将被设置为本地时区

  #pr(
    5571,
    [Change error when accessing non-existent label],
    type: fix,
  )
  优化了某些情况下访问不存在的字段的错误提示.

  #exp-change(
    ```typ
    #[].foo
    ```,
    align(left)[
      ERR:\
      Internal error when accessing\
      field "label" in sequence\
       - this is a bug
    ],
    align(left)[
      ERR:\
      sequence does not have field\
      "foo"
    ],
  )

  #pr(
    5575,
    [Derivation comment for calculation in `repeat`],
    type: fix,
  ) <highlight>
  通过对 `repeat` 逻辑的一些改进修复了使用 `repeat` 创建 `link` 时造成的 PDF 体积过大的问题.

  相关的 PR 还有 #link("https://github.com/typst/typst/pull/5732", [5732]).


  #pr(
    5581,
    [Fix sticky blocks at the top of blocks and pages],
    type: fix,
  ) <highlight>
  修复了在 `block` 或 `page` 顶部的 `sticky` `block` 不 `sticky` 的问题.


  #exp-change(
    ```typ
    #set page(height: 3cm, fill: luma(230))
    #v(1.6cm)
    #block(height: 2cm, breakable: true)[
      #block(sticky: true)[*A*]

      b
    ]
    ```,
    {
      set block(width: 5em, height: 3cm, inset: 0.35cm)
      block(
        fill: luma(230),
        align(
          bottom,
          [
            *A*
            #v(0.42cm)
          ],
        ),
      )
      block(fill: luma(230))[
        b
      ]
    },
    {
      set block(width: 5em, height: 3cm, inset: 0.35cm)
      block(
        fill: luma(230),
        [],
      )
      block(fill: luma(230))[
        *A*

        b
      ]
    },
  )

  #pr(
    5587,
    [Error on duplicate symbol variant with modifiers in different orders],
    type: (breaking, fix),
  )
  现在在 `symbol` 中定义两个 `modifiers` 相同但是顺序不同的符号会导致编译错误.

  #exp-change(
    ```typ
    #let s = symbol(
      ("foo.bar", "A"),
      ("bar.foo", "B"),
    )

    #s.foo
    #s.bar
    #s.foo.bar
    #s.bar.foo
    ```,
    [A A A A],
    align(left)[ERR: \
      duplicate variant: "bar.foo"

      Hint: variants with the same\
      modifiers are identical, \
      regardless of their order
    ],
  )

  #pr(
    5589,
    [Get numbering of page counter from style chain],
    type: feature,
  ) <highlight>
  现在 Typst 可以自动处理 `page.numbering` 为 `none` 时的 `counter(page).display()`. 所以我们可以不需要再写
  ```typ
  #set page(footer: context {
    let page-numbering = if page.numbering != none { page.numbering } else { "1" }
    counter(page).display(page-numbering)
  })
  ```
  而是可以直接
  ```typ
  #set page(footer: context counter(page).display())
  ```

  #pr(
    5590,
    [Rename `pattern` to `tiling`],
  )
  把 `pattern` 改为 `tiling`.

  #pr(
    5591,
    [Remove deprecated things and compatibility behaviours],
    type: breaking,
  )
  彻底删除上个版本就已经警告 deprecated 的内容, 具体来说, 包含:
  - `style`
  - `state.display`
  - `measure` 的 `styles` 参数
  - `state.at`, `counter.at`, `query` 的 `location` 参数
  - `counter.display` 的兼容性行为(自动 `context`)
  - `locate` 的兼容性行为(自动 `context`)
  - 类型和字符串的兼容性行为(比如 `int == "integer"`)
  - `outline.indent` 的 `bool` 支持

  #pr(
    5596,
    [Fix math size resolving],
    type: fix,
  )
  修复数学模式中某些情况下的文字大小解析.
  #exp-change(
    ```typ
    #let size = context [#text.size.to-absolute() #(1em).to-absolute()]
    $ a^size $
    ```,
    [#let size = context [#text.size.to-absolute() #text.size.to-absolute()]
      $ a^size $],
    [#let size = context [#text.size.to-absolute() #1em.to-absolute()]
      $ a^size $],
  )

  #pr(
    5610,
    [Fix crash when block or text have negative sizes],
    type: fix,
  )
  修复 `block` 或者 `text` 的大小为负时的编译器崩溃.

  #pr(
    5613,
    [Fix arbitrarily nested equations in the base of `math.attach`],
    type: fix,
  )
  修复 `math.attach` 在处理多层嵌套的 `math.equation` 不能正常工作的问题.

  #exp-change(
    ```typ
    #{
      let body = $stretch(=)$
      body = $body$
      $ body^"long text" $
    }
    ```,
    [#{
        let body = $=$
        body = $body$
        $ body^"long text" $
      }
    ],
    [#{
        let body = $stretch(=)$
        body = $body$
        $ body^"long text" $
      }
    ],
  )

  #pr(
    5632,
    [Include images from raw pixmaps and more],
    type: feature,
  )

  `image` 现在可以用 pixmap 创建, 并且可以指定编码方式, ICC 等. 此外, 现在还可以使用 `scaling` 参数指示查看器应该如何缩放图片(平滑或像素化).

  #exp(
    frame: true,
    ```typ
    #image(
      bytes(range(16).map(x => x * 16)),
      format: (
        encoding: "luma8",
        width: 4,
        height: 4,
      ),
      // auto, "pixelated", "smooth"
      scaling: "pixelated",
      width: 3cm,
      icc: auto,
    )
    ```,
  )

  #pr(
    5651,
    [Allow adding and joining `arguments`],
    type: feature,
  )
  现在 `arguments` 也可以 `add` 和 `join` 了.
  #exp(
    frame: true,
    ```typ
    #{ arguments(1) + arguments(2) } \
    #{ (arguments(1), arguments(2)).join() }
    ```,
  )

  #pr(
    5652,
    [Improve `repr` for `arguments`],
    type: feature,
  )
  现在 `arguments` 的 `repr` 会显示类似于 constructor 的格式.

  #exp-change(
    ```typ
    #repr(arguments(1))
    ```,
    [(1)],
    [arguments(1)],
  )

  #pr(
    5655,
    [Add support for `c2sc` OpenType feature in `smallcaps`],
    type: feature,
  )
  给 `smallcaps` 添加了 OpenType 的 `c2sc` 特性支持.

  `c2sc` 特性可以将大写字母转换为小型大写字母, 之前 `smallcaps` 的默认行为是使用 `smcp` 特性将小写字母转换为小型大写字母).

  #exp(
    frame: true,
    ```typ
    #set text(font: "Libertinus Serif")
    #smallcaps("Hello World", all: true) \
    #smallcaps("Hello World", all: false)
    ```,
  )

  #pr(
    5659,
    [Avoid stripping url prefixes multiple times or multiple prefixes],
    type: fix,
  )
  防止多次删除 URL 前缀.
  #exp-change(
    ```typ
    #link("mailto:foo") \
    #link("mailto:tel:foo") \
    #link("mailto:mailto:foo")
    ```,
    [#link("mailto:foo", "foo") \
      #link("mailto:tel:foo", "foo") \
      #link("mailto:mailto:foo", "foo")],
    [#link("mailto:foo") \
      #link("mailto:tel:foo") \
      #link("mailto:mailto:foo")],
  )


  #pr(
    5671,
    [Revamp data loading and deprecate `decode` functions],
    type: feature,
  ) <highlight>
  重构了多种支持传入路径的函数的 API, 具体为:

  - `image`, `cbor`, `csv`, `json`, `toml`, `xml`, `yaml` 现在支持传入路径或 `bytes`, 因此它们的 `.decode` 函数已被弃用
  - `plugin`, `bibliography`, `bibliography.style`, `cite.style`, `raw.theme` 和 `raw.syntaxes` 现在除了接受路径参数外, 还接受 `bytes` (其中一些还接受两种类型的混合数组). 这些功能之前没有 `.decode` 变体, 因此这次更新提高了灵活性

  #pr(
    5702,
    [Ignore shebang at start of file],
    type: feature,
  ) <highlight>
  `.typ` 文件首行的 shebang (`#!` 开头的一行文字, 用于指定该文件的解释器) 会被 Typst 编译器忽略.

  #exp(
    frame: true,
    ```typ
    #!/usr/bin/typst c
    运行此文件会直接产生 PDF 输出
    ```,
  )

  #pr(
    5728,
    [Support syntactically directly nested list, enum, and term list],
    type: feature,
  ) <highlight>
  优化了嵌套 `list`, `enum`, `terms` 的写法.

  之前, 为了产生嵌套的上述元素, 我们必须使用换行和缩进, 比如
  #exp(
    frame: true,
    ```typ
    + first main
    +
      - first sub
      - second sub
    ```,
  )

  现在不需要额外的换行了.
  #exp(
    frame: true,
    ```typ
    + first main
    + - first sub
      - second sub
    ```,
  )

  #pr(
    5733,
    [Methods on elements],
    type: feature,
  )
  现在可以通过 `element.func()` 的语法调用元素的函数, 目前仅用于下一条.

  #pr(
    5735,
    [Rework outline],
    type: (feature, fix),
  ) <highlight>
  对 `outline` 进行了多项改良, 具体包括:
  - 目录条目现在是 `block` 了, 因此可以通过 `set block(spacing)` 设置目录条目的间隔:
    #exp(
      frame: true,
      ```typ
      #show outline.entry.where(level: 1): set block(spacing: 1.5em)
      #outline()
      = 你好
      = 我好
      ```,
      [
        #show outline.entry.where(level: 1): set block(spacing: 1.5em)
        #outline(target: <5735-heading>)
        = 你好 <5735-heading>
        = 我好 <5735-heading>
      ],
    )
  - 修复了目录中多行条目的对齐问题.
  - 基于上一个 PR, 新增了一系列 `outline.entry` 的函数, 包括
    - `body()`: 条目内容
    - `page()`: 条目页码
    - `prefix()`: 条目的 `supplement` 和编号.
    - `inner()`: 条目的内容, 引导符(比如`repeat(".")`)和页码.
    - `indented(prefix, inner)`: 返回带缩进的 `prefix` + `inner`


  #pr(
    5738,
    [Add SymbolElem to improve math character styling and fix `$"a"$` vs. `$a$`],
    type: fix,
  ) <highlight>
  修复 `$"a"$` 不是斜体的问题.

  #exp-change(
    ```typ
    $ "a" $
    ```,
    [$ a $],
    [$ "a" $],
  )

  #pr(
    5739,
    "Fix delimiter unparen syntax",
    type: fix,
  )
  修复某些情况下手动 `$lr([])$` 和 `$[]$` 的不同.

  #exp-change(
    ```typ
    #let item = $limits(sum)_i$
    $
      1 / lr([item]) quad
      1 / [item]
    $
    ```,
    [#let item = $limits(sum)_i$
      $
        1 / lr([item]) quad
        1 / limits([sum])_i
      $],
    [#let item = $limits(sum)_i$
      $
        1 / lr([item]) quad
        1 / [item]
      $],
  )

  #pr(
    5746,
    [Semantic paragraphs],
    type: feature,
  )
  引入了一些区分语义段落和普通文本的规则, 主要用于 HTML 输出和首行缩进的修复, 具体来说
  - 文档顶层的文本都会自动成为段落
  - 容器(比如 `block`)中的文本
    - 如果容器内还有其他块级元素元素, 那该文本会成为段落
    - 否则, 不会

  #pr(
    5753,
    [Disable cjk_latin_spacing in raw by default],
    type: fix,
  )

  默认情况下在 `raw` 中关闭 CJK 文字和拉丁文字间的空格.


  #pr(
    5768,
    [Support first-line-indent for every paragraph],
    type: feature,
  ) <highlight>
  支持对所有段落设置首行缩进.

  #exp(
    frame: true,
    ```typ
    #set par(first-line-indent: (amount: 2em, all: true))
    = 标题
    标题下首段也能缩进了.
    ```,
    [
      #set heading(outlined: false)
      #set par(first-line-indent: (amount: 2em, all: true))
      = 标题
      标题下首段也能缩进了.
    ],
  )

  #pr(
    5773,
    [Resolve bound name of bare import statically],
    type: (breaking),
  )

  改变了无导入列表, 无重命名的 `import` 解析绑定名称的行为, 具体来说, 现在的绑定名不再动态解析, 而是必须在 AST 中静态地已知.

  #exp-err(
    ```typ
    #import "te" + "st.typ"
    这是一个不静态的 `import`
    ```,
    "cannot determine binding name for this import

  Hint: the name must be statically known
  Hint: you can rename the import with `as`
  Hint: to import specific items from a dynamic source, add a colon followed by an import list
  ",
  )


  #pr(
    5779,
    [Modular, multi-threaded, transitioning plugins],
    type: (breaking, feature),
  ) <highlight>
  对插件系统做了一些改进, 具体包括:
  - 现在没有专门的插件类型了. `plugin(...)` 会直接返回 `module`. 于是我们可以对插件使用 `import`, 也可以对插件中的函数使用 `.with`.
  - 现在支持多线程运行插件, 这一切都是自动完成的, 用户不需要进行任何手动操作.
  - 提供了新的 `plugin.transition` API 用于执行非纯函数. 如果不使用 `transition` 调用非纯函数, 可能会导致不可预测的结果.

  #exp(
    frame: true,
    ```typ
    #import plugin("mycalc.wasm"): myadd, mymut
    #myadd(3, 5) \
    #mymut.with(3)(5)
    ```,
    [
      8 \
      15
    ],
  )

  #exp(
    frame: true,
    ```typ
    #let base = plugin("mut.wasm")
    变化前的 `base`: #base.get() \

    #let mutated = plugin.transition(base.add, "hello")
    变化后的 `base`: #base.get() \
    变化后的返回值 `mutated`: #mutated.get()
    ```,
    [
      变化前的 `base`: [] \
      变化后的 `base`: [] \
      变化后的返回值 `mutated`: [hello]
    ],
  )

  // todo: 在新版发布后把这里的代码改为实际计算
  #pr(
    5788,
    [Change type repr to short name],
    type: fix,
  )
  现在 `repr` 某个类型会显示较短的那个名字, 和代码中使用的标识符更统一. 但是, 把类型转为 `str` 仍然会显示较长的那个名字.

  #exp-change(
    ```typ
    #repr(int)
    #str(int)
    ```,
    [
      integer
      #str(int)
    ],
    [
      int
      #str(int)
    ],
  )


  #pr(
    none,
    "符号变动",
    type: (breaking, feature),
  )

  #let new-symbols = (
    "+$eq.triple.not$",
    "+$asymp$",
    "+$asymp.not$",
    "+$lcm$",
    "+$asymp$",
    "+$asymp.not$",
    "+$mapsto$",
    "+$mapsto.long$",
    "+$divides.not.rev$",
    "+$divides.struck$",
    "+$interleave$",
    "+$interleave.big$",
    "+$interleave.struck$",
    "+$eq.triple.not$",
    "+$eq.dots$",
    "+$eq.dots.down$",
    "+$eq.dots.up$",
    "+$smt$",
    "+$smt.eq$",
    "+$lat$",
    "+$lat.eq$",
    "+$colon.tri$",
    "+$colon.tri.op$",
    "+$dagger.triple$",
    "+$dagger.l$",
    "+$dagger.r$",
    "+$dagger.inv$",
    "+sym.hourglass.stroked",
    "+sym.hourglass.filled",
    "+sym.die.six",
    "+sym.die.five",
    "+sym.die.four",
    "+sym.die.three",
    "+sym.die.two",
    "+sym.die.one",
    "+sym.errorbar.square.stroked",
    "+sym.errorbar.square.filled",
    "+sym.errorbar.diamond.stroked",
    "+sym.errorbar.diamond.filled",
    "+sym.errorbar.circle.stroked",
    "+sym.errorbar.circle.filled",
    "+sym.numero",
    "*$sect$|$inter$",
    "*$sect.and$|$inter.and$",
    "*$sect.big$|$inter.big$",
    "*$sect.dot$|$inter.dot$",
    "*$sect.double$|$inter.double$",
    "*$sect.sq$|$inter.sq$",
    "*$sect.sq.big$|$inter.sq.big$",
    "*$sect.sq.double$|$inter.sq.double$",
    "*$integral.sect$|$integral.inter$",
    "*$ohm.inv$|$Omega.inv$",
    "-$diff$|$partial$",
    "-$degree.c$|$upright(°C)$",
    "-$degree.f$|$upright(°F)$",
    "-$kelvin$|$upright(K)$",
  )



  #let new-symbols-col = 2
  #table(
    columns: new-symbols-col * 3,
    align: center + horizon,
    ..("类型", "代码", "符号") * new-symbols-col,
    ..new-symbols
      .map(x => {
        if (x.starts-with("+")) {
          let code = x.slice(1)
          return ("添加", raw(code, lang: "typ"), eval(code))
        } else if (x.starts-with("-")) {
          let (old, new) = x.slice(1).split("|")
          return ("删除", raw(old, lang: "typ"), eval(new))
        } else if (x.starts-with("*")) {
          let (old, new) = x.slice(1).split("|")
          return (
            "变更",
            {
              strike(raw(old, lang: "typ"))
              h(0.2em)
              raw(new, lang: "typ")
            },
            eval(new),
          )
        }
      })
      .flatten()
  )

  相关 PR 包括 #(5326, 5372, 5388, 5391, 5718).map(str).map(x => link("https://github.com/typst/typst/pull/" + x, "#" + x)).join([, ]), 以及 #link("https://github.com/typst/codex", "typst/codex") 仓库创建以来的所有 PR.
]
