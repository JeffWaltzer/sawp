(use missbehave http-client)
(declare (uses scraper templates))

(printf "scrape: ~A~%" scrape)

(describe "scraping a page which is not in the cache"
  (it "calls with-input-from-request"
    (expect (scrape "http://something.invalid")
			(call with-input-from-request once))))
