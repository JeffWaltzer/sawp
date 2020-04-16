(use missbehave-stubs)

(define (debug #!rest args)
  (with-output-to-file "/dev/tty"
    (lambda () (apply printf args))))

(describe "the main page"
  (before #:each
    (stub! $ (lambda (request-parameter #!optional converter)
               (debug "~%got here~%")
               (string-append
                "the-"
                (symbol->string request-parameter))))
    (stub! scrape-element (returns "something or other"))
    (stub! <scrape-results> (returns (void))))

  (after #:each
    (clear-stubs!))

  (it "something"
    (expect (main-page-post)
            (call save-query (with "the-url" "the-xpath" "the-regex" "the-json-index") once))))
