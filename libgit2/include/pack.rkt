#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "buffer.rkt")
(provide (all-defined-out))


(define _git_packbuilder_stage_t
  (_enum '(GIT_PACKBUILDER_ADDING_OBJECTS
           GIT_PACKBUILDER_DELTAFICATION)))

(define-libgit2 git_packbuilder_new
  (_fun (_cpointer _packbuilder) _repository -> _int))
(define-libgit2 git_packbuilder_set_threads
  (_fun _packbuilder _uint -> _uint))
(define-libgit2 git_packbuilder_insert
  (_fun _packbuilder _oid _string -> _int))
(define-libgit2 git_packbuilder_insert_tree
  (_fun _packbuilder _oid -> _int))
(define-libgit2 git_packbuilder_insert_commit
  (_fun _packbuilder _oid -> _int))
(define-libgit2 git_packbuilder_insert_walk
  (_fun _packbuilder _revwalk -> _int))
(define-libgit2 git_packbuilder_insert_recur
  (_fun _packbuilder _oid _string -> _int))
(define-libgit2 git_packbuilder_write_buf
  (_fun _buf _packbuilder -> _int))
(define-libgit2 git_packbuilder_write
  (_fun _packbuilder _string _uint _git_transfer_progress_cb (_cpointer _void) -> _int))
(define-libgit2 git_packbuilder_hash
  (_fun _packbuilder -> _oid))

(define _git_packbuilder_foreach_cb
  (_fun (_cpointer _void) _size (_cpointer _void) -> _int))

(define-libgit2 git_packbuilder_foreach
  (_fun _packbuilder _git_packbuilder_foreach_cb (_cpointer _void) -> _int))
(define-libgit2 git_packbuilder_written
  (_fun _packbuilder -> _size))

(define _git_packbuilder_progress
  (_fun _int _uint32 _uint32 (_cpointer _void) -> _int))

(define-libgit2 git_packbuilder_set_callbacks
  (_fun _packbuilder _git_packbuilder_progress (_cpointer _void) -> _int))
(define-libgit2 git_packbuilder_free
  (_fun _packbuilder -> _void))

