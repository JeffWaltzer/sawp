(declare (unit routes)
         (uses page-handlers))
(use awful)
(use awful-path-matchers)

(define (create-pages)
  (define-page (main-page-path)
    main-page-get
    method: '(GET HEAD))

  (define-page (main-page-path)
    main-page-post
    method: '(POST))

  (define-page (path-match (<string> "queries"))
    queries
    method: '(GET))

  (define-page (path-match (<string> "queries") (<regex> '(* any)) (<string> "result"))
    run-query
    method: '(GET)))
