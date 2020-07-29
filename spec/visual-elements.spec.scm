(use sxml-serializer)

(describe "the saved queries"
  (before #:each
    (save-query "dummy-query" "https://yahoo.com" "//body" "[A-Z]+" 0))

  (after #:each (clear-queries))

  (it "fails"
    (expect '(: (* any) "/queries/dummy-query/result" (* any))
            (match-string (serialize-sxml (<scraper-controls>))))))
