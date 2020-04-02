(use missbehave-stubs)
(load "src/page-handlers.scm")
(load "src/templates.scm")

(describe "the main page"
  (before #:each
    (stub! $ (returns ""))
    (stub! scrape-element (returns "something or other"))
    (stub! <scrape-results> (returns (void))))

  (after #:each
    (clear-stubs!))

  (it "something"
    (expect (main-page-post)
            (call <scrape-results> (with "something or other") once))))
