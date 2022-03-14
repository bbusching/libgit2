#lang racket

(require ffi/unsafe
         "transport.rkt"
         (only-in "types.rkt"
                  _git_transport_certificate_check_cb)
         "../private/base.rkt")

(provide (all-defined-out))

; Types

(define-enum _git_proxy_t
  GIT_PROXY_NONE
  GIT_PROXY_AUTO
  GIT_PROXY_SPECIFIED)

(define-cstruct _git_proxy_options
  ([version _uint]
   [type _git_proxy_t]
   [url _string]
   [credentials _git_credential_acquire_cb]
   [certificate_check _git_transport_certificate_check_cb]
   [payload _bytes]))

(define GIT_PROXY_OPTIONS_VERSION 1)

; Functions

(define-libgit2/check git_proxy_options_init
  (_fun _git_proxy_options-pointer _uint -> _int))
