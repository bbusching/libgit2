#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "buffer.rkt")
(provide (all-defined-out))


(define _git_note_foreach_cb
  (_fun _oid _oid (_cpointer _void) -> _int))

(define _note_iterator (_cpointer 'git_iterator))

(define-libgit2 git_note_iterator_new
  (_fun (_cpointer _note_iterator) _repository _string -> _int))
(define-libgit2 git_note_iterator_free
  (_fun _note_iterator -> _void))
(define-libgit2 git_note_next
  (_fun _oid _oid _note_iterator -> _int))
(define-libgit2 git_note_read
  (_fun (_cpointer _note) _repository _string _oid -> _int))
(define-libgit2 git_note_author
  (_fun _note -> _signature))
(define-libgit2 git_note_committer
  (_fun _note -> _signature))
(define-libgit2 git_note_message
  (_fun _note -> _string))
(define-libgit2 git_note_id
  (_fun _note -> _oid))
(define-libgit2 git_note_create
  (_fun _oid _repository _string _signature _signature _oid _note _int -> _int))
(define-libgit2 git_note_remove
  (_fun _repository _string _signature _signature _oid -> _int))
(define-libgit2 git_note_free
  (_fun _note -> _void))
(define-libgit2 git_note_default_ref
  (_fun _buf _repository -> _int))
(define-libgit2 git_note_foreach
  (_fun _repository _string _git_note_foreach_cb (_cpointer _void) -> _int))

