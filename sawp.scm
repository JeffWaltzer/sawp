(use awful html-tags http-client)

(generate-sxml? #t)

(define (<scraper-controls>)
  (<form> method: "POST"
		  (<input> name: "url" type: "text")
		  (<input> name: "submit" type: "submit")))

(define (<scrape-results> url)
  (let ((response-body #f))
	(set! response-body
		  (with-input-from-request url #f read-string))
	`(,(<scraper-controls> )
	  ,(<hr>)
	  ,(<code> response-body))))


(define-page (main-page-path)
  <scraper-controls>
  method: '(GET HEAD))

(define-page (main-page-path)
  (lambda ()	(<scrape-results> ($ 'url)))
  method: '(POST))

