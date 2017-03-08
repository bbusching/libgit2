#lang racket

(require ffi/unsafe
         "define.rkt"
         "transport.rkt"
         "utils.rkt")
(provide (all-defined-out))


; Types

(define-cstruct _git_cred_userpass_payload
  ([username _string]
   [password _string]))
