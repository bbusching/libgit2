#lang racket/base

(require "private/define.rkt"
         "private/errors.rkt"
         "private/utils.rkt"
         (rename-in racket/contract [-> ->c]))

(provide libgit2-available?
         symbols-not-available
         check-git_error_code ;; prefer this to be private
         _git_error_code
         (all-from-out racket/contract)
         define-bitmask
         define-enum
         define-libgit2
         define-libgit2/check
         define-libgit2/alloc
         define-libgit2/dealloc)
         