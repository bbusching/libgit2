#lang racket

(require ffi/unsafe
         "types.rkt"
         "buffer.rkt"
         (submod "oid.rkt" private)
         libgit2/private)
(provide (all-defined-out))


(define-libgit2/dealloc git_object_free
  (_fun _object -> _void))

(define-libgit2 git_object__size
  (_fun _git_object_t -> _size))

(define-libgit2/alloc git_object_dup
  (_fun _object _object -> _int)
  git_object_free)

(define-libgit2 git_object_id
  (_fun _object -> _git_oid-pointer))

(define-libgit2/alloc git_object_lookup
  (_fun _object _repository _git_oid-pointer _git_object_t -> _int)
  git_object_free)

(define-libgit2/alloc git_object_lookup_bypath
  (_fun _object _object _string _git_object_t -> _int)
  git_object_free)

(define-libgit2/alloc git_object_lookup_prefix
  (_fun _object _repository _git_oid-pointer _size _git_object_t -> _int)
  git_object_free)

(define-libgit2 git_object_owner
  (_fun _object -> _repository))

(define-libgit2/alloc git_object_peel
  (_fun _object _object _git_object_t -> _int)
  git_object_free)

(define-libgit2/check git_object_short_id
  (_fun _buf _object -> _int))

(define-libgit2 git_object_string2type
  (_fun _string -> _git_object_t))

(define-libgit2 git_object_type
  (_fun _object -> _git_object_t))

(define-libgit2 git_object_type2string
  (_fun _git_object_t -> _string))

(define-libgit2 git_object_typeisloose
  (_fun _git_object_t -> _bool))
