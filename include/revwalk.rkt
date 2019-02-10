#lang racket

(require ffi/unsafe
         "types.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define _git_sort_t
  (_bitmask '(GIT_SORT_NONE = 0
              GIT_SORT_TOPOLOGICAL = 1
              GIT_SORT_TIME = 2
              GIT_SORT_REVERSE = 4)))

(define _git_revwalk_hide_cb
  (_fun _oid _bytes -> _int))

; Functions

(define-libgit2/check git_revwalk_add_hide_cb
  (_fun _revwalk _git_revwalk_hide_cb _bytes -> _int))

(define-libgit2/dealloc git_revwalk_free
  (_fun _revwalk -> _void))

(define-libgit2/check git_revwalk_hide
  (_fun _revwalk _oid -> _int))

(define-libgit2/check git_revwalk_hide_glob
  (_fun _revwalk _string -> _int))

(define-libgit2/check git_revwalk_hide_head
  (_fun _revwalk -> _int))

(define-libgit2/check git_revwalk_hide_ref
  (_fun _revwalk _string -> _int))

(define-libgit2/alloc git_revwalk_new
  (_fun _revwalk _repository -> _int)
  git_revwalk_free)

(define-libgit2/check git_revwalk_next
  (_fun _oid _revwalk -> _int))

(define-libgit2/check git_revwalk_push
  (_fun _revwalk _oid -> _int))

(define-libgit2/check git_revwalk_push_glob
  (_fun _revwalk _string -> _int))

(define-libgit2/check git_revwalk_push_head
  (_fun _revwalk -> _int))

(define-libgit2/check git_revwalk_push_range
  (_fun _revwalk _string -> _int))

(define-libgit2/check git_revwalk_push_ref
  (_fun _revwalk _string -> _int))

(define-libgit2 git_revwalk_repository
  (_fun _revwalk -> _repository))

(define-libgit2 git_revwalk_reset
  (_fun _revwalk -> _void))

(define-libgit2 git_revwalk_simplify_first_parent
  (_fun _revwalk -> _void))

(define-libgit2 git_revwalk_sorting
  (_fun _revwalk _git_sort_t -> _void))
