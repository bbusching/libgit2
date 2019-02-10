#lang racket

(require ffi/unsafe
         "buffer.rkt"
         libgit2/private)
(provide (all-defined-out))


(define-libgit2/check git_message_prettify
  (_fun _buf _string _int _int8 -> _int))
