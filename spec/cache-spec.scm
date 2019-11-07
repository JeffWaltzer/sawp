(use test http-client)
(declare (uses scraper templates))

(define passed-url #f)

(define (with-input-from-request url the-boolean read-procedure)
  (set! passed-url url))

(test-group "scraping a page which is not in the cache"
  (scrape "http://something.invalid")
  (test passed-url "http://something.invalid" )
)

(test-group "save time of caching"
  (scrape "http://something.invalid")
  (test (current-time) (cached-time passed-url) )
)

(test-group "scraping a page which is in the cache"
  (scrape "http://something.invalid")
  (set! passed-url #f)
  (scrape "http://something.invalid")
  (test #f passed-url  )
)
(exit)