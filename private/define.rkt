#lang racket/base

(require ffi/unsafe
         ffi/unsafe/custodian
         ffi/unsafe/define)

(provide libgit2-available?
         define-libgit2)

(define libgit2
  (ffi-lib (case (system-type)
             [(windows) "git2"]
             [else "libgit2"])
           '("28" #f)
           #:fail (λ () #f)))

(define libgit2-available?
  (and libgit2 #t))

(define-ffi-definer define-libgit2 libgit2
  #:default-make-fail make-not-available)

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
