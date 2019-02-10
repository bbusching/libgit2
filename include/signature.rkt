#lang racket

(require ffi/unsafe
         "types.rkt"
         "buffer.rkt"
         libgit2/private)
(provide (all-defined-out))


(define-libgit2/dealloc git_signature_free
  (_fun _signature -> _void))

(define-libgit2/alloc git_signature_default
  (_fun _signature _repository -> _int)
  git_signature_free)

(define-libgit2/alloc git_signature_dup
  (_fun _signature _signature -> _int)
  git_signature_free)

(define-libgit2/alloc git_signature_from_buffer
  (_fun _signature _buf -> _int)
  git_signature_free)

(define-libgit2/alloc git_signature_new
  (_fun _signature _string _string _git_time_t _int -> _int)
  git_signature_free)

(define-libgit2/alloc git_signature_now
  (_fun _signature _string _string -> _int)
  git_signature_free)
