(use missbehave-stubs)

(describe "queries"
  (describe "when there are no saved queries"
    (it "returns an empty list of queries"
      (expect (queries)
        (be
            `(,(<h3> "Queries")
               ,(<ul>))))))

  (describe "when there is one saved query"
    (define query-run-path "/queries/first%20one/result")

    (before #:each
      (save-query "first one" "/yahoo.com" "//body" "[A-Z]+" 0))

    (after #:each (clear-queries))

    (it "returns a list of the queries"
      (expect (queries)
        (be
            `(,(<h3> "Queries")
               ,(<ul>
                  (<li> (<a> #:href query-run-path "first one"))) ))))

    (describe "hitting the query's run endpoint"
      (it "runs the query")) ) )
