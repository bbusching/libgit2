#lang racket

(require ffi/unsafe
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository
                  _git_note
                  _git_signature-pointer)
         libgit2/private)

(provide (all-defined-out))

; Types

(define _git_note_foreach_cb
  (_fun _git_oid-pointer _git_oid-pointer _bytes -> _int))

(define _note_iterator (_cpointer 'git_iterator))

; Functions

(define-libgit2 git_note_author
  (_fun _git_note -> _git_signature-pointer))

(define-libgit2 git_note_committer
  (_fun _git_note -> _git_signature-pointer))

(define-libgit2/check git_note_create
  (_fun _git_oid-pointer _git_repository _string _git_signature-pointer _git_signature-pointer _git_oid-pointer _git_note _int -> _int))

(define-libgit2/check git_note_foreach
  (_fun _git_repository _string _git_note_foreach_cb _bytes -> _int))

(define-libgit2/dealloc git_note_free
  (_fun _git_note -> _void))

(define-libgit2 git_note_id
  (_fun _git_note -> _git_oid-pointer))

(define-libgit2/dealloc git_note_iterator_free
  (_fun _note_iterator -> _void))

(define-libgit2/alloc git_note_iterator_new
  (_fun _note_iterator _git_repository _string -> _int)
  git_note_iterator_free)

(define-libgit2 git_note_message
  (_fun _git_note -> _string))

(define-libgit2/check git_note_next
  (_fun _git_oid-pointer _git_oid-pointer _note_iterator -> _int))

(define-libgit2/alloc git_note_read
  (_fun _git_note _git_repository _string _git_oid-pointer -> _int)
  git_note_free)

(define-libgit2/check git_note_remove
  (_fun _git_repository _string _git_signature-pointer _git_signature-pointer _git_oid-pointer -> _int))
