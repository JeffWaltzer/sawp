(use html-parser)
(use irregex)
(use txpath)
(define fooferd
  ;span data-reactid="39"
  ;//*[contains(text(),'ABC')]
  (txpath "//script[contains(text(), 'root.App.main')]")
  ;(txpath "//span[@data-reactid='39']")
)

(define head-extractor (irregex "root.App.main = ?(.*);"))
(define tail-extractor (irregex ""))

(define html
  (with-input-from-file "../examples/qcom-statistics.html"
    (lambda () (read-string))
  )
)
(define parsed-html (html->sxml html))

(define js-stuff  (cadar (fooferd parsed-html)))

(define json-stuff (irregex-match-substring (irregex-search head-extractor js-stuff ) 1))

(printf "~%~a~%"  json-stuff)

