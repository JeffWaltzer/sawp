(declare (unit scraper))
(use http-client)


(define-record cache-entry time page)
(define cache '())


(define (clear-page-cache)
  (set! cache '()))

(define (cache-data url accessor)
  (let ((cache-entry (alist-ref url cache string=?)))
	(and cache-entry (accessor cache-entry))))

(define (cached-time url)
  (cache-data url cache-entry-time))

(define (cached-page url)
  (cache-data url cache-entry-page))

(define (update-cache url page time)
  (set! cache
	(alist-update url
				  (make-cache-entry time page)
				  cache)))

(define cache-staleness-time 3600)

(define (cache-fresh url)
  (and
    (cached-time url)
    (<= (-
          (time->seconds (current-time))
          (time->seconds (cached-time url)))
      cache-staleness-time)))

(define (scrape url)
  (if (cache-fresh url)
    (begin
      (cached-page url))
    (begin
      (let ((fetched-copy
              (with-input-from-request url #f read-string)))
        (update-cache url fetched-copy (current-time))
        fetched-copy))))
