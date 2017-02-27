#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "buffer.rkt")
(provide (all-defined-out))


(define-libgit2 git_signature_new
  (_fun (_cpointer _signature) _string _string _git_time_t _int -> _int))
(define-libgit2 git_signature_now
  (_fun (_cpointer _signature) _string _string -> _int))
(define-libgit2 git_signature_default
  (_fun (_cpointer _signature) _repository -> _int))
(define-libgit2 git_signature_from_buffer
  (_fun (_cpointer _signature) _buf -> _int))
(define-libgit2 git_signature_dup
  (_fun (_cpointer _signature) _signature -> _int))
(define-libgit2 git_signature_free
  (_fun _signature -> _void))

