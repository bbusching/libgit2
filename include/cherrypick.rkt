#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "merge.rkt"
         "checkout.rkt"
         "index.rkt"
         "utils.rkt")
(provide (all-defined-out))


; Types

(define-cstruct _git_cherrypick_opts
  ([version _uint]
   [mainline _uint]
   [merge_opts _git_merge_opts]
   [checkout_opts _git_checkout_opts]))

; Functions

(define-libgit2/check git_cherrypick
  (_fun _repository _commit _git_cherrypick_opts-pointer/null -> _int))

(define-libgit2/alloc git_cherrypick_commit
  (_fun _index _repository _commit _commit _uint _git_merge_opts-pointer/null -> _int)
  git_index_free)

(define-libgit2/check git_cherrypick_init_options
  (_fun _git_cherrypick_opts-pointer _uint -> _int))
