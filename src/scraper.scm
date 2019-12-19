(declare (unit scraper))
(use http-client)


(define-record cache-entry time page)
(define new-cache '())


(define (cached-time url)
  (let ((cache-entry (alist-ref url new-cache string=?)))
	(and cache-entry (cache-entry-time cache-entry))))

(define (cached-page url)
  (let ((cache-entry (alist-ref url new-cache string=?)))
	(and cache-entry (cache-entry-page cache-entry))))

;; ToDo: finish cleaning this up.
(define (update-cache url page time)
  (define (update-cache-alist alist x)
    (alist-update url x alist string=?))

  (define-syntax my-update
    (syntax-rules ()
      ((_ alist value)
        (set! alist (update-cache-alist alist value)))))

  (my-update new-cache (make-cache-entry time page)))

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

(define (clear-page-cache)
  (set! new-cache '()))
