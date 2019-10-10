(define (scrape url)
	(with-input-from-request url #f read-string))
