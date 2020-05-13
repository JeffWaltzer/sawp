(use missbehave-stubs)

(describe "queries"
  (describe "when there are no saved queries"
    (it "returns an empty list of queries"
      (expect (queries)
        (be
            `(,(<h3> "Queries")
               ,(<ul>))))))

  (describe "when there is one saved query"
    (before #:each
      (save-query "first one" "/yahoo.com" "//body" "[A-Z]+" 0))

    (after #:each (clear-queries))

    (it "returns an empty list of queries"
      (expect (queries)
        (be
            `(,(<h3> "Queries")
               ,(<ul>
                  (<li> (<a> #:href "/yahoo.com" "first one"))
                )))))))
