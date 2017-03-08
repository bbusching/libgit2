#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define-libgit2/check git_reflog_append
  (_fun _reflog _oid _signature _string -> _int))

(define-libgit2/check git_reflog_delete
  (_fun _repository _string -> _int))

(define-libgit2/check git_reflog_drop
  (_fun _reflog _size _int -> _int))

(define-libgit2 git_reflog_entry_byindex
  (_fun _reflog _size -> _reflog_entry))

(define-libgit2 git_reflog_entry_committer
  (_fun _reflog_entry -> _signature))

(define-libgit2 git_reflog_entry_id_new
  (_fun _reflog_entry -> _oid))

(define-libgit2 git_reflog_entry_id_old
  (_fun _reflog_entry -> _oid))

(define-libgit2 git_reflog_entry_message
  (_fun _reflog_entry -> _string))

(define-libgit2 git_reflog_entrycount
  (_fun _reflog -> _size))

(define-libgit2/dealloc git_reflog_free
  (_fun _reflog -> _void))

(define-libgit2/alloc git_reflog_read
  (_fun _reflog _repository _string -> _int)
  git_reflog_free)

(define-libgit2/check git_reflog_rename
  (_fun _repository _string _string -> _int))

(define-libgit2/check git_reflog_write
  (_fun _reflog -> _int))
