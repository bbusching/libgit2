#lang racket

(require ffi/unsafe
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository
                  _git_reflog
                  _git_signature-pointer
                  _git_reflog_entry)
         libgit2/private)

(provide (all-defined-out))

(define-libgit2/check git_reflog_append
  (_fun _git_reflog _git_oid-pointer _git_signature-pointer _string -> _int))

(define-libgit2/check git_reflog_delete
  (_fun _git_repository _string -> _int))

(define-libgit2/check git_reflog_drop
  (_fun _git_reflog _size _int -> _int))

(define-libgit2 git_reflog_entry_byindex
  (_fun _git_reflog _size -> _git_reflog_entry))

(define-libgit2 git_reflog_entry_committer
  (_fun _git_reflog_entry -> _git_signature-pointer))

(define-libgit2 git_reflog_entry_id_new
  (_fun _git_reflog_entry -> _git_oid-pointer))

(define-libgit2 git_reflog_entry_id_old
  (_fun _git_reflog_entry -> _git_oid-pointer))

(define-libgit2 git_reflog_entry_message
  (_fun _git_reflog_entry -> _string))

(define-libgit2 git_reflog_entrycount
  (_fun _git_reflog -> _size))

(define-libgit2/dealloc git_reflog_free
  (_fun _git_reflog -> _void))

(define-libgit2/alloc git_reflog_read
  (_fun _git_reflog _git_repository _string -> _int)
  git_reflog_free)

(define-libgit2/check git_reflog_rename
  (_fun _git_repository _string _string -> _int))

(define-libgit2/check git_reflog_write
  (_fun _git_reflog -> _int))
