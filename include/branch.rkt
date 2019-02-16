#lang racket

(require ffi/unsafe
         ffi/unsafe/alloc
         "buffer.rkt"
         "refs.rkt"
         (only-in "types.rkt"
                  _git_repository
                  _git_branch_t
                  _git_commit
                  _git_reference
                  _git_annotated_commit)
         libgit2/private)

(provide (all-defined-out))

; Types

(define _branch_iter (_cpointer 'git_branch_iterator))

; Functions

(define-libgit2/alloc git_branch_create
  (_fun _git_reference _git_repository _string _git_commit _bool -> _int)
  git_reference_free)

(define-libgit2/alloc git_branch_create_from_annotated
  (_fun _git_reference _git_repository _string _git_annotated_commit _bool -> _int)
  git_reference_free)

(define-libgit2/check git_branch_delete (_fun _git_reference -> _int))

(define-libgit2 git_branch_is_head
  (_fun _git_reference -> _bool))

(define-libgit2/dealloc git_branch_iterator_free
  (_fun _branch_iter -> _void))

(define-libgit2/alloc git_branch_iterator_new
  (_fun _branch_iter _git_repository _git_branch_t -> _int)
  git_branch_iterator_free)

(define-libgit2/alloc git_branch_lookup
  (_fun _git_reference _git_repository _string _git_branch_t -> _int)
  git_reference_free)

(define-libgit2/alloc git_branch_move
  (_fun _git_reference _git_reference _string _bool -> _int)
  git_reference_free)

(define-libgit2/alloc git_branch_name
  (_fun _string _git_reference -> _int)
  free)

(define-libgit2 git_branch_next
  (_fun (ref : (_ptr o _git_reference)) (type : (_ptr o _git_branch_t)) _branch_iter -> (v : _int)
        -> (check-git_error_code v (λ () (values ((allocator git_reference_free) ref) type)) 'git_branch_next)))

(define-libgit2/check git_branch_set_upstream
  (_fun _git_reference _string -> _int))

(define-libgit2/alloc git_branch_upstream
  (_fun _git_reference _git_reference -> _int)
  git_reference_free)

; the following exist in the source code but not in the reference.
; see https://github.com/libgit2/libgit2/blob/v0.25.1/include/git2/branch.h

(define-libgit2/check git_branch_upstream_name
  (_fun _buf _git_repository _string -> _int))

(define-libgit2/check git_branch_upstream_remote
  (_fun _buf _git_repository _string -> _int))

(define-libgit2/check git_branch_remote_name
  (_fun _buf _git_repository _string -> _int))
