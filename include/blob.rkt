#lang racket

(require ffi/unsafe
         ffi/unsafe/alloc
         "repository.rkt"
         (submod "oid.rkt" private)
         (submod "repository.rkt" free) ;; TODO avoid this
         (only-in "types.rkt"
                  _git_repository
                  _git_off_t
                  _git_blob
                  _git_writestream)
         "../private/base.rkt")

(provide (all-defined-out))

(define-libgit2/dealloc git_blob_free
  (_fun _git_blob -> _void))

(define-libgit2/check git_blob_create_from_buffer
  (_fun _git_oid-pointer _git_repository _bytes _size -> _int))

(define-libgit2/check git_blob_create_from_disk
  (_fun _git_oid-pointer _git_repository _string -> _int))

(define-libgit2/alloc git_blob_create_from_stream
  (_fun _git_writestream _git_repository _string -> _int))

(define-libgit2/check git_blob_create_from_stream_commit
  (_fun _git_oid-pointer _git_writestream -> _int))

(define-libgit2/check git_blob_create_from_workdir
  (_fun _git_oid-pointer _git_repository _string -> _int))

(define-libgit2/alloc git_blob_dup
  (_fun _git_blob _git_blob -> _int)
  git_blob_free)


(define-libgit2 git_blob_id
  (_fun _git_blob -> _git_oid-pointer))

(define-libgit2 git_blob_is_binary
  (_fun _git_blob -> _bool))

(define-libgit2/alloc git_blob_lookup
  (_fun _git_blob _git_repository _git_oid-pointer -> _int)
  git_blob_free)

(define-libgit2/alloc git_blob_lookup_prefix
  (_fun _git_blob _git_repository _git_oid-pointer _size -> _int)
  git_blob_free)

(define-libgit2 git_blob_owner
  (_fun _git_blob -> _git_repository)
  #:wrap (allocator git_repository_free))

(define-libgit2 git_blob_rawcontent
  (_fun _git_blob -> _bytes))

(define-libgit2 git_blob_rawsize
  (_fun _git_blob -> _git_off_t))
