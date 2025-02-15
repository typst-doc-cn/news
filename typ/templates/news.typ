
#import "/typ/templates/html-toolkit.typ": *

/// Don't worry if you don't write a description. We can generate description automatically
/// by text exporting the content.
#let news-template(
  date: none,
  title: none,
  tags: (),
  description: none,
  content,
) = {
  set document(title: title, description: description)

  template({
    h1(class: "main-title", title)
    div(
      class: "news-prop",
      {
        "Published At: "
        date
        "  "
        "Tags: "
        tags.join(", ")
      },
    )
    content
  })
}
