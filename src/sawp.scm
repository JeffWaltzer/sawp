(use awful)
(declare (uses routes))

(create-pages)
(awful-start (lambda () #t)  dev-mode?: #t)
