(use html-tags)
(declare (unit templates))

(generate-sxml? #t)

(define (<scraper-controls>)
  (<form> method: "POST"
    (<label> "URL: ")
    (<input> name: "url" type: "text")

    (<br>)
    (<label> "XPath: ")
    (<input> name: "xpath" type: "text")

    (<br>)
    (<label> "Regex: ")
    (<input> name: "regex" type: "text")

    (<br>)
    (<label> "JSON index: ")
    (<input> name: "json-index" type: "text")

    (<br>)
    (<input> name: "submit" type: "submit")))

(define (<scrape-results> response-body)
    `(,(<scraper-controls>)
       ,(<hr>)
       ,(<code> response-body)))
