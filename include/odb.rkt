#lang racket

(require ffi/unsafe
         "types.rkt"
         libgit2/private)
(provide (all-defined-out))

; Types

(define _git_odb_foreach_cb
  (_fun _oid _bytes -> _int))

(define-cstruct _git_odb_expand_id
  ([id _oid]
   [length _ushort]
   [type _git_object_t]))
(define _odb_expand_id _git_odb_expand_id-pointer)

; Functions

(define-libgit2/check git_odb_add_alternate
  (_fun _odb _odb_backend _int -> _int))

(define-libgit2/check git_odb_add_backend
  (_fun _odb _odb_backend _int -> _int))

(define-libgit2/check git_odb_add_disk_alternate
  (_fun _odb _string -> _int))

(define-libgit2 git_odb_exists
  (_fun _odb _oid -> _bool))

(define-libgit2 git_odb_exists_prefix
  (_fun _oid _odb _oid _size -> _bool))

(define-libgit2/check git_odb_expand_ids
  (_fun _odb _odb_expand_id _size -> _int))

(define-libgit2/check git_odb_foreach
  (_fun _odb _git_odb_foreach_cb _bytes -> _int))

(define-libgit2/dealloc git_odb_free
  (_fun _odb -> _void))

(define-libgit2/alloc git_odb_get_backend
  (_fun _odb_backend _odb _size -> _int))

(define-libgit2/check git_odb_hash
  (_fun _oid _bytes _size _git_object_t -> _int))

(define-libgit2/check git_odb_hashfile
  (_fun _oid _string _git_object_t -> _int))

(define-libgit2/alloc git_odb_new
  (_fun _odb -> _int)
  git_odb_free)

(define-libgit2 git_odb_num_backends
  (_fun _odb -> _size))

(define-libgit2 git_odb_object_data
  (_fun _odb_object -> _bytes))

(define-libgit2/dealloc git_odb_object_free
  (_fun _odb_object -> _void))

(define-libgit2/alloc git_odb_object_dup
  (_fun _odb_object _odb_object -> _int)
  git_odb_object_free)

(define-libgit2 git_odb_object_id
  (_fun _odb_object -> _oid))

(define-libgit2 git_odb_object_size
  (_fun _odb_object -> _size))

(define-libgit2 git_odb_object_type
  (_fun _odb_object -> _git_object_t))

(define-libgit2/alloc git_odb_open
  (_fun _odb _string -> _int))

(define-libgit2/alloc git_odb_open_rstream
  (_fun _odb_stream _odb _oid -> _int))

(define-libgit2/alloc git_odb_open_wstream
  (_fun _odb_stream _odb _git_off_t _git_object_t -> _int))

(define-libgit2/alloc git_odb_read
  (_fun _odb_object _odb _oid -> _int)
  git_odb_object_free)

(define-libgit2/check git_odb_read_header
  (_fun (_cpointer _size) (_cpointer _git_object_t) _odb _oid -> _int))

(define-libgit2/alloc git_odb_read_prefix
  (_fun _odb_object _odb _oid _size -> _int)
  git_odb_object_free)

(define-libgit2/check git_odb_refresh
  (_fun _odb -> _int))

(define-libgit2/check git_odb_stream_finalize_write
  (_fun _oid _odb_stream -> _int))

(define-libgit2 git_odb_stream_free
  (_fun _odb_stream -> _void))

(define-libgit2/check git_odb_stream_read
  (_fun _odb_stream _string _size -> _int))

(define-libgit2/check git_odb_stream_write
  (_fun _odb_stream _string _size -> _int))

(define-libgit2/check git_odb_write
  (_fun _oid _odb _bytes _size _git_object_t -> _int))

(define-libgit2/alloc git_odb_write_pack
  (_fun _odb_writepack _odb _git_transfer_progress_cb _bytes -> _int))
