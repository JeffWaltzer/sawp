(use awful html-tags http-client)
(declare (uses scraper))
(declare (uses templates))

(generate-sxml? #t)

(define-page (main-page-path)
  <scraper-controls>
  method: '(GET HEAD))

(define-page (main-page-path)
  (lambda ()
	(<scrape-results> (scrape ($ 'url))))
  method: '(POST))
