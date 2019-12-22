(use missbehave-stubs http-client)

(define some-url "http://something-invalid")

(define (preload-into-cache url)
  (stub! with-input-from-request (returns #t))
  (scrape url)
  (clear-stubs!))


(describe "scraping a page which is not in the cache"
  (before #:each
	(load "src/scraper.scm")
	(stub! with-input-from-request (returns #t)))

  (it "calls with-input-from-request"
	(expect (scrape some-url)
			(call with-input-from-request once))))

(describe "scraping a page which is in the cache"
  (before #:each
	(load "src/scraper.scm")
	(preload-into-cache some-url)
	(stub! with-input-from-request (returns #t)))

  (it "does not call with-input-from-request"
	(expect (scrape some-url)
			(call with-input-from-request never))))

(describe "save time of caching"
  (before #:each
	(load "src/scraper.scm")
	(stub! with-input-from-request (returns #t)))

  (it "saves the time"
	  (scrape "http://something.invalid")
	  (expect (cached-time passed-url)
			  (current-time))))
