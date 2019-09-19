(use awful)
(use html-tags)

(generate-sxml? #f)

(define-page (main-page-path)
  (lambda ()
    (<form> convert-to-entities: #f
      (<input> convert-to-entities: #f name: "url" type: "text")
      (<input> convert-to-entities: #f name: "submit" type: "submit")
    )
  ))

