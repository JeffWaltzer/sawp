(use html-parser)
(use txpath)
(declare (unit scraper))
(declare (uses cache))
(use http-client)

(define (scrape-n-cache url)
  (update-cache url
				(with-input-from-request url #f read-string)
				(current-time)))

(define (scrape url)
  (if (cache-fresh url)
      (cached-page url)
      (scrape-n-cache url)))

(define (scrape-element url xpath)
  (cadar ((txpath xpath)
		  (html->sxml (scrape url)))))
