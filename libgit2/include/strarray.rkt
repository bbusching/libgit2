#lang racket

(require ffi/unsafe
         "define.rkt"
         "utils.rkt")
(provide (all-defined-out))

; Types

(define-cstruct _git_strarray
  ([strings (_cpointer _string)]
   [count _size]))
(define _strarray _git_strarray-pointer)
(define _strarray/null _git_strarray-pointer/null)

; Functions

(define-libgit2/dealloc git_strarray_free
  (_fun _strarray -> _void))

(define-libgit2/check git_strarray_copy
  (_fun _strarray _strarray -> _int))
