#let js = ```javascript
document.addEventListener("DOMContentLoaded", function() {
  let prefix = window.location.pathname;
  if (prefix.endsWith("index.html")) {
    prefix = prefix.slice(0, -10);
  }
  if (prefix.endsWith("/")) {
    prefix = prefix.slice(0, -1);
  }
  let lang = window.navigator.userLanguage || window.navigator.language;
  if (lang.startsWith("en")) {
    window.location.href = `${prefix}/en/`;
  } else {
    window.location.href = `${prefix}/${lang}/`;
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
        html.elem("script", js.text)
      },
    )
    html.elem("body", html.elem("h1", "Redirecting..."))
  },
)
