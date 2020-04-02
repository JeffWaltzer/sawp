(use awful)
(declare (unit page-handlers)
         (uses scraper templates))

(define (save-query url xpath regex json-index)
  (void))

(define (main-page-get)
  (<scraper-controls>))

(define (main-page-post)
  (unless (string-null? ($ 'query-name))
    (save-query ($ 'url) ($ 'xpath) ($ 'regex) ($ 'json-index as-list)))

  (<scrape-results> (scrape-element ($ 'url) ($ 'xpath) ($ 'regex) ($ 'json-index as-list))))
