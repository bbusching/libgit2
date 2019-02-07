#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "utils.rkt")
(provide (all-defined-out))


; Types

(define _git_odb_stream_t
  (_enum '(GIT_STREAM_RDONLY = 2
           GIT_STREAM_WRONLY = 4
           GIT_STREAM_RW = 6)))

(define-cstruct _git_odb_stream
  ([backend _odb_backend]
   [mode _uint]
   [hash_ctx _bytes]
   [declared_size _git_off_t]
   [received_bytes _git_off_t]
   [read (_fun _git_odb_stream-pointer _string _size -> _int)]
   [write (_fun _git_odb_stream-pointer _string _size -> _int)]
   [finalize_write (_fun _git_odb_stream-pointer _oid -> _int)]
   [free (_fun _git_odb_stream-pointer -> _void)]))

(define-cstruct _git_odb_writepack
  ([backend _odb_backend]
   [append (_fun _git_odb_writepack-pointer _bytes _size _git_transfer_progress-pointer -> _int)]
   [commit (_fun _git_odb_writepack-pointer _git_transfer_progress-pointer -> _int)]
   [free (_fun _git_odb_writepack-pointer -> _void)]))

; Functions

(define-libgit2/alloc git_odb_backend_loose
  (_fun _odb_backend _string _int _int _uint _uint -> _int))

(define-libgit2/alloc git_odb_backend_one_pack
  (_fun _odb_backend _string -> _int))

(define-libgit2/alloc git_odb_backend_pack
  (_fun _odb_backend _string -> _int))

(define-libgit2/check git_odb_init_backend
  (_fun _odb_backend _uint -> _int))
