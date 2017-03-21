#lang racket

(require ffi/unsafe
         "define.rkt"
         "utils.rkt")
(provide (all-defined-out))

(define-cstruct _git_buf
  ([ptr _string]
   [asize _size]
   [size _size]))
(define _buf _git_buf-pointer)

(define-libgit2/dealloc git_buf_free (_fun _buf -> _void))
(define-libgit2/check git_buf_grow (_fun _buf _size -> _int))
(define-libgit2/check git_buf_set (_fun _buf _bytes _size -> _int))
(define-libgit2 git_buf_is_binary (_fun _buf -> _bool))
(define-libgit2 git_buf_contains_nul (_fun _buf -> _bool))
