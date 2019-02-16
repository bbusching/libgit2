#lang racket

(require ffi/unsafe
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository
                  _git_transaction
                  _git_reflog
                  _git_signature-pointer)
         libgit2/private)

(provide (all-defined-out))

(define-libgit2/check git_transaction_commit
  (_fun _git_transaction -> _int))

(define-libgit2/dealloc git_transaction_free
  (_fun _git_transaction -> _void))

(define-libgit2/check git_transaction_lock_ref
  (_fun _git_transaction _string -> _int))

(define-libgit2/alloc git_transaction_new
  (_fun _git_transaction _git_repository -> _int)
  git_transaction_free)

(define-libgit2/check git_transaction_remove
  (_fun _git_transaction _string -> _int))

(define-libgit2/check git_transaction_set_reflog
  (_fun _git_transaction _string _git_reflog -> _int))

(define-libgit2/check git_transaction_set_symbolic_target
  (_fun _git_transaction _string _string _git_signature-pointer _string -> _int))

(define-libgit2/check git_transaction_set_target
  (_fun _git_transaction _string _git_oid-pointer _git_signature-pointer _string -> _int))
