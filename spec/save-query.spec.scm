(describe "Saving a query"
  (before #:each
    (save-query "first-query"
                "the-url"
                "the-xpath"
                "the-regex"
                "the-json-index"))


  (it "saves query"
    (expect saved-queries
            (be '((first-query . ("the-url"
                                  "the-xpath"
                                  "the-regex"
                                  "the-json-index"))))))
  )
