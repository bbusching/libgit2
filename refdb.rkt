#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "refs.rkt")
(provide (all-defined-out))


(define-libgit2 git_refdb_new
  (_fun (_cpointer _refdb) _repository -> _int))
(define-libgit2 git_refdb_open
  (_fun (_cpointer _refdb) _repository -> _int))
(define-libgit2 git_refdb_compress
  (_fun _refdb -> _int))
(define-libgit2 git_refdb_free
  (_fun _refdb -> _void))

