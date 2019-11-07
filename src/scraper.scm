(declare (unit scraper))
(use http-client)

(define cache '()
)

(define (cached-time url) 10000)

(define (scrape url)
  (or (alist-ref url cache string=?)
    (let ((fetched-copy
            (with-input-from-request url #f read-string)))
      (set! cache (alist-update url fetched-copy cache string=?))
      fetched-copy
    )
  )
)
