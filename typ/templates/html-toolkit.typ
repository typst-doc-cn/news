#let bootstrap = html.elem(
  "link",
  attrs: (
    "rel": "stylesheet",
    "href": "https://cdn.bootcss.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css",
  ),
);

#let load-html-template(template-path, content) = html.elem(
  "html",
  attrs: (
    "lang": "en",
    "xmlns": "http://www.w3.org/1999/xhtml",
  ),
  {
    html.elem(
      "head",
      {
        bootstrap
      },
    )
    html.elem("body", content)
  },
)
