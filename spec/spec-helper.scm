(load "src/cache.scm")
(load "src/page-handlers.scm")
(load "src/routes.scm")
(load "src/scraper.scm")
(load "src/templates.scm")

(define (debug #!rest args)
  (with-output-to-file "/dev/tty"
    (lambda ()
      (apply printf args))))

