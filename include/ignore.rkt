#lang racket

(require ffi/unsafe
         "types.rkt"
         libgit2/private)
(provide (all-defined-out))


(define-libgit2/check git_ignore_add_rule
  (_fun _repository _string -> _int))

(define-libgit2/check git_ignore_clear_internal_rules
  (_fun _repository -> _int))

(define-libgit2/alloc git_ignore_path_is_ignored
  (_fun _bool _repository _string -> _int))
