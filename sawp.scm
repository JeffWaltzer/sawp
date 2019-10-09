(use awful)
(use html-tags)
(use http-client)
(use intarweb)
(use spiffy)

(generate-sxml? #t)

(define (scraper-controls)
  (<form> method: "POST"
		  (<input> name: "url" type: "text")
		  (<input> name: "submit" type: "submit")))

(define-page (main-page-path)
  (lambda ()
	(scraper-controls))
  method: '(GET HEAD))


(define-page (main-page-path)
  (lambda ()
	(let* ((request-url ($ 'url))
		   (response (with-input-from-request request-url
											  #f
											  read-string)))
	  (<div>
	   (scraper-controls)
	   (<div>
		(<hr>)
		(<code> response)))))
  method: '(POST))

