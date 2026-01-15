#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-02-04",
  title: "PR #5805 Bump codex to 0.1.0",
  lang: "en",
  tags: ("update",),
  description: "This PR updates the codex version used by Typst, which is Typst's new symbol notation library.",
)

#link("https://github.com/typst/codex", [codex]) is Typst's new symbol notation library, used to assign human-friendly notations to Unicode symbols. Starting from version 0.13.0, Typst no longer stores symbol notations in the main repository but uses codex as its symbol notation library.

This update introduces several symbol changes, as detailed below.


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
  ..("Type", "Code", "Symbol") * new-symbols-col,
  ..new-symbols
    .map(x => {
      if (x.starts-with("+")) {
        let code = x.slice(1)
        return ("Add", raw(code, lang: "typ"), eval(code))
      } else if (x.starts-with("-")) {
        let (old, new) = x.slice(1).split("|")
        return ("Remove", raw(old, lang: "typ"), eval(new))
      } else if (x.starts-with("*")) {
        let (old, new) = x.slice(1).split("|")
        return (
          "Change",
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
