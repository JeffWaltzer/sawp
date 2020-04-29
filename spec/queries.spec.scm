(use missbehave-stubs)

(describe "queries"
  (describe "when there are no saved queries"
    (it "returns an empty list of queries"
      (expect (queries)
              (be
               `(,(<h3> "Queries")
                 ,(<ul>)))))))
