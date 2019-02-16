#lang racket

(require ffi/unsafe
         "transport.rkt"
         (only-in "types.rkt"
                  _git_transport_certificate_check_cb)
         libgit2/private)

(provide (all-defined-out))

; Types

(define _git_proxy_t
  (_enum '(GIT_PROXY_NONE
           GIT_PROXY_AUTO
           GIT_PROXY_SPECIFIED)))

(define-cstruct _git_proxy_opts
  ([version _uint]
   [type _git_proxy_t]
   [url _string]
   [credentials _git_cred_acquire_cb]
   [certificate_check _git_transport_certificate_check_cb]
   [payload _bytes]))

(define GIT_PROXY_OPTS_VERSION 1)

; Functions

(define-libgit2/check git_proxy_init_options
  (_fun _git_proxy_opts-pointer _uint -> _int))
