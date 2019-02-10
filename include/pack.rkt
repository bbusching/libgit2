#lang racket

(require ffi/unsafe
         "types.rkt"
         "buffer.rkt"
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
  (_fun _packbuilder _git_packbuilder_foreach_cb _bytes -> _int))

(define-libgit2/dealloc git_packbuilder_free
  (_fun _packbuilder -> _void))

(define-libgit2 git_packbuilder_hash
  (_fun _packbuilder -> _oid))

(define-libgit2/check git_packbuilder_insert
  (_fun _packbuilder _oid _string -> _int))

(define-libgit2/check git_packbuilder_insert_commit
  (_fun _packbuilder _oid -> _int))

(define-libgit2/check git_packbuilder_insert_recur
  (_fun _packbuilder _oid _string -> _int))

(define-libgit2/check git_packbuilder_insert_tree
  (_fun _packbuilder _oid -> _int))

(define-libgit2/check git_packbuilder_insert_walk
  (_fun _packbuilder _revwalk -> _int))

(define-libgit2/alloc git_packbuilder_new
  (_fun _packbuilder _repository -> _int)
  git_packbuilder_free)

(define-libgit2 git_packbuilder_object_count
  (_fun _packbuilder -> _size))

(define-libgit2/check git_packbuilder_set_callbacks
  (_fun _packbuilder _git_packbuilder_progress _bytes -> _int))

(define-libgit2 git_packbuilder_set_threads
  (_fun _packbuilder _uint -> _uint))

(define-libgit2/check git_packbuilder_write
  (_fun _packbuilder _string _uint _git_transfer_progress_cb _bytes -> _int))

(define-libgit2 git_packbuilder_written
  (_fun _packbuilder -> _size))

(define-libgit2/check git_packbuilder_write_buf
  (_fun _buf _packbuilder -> _int))
