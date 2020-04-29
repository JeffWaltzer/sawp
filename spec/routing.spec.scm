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
                (sprintf "Expected ~A not to have entry ~A" (force subject) entry)
                (sprintf "Expected ~A to have entry ~A" (force subject) entry)))))

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
    (create-pages))

  (it "has an entry for GET-ing the main page"
    (expect routing-table (to-have-entry `("/"  ,main-page-get GET))))

  (it "has an entry for HEAD-ing the main page"
    (expect routing-table (to-have-entry `("/"  ,main-page-get  HEAD))))

  (it "has an entry for POST-ing the main page"
    (expect routing-table (to-have-entry `("/"  ,main-page-post POST)))))
