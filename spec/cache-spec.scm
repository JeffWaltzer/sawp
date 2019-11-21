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

	(it "scrapes the url"
	  (expect ((lambda () (scrape "http://something.invalid")))
			  (call with-input-from-request
					(with "http://something.invalid" #f read-string)
					once))))

  (describe "scraping a page which is in the cache"
	(describe "foo"
	  (before #:each
		(scrape "http://something.invalid"))

	  (it "doesn't do a HTTP request"
		(expect ((lambda () (scrape "http://something.invalid")))
				(call with-input-from-request never)))))

  (describe "save time of caching"
	(define passed-url "http://something.invalid")

	(before #:each
	  (stub! current-time (lambda () 1))
	  (scrape "http://something.invalid"))

	(it "saves the fetch time" 
	  (expect(cached-time passed-url)
			 (be (current-time))))))


