#lang racket

(require ffi/unsafe
         "types.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define-cstruct _git_oidarray
  ([oid _oid]
   [count _size]))
(define _oidarray _git_oidarray-pointer)

; Functions

(define-libgit2/dealloc git_oidarray_free
  (_fun _oidarray -> _void))
