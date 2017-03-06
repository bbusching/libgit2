#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "refs.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define-libgit2/alloc git_refdb_new
  (_fun _refdb _repository -> _int))
(define-libgit2/alloc git_refdb_open
  (_fun _refdb _repository -> _int))
(define-libgit2/check git_refdb_compress
  (_fun _refdb -> _int))
(define-libgit2 git_refdb_free
  (_fun _refdb -> _void))

