#lang racket

(require ffi/unsafe
         (submod "oid.rkt" private)
         libgit2/private)

(provide (all-defined-out))

(define GIT_DEFAULT_PORT 9418)

(define-enum _git_direction
  GIT_DIRECTION_FETCH
  GIT_DIRECTION_PUSH)

(define-cstruct _git_remote_head
  ([local _int]
   [oid _git_oid-pointer]
   [name _string]
   [symref_target _string]))

(define _git_headlist_cb
  (_fun _git_remote_head-pointer _bytes -> _int))
