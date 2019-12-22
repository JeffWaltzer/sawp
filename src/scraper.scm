(declare (unit scraper))
(use http-client)

(define cache '())

(define (scrape url)
  (or (alist-ref url cache string=?)
	  (let ((fetched-copy
			 (with-input-from-request url #f read-string)))
		(set! cache (alist-update url fetched-copy cache string=?))
		fetched-copy)))

(define (cached-time url) #f)
