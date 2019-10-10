(use html-tags)
(declare (unit templates))

(define-syntax define-markup
  (syntax-rules ()
	((_ lambda-list markup-form ...)
	 (define lambda-list
	   `(,markup-form ...)))))


(define-markup (<scraper-controls>)
  (<form> method: "POST"
		  (<input> name: "url" type: "text")
		  (<input> name: "submit" type: "submit")))

(define-markup (<scrape-results> response-body)
  (<scraper-controls>)
  (<hr>)
  (<code> response-body))
