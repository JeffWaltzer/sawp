(use missbehave missbehave-stubs http-client)
(load "src/scraper")
(declare (uses scraper templates))

(describe "scraping a page"
  (define passed-url "http://something.invalid")
  (before #:each
    (stub! with-input-from-request (lambda (url junk reader) "")))

  (after #:each
    (clear-page-cache)
    (clear-stubs!))

  (describe "which is not in the cache"
	(before #:each
      (stub! with-input-from-request (lambda (url junk reader)
                                       "some fake body"))
      (stub! current-time (lambda () (seconds->time 10000)))

      (scrape passed-url))

    (it "saves the page body"
      (expect (cached-page passed-url)
			  (be "some fake body")))

    (it "saves the fetch time"
      (expect (cached-time passed-url)
			  (be (current-time))))

    (it "does a HTTP request"
	  (clear-page-cache)
	  (expect (scrape passed-url)
			  (call with-input-from-request
					(with passed-url #f read-string)
					once))))

  (describe "which is in the cache and not expired"
    (before #:each
      (scrape passed-url))

    (it "doesn't do a HTTP request"
      (expect ((lambda () (scrape passed-url)))
			  (call with-input-from-request never))))

  (describe "which is in the cache but expired"
    (define expected-cache-timeout 3600)

    (before #:each
      (update-cache "a-url"
					"page body"
					(seconds->time (- (time->seconds (current-time))
									  (+ 1 expected-cache-timeout)))))
    (it "does a new HTTP request"
      (expect (scrape "a-url")
			  (call with-input-from-request
					(with "a-url" #f read-string)
					once)))))
