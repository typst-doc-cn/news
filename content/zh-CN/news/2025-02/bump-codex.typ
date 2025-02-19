
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-02-04",
  title: "PR #5805 Bump codex to 0.1.0",
  lang: "zh",
  region: "CN",
  tags: ("update",),
  description: "此 PR 升级了 Typst 使用的 codex 版本, 这是 Typst 的新符号记号库.",
)
#link("https://github.com/typst/codex", [codex]) 是 Typst 的新符号记号库, 用于给 Unicode 符号分配人类友好的记号. 从 0.13.0 版本开始, Typst 不再把符号的记号存储在主代码仓库中, 而是使用 codex 作为符号记号库.

这次更新引入了一些符号变动, 具体如下.


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
