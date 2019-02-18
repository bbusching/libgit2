#lang racket

(require ffi/unsafe
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository
                  _git_transfer_progress_cb
                  _git_packbuilder
                  _git_revwalk)
         libgit2/private)

(provide (all-defined-out))

; Types

(define _git_packbuilder_stage_t
  (_enum '(GIT_PACKBUILDER_ADDING_OBJECTS
           GIT_PACKBUILDER_DELTAFICATION)))

(define _git_packbuilder_foreach_cb
  (_fun _bytes _size _bytes -> _int))

(define _git_packbuilder_progress
  (_fun _int _uint32 _uint32 _bytes -> _int))

; Functions

(define-libgit2/check git_packbuilder_foreach
  (_fun _git_packbuilder _git_packbuilder_foreach_cb _bytes -> _int))

(define-libgit2/dealloc git_packbuilder_free
  (_fun _git_packbuilder -> _void))

(define-libgit2 git_packbuilder_hash
  (_fun _git_packbuilder -> _git_oid-pointer))

(define-libgit2/check git_packbuilder_insert
  (_fun _git_packbuilder _git_oid-pointer _string -> _int))

(define-libgit2/check git_packbuilder_insert_commit
  (_fun _git_packbuilder _git_oid-pointer -> _int))

(define-libgit2/check git_packbuilder_insert_recur
  (_fun _git_packbuilder _git_oid-pointer _string -> _int))

(define-libgit2/check git_packbuilder_insert_tree
  (_fun _git_packbuilder _git_oid-pointer -> _int))

(define-libgit2/check git_packbuilder_insert_walk
  (_fun _git_packbuilder _git_revwalk -> _int))

(define-libgit2/alloc git_packbuilder_new
  (_fun _git_packbuilder _git_repository -> _int)
  git_packbuilder_free)

(define-libgit2 git_packbuilder_object_count
  (_fun _git_packbuilder -> _size))

(define-libgit2/check git_packbuilder_set_callbacks
  (_fun _git_packbuilder _git_packbuilder_progress _bytes -> _int))

(define-libgit2 git_packbuilder_set_threads
  (_fun _git_packbuilder _uint -> _uint))

(define-libgit2/check git_packbuilder_write
  (_fun _git_packbuilder _string _uint _git_transfer_progress_cb _bytes -> _int))

(define-libgit2 git_packbuilder_written
  (_fun _git_packbuilder -> _size))

(define-libgit2/check git_packbuilder_write_buf
  (_fun (_git_buf/bytes-or-null) _git_packbuilder -> _int))
