/// 将中文社区导航、教程、文档等站点的链接替换为镜像。
///
/// 镜像列表 MIRROR REGISTRY 需与导航站同步更新。
/// https://typst.dev/guide/dev/mirror-link.html
/// https://github.com/typst-doc-cn/guide/blob/master/docs/.vitepress/plugins/mirror_link.ts

// `default` is mandatory, others are optional.
#let _MIRROR_REGISTRY = (
  (
    default: "https://typst-doc-cn.github.io/guide/",
    cloudflare: "https://guide.typst.dev/",
    vercel: "https://typst.dev/guide/",
    netlify: "https://luxury-mochi-9269a9.netlify.app/",
  ),
  (
    default: "https://typst-doc-cn.github.io/tutorial/",
    cloudflare: "https://tutorial.typst.dev/",
    vercel: "https://typst.dev/tutorial/",
  ),
  (
    default: "https://typst-doc-cn.github.io/docs/",
    cloudflare: "https://docs.typst.dev/",
    vercel: "https://typst.dev/docs/",
  ),
  (
    default: "https://typst-doc-cn.github.io/news/",
    cloudflare: "https://news.typst.dev/",
    vercel: "https://typst.dev/news/",
  ),
  (
    default: "https://typst-doc-cn.github.io/clreq/",
    netlify: "https://gap.zhtyp.art/",
  ),
)

#let _check-profile(profile) = assert(
  profile in ("default", "cloudflare", "vercel", "netlify"),
  message: "unknown profile for mirror-link: " + profile,
)


/// Transform a given URL. Returns `none` if unchanged.
#let _transform(url, profile: "default") = {
  for mirror in _MIRROR_REGISTRY {
    if profile != "default" and profile in mirror {
      if url.starts-with(mirror.default) {
        return mirror.at(profile) + url.trim(mirror.default, at: start)
      }
    }
    if url == mirror.default.slice(0, mirror.default.len() - 1) {
      // This warning should always be shown, regardless of the profile.
      panic(
        "Only links with trailing slashes can be replaced with a mirror, but found {url}. Please add a trailing slash.".replace(
          "{url}",
          url,
        ),
      )
    }
  }
  return none
}

#{
  assert.eq(
    _transform("https://typst-doc-cn.github.io/guide/FAQ/equation-chinese-font.html#typst-0-14", profile: "cloudflare"),
    "https://guide.typst.dev/FAQ/equation-chinese-font.html#typst-0-14",
  )
  assert.eq(
    _transform("https://typst-doc-cn.github.io/guide/", profile: "cloudflare"),
    "https://guide.typst.dev/",
  )
  assert.eq(
    _transform("https://typst-doc-cn.github.io/guide/", profile: "vercel"),
    "https://typst.dev/guide/",
  )
  assert.eq(
    _transform("https://github.com/typst/typst/issues/5512", profile: "vercel"),
    none,
  )
}

/// A show rule to transform links to the mirror selected via the profile.
///
/// Example usage: `show: mirror-link.with(profile: "vercel")`
#let mirror-link(body, profile: "default") = {
  _check-profile(profile)

  show link: it => {
    if type(it.dest) != str {
      // Skip in-page links
      return it
    }

    let mirrored = _transform(it.dest, profile: profile)
    if mirrored == none {
      return it
    }

    html.a(href: mirrored, it.body)
  }
  body
}
