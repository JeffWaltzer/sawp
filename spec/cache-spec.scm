(use missbehave missbehave-stubs http-client)
(load "src/scraper")
(declare (uses scraper templates))


(describe "scraping a page which is not in the cache"
  (before #:each
	(clear-page-cache)
	(stub! with-input-from-request (lambda (url junk reader) "")))
  (after #:each
	(clear-stubs!))

  (it "scrapes the url"
	(expect ((lambda () (scrape "http://something.invalid")))
			(call with-input-from-request
				  (with "http://something.invalid" #f read-string)
				  once))))

(describe "scraping a page which is in the cache"
  (before #:each
	(stub! with-input-from-request (lambda (url junk reader) "")))

  (after #:each
	(clear-stubs!))

  (after #:each
	(clear-page-cache))

  (describe "foo"
	(before #:each
	  (scrape "http://something.invalid")
	  (set! passed-url #f))

	(it "doesn't do a HTTP request"
	  (expect ((lambda () (scrape "http://something.invalid")))
			  (call with-input-from-request never)))))


;; PENDING
;; (test-group "save time of caching"
;;   (scrape "http://something.invalid")
;;   (test (current-time) (cached-time passed-url) )
;; )
(describe "save time of caching"
  (define passed-url "http://something.invalid")

  (before #:each
	(stub! with-input-from-request (lambda (url junk reader) ""))
	(stub! current-time (lambda () 1))
	(scrape "http://something.invalid"))

  (after #:each
	(clear-stubs!))

  (it "saves the fetch time" 
	(expect(cached-time passed-url)
		   (be (current-time)))))


