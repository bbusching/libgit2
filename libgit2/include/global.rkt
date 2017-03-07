#lang racket

(require ffi/unsafe
         "define.rkt")
(provide (all-defined-out))


(define-libgit2 git_libgit2_init
  (_fun -> _int))
(define-libgit2 git_libgit2_shutdown
  (_fun -> _int))
