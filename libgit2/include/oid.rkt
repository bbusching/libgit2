#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define GIT_OID_RAWSZ 20)
(define GIT_OID_HEXSZ (* GIT_OID_RAWSZ 2))
(define GIT_OID_MINPREFIXLEN 4)

(define-cstruct _git_oid
  ([id (_array _uint8 GIT_OID_RAWSZ)]))

(define _oid_shorten (_cpointer 'git_oid_shorten))

(define-libgit2/check git_oid_fromstr
  (_fun _oid _string -> _int))
(define-libgit2/check git_oid_fromstrp
  (_fun _oid _string -> _int))
(define-libgit2/check git_oid_fromstrn
  (_fun _oid _string _size -> _int))
(define-libgit2 git_oid_fromraw
  (_fun _oid (_cpointer _uint8) -> _void))
(define-libgit2 git_oid_fmt
  (_fun _string _oid -> _void))
(define-libgit2 git_oid_nfmt
  (_fun _string _size _oid -> _void))
(define-libgit2 git_oid_pathfmt
  (_fun _string _oid -> _void))
(define-libgit2 git_oid_tostr_s
  (_fun _oid -> _string))
(define-libgit2 git_oid_tostr
  (_fun _oid -> _string))
(define-libgit2 git_oid_cmp
  (_fun _oid _oid -> _int))
(define-libgit2 git_oid_equal
  (_fun _oid _oid -> _bool))
(define-libgit2 git_oid_ncmp
  (_fun _oid _oid _size -> _int))
(define-libgit2 git_oid_streq
  (_fun _oid _string -> _int))
(define-libgit2 git_oid_strcmp
  (_fun _oid _string -> _int))
(define-libgit2 git_oid_iszero
  (_fun _oid -> _bool))
(define-libgit2 git_oid_shorten_new
  (_fun _size -> _oid_shorten))
(define-libgit2 git_oid_shorten_add
  (_fun _oid_shorten _string -> _int))
(define-libgit2 git_oid_shorten_free
  (_fun _oid_shorten -> _void))

