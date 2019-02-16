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
        -> [v : _int]
        -> (check-git_error_code v (λ () (values ahead behind)) 'git_graph_ahead_behind)))

(define-libgit2 git_graph_descendant_of
  (_fun _git_repository _git_oid-pointer _git_oid-pointer
        -> [v : _int]
        -> (cond
             [(eq? v 0) #f]
             [(eq? v 1) #t]
             [else (check-git_error_code v v 'git_graph_descendent_of)])))
