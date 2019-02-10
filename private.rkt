#lang racket/base

(require "private/define.rkt"
         "private/errors.rkt"
         "private/utils.rkt")

(provide libgit2-available?
         check-git_error_code ;; prefer this to be private
         _git_error_code
         define-libgit2
         define-libgit2/check
         define-libgit2/alloc
         define-libgit2/dealloc)
         