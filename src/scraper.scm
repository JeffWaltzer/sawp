(declare (unit scraper))
(use http-client)

(define (scrape url)
	(with-input-from-request url #f read-string))
