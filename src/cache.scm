(declare (unit cache))

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
				  cache))
  page)

(define cache-staleness-time 3600)

(define (cache-age url)
  (-
   (time->seconds (current-time))
   (time->seconds (cached-time url))))

(define (cache-fresh url)
  (and
    (cached-time url)
    (<= (cache-age url)
		cache-staleness-time)))
