#lang racket

(require ffi/unsafe
         (submod "oid.rkt" private)
         (only-in "types.rkt" _git_repository)
         libgit2/private)

(provide (all-defined-out))

(define-libgit2 git_graph_ahead_behind
  (_fun [ahead : (_ptr o _size)]
        [behind : (_ptr o _size)]
        _git_repository
        _git_oid-pointer
        _git_oid-pointer
        -> [v : (_git_error_code/check)]
        -> (values ahead behind)))

(define-libgit2 git_graph_descendant_of
  (_fun _git_repository _git_oid-pointer _git_oid-pointer
        -> [v : (_git_error_code/check/int #:handle '(0 1))]
        -> (case v
             [(0) #f]
             [(1) #t])))
