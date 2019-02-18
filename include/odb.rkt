#lang racket

(require ffi/unsafe
         (submod "oid.rkt" private)
         (only-in "odb_backend.rkt"
                  _git_odb_stream-pointer
                  _git_odb_writepack-pointer)
         (only-in "types.rkt"
                  _git_object_t
                  _git_off_t
                  _git_odb
                  _git_odb_backend
                  _git_odb_object
                  _git_transfer_progress_cb)
         libgit2/private)

(provide (all-defined-out))

; Types

(define _git_odb_foreach_cb
  (_fun _git_oid-pointer _bytes -> _int))

(define-cstruct _git_odb_expand_id
  ([id _git_oid-pointer]
   [length _ushort]
   [type _git_object_t]))
(define _odb_expand_id _git_odb_expand_id-pointer)

; Functions

(define-libgit2/check git_odb_add_alternate
  (_fun _git_odb _git_odb_backend _int -> _int))

(define-libgit2/check git_odb_add_backend
  (_fun _git_odb _git_odb_backend _int -> _int))

(define-libgit2/check git_odb_add_disk_alternate
  (_fun _git_odb _string -> _int))

(define-libgit2 git_odb_exists
  (_fun _git_odb _git_oid-pointer -> _bool))

(define-libgit2 git_odb_exists_prefix
  (_fun _git_oid-pointer _git_odb _git_oid-pointer _size -> _bool))

(define-libgit2/check git_odb_expand_ids
  (_fun _git_odb _odb_expand_id _size -> _int))

(define-libgit2/check git_odb_foreach
  (_fun _git_odb _git_odb_foreach_cb _bytes -> _int))

(define-libgit2/dealloc git_odb_free
  (_fun _git_odb -> _void))

(define-libgit2/alloc git_odb_get_backend
  (_fun _git_odb_backend _git_odb _size -> _int))

(define-libgit2/check git_odb_hash
  (_fun _git_oid-pointer _bytes _size _git_object_t -> _int))

(define-libgit2/check git_odb_hashfile
  (_fun _git_oid-pointer _string _git_object_t -> _int))

(define-libgit2/alloc git_odb_new
  (_fun _git_odb -> _int)
  git_odb_free)

(define-libgit2 git_odb_num_backends
  (_fun _git_odb -> _size))

(define-libgit2 git_odb_object_data
  (_fun _git_odb_object -> _bytes))

(define-libgit2/dealloc git_odb_object_free
  (_fun _git_odb_object -> _void))

(define-libgit2/alloc git_odb_object_dup
  (_fun _git_odb_object _git_odb_object -> _int)
  git_odb_object_free)

(define-libgit2 git_odb_object_id
  (_fun _git_odb_object -> _git_oid-pointer))

(define-libgit2 git_odb_object_size
  (_fun _git_odb_object -> _size))

(define-libgit2 git_odb_object_type
  (_fun _git_odb_object -> _git_object_t))

(define-libgit2/alloc git_odb_open
  (_fun _git_odb _string -> _int))

(define-libgit2/alloc git_odb_open_rstream
  (_fun _git_odb_stream-pointer _git_odb _git_oid-pointer -> _int))

(define-libgit2/alloc git_odb_open_wstream
  (_fun _git_odb_stream-pointer _git_odb _git_off_t _git_object_t -> _int))

(define-libgit2/alloc git_odb_read
  (_fun _git_odb_object _git_odb _git_oid-pointer -> _int)
  git_odb_object_free)

(define-libgit2/check git_odb_read_header
  (_fun (_cpointer _size) (_cpointer _git_object_t) _git_odb _git_oid-pointer -> _int))

(define-libgit2/alloc git_odb_read_prefix
  (_fun _git_odb_object _git_odb _git_oid-pointer _size -> _int)
  git_odb_object_free)

(define-libgit2/check git_odb_refresh
  (_fun _git_odb -> _int))

(define-libgit2/check git_odb_stream_finalize_write
  (_fun _git_oid-pointer _git_odb_stream-pointer -> _int))

(define-libgit2 git_odb_stream_free
  (_fun _git_odb_stream-pointer -> _void))

(define-libgit2/check git_odb_stream_read
  (_fun _git_odb_stream-pointer _string _size -> _int))

(define-libgit2/check git_odb_stream_write
  (_fun _git_odb_stream-pointer _string _size -> _int))

(define-libgit2/check git_odb_write
  (_fun _git_oid-pointer _git_odb _bytes _size _git_object_t -> _int))

(define-libgit2/alloc git_odb_write_pack
  (_fun _git_odb_writepack-pointer _git_odb _git_transfer_progress_cb _bytes -> _int))
