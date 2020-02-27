(use missbehave missbehave-stubs)
(declare (uses scraper))

(describe "scraping the contents of an html/xml element specified by xpath and regex"
  (define passed-url "junk")
  (define passed-xpath "//joe")
  (define passed-regex "\\[(.*)\\]")
  (define passed-json '(""))

  (define (scrape-stub url)
    "<html><head></head><body><joe>[joe-stuff]</joe></body></html>")

  (before #:each
    (stub! scrape scrape-stub))

  (after #:each
    (clear-stubs!))

  (it "returns the requested text"
    (expect
      (scrape-element passed-url passed-xpath passed-regex passed-json)
      (be "joe-stuff"))))

(describe "scraping the contents of an html/xml element specified by xpath regex, and JSON indices"
  (define passed-url "junk")
  (define passed-xpath "//joe")
  (define passed-regex "\\[(.*)\\]")
  (define passed-json-indices '("some-key"))

  (define (scrape-stub url)
    "<html><head></head><body><joe>[{\"some-key\" : \"some-value\"}]</joe></body></html>")

  (before #:each
    (stub! scrape scrape-stub))

  (after #:each
    (clear-stubs!))

  (it "returns the requested text"
    (expect
      (scrape-element passed-url passed-xpath passed-regex passed-json-indices)
      (be "some-value"))))


(describe "extract data from a JSON object"
  (define passed-json "{\"the-key\" : \"the-data\"}")

  (define expected-value "the-data")

  (it "returns the expected text"
    (expect
      (extract-by-json passed-json '(the-key))
      (be "the-data"))))

(describe "return #f if key is missing from a JSON object"
  (define passed-json "{\"the-key\" : \"the-data\"}")

  (it "returns #f"
    (expect
      (extract-by-json passed-json '(wrong-key))
      (be #f))))

(describe "return #f if index is out of bounds for a JSON array"
  (define passed-json "[\"first-element\"]")

  (it "returns #f"
    (expect
      (extract-by-json passed-json '(1))
      (be #f))))


(describe "extract data from nested JSON"
  (define passed-json "{\"top-key\" : {\"inner-key\": \"buried-data\"}}")

  (define expected-value "buried-data")

  (it "returns the expected text"
    (expect
      (extract-by-json passed-json '(top-key inner-key))
      (be "buried-data"))))


(describe "extract data from JSON array"
  (define passed-json "[\"first-data\", \"second-data\"]")

  (define expected-value "second-data")

  (it "returns the expected text"
    (expect
      (extract-by-json passed-json '(1))
      (be "second-data"))))


(describe "extract data from a JSON array inside an object"
  (define passed-json "{\"top-key\" : [\"first-data\", \"second-data\"]}")

  (define expected-value "second-data")

  (it "returns the expected text"
    (expect
      (extract-by-json passed-json '(top-key 1))
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
