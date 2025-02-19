#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-01-08",
  title: "PR #5221 Embed files associated with the document as a whole",
  lang: "en",
  tags: ("pr",),
  description: "This PR implements file embedding in PDF output without visible annotations",
)

Implemented file embedding functionality in PDF output without visible annotations.

#_exp(
  ```typ
  The following code will embed attachments in the PDF.
  #pdf.embed("hello.txt")

  Multiple parameters can be manually configured.
  #pdf.embed("changelog.typ", description: "Source code of this document.", mime-type: "text/plain", relationship: "source")

  You can also insert from `bytes` with a custom filename.
  #let data = read("hello.txt", encoding: none)
  #pdf.embed("hello2.txt", data)
  ```,
  [],
)
