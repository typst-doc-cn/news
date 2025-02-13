
#import "mod.typ": *

#show: template

#main-title[
  Broadsheet
][
  The recent changes about typst.
]

#news-list({
  news-item("2021-09-01", "PR #5779 Modular, multi-threaded, transitioning plugins", ("pr",))[
    This PR adds changes about the WASM plugins to allow fork state of plugin by calling mutable plugin functions.
  ]
  news-item("2021-09-01", "PR #5773 Resolve bound name of bare import statically", ("pr",))[
    This PR forbids inwarranted dynamic imports, making imported names of modules determined at syntax stage.
  ]
})

An equation:

$
  integral f(x) dif x
$

An equation that is scrolled horizontally:

$
  integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x integral f(x) dif x
$
