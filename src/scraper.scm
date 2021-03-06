(use html-parser)
(use json)
(use txpath)
(declare (unit scraper))
(declare (uses cache))
(use http-client)

(define (scrape-n-cache url)
  (update-cache url
    (with-input-from-request url #f read-string)
    (current-time)))

(define (scrape url)
  (if (cache-fresh url)
    (cached-page url)
    (scrape-n-cache url)))

(define (extract-by-xpath html-text xpath)
  (map cadr ((txpath xpath)
         (html->sxml html-text))))

(define (extract-by-regex text regex)
  (irregex-match-substring
   (irregex-search
    (irregex regex)
    text)
   1))

(define (extract-by-json json-string keys)
  (define (inner-extract-by-json keys json)
    (define (object-ref key object)
      (alist-ref (vector->list object)
                 (symbol->string key)
                 (lambda () #f)
                 string=?))

    (define (array-ref key object)
      (and (>= key 0)
           (< key (length object))
           (list-ref json key)))

    (define (ref key json)
      (cond ((symbol? key)  (object-ref key json))
            ((number? key)  (array-ref key json))))

    (if (null? keys)
        json
        (inner-extract-by-json
         (cdr keys)
         (ref (car keys) json))))

  (inner-extract-by-json keys
                         (call-with-input-string json-string json-read)))

(define (scrape-element url xpath regex json-indices)
  (define (have s)
    (not (string=? "" s)))

  (define (have-json-indices)
    (have (car json-indices)))

  (let ((result (scrape url)))
    ;; result is a string here
    (if (have xpath)
        (set! result (extract-by-xpath result xpath))
        (set! result (list result)))

    ;; result is a list of strings here
    (if (have regex)
        (set! result
          (map (lambda (sub-result)
                 (extract-by-regex sub-result regex))
               result)))

    ;; result is ? here
    (if (have-json-indices)
        (begin
          (set! result
            (map
             (lambda (sub-result)
               (extract-by-json sub-result (map string->symbol json-indices)))
             result))))

    ;; result is a list of strings here

    #;(set! result (car result))

    ;; result is a string, finally
    result))
