#lang racket

(require ffi/unsafe
         (only-in "types.rkt"
                  _git_repository
                  _git_refdb
                  _git_refdb_backend)
         libgit2/private)

(provide (all-defined-out))

(define-libgit2/alloc git_refdb_backend_fs
  (_fun _git_refdb_backend _git_repository -> _int))

(define-libgit2/check git_refdb_compress
  (_fun _git_refdb -> _int))

(define-libgit2/dealloc git_refdb_free
  (_fun _git_refdb -> _void))

(define-libgit2/check git_refdb_init_backend
  (_fun _git_refdb_backend _uint -> _int))

(define-libgit2/alloc git_refdb_new
  (_fun _git_refdb _git_repository -> _int)
  git_refdb_free)

(define-libgit2/alloc git_refdb_open
  (_fun _git_refdb _git_repository -> _int)
  git_refdb_free)

(define-libgit2/check git_refdb_set_backend
  (_fun _git_refdb _git_refdb_backend -> _int))
