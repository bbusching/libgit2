#lang racket

(require ffi/unsafe
         "types.rkt"
         libgit2/private)
(provide (all-defined-out))


(define-libgit2 git_graph_ahead_behind
  (_fun (ahead : (_ptr o _size)) (behind : (_ptr o _size)) _repository _oid _oid -> (v : _int)
        -> (check-git_error_code v (λ () (values ahead behind)) 'git_graph_ahead_behind)))

(define-libgit2 git_graph_descendant_of
  (_fun _repository _oid _oid -> (v : _int)
        -> (cond
             [(eq? v 0) #f]
             [(eq? v 1) #t]
             [else (check-git_error_code v v 'git_graph_descendent_of)])))
