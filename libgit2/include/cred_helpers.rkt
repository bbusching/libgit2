#lang racket

(require ffi/unsafe
         "define.rkt"
         "transport.rkt")
(provide (all-defined-out))




(define-cstruct _git_cred_userpass_payload
  ([username _string]
   [password _string]))

(define-libgit2 git_cred_userpass
  (_fun (_cpointer _cred) _string _string _uint (_cpointer _void) -> _int))

