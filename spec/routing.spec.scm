(use missbehave-stubs)
(use awful)

(describe "the routing table"
  (before #:each
    (create-pages)
    )

  (define (the-routing-table)
    (hash-table->alist (awful-resources-table)))

  (it "something"
    (expect (the-routing-table)
            (be
             `((("/" "/home/jmax/projects/sawp" GET)  ,main-page-get  . #f)
               (("/" "/home/jmax/projects/sawp" HEAD) ,main-page-get  . #f)
               (("/" "/home/jmax/projects/sawp" POST) ,main-page-post . #f))))
    )
  )
