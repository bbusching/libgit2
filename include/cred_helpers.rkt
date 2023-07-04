#lang racket

(require ffi/unsafe
         "transport.rkt"
         "../private/base.rkt")

(provide (all-defined-out))


; Types

(define-cstruct _git_cred_userpass_payload
  ;; FIXME is this deprecated?
  ([username _string]
   [password _string]))
