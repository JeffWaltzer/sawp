(use missbehave-stubs)
(use awful)

(define (to-have-entry entry)
  (matcher
   (check (subject)
          (let ((expected-value (force entry))
                (routing-table (force subject)))
            (any (lambda (routing-table-entry) (equal? expected-value routing-table-entry))
                 routing-table)))
   (message (form subject negate)
            (if negate
                (apply string-append
                       `(,(sprintf "Expected routing-table not to have entry ~A~%" entry)
                         "routing table:\n"
                         ,@(map (lambda (routing-table-entry)
                                  (sprintf "    ~A\n" routing-table-entry))
                                (force subject))))

                (apply string-append
                       `(,(sprintf "Expected routing-table to have entry ~A~%" entry)
                         "routing table:\n"
                         ,@(map (lambda (routing-table-entry)
                                  (sprintf "    ~A\n" routing-table-entry))
                                (force subject))))))))


(describe "the routing table"
  (define routing-table '())

  (before #:each
    (stub! define-page (lambda (path handler #!key method)
                         (for-each
                          (lambda (a-method)
                            (set! routing-table
                              (cons `(,path ,handler ,a-method)
                                    routing-table)))
                          method)))

    (stub! path-match (lambda (#!rest args)
                        args))

    (stub! <string> (lambda (some-string)
                      `(<string> ,some-string)))

    (stub! <regex> (lambda (some-regex)
                     `(<regex> ,some-regex)))

    (create-pages))

  (after #:each
    (set! routing-table '()))

  (it "has an entry for GET-ing the main page"
    (expect routing-table (to-have-entry `("/"  ,main-page-get GET))))

  (it "has an entry for HEAD-ing the main page"
    (expect routing-table (to-have-entry `("/"  ,main-page-get  HEAD))))

  (it "has an entry for POST-ing the main page"
    (expect routing-table (to-have-entry `("/"  ,main-page-post POST))))

  (it "has an entry for GET-ing a saved query"
    (expect routing-table (to-have-entry `(
                                           ((<string> "queries") (<regex> (* any)))
                                           ,queries
                                           GET))))
)

