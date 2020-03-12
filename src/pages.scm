(declare (unit pages)
		 (uses scraper templates))
(use awful)

(define (create-pages)
  (define-page (main-page-path)
	<scraper-controls>
	method: '(GET HEAD))

  (define-page (main-page-path)
	(lambda ()
	  (<scrape-results> (scrape-element ($ 'url) ($ 'xpath) ($ 'regex) ($ 'json-index as-list))))
	method: '(POST)))
