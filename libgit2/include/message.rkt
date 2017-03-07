#lang racket

(require ffi/unsafe
         "define.rkt"
         "buffer.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define-libgit2/check git_message_prettify
  (_fun _buf _string _int _int8 -> _int))
