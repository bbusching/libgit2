#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt")
(provide (all-defined-out))


(define-libgit2 git_ignore_add_rule
  (_fun _repository _string -> _int))
(define-libgit2 git_ignore_clear_internal_rules
  (_fun _repository -> _int))
(define-libgit2 git_ignore_path_is_ignored
  (_fun (_cpointer _int) _repository _string -> _int))

