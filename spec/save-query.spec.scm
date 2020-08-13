(describe "Saving a query"
  (before #:each
    (save-query "first-query"
                "the-url"
                "the-xpath"
                "the-regex"
                "the-json-index"))

  (after #:each (clear-queries))

  (it "saves query"
    (expect saved-queries
            (be `((first-query . ,(make-query "the-url"
                                              "the-xpath"
                                              "the-regex"
                                              "the-json-index")))))))
