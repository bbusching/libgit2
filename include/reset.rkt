#lang racket

(require ffi/unsafe
         "strarray.rkt"
         "checkout.rkt"
         (only-in "types.rkt"
                  _git_repository
                  _git_object
                  _git_object/null
                  _git_annotated_commit)
         libgit2/private)

(provide (all-defined-out))

; Types

(define _git_reset_t
  (_enum '(GIT_RESET_SOFT = 1
           GIT_RESET_MIXED = 2
           GIT_RESET_HARD = 3)))

; Functions

(define-libgit2/check git_reset
  (_fun _git_repository _git_object _git_reset_t _git_checkout_opts-pointer -> _int))

(define-libgit2/check git_reset_default
  (_fun _git_repository _git_object/null _strarray -> _int))

(define-libgit2/check git_reset_from_annotated
  (_fun _git_repository _git_annotated_commit _git_reset_t _git_checkout_opts-pointer -> _int))
