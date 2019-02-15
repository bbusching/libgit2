#lang racket

(require ffi/unsafe
         (submod "oid.rkt" private)
         libgit2/private)

(provide (all-defined-out))

;; only used by git_merge_bases and git_merge_bases_many

; Types

(define-cstruct _git_oidarray
  ([oid _git_oid-pointer]
   [count _size]))
(define _oidarray _git_oidarray-pointer)

; Functions

(define-libgit2/dealloc git_oidarray_free
  (_fun _oidarray -> _void))
