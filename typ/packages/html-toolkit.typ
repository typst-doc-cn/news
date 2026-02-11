/// = HTML Toolkit
///
/// This package provides a set of utility functions for working with HTML export.


#import "supports-text.typ": plain-text
#import "/typ/route.typ": asset-url

/// Converts the xml loaded data to HTML.
///
/// - data (dict): The data to convert to HTML.
/// -> content
#let to-html(data) = {
  if type(data) == str {
    let data = data.trim()
    if data.len() > 0 {
      data
    }
  } else {
    let rewrite(data, attr) = {
      let value = data.attrs.at(attr, default: none)
      if value != none and value.starts-with("/") {
        data.attrs.at(attr) = asset-url(value)
      }

      data
    }

    data = rewrite(data, "href")
    data = rewrite(data, "src")

    html.elem(
      data.tag,
      attrs: data.attrs,
      data.children.map(to-html).join(),
    )
  }
}

/// Loads the HTML template and inserts the content.
///
/// - template-path (str): The absolute path to the HTML template.
/// - content (content): The body to insert into the template.
/// - extra-head (content): Additional content to insert into the head.
/// ->
#let load-html-template(template-path, content, extra-head: none) = {
  let head-data = xml(template-path).at(0).children.at(1)
  let head = to-html(head-data).body

  html.elem(
    "html",
    attrs: (
      "lang": "en",
      "xmlns": "http://www.w3.org/1999/xhtml",
    ),
    {
      html.head({
        head
        extra-head
        context if document.description != none {
          html.meta(name: "description", content: plain-text(document.description))
        }
      })
      html.body(content)
    },
  )
}

/// Creates a preload link for the given CSS file.
///
/// - href (str): The URL of the CSS file.
/// -> content
#let preload-css(href) = to-html(
  xml(
    bytes(
      ```xml
      <link
      rel="preload"
      as="style"
      href="{{href}}"
      onload="this.rel='stylesheet'"
      />
      ```
        .text
        .replace("{{href}}", href),
    ),
  ).at(0),
)

/// Creates an embedded block typst frame.
#let div-frame(content, ..attrs) = html.div(html.frame(content), ..attrs)
