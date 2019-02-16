#lang racket

(require ffi/unsafe
         "buffer.rkt"
         libgit2/private)

(provide git_message_prettify)

(define-libgit2/check git_message_prettify
  (_fun _buf _string _int _int8 -> _int))
