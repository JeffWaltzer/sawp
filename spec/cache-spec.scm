(use missbehave missbehave-stubs http-client)
(declare (uses scraper templates))

(define expected-page-body (make-parameter "some fake body"))
(define expected-cache-timeout (make-parameter 3600))


(define (with-input-from-request-stub url junk reader) (expected-page-body))
(define (current-time-stub) (seconds->time 10000))

(describe "scraping a page"
  (define passed-url "http://something.invalid")
  (before #:each
    (stub! with-input-from-request with-input-from-request-stub)
    (stub! current-time current-time-stub)
    (scrape passed-url))

  (after #:each
    (clear-page-cache)
    (clear-stubs!))

  (describe "which is not in the cache"
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
    (it "doesn't do a HTTP request"
      (expect (scrape passed-url)
              (call with-input-from-request never))))

  (describe "which is in the cache but expired"
    (before #:each
      (define just-stale-time
        (seconds->time (- (time->seconds (current-time))
                          (+ 1 (expected-cache-timeout)))))

      (update-cache "a-url" "page body" just-stale-time))

    (it "does a new HTTP request"
      (expect (scrape "a-url")
              (call with-input-from-request
                    (with "a-url" #f read-string)
                    once)))))
