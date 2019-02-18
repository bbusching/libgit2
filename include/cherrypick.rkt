#lang racket

(require ffi/unsafe
         "merge.rkt"
         "checkout.rkt"
         "index.rkt"
         (only-in "types.rkt"
                  _git_repository
                  _git_commit
                  _git_index)
         libgit2/private)

(provide (all-defined-out))

; Types

(define-cstruct _git_cherrypick_opts
  ([version _uint]
   [mainline _uint]
   [merge_opts _git_merge_opts]
   [checkout_opts _git_checkout_opts]))

; Functions

(define-libgit2/check git_cherrypick
  (_fun _git_repository _git_commit _git_cherrypick_opts-pointer/null -> _int))

(define-libgit2/alloc git_cherrypick_commit
  (_fun _git_index _git_repository _git_commit _git_commit _uint _git_merge_opts-pointer/null -> _int)
  git_index_free)

(define-libgit2/check git_cherrypick_init_options
  (_fun _git_cherrypick_opts-pointer _uint -> _int))
