#lang racket

(require ffi/unsafe
         (only-in "types.rkt"
                  _git_repository
                  _git_time_t
                  _git_signature-pointer)
         libgit2/private)

(provide (all-defined-out))

(define-libgit2/dealloc git_signature_free
  (_fun _git_signature-pointer -> _void))

(define-libgit2/alloc git_signature_default
  (_fun _git_signature-pointer _git_repository -> _int)
  git_signature_free)

(define-libgit2/alloc git_signature_dup
  (_fun _git_signature-pointer _git_signature-pointer -> _int)
  git_signature_free)

(define-libgit2/alloc git_signature_from_buffer
  (_fun _git_signature-pointer (_git_buf/bytes-or-null) -> _int)
  git_signature_free)

(define-libgit2/alloc git_signature_new
  (_fun _git_signature-pointer _string _string _git_time_t _int -> _int)
  git_signature_free)

(define-libgit2/alloc git_signature_now
  (_fun _git_signature-pointer _string _string -> _int)
  git_signature_free)
