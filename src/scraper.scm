(declare (unit scraper))
(use http-client)

(define page-cache '()
)

(define time-cache '()
)

(define (cached-time url)
  (alist-ref url time-cache string=?))

(define (cached-page url)
  (alist-ref url page-cache string=?))

;; ToDo: finish cleaning this up.
(define (update-cache url page time)
  (define (update-cache-alist alist x)
	(alist-update url x alist string=?))

  (define-syntax my-update
	(syntax-rules ()
	  ((_ alist value)
	   (set! alist (update-cache-alist alist value)))))

  (my-update page-cache page)
  (my-update time-cache time))

(define (scrape url)
  (or (alist-ref url page-cache string=?)
    (let ((fetched-copy
		   (with-input-from-request url #f read-string)))
	  (update-cache url fetched-copy (current-time))
      fetched-copy)))

(define (clear-page-cache)
  (set! page-cache '()))
