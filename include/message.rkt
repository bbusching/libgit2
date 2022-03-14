#lang racket

(require ffi/unsafe
         "../private/buffer.rkt"
         "../private/base.rkt")

(provide git_message_prettify)

(define-libgit2/check git_message_prettify
  (_fun (_git_buf/bytes-or-null) _string _int _int8 -> _int))
