(use html-parser)
(use irregex)
(use json)
(use txpath)
(use vector-lib)

(define fooferd
  (txpath "//script[contains(text(), 'root.App.main')]"))

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

(define parsed-json (call-with-input-string json-stuff json-read))

(define (fix-json json)
  (cond
   ((list? json)
	(map fix-json json))
   ((vector? json)
	(alist->hash-table
	 (vector->list
	  (vector-map
	   (lambda (i kv-pair)
		 `(,(car kv-pair) . ,(fix-json (cdr kv-pair))))
	   json))))
   (else
	json)))

(define (find-price-key path-so-far json)
  (cond
   ((hash-table? json)
	(if (hash-table-exists? json "price")
		(printf "~A~%" (reverse path-so-far))
		(hash-table-map
		 json
		 (lambda (key value)
		   (find-price-key (cons key path-so-far) value)))))
   
   ((list? json)
	(for-each
	 (lambda (value) (find-price-key (cons "[]" path-so-far) value))
	 json)))

  #f)

(printf "~S~%"
		(hash-table-ref
		 (hash-table-ref
		  (hash-table-ref
		   (hash-table-ref
			(hash-table-ref
			 (hash-table-ref
			  (hash-table-ref (fix-json parsed-json)
							  "context")
			  "dispatcher")
			 "stores")
			"QuoteSummaryStore")
		   "price")
		  "regularMarketOpen")
		 "fmt"))
