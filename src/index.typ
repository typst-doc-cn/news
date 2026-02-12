#import "/typ/route.typ": news-url

#let js = ```javascript
document.addEventListener("DOMContentLoaded", function() {
  let lang = window.navigator.userLanguage || window.navigator.language;
  if (lang.startsWith("zh")) {
    window.location.href = `{{index.zh-CN}}`;
  } else {
    window.location.href = `{{index.en}}`;
  }
});
```.text

#html.elem(
  "html",
  attrs: (
    "lang": "en",
    "xmlns": "http://www.w3.org/1999/xhtml",
  ),
  {
    html.head(
      html.script(
        js
          .replace("{{index.zh-CN}}", news-url("/content/index.zh-CN.typ"))
          .replace("{{index.en}}", news-url("/content/index.en.typ")),
      ),
    )
    html.body(html.h1("Redirecting..."))
  },
)
