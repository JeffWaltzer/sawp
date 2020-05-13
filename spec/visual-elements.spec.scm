(use sxml-serializer)

(describe "the saved queries"
  (before #:each
    (save-query "dummy-query" "https://yahoo.com" "//body" "[A-Z]+" 0))

  (after #:each (clear-queries))

  (it "fails"
    (expect '(: (* any) "https://yahoo.com" (* any))
            (match-string (serialize-sxml (<scraper-controls>))))))
