(use missbehave missbehave-stubs http-client)
(load "src/scraper")
(declare (uses scraper templates))

(describe "scraping a page"
  (define passed-url "http://something.invalid")
  (before #:each
    (clear-page-cache)
    (stub! with-input-from-request (lambda (url junk reader) "")))

  (after #:each
    (clear-stubs!))

  (describe "which is not in the cache"
    (before #:each
      (clear-stubs!)
      (clear-page-cache))

    (it "saves the page body"
      (stub! with-input-from-request (lambda (url junk reader)
                                       "some fake body"))

      (scrape passed-url)


      (expect (cached-page passed-url)
        (be "some fake body")))

    (it "saves the fetch time"
      (clear-page-cache)
      (stub! with-input-from-request (lambda (url junk reader)
                                       "some fake body"))
      (stub! current-time (lambda () (seconds->time 10000)))
      (scrape passed-url)
      (expect (cached-time passed-url)
        (be (current-time))))

    (it "does a HTTP request"
      (clear-page-cache)
      (stub! with-input-from-request (lambda (url junk reader)
                                       "some fake body"))
      (expect ((lambda () (scrape passed-url)))
        (call with-input-from-request
          (with passed-url #f read-string)
          once))))

  (describe "which is in the cache and not expired"
    (before #:each
      (clear-page-cache)
      (scrape passed-url))

    (it "doesn't do a HTTP request"
      (expect ((lambda () (scrape passed-url)))
        (call with-input-from-request never))))

  (describe "which is in the cache but expired"
    (define cache-timeout 3600)

    (before #:each
      (clear-page-cache)
      (update-cache "a-url"
        "page body"
        (seconds->time (- (time->seconds (current-time))
                         (+ 1 cache-timeout)))))
    (it "does a new HTTP request"
      (expect ((lambda () (scrape "a-url")))
        (call with-input-from-request
          (with "a-url" #f read-string)
          once)))))
