#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt")
(provide (all-defined-out))


(define-libgit2 git_graph_ahead_behind
  (_fun (_cpointer _size) (_cpointer _size) _repository _oid _oid -> _int))
(define-libgit2 git_graph_descendant_of
  (_fun _repository _oid _oid -> _int))

