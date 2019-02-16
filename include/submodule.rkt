#lang racket

(require ffi/unsafe
         ffi/unsafe/alloc
         "remote.rkt"
         "checkout.rkt"
         "buffer.rkt"
         "repository.rkt"
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository
                  _git_submodule
                  _git_submodule_recurse_t
                  _git_submodule_ignore_t
                  _git_submodule_update_t)
         libgit2/private)

(provide (all-defined-out))

; Types

(define-bitmask _git_submodule_status_t
  [GIT_SUBMODULE_STATUS_IN_HEAD = #x0001]
  [GIT_SUBMODULE_STATUS_IN_INDEX = #x0002]
  [GIT_SUBMODULE_STATUS_IN_CONFIG = #x0004]
  [GIT_SUBMODULE_STATUS_IN_WD = #x0008]
  [GIT_SUBMODULE_STATUS_INDEX_ADDED = #x0010]
  [GIT_SUBMODULE_STATUS_INDEX_DELETED = #x0020]
  [GIT_SUBMODULE_STATUS_INDEX_MODIFIED = #x0040]
  [GIT_SUBMODULE_STATUS_WD_UNITIALIZED = #x0080]
  [GIT_SUBMODULE_STATUS_WD_ADDED = #x0100]
  [GIT_SUBMODULE_STATUS_WD_DELETED = #x0200]
  [GIT_SUBMODULE_STATUS_WD_MODIFIED = #x0400]
  [GIT_SUBMODULE_STATUS_WD_INDEX_MODIFIED = #x0800]
  [GIT_SUBMODULE_STATUS_WD_WD_MODIFIED = #x1000]
  [GIT_SUBMODULE_STATUS_WD_UNTRACKED = #x2000])

(define _git_submodule_cb
  (_fun _git_submodule _string _bytes -> _int))

(define-cstruct _git_submodule_update_opts
  ([version _uint]
   [checkout_opts _git_checkout_opts]
   [fetch_opts _git_fetch_opts]
   [allow_fetch _int]))

(define GIT_SUBMODULE_UPDATE_OPTS_VERSION 1)

; Functions

(define-libgit2/check git_submodule_add_finalize
  (_fun _git_submodule -> _int))

(define-libgit2/alloc git_submodule_add_setup
  (_fun _git_submodule _git_repository _string _string _int -> _int))

(define-libgit2/check git_submodule_add_to_index
  (_fun _git_submodule -> _int))

(define-libgit2 git_submodule_branch
  (_fun _git_submodule -> _string))

(define-libgit2 git_submodule_fetch_recurse_submodules
  (_fun _git_submodule -> _git_submodule_recurse_t))

(define-libgit2/check git_submodule_foreach
  (_fun _git_repository _git_submodule_cb _bytes -> _int))

(define-libgit2/dealloc git_submodule_free
  (_fun _git_submodule -> _void))

(define-libgit2 git_submodule_head_id
  (_fun _git_submodule -> _git_oid-pointer))

(define-libgit2 git_submodule_ignore
  (_fun _git_submodule -> _git_submodule_ignore_t))

(define-libgit2 git_submodule_index_id
  (_fun _git_submodule -> _git_oid-pointer))

(define-libgit2/check git_submodule_init
  (_fun _git_submodule _bool -> _int))

(define-libgit2/alloc git_submodule_location
  (_fun _uint _git_submodule -> _int))

(define-libgit2/alloc git_submodule_lookup
  (_fun _git_submodule _git_repository _string -> _int)
  git_submodule_free)

(define-libgit2 git_submodule_name
  (_fun _git_submodule -> _string))

(define-libgit2/alloc git_submodule_open
  (_fun _git_repository _git_submodule -> _int)
  git_repository_free)

(define-libgit2 git_submodule_owner
  (_fun _git_submodule -> _git_repository)
  #:wrap (allocator git_repository_free))

(define-libgit2 git_submodule_path
  (_fun _git_submodule -> _string))

(define-libgit2/check git_submodule_reload
  (_fun _git_submodule _bool -> _int))

(define-libgit2/alloc git_submodule_repo_init
  (_fun _git_repository _git_submodule _bool -> _int))

(define-libgit2/check git_submodule_resolve_url
  (_fun _buf _git_repository _string -> _int))

(define-libgit2/check git_submodule_set_branch
  (_fun _git_repository _string _string -> _int))

(define-libgit2/check git_submodule_set_fetch_recurse_submodules
  (_fun _git_repository _string _git_submodule_recurse_t -> _int))

(define-libgit2/check git_submodule_set_ignore
  (_fun _git_repository _string _git_submodule_ignore_t -> _int))

(define-libgit2/check git_submodule_set_update
  (_fun _git_repository _string _git_submodule_update_t -> _int))

(define-libgit2/check git_submodule_set_url
  (_fun _git_repository _string _string -> _int))

(define-libgit2/alloc git_submodule_status
  (_fun _uint _git_repository _string _git_submodule_ignore_t -> _int))

(define-libgit2/check git_submodule_sync
  (_fun _git_submodule -> _int))

(define-libgit2/check git_submodule_update
  (_fun _git_submodule _bool _git_submodule_update_opts-pointer/null -> _int))

(define-libgit2/check git_submodule_update_init_options
  (_fun _git_submodule_update_opts-pointer _uint -> _int))

(define-libgit2 git_submodule_update_strategy
  (_fun _git_submodule -> _git_submodule_update_t))

(define-libgit2 git_submodule_url
  (_fun _git_submodule -> _string))

(define-libgit2 git_submodule_wd_id
  (_fun _git_submodule -> _git_oid-pointer/null))
