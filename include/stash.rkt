#lang racket

(require ffi/unsafe
         "types.rkt"
         "checkout.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define _git_stash_flags
  (_bitmask '(GIT_STASH_DEFAULT = 0
              GIT_STASH_KEEP_INDEX = 1
              GIT_STASH_INCLUDE_UNTRACKED = 2
              GIT_STASH_INCLUDE_IGNORED = 4)))

(define _git_stash_apply_flags
  (_bitmask '(GIT_STASH_APPLY_DEFAULT = 0
              GIT_STASH_APPLY_REINSTATE_INDEX = 1)))

(define _git_stash_apply_progress_t
  (_enum '(GIT_STASH_APPLY_PROGRESS_NONE
           GIT_STASH_APPLY_PROGRESS_LOADING_STASH
           GIT_STASH_APPLY_PROGRESS_ANALYZE_INDEX
           GIT_STASH_APPLY_PROGRESS_ANALYZE_MODIFIED
           GIT_STASH_APPLY_PROGRESS_ANALYZE_UNTRACKED
           GIT_STASH_APPLY_PROGRESS_CHECKOUT_UNTRACKED
           GIT_STASH_APPLY_PROGRESS_CHECKOUT_MODIFIED
           GIT_STASH_APPLY_PROGRESS_DONE)))

(define _git_stash_apply_progress_cb
  (_fun _git_stash_apply_progress_t _bytes -> _int))

(define-cstruct _git_stash_apply_opts
  ([version _uint]
   [flags _git_stash_apply_flags]
   [checkout_options _git_checkout_opts]
   [progress_cb _git_stash_apply_progress_cb]
   [progress_payload _bytes]))

(define GIT_STASH_APPLY_OPTS_VERSION 1)

(define _git_stash_cb
  (_fun _size _string _oid _bytes -> _int))

; Functions

(define-libgit2/check git_stash_apply
  (_fun _repository _size _git_stash_apply_opts-pointer -> _int))

(define-libgit2/check git_stash_apply_init_options
  (_fun _git_stash_apply_opts-pointer _uint -> _int))

(define-libgit2/check git_stash_drop
  (_fun _repository _size -> _int))

(define-libgit2/check git_stash_foreach
  (_fun _repository _git_stash_cb _bytes -> _int))

(define-libgit2/check git_stash_pop
  (_fun _repository _size _git_stash_apply_opts-pointer -> _int))

(define-libgit2/check git_stash_save
  (_fun _oid _repository _signature _string _uint32 -> _int))
