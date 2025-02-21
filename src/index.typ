#import "/typ/packages/html-toolkit.typ": url-base

#let js = ```javascript
document.addEventListener("DOMContentLoaded", function() {
  let lang = window.navigator.userLanguage || window.navigator.language;
  if (lang.startsWith("en")) {
    window.location.href = `{{prefix}}en/`;
  } else {
    window.location.href = `{{prefix}}${lang}/`;
  }
});
```

#html.elem(
  "html",
  attrs: (
    "lang": "en",
    "xmlns": "http://www.w3.org/1999/xhtml",
  ),
  {
    html.elem(
      "head",
      {
        html.elem("script", js.text.replace("{{prefix}}", url-base))
      },
    )
    html.elem("body", html.elem("h1", "Redirecting..."))
  },
)
