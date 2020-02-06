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


(describe "extract data from JSON"
  (define passed-json "{\"the-key\" : \"the-data\"}")

  (define expected-value "the-data")

  (it "returns the expected text"
    (expect
      (extract-by-json '(the-key) passed-json)
      (be "the-data"))))


(describe "extract data from different JSON"
  (define passed-json "{\"another-key\": \"some-more-data\"}")

  (define expected-value "some-more-data")

  (it "returns the expected text"
    (expect
      (extract-by-json '(another-key) passed-json)
      (be "some-more-data"))))

(describe "extract data from nested JSON"
  (define passed-json "{\"top-key\" : {\"inner-key\": \"buried-data\"}}")

  (define expected-value "buried-data")

  (it "returns the expected text"
    (expect
      (extract-by-json '(top-key inner-key) passed-json)
      (be "buried-data"))))


(describe "extract data from JSON array"
  (define passed-json "{\"top-key\" : [\"first-data\", \"second-data\"]}")

  (define expected-value "second-data")

  (it "returns the expected text"
    (expect
      (extract-by-json '(top-key 1) passed-json)
      (be "second-data"))))


(describe "extract data by regex"
  (define passed-regex "\\[(.*)\\]")

  (define text
    "[joe-stuff]")

  (it "returns the requested text"
    (expect
      (extract-by-regex text passed-regex)
      (be "joe-stuff"))))

(describe "extract data by xpath"
  (define xpath "//joe")
  (define html-text
    "<html><head></head><body><joe>joe-stuff</joe></body></html>")

  (it "returns the requested text"
    (expect
      (extract-by-xpath html-text xpath)
      (be "joe-stuff"))))
