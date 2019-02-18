#lang racket

(require ffi/unsafe
         (only-in "types.rkt"
                  _git_repository)
         libgit2/private)

(provide (all-defined-out))

(define-libgit2/check git_ignore_add_rule
  (_fun _git_repository _string -> _int))

(define-libgit2/check git_ignore_clear_internal_rules
  (_fun _git_repository -> _int))

(define-libgit2/alloc git_ignore_path_is_ignored
  (_fun _bool _git_repository _string -> _int))
