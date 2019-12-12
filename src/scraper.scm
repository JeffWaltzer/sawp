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
  (debug "(update-cache ~S ~S ~S)~%" url page time)
  (debug "update-cache: page-cache: ~S)~%" page-cache)

  (define (update-cache-alist alist x)
	(alist-update url x alist string=?))

  (define-syntax my-update
	(syntax-rules ()
	  ((_ alist value)
	   (set! alist (update-cache-alist alist value)))))

  (my-update page-cache page)
  (my-update time-cache time)
  (debug "update-cache: page-cache: ~S)~%" page-cache))

(define cache-staleness-time 3600) 

(define (debug . stuff)
  (with-output-to-file "/dev/tty"
	(lambda () (apply printf stuff))))

(define (cache-fresh url)
  ;; (debug "(cache-fresh ~S)~%" url)
  ;; (debug "(current-time): ~S~%" (current-time))
  ;; (if (current-time)
  ;; 	  (debug "(current-time): ~S~%" (time->seconds (current-time))))

  (and
   (cached-time url)
   (<= (- (time->seconds (current-time))
		  (time->seconds (cached-time url)))
	   cache-staleness-time)))

(define (scrape url)
  (if (cache-fresh url)
	  (begin
		(debug "scrape: returning cached page: ~S~%" (cached-page url))
		(cached-page url))
	  (begin
		(debug "scrape: doing fetch~%")
		(let ((fetched-copy
			   (with-input-from-request url #f read-string)))
		  (debug "scrape: fetched-copy: ~S~%" fetched-copy)
		  (update-cache url fetched-copy (current-time))
		  fetched-copy))))

(define (clear-page-cache)
  (set! page-cache '()))
