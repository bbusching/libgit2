#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "strarray.rkt"
         "checkout.rkt"
         "utils.rkt")
(provide (all-defined-out))


; Types

(define _git_reset_t
  (_enum '(GIT_RESET_SOFT = 1
           GIT_RESET_MIXED = 2
           GIT_RESET_HARD = 3)))

; Functions

(define-libgit2/check git_reset
  (_fun _repository _object _git_reset_t _git_checkout_opts-pointer -> _int))

(define-libgit2/check git_reset_default
  (_fun _repository _object/null _strarray -> _int))

(define-libgit2/check git_reset_from_annotated
  (_fun _repository _annotated_commit _git_reset_t _git_checkout_opts-pointer -> _int))
