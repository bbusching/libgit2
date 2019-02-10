#lang racket/base

(require ffi/unsafe
         ffi/unsafe/custodian
         (rename-in racket/contract/base [-> ->c])
         ffi/unsafe/define)

(provide libgit2-available?
         define-libgit2
         (contract-out
          [symbols-not-available
           (->c (listof symbol?))]
          ))

(define libgit2
  (ffi-lib (case (system-type)
             [(windows) "git2"]
             [else "libgit2"])
           '("28" #f)
           #:fail (λ () #f)))

(define libgit2-available?
  (and libgit2 #t))

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

(let ()
  ;; Handle initialization and teardown
  (define-libgit2 git_libgit2_init
    (_fun -> _int))
  (define-libgit2 git_libgit2_shutdown
    (_fun -> _int))
  (register-custodian-shutdown #f
                               (λ (arg) (git_libgit2_shutdown))
                               (current-custodian) ;; (make-custodian-at-root) ;; ??
                               #:at-exit? #t)
  (git_libgit2_init)
  (void))
