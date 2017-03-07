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

; Functions

(define-libgit2/alloc git_cred_userpass
  (_fun _cred _string _string _uint (_cpointer _void) -> _int)
  git_cred_free)
