(use awful)
(use html-tags)

(generate-sxml? #t)

(define-page (main-page-path)
  (lambda ()
    (<form>
	 (<input> name: "url" type: "text")
	 (<input> name: "submit" type: "submit"))))
