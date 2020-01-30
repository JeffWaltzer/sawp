(use missbehave missbehave-stubs)
(declare (uses scraper))

(describe "scraping the contents of an html/xml element specified by xpath and regex"
  (define passed-url "junk")
  (define passed-xpath "//joe")
  (define passed-regex "\\[(.*)\\]")

  (define (scrape-stub url)
	"<html><head></head><body><joe>[joe-stuff]</joe></body></html>")

  (before #:each
	(stub! scrape scrape-stub))

  (after #:each
	(clear-stubs!))

  (it "returns the requested text"
	(expect
	 (scrape-element passed-url passed-xpath passed-regex)
	 (be "joe-stuff"))))
