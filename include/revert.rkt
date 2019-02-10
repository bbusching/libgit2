#lang racket

(require ffi/unsafe
         "types.rkt"
         "merge.rkt"
         "checkout.rkt"
         "index.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define-cstruct _git_revert_opts
  ([version _uint]
   [mainline _uint]
   [merge_opts _git_merge_opts]
   [checkout_opts _git_checkout_opts]))

(define GIT_REVERT_OPTS_VERSION 1)

; Functions

(define-libgit2/check git_revert
  (_fun _repository _commit _git_revert_opts-pointer -> _int))

(define-libgit2/alloc git_revert_commit
  (_fun _index _repository _commit _commit _uint _git_merge_opts-pointer -> _int)
  git_index_free)

(define-libgit2/check git_revert_init_options
  (_fun _git_revert_opts-pointer _uint -> _int))
