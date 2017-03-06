#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "remote.rkt"
         "checkout.rkt"
         "buffer.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define _git_submodule_status_t
  (_bitmask '(GIT_SUBMODULE_STATUS_IN_HEAD = #x0001
              GIT_SUBMODULE_STATUS_IN_INDEX = #x0002
              GIT_SUBMODULE_STATUS_IN_CONFIG = #x0004
              GIT_SUBMODULE_STATUS_IN_WD = #x0008
              GIT_SUBMODULE_STATUS_INDEX_ADDED = #x0010
              GIT_SUBMODULE_STATUS_INDEX_DELETED = #x0020
              GIT_SUBMODULE_STATUS_INDEX_MODIFIED = #x0040
              GIT_SUBMODULE_STATUS_WD_UNITIALIZED = #x0080
              GIT_SUBMODULE_STATUS_WD_ADDED = #x0100
              GIT_SUBMODULE_STATUS_WD_DELETED = #x0200
              GIT_SUBMODULE_STATUS_WD_MODIFIED = #x0400
              GIT_SUBMODULE_STATUS_WD_INDEX_MODIFIED = #x0800
              GIT_SUBMODULE_STATUS_WD_WD_MODIFIED = #x1000
              GIT_SUBMODULE_STATUS_WD_UNTRACKED = #x2000)))

(define _git_submodule_cb
  (_fun _submodule _string (_cpointer _void) -> _int))

(define-cstruct _git_submodule_update_opts
  ([version _uint]
   [checkout_opts _git_checkout_opts]
   [fetch_opts _git_fetch_opts]
   [allow_fetch _int]))

(define-libgit2/check git_submodule_update_init_options
  (_fun _git_submodule_update_opts-pointer _uint -> _int))
(define-libgit2/check git_submodule_update
  (_fun _submodule _int _git_submodule_update_opts-pointer -> _int))
(define-libgit2/alloc git_submodule_lookup
  (_fun _submodule _repository _string -> _int))
(define-libgit2 git_submodule_free
  (_fun _submodule -> _void))
(define-libgit2/check git_submodule_foreach
  (_fun _repository _git_submodule_cb (_cpointer _void) -> _int))
(define-libgit2/alloc git_submodule_add_setup
  (_fun _submodule _repository _string _string _int -> _int))
(define-libgit2/check git_submodule_add_finalize
  (_fun _submodule -> _int))
(define-libgit2/check git_submodule_add_to_index
  (_fun _submodule -> _int))
(define-libgit2 git_submodule_owner
  (_fun _submodule -> _repository))
(define-libgit2 git_submodule_name
  (_fun _submodule -> _string))
(define-libgit2 git_submodule_path
  (_fun _submodule -> _string))
(define-libgit2 git_submodule_url
  (_fun _submodule -> _string))
(define-libgit2/check git_submodule_resolve_url
  (_fun _buf _repository _string -> _int))
(define-libgit2 git_submodule_branch
  (_fun _submodule -> _string))
(define-libgit2/check git_submodule_set_branch
  (_fun _repository _string _string -> _int))
(define-libgit2/check git_submodule_set_url
  (_fun _repository _string _string -> _int))
(define-libgit2 git_submodule_index_id
  (_fun _submodule -> _oid))
(define-libgit2 git_submodule_head_id
  (_fun _submodule -> _oid))
(define-libgit2 git_submodule_wd_id
  (_fun _submodule -> _oid))
(define-libgit2/check git_submodule_ignore
  (_fun _repository _string _git_submodule_ignore_t -> _int))
(define-libgit2 git_submodule_update_strategy
  (_fun _submodule -> _git_submodule_update_t))
(define-libgit2/check git_submodule_set_update
  (_fun _repository _string _git_submodule_update_t -> _int))
(define-libgit2 git_submodule_fetch_recurse_submodules
  (_fun _submodule -> _git_submodule_recurse_t))
(define-libgit2/check git_submodule_set_fetch_recurse_submodules
  (_fun _repository _string _git_submodule_recurse_t -> _int))
(define-libgit2/check git_submodule_init
  (_fun _submodule _int -> _int))
(define-libgit2/alloc git_submodule_repo_init
  (_fun _repository _submodule _int -> _int))
(define-libgit2/check git_submodule_sync
  (_fun _submodule -> _int))
(define-libgit2/alloc git_submodule_open
  (_fun _repository _submodule -> _int))
(define-libgit2/check git_submodule_reload
  (_fun _submodule _int -> _int))
(define-libgit2/alloc git_submodule_status
  (_fun _uint _repository _string _git_submodule_ignore_t -> _int))
(define-libgit2/alloc git_submodule_location
  (_fun _uint _submodule -> _int))

