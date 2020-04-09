(use awful)
(use alist-lib)

(declare (unit page-handlers)
         (uses scraper templates))

(define (debug #!rest args)
  (with-output-to-file "/dev/tty"
    (lambda () (apply printf args))))

(define saved-queries '())

(define (save-query name url xpath regex json-index)
  (alist-set! saved-queries (string->symbol name)
                `(,url ,xpath ,regex ,json-index)))


(define (main-page-get)
  (<scraper-controls>))

(define (main-page-post)
  (unless (string-null? ($ 'query-name))
    (save-query
     ($ 'query-name)
     ($ 'url)
     ($ 'xpath)
     ($ 'regex)
     ($ 'json-index as-list)))

  (<scrape-results> (scrape-element
                     ($ 'url)
                     ($ 'xpath)
                     ($ 'regex)
                     ($ 'json-index as-list)))

  )

