(use missbehave missbehave-stubs http-client)
(load "src/scraper")
(declare (uses scraper templates))

(describe "scraping a page"
  (define passed-url "http://something.invalid")
  (before #:each
    (clear-page-cache)
    (stub! with-input-from-request (lambda (url junk reader) "")))

  (after #:each
    (clear-page-cache)
    (clear-stubs!))

  (describe "which is not in the cache"
    (it "saves the page body"
	  (stub! with-input-from-request (lambda (url junk reader)
									   "some fake body"))
	  (scrape passed-url)
	  (expect (cached-page passed-url)
					  (be "some fake body")))

    (it "saves the fetch time"
      (stub! current-time (lambda () 1))
      (scrape passed-url)
      (expect (cached-time passed-url)
        (be (current-time))))

    (it "does a HTTP request"
      (expect ((lambda () (scrape passed-url)))
        (call with-input-from-request
          (with passed-url #f read-string)
          once))))

  (describe "which is in the cache"
    (before #:each
      (scrape passed-url))

    (it "doesn't do a HTTP request"
      (expect ((lambda () (scrape passed-url)))
        (call with-input-from-request never))))

)
