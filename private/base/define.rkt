#lang racket/base

(require ffi/unsafe
         (rename-in racket/contract/base [-> ->c])
         ffi/unsafe/define
         syntax/parse/define
         racket/stxparam
         (for-syntax racket/base))

(module+ test
  (require rackunit
           (submod "..")))

(provide (rename-out [define-libgit2/who define-libgit2])
         (for-syntax libgit2-local-who)
         (contract-out
          [libgit2-available?
           boolean?]
          [symbols-not-available
           (->c (listof symbol?))]
          ))

(define libgit2
  (ffi-lib (case (system-type)
             [(windows) "git2"]
             [else "libgit2"])
           '(#f)
           #:fail (λ () #f)))

(define libgit2-available?
  (and libgit2 #t))

(module+ test
  (check-true libgit2-available?
              "libgit2 should be available"))

(define symbols-not-available
  (let ([lst null])
    (case-lambda
      [() lst]
      [(name) (set! lst (cons name lst))])))

(define-ffi-definer define-libgit2 libgit2
  #:default-make-fail
  (λ (name)
    (λ () 
      (symbols-not-available name)
      ((make-not-available name)))))

(when libgit2-available?
  ;; Handle initialization.
  ;; "Usually you don’t need to call [git_libgit2_shutdown]
  ;; as the operating system will take care of reclaiming resources"
  (define-libgit2 git_libgit2_init
    (_fun -> _int))
  (git_libgit2_init)
  (void))

(define-syntax-parameter libgit2-local-who-stxparam #f)

(define-for-syntax (libgit2-local-who)
  (syntax-parameter-value #'libgit2-local-who-stxparam))

(define-syntax-parser with-libgit2-local-who
  [(_ who:id body:expr ...+)
   #'(syntax-parameterize ([libgit2-local-who-stxparam 'who])
       body ...)])

(define-syntax-parser define-libgit2/who
  [(_ name:id
      (~alt (~once type:expr #:name "type-expr")
            (~optional (~seq #:c-id c-id:id) #:name "#:c-id")
            (~optional (~seq #:wrap wrap:expr) #:name "#:wrap")
            (~optional (~or* (~seq #:make-fail make-fail:expr)
                             (~seq #:fail fail:expr))
                       #:name "#:fail or #:make-fail"))
      ...)
   #'(define-libgit2 name
       (with-libgit2-local-who name type)
       (~? (~@ #:c-id c-id))
       (~? (~@ #:wrap (with-libgit2-local-who name wrap)))
       (~? (~@ #:fail (with-libgit2-local-who name fail)))
       (~? (~@ #:make-fail (with-libgit2-local-who name make-fail))))])

