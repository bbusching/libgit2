#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define-libgit2/alloc git_refdb_backend_fs
  (_fun _refdb_backend _repository -> _int))

(define-libgit2/check git_refdb_compress
  (_fun _refdb -> _int))

(define-libgit2/dealloc git_refdb_free
  (_fun _refdb -> _void))

(define-libgit2/check git_refdb_init_backend
  (_fun _refdb_backend _uint -> _int))

(define-libgit2/alloc git_refdb_new
  (_fun _refdb _repository -> _int)
  git_refdb_free)

(define-libgit2/alloc git_refdb_open
  (_fun _refdb _repository -> _int)
  git_refdb_free)

(define-libgit2/check git_refdb_set_backend
  (_fun _refdb _refdb_backend -> _int))
