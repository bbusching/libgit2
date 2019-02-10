#lang racket

(require ffi/unsafe
         "transport.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define-cstruct _git_cred_userpass_payload
  ([username _string]
   [password _string]))
