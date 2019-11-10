(use missbehave-stubs http-client)

(describe "scraping a page which is not in the cache"
  (before #:each
	(load "src/scraper.scm")
	(stub! with-input-from-request (returns #t)))

  (it "calls with-input-from-request"
    (expect (scrape "http://something.invalid")
			(call with-input-from-request once))))
