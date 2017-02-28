#lang racket

(require ffi/unsafe
         "define.rkt")
(provide (all-defined-out))

(define-cstruct _git_strarray
  ([strings (_cpointer _string)]
   [count _size]))
(define _strarray _git_strarray-pointer)

(define-libgit2 git_strarray_free
  (_fun _strarray -> _void))
(define-libgit2 git_strarray_copy
  (_fun _strarray _strarray -> _int))

