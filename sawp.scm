(use awful)
(use html-tags)
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
	(let* ((request-parameters (read-urlencoded-request-data (current-request)))
		   (request-url (cdr (assq 'url request-parameters))))
	  (<div>
	   (scraper-controls)
	   (<div>
		(<hr>)
		(<iframe> src: request-url
				  width: "75%"
				  style: "margin-left: 10%")))))
  method: '(POST))

