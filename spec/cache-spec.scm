(use missbehave missbehave-stubs http-client)
(load "src/scraper")
(declare (uses scraper templates))


(describe "scraping a page"
  (before #:each
	(clear-page-cache)
	(stub! with-input-from-request (lambda (url junk reader) "")))

  (after #:each
	(clear-page-cache)
	(clear-stubs!))

  (describe "which is not in the cache"

		(it "does a HTTP request"
	  (expect ((lambda () (scrape "http://something.invalid")))
			  (call with-input-from-request
					(with "http://something.invalid" #f read-string)
					once))))

	(describe "which is in the cache"
	  (before #:each
		(scrape "http://something.invalid"))

		(it "doesn't do a HTTP request"
			(expect ((lambda () (scrape "http://something.invalid")))
				(call with-input-from-request never))))

  (describe "when caching"
		(define passed-url "http://something.invalid")

		(before #:each
			(stub! current-time (lambda () 1))
			(scrape "http://something.invalid"))

		(it "saves the fetch time"
			(expect (cached-time passed-url)
				(be (current-time))))))

