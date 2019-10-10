(use awful html-tags http-client)

(load "scraper")

(generate-sxml? #t)

(define (<scraper-controls>)
  (<form> method: "POST"
		  (<input> name: "url" type: "text")
		  (<input> name: "submit" type: "submit")))

(define (<scrape-results> response-body)
  `(,(<scraper-controls> )
	,(<hr>)
	,(<code> response-body)))


(define-page (main-page-path)
  <scraper-controls>
  method: '(GET HEAD))

(define-page (main-page-path)
  (lambda ()
	(<scrape-results> (scrape ($ 'url))))
  method: '(POST))
