(use awful)
(use alist-lib)
(use html-tags)
(use uri-common)

(declare (unit page-handlers)
  (uses scraper templates))

(define (debug #!rest args)
  (with-output-to-file "/dev/tty"
    (lambda () (apply printf args))))

(define saved-queries '())

(define (save-query name url xpath regex json-index)
  (alist-set! saved-queries
              (string->symbol name)
              `(,url ,xpath ,regex ,json-index)))

(define (clear-queries)
  (set! saved-queries '()))

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
                      ($ 'json-index as-list))))

(define (queries)
    `(,(<h3> "Queries") ,(apply <ul>
                           (map (lambda (saved-query)
                                  (let ((query-name
                                         (symbol->string (car saved-query))))

                                    (<li> (<a> #:href (string-append "/queries/"
                                                                     (uri-encode-string query-name)
                                                                     "/result")
                                               query-name))))
                                saved-queries))))

(define (run-query #!rest args)
  (debug "run-query: args: ~S~%" args)
  #f)
