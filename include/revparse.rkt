#lang racket

(require ffi/unsafe
         ffi/unsafe/alloc
         "define.rkt"
         "types.rkt"
         "object.rkt"
         "refs.rkt"
         "utils.rkt")
(provide (all-defined-out))


; Types

(define _git_revparse_mode_t
  (_bitmask '(GIT_REVPARSE_SINGLE = 1
              GIT_REVPARSE_RANGE = 2
              GIT_REVPARSE_MERGE_BASE = 4)))

(define-cstruct _git_revspec
  ([from _object]
   [to _object]
   [flags _uint]))

; Functions

(define-libgit2/check git_revparse
  (_fun _git_revspec-pointer _repository _string -> _int))

(define-libgit2 git_revparse_ext
  (_fun (object_out : (_ptr o _object)) (reference_out : (_ptr o _reference)) _repository _string -> (v : _int)
        -> (check-lg2 v
                      (λ () (values ((allocator git_object_free) object_out)
                                    ((allocator git_reference_free) reference_out)))
                      'git_revparse_ext)))

(define-libgit2/alloc git_revparse_single
  (_fun _object _repository _string -> _int)
  git_object_free)

