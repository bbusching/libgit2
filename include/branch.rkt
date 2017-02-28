#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "buffer.rkt")
(provide (all-defined-out))


(define-libgit2 git_branch_create
  (_fun (_cpointer _reference) _repository _string _commit _bool -> _int))
(define-libgit2 git_branch_create_from_annotated
  (_fun (_cpointer _reference) _repository _string _annotated_commit _bool -> _int))
(define-libgit2 git_branch_delete (_fun _reference -> _int))

(define _branch_iter (_cpointer 'git_branch_iterator))

(define-libgit2 git_branch_iterator_new
  (_fun (_cpointer _branch_iter) _repository _git_branch_t -> _int))
(define-libgit2 git_branch_next
  (_fun (_cpointer _branch_iter) (_cpointer _git_branch_t) _branch_iter -> _int))
(define-libgit2 git_branch_move
  (_fun (_cpointer _reference) _reference _string _bool -> _int))
(define-libgit2 git_branch_lookup
  (_fun (_cpointer _reference) _repository _string _git_branch_t -> _int))
(define-libgit2 git_branch_name
  (_fun (_cpointer _string) _reference -> _int))
(define-libgit2 git_branch_upstream
  (_fun (_cpointer _reference) _reference -> _int))
(define-libgit2 git_branch_set_upstream
  (_fun _reference _string -> _int))
(define-libgit2 git_branch_upstream_name
  (_fun _buf _repository _string -> _int))
(define-libgit2 git_branch_is_head
  (_fun _reference -> _bool))
(define-libgit2 git_branch_remote_name
  (_fun _buf _repository _string -> _int))
(define-libgit2 git_branch_upstream_remote
  (_fun _buf _repository _string -> _int))

