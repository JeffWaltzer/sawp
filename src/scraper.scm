(declare (unit scraper))
(use http-client)

(define page-cache '()
)

(define time-cache '()
)

(define (cached-time url)
  (alist-ref url time-cache string=?))

(define (scrape url)
  (or (alist-ref url page-cache string=?)
    (let ((fetched-copy
            (with-input-from-request url #f read-string)))
      (set! page-cache (alist-update url fetched-copy page-cache string=?))
	  (set! time-cache (alist-update url (current-time) time-cache string=?))
      fetched-copy)))

(define (clear-page-cache)
  (set! page-cache '()))
