#lang racket

(require ffi/unsafe
         "types.rkt"
         (submod "oid.rkt" private)
         libgit2/private)

(provide (all-defined-out))


; Types

(define _indexer (_cpointer 'git_indexer))

; Functions

(define-libgit2/check git_indexer_append
  (_fun _indexer _bytes _size _git_transfer_progress-pointer -> _int))

(define-libgit2/check git_indexer_commit
  (_fun _indexer _git_transfer_progress-pointer -> _int))

(define-libgit2/dealloc git_indexer_free
  (_fun _indexer -> _void))

(define-libgit2/alloc git_indexer_new
  (_fun _indexer _string _uint _odb _git_transfer_progress_cb _bytes -> _int)
  git_indexer_free)

(define-libgit2 git_indexer_hash
  (_fun _indexer -> _git_oid-pointer))
