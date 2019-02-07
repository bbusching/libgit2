#lang racket

(require ffi/unsafe
         ffi/unsafe/define
         racket/runtime-path)
(provide (all-defined-out))

(define-runtime-path lib-path "../lib")
(define win-dll-path (build-path lib-path (system-library-subpath) "git2"))

(define libgit2
  (case (system-type)
    [(windows) (or (ffi-lib win-dll-path #:fail (λ () #f))
                   (ffi-lib "git2" '(#f)))]
    [(unix) (ffi-lib "libgit2" '("0.26.0" #f))]
    [(macosx) (ffi-lib "libgit2" '("28" #f))]))

(define-ffi-definer define-libgit2 libgit2
  #:default-make-fail make-not-available)
