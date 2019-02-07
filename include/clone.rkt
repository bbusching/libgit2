#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "checkout.rkt"
         "remote.rkt"
         "repository.rkt"
         "utils.rkt")
(provide (all-defined-out))


; Types

(define _git_clone_local_t
  (_enum '(GIT_CLONE_LOCAL_AUTO
           GIT_CLONE_LOCAL
           GIT_CLONE_NO_LOCAL
           GIT_CLONE_LOCAL_NO_LINKS)))

(define _git_remote_create_cb
  (_fun (_cpointer _remote) _repository _string _string _bytes -> _int))
(define _git_repository_create_cb
  (_fun (_cpointer _repository) _string _int _bytes -> _int))

(define-cstruct _git_clone_opts
  ([version _uint]
   [checkout_opts _git_checkout_opts]
   [fetch_opts _git_fetch_opts]
   [bare _int]
   [local _git_clone_local_t]
   [checkout_branch _string]
   [repository_cb _git_repository_create_cb]
   [repository_cb_payload _bytes]
   [remote_cb _git_remote_create_cb]
   [remote_cb_payload _bytes]))

(define GIT_CLONE_OPTS_VERSION 1)

; Functions

(define-libgit2/alloc git_clone
  (_fun _repository _string _string _git_clone_opts-pointer/null -> _int)
  git_repository_free)

(define-libgit2/check git_clone_init_options
  (_fun _git_clone_opts-pointer _uint -> _int))

