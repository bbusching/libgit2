#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "object.rkt"
         "buffer.rkt")
(provide (all-defined-out))


(define-libgit2 git_blob_lookup
  (_fun (_cpointer _blob) _repository _oid -> _int))
(define-libgit2 git_blob_lookup_prefix
  (_fun (_cpointer _blob) _repository _oid _size -> _int))
(define-libgit2 git_blob_free
  (_fun _blob -> _void))
(define-libgit2 git_blob_id
  (_fun _blob -> _oid))
(define-libgit2 git_blob_owner
  (_fun _blob -> _repository))
(define-libgit2 git_blob_rawcontent
  (_fun _blob -> (_cpointer _void)))
(define-libgit2 git_blob_rawsize
  (_fun _blob -> _git_off_t))
(define-libgit2 git_blob_filtered_content
  (_fun _buf _blob _string _int -> _int))
(define-libgit2 git_blob_create_fromworkdir
  (_fun _oid _repository _string -> _int))
(define-libgit2 git_blob_create_fromdisk
  (_fun _oid _repository _string -> _int))
(define-libgit2 git_blob_create_fromstream
  (_fun (_cpointer _writestream) _repository _string -> _int))
(define-libgit2 git_blob_create_fromstream_commit
  (_fun _oid _writestream -> _int))
(define-libgit2 git_blob_create_frombuffer
  (_fun _oid _repository (_cpointer _void) _size -> _int))
(define-libgit2 git_blob_is_binary
  (_fun _blob -> _bool))
(define-libgit2 git_blob_dup
  (_fun (_cpointer _blob) _blob -> _int))

