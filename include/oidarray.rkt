#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt")
(provide (all-defined-out))


(define-cstruct _git_oidarray
  ([oid _oid]
   [count _size]))
(define _oidarray _git_oidarray-pointer)

(define-libgit2 git_oidarray_free
  (_fun _oidarray -> _void))

