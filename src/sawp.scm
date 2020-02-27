(use awful http-client)
(declare (uses scraper templates))

(define-page (main-page-path)
  <scraper-controls>
  method: '(GET HEAD))

(define-page (main-page-path)
  (lambda ()
	(<scrape-results> (scrape-element ($ 'url) ($ 'xpath) ($ 'regex) ($ 'json-index as-list))))
  method: '(POST))

(awful-start (lambda () #t)  dev-mode?: #t)
