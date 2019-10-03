(use awful)
(use html-tags)
(use intarweb)
(use spiffy)

(generate-sxml? #t)

(define-page (main-page-path)
  (lambda ()
	(let ((request-parameters #f))

	  (if (eq? 'POST (request-method (current-request)))
		  (set! request-parameters
				(read-urlencoded-request-data (current-request))))

	  (<div>
	   (<form> method: "POST"
			   (<input> name: "url" type: "text")
			   (<input> name: "submit" type: "submit"))

	   (if request-parameters
		   (<div>
			(<hr>)
			(<iframe> src: (cdr (assq 'url request-parameters))
					  width: "75%"
					  style: "margin-left: 10%"))
		   ""))))
  method: '(GET HEAD POST))

