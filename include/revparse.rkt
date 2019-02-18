#lang racket

(require ffi/unsafe
         ffi/unsafe/alloc
         "object.rkt"
         "refs.rkt"
         (only-in "types.rkt"
                  _git_repository
                  _git_object
                  _git_reference)
         libgit2/private)
         
(provide (all-defined-out))


; Types

(define-bitmask _git_revparse_mode_t
  [GIT_REVPARSE_SINGLE = 1]
  [GIT_REVPARSE_RANGE = 2]
  [GIT_REVPARSE_MERGE_BASE = 4])

(define-cstruct _git_revspec
  ([from _git_object]
   [to _git_object]
   [flags _uint]))

; Functions

(define-libgit2/check git_revparse
  (_fun _git_revspec-pointer _git_repository _string -> _int))

(define-libgit2/check git_revparse_ext
  (_fun [object_out : (_ptr o _git_object)]
        [reference_out : (_ptr o _git_reference)]
        _git_repository
        _string
        -> [v : _git_error_code]
        -> (values ((allocator git_object_free) object_out)
                   ((allocator git_reference_free) reference_out))))

(define-libgit2/alloc git_revparse_single
  (_fun _git_object _git_repository _string -> _int)
  git_object_free)

