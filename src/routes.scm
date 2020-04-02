(declare (unit routes)
         (uses page-handlers))
(use awful)

(define (create-pages)
  (define-page (main-page-path)
    main-page-get
    method: '(GET HEAD))

  (define-page (main-page-path)
    main-page-post
    method: '(POST)))
