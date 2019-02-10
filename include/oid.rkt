#lang racket

(require ffi/unsafe
         ffi/unsafe/alloc
         "types.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define _oid_shorten (_cpointer 'git_oid_shorten))

; Functions

(define-libgit2 git_oid_cmp
  (_fun _oid _oid -> _int))

(define-libgit2 git_oid_cpy
  (_fun _oid _oid -> _void))

(define-libgit2 git_oid_equal
  (_fun _oid _oid -> _bool))

(define-libgit2 git_oid_fmt
  (_fun _string _oid -> _void))

(define-libgit2 git_oid_fromraw
  (_fun _oid (_cpointer _uint8) -> _void))

(define-libgit2/check git_oid_fromstr
  (_fun _oid _string -> _int))

(define-libgit2/check git_oid_fromstrn
  (_fun _oid _string _size -> _int))

(define-libgit2/check git_oid_fromstrp
  (_fun _oid _string -> _int))

(define-libgit2 git_oid_iszero
  (_fun _oid -> _bool))

(define-libgit2 git_oid_ncmp
  (_fun _oid _oid _size -> _int))

(define-libgit2 git_oid_nfmt
  (_fun _string _size _oid -> _void))

(define-libgit2 git_oid_pathfmt
  (_fun _string _oid -> _void))

(define-libgit2 git_oid_shorten_add
  (_fun _oid_shorten _string -> _int))

(define-libgit2/dealloc git_oid_shorten_free
  (_fun _oid_shorten -> _void))

(define-libgit2 git_oid_shorten_new
  (_fun _size -> _oid_shorten)
  #:wrap (allocator git_oid_shorten_free))

(define-libgit2 git_oid_strcmp
  (_fun _oid _string -> _int))

(define-libgit2 git_oid_streq
  (_fun _oid _string -> _int))

(define-libgit2 git_oid_tostr
  (_fun _oid -> _string))

(define-libgit2 git_oid_tostr_s
  (_fun _oid -> _string))
