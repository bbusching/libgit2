#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define-libgit2/alloc git_revparse_single
  (_fun _object _repository _string -> _int))
(define-libgit2/check git_revparse_ext
  (_fun (_cpointer _object) (_cpointer _reference) _repository _string -> _int))

(define _git_revparse_mode_t
  (_bitmask '(GIT_REVPARSE_SINGLE = 1
              GIT_REVPARSE_RANGE = 2
              GIT_REVPARSE_MERGE_BASE = 4)))

(define-cstruct _git_revspec
  ([from _object]
   [to _object]
   [flags _uint]))

(define-libgit2/check git_revparse
  (_fun _git_revspec-pointer _repository _string -> _int))

