#lang racket/base

(define-syntax-rule (require-provide mod ...)
  (begin (require mod ...) (provide (all-from-out mod) ...)))

(provide require-provide)

(require-provide "private/base.rkt"
                 "private/buffer.rkt")
         