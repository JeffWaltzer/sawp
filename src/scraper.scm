(use html-parser)
(use txpath)
(declare (unit scraper))
(declare (uses cache))
(use http-client)

(define (scrape-n-cache url)
  (update-cache url
    (with-input-from-request url #f read-string)
    (current-time)))

(define (scrape url)
  (if (cache-fresh url)
    (cached-page url)
    (scrape-n-cache url)))

(define (extract-by-xpath html-text xpath)
  (cadar ((txpath xpath)
           (html->sxml html-text))))

(define (extract-by-regex text regex)
  (irregex-match-substring
    (irregex-search
      (irregex regex)
      text)
    1))

(define (scrape-element url xpath regex)
  (extract-by-regex
    (extract-by-xpath
      (scrape url)
      xpath)
    regex))
