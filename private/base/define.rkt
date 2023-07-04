#lang racket/base

(require ffi/unsafe
         (rename-in racket/contract/base [-> ->c])
         ffi/unsafe/define
         syntax/parse/define
         racket/stxparam
         racket/runtime-path
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

;; hopefully, we have provided the native lib
(define-runtime-path libgit2-so
  '(so "libgit2" ("1.4" #f)))
;; as a fallback, try a system-provided version
(define libgit2-so-versions
  '("1.4" ;; preferred
    ;; these probably work
    "1.4.3" "1.4.2" "1.4.1" "1.4.0"
    "1.3" "1.3.0"
    "1"
    ;; some other plausible versions ... good luck!
    "1.2" "1.1" "1.0" "0.28" "0.26" #f))

(define libgit2
  (ffi-lib libgit2-so
           libgit2-so-versions
           #:fail (λ () #f)))

(define libgit2-available?
  (and libgit2 #t))

(module+ test
  (check-true libgit2-available?
              "libgit2 should be available"))

(define symbols-not-available
  (let ([bx (box null)])
    (case-lambda
      [() (unbox bx)]
      [(name)
       (let spin ()
         (define old (unbox bx))
         (define new
           (sort (cons name old) symbol<?))
         (let retry ()
           (cond
             [(box-cas! bx old new)]
             [(eq? old (unbox bx))
              ;; spurrious failure
              (retry)]
             [else
              (spin)])))])))

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
  ;; But maybe we should load it with 'place or a custodian ...
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

