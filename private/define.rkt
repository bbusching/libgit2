#lang racket/base

(require ffi/unsafe
         (rename-in racket/contract/base [-> ->c])
         ffi/unsafe/define)

(module+ test
  (require rackunit
           (submod "..")))

(provide define-libgit2
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
