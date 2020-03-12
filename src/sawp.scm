(use awful)
(declare (uses pages))

(create-pages)
(awful-start (lambda () #t)  dev-mode?: #t)
