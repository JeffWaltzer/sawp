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
		   (request-url (cdr (assq 'url request-parameters)))
		   (scrape-request (make-request uri: request-url))
		   (scrape-response #f))
	  (write-request scrape-request)
	  (set! scrape-response
			(read-response (request-port scrape-request)))

	  (<div>
	   (scraper-controls)
	   (<div>
		(<hr>)
		(<code> (with-output-to-string (lambda () (write scrape-response))))))))
  method: '(POST))

