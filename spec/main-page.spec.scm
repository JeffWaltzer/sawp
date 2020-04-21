(use missbehave-stubs)
(use awful)

(describe "the main page"
  (before #:each
    (stub! $ (lambda (request-parameter #!optional converter)
               (string-append
                "the-"
                (symbol->string request-parameter))))
    (stub! scrape-element (returns "something or other"))
    (stub! <scrape-results> (returns (void)))
    (stub! save-query (returns (void))))

  (after #:each
    (clear-stubs!))

  (it "saves the query"
    (expect (main-page-post)
            (call save-query (with "the-query-name" "the-url" "the-xpath" "the-regex" "the-json-index") once))))
