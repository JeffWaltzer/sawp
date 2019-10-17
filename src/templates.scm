(use html-tags)
(declare (unit templates))
(generate-sxml? #t)

(define (<scraper-controls>)
  (<form> method: "POST"
    (<input> name: "url" type: "text")
    (<input> name: "submit" type: "submit")))

(define (<scrape-results> response-body)
    `(,(<scraper-controls> )
       ,(<hr>)
       ,(<code> response-body)))