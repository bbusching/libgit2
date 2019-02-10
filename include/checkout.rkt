#lang racket

(require ffi/unsafe
         "types.rkt"
         "diff.rkt"
         "strarray.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define _git_checkout_strategy_t
  (_bitmask '(GIT_CHECKOUT_NONE = #x00000000
              GIT_CHECKOUT_SAFE = #x00000001
              GIT_CHECKOUT_FORCE = #x00000002
              GIT_CHECKOUT_RECREATE_MISSING = #x00000004
              GIT_CHECKOUT_ALLOW_CONFLICTS = #x00000010
              GIT_CHECKOUT_REMOVE_UNTRACKED = #x00000020
              GIT_CHECKOUT_REMOVE_IGNORED = #x00000040
              GIT_CHECKOUT_UPDATE_ONLY = #x00000080
              GIT_CHECKOUT_DONT_UPDATE_INDEX = #x00000100
              GIT_CHECKOUT_NO_REFRESH = #x00000200
              GIT_CHECKOUT_SKIP_UNMERGED = #x00000400
              GIT_CHECKOUT_USE_OURS = #x00000800
              GIT_CHECKOUT_USE_THEIRS = #x00001000
              GIT_CHECKOUT_DISABLE_PATHSPEC_MATCH = #x00002000
              GIT_CHECKOUT_SKIP_LOCKED_DIRECTORIES = #x00040000
              GIT_CHECKOUT_DONT_OVERWRITE_IGNORED = #x00080000
              GIT_CHECKOUT_CONFLICT_STYLE_MERGE = #x00100000
              GIT_CHECKOUT_CONFLICT_STYLE_DIFF3 = #x00200000
              GIT_CHECKOUT_DONT_REMOVE_EXISTING = #x00400000
              GIT_CHECKOUT_DONT_WRITE_INDEX = #x00800000)))

(define _git_checkout_notify_t
  (_bitmask '(GIT_CHECKOUT_NOTIFY_NONE = #x0000
              GIT_CHECKOUT_NOTIFY_CONFLICT = #x0001
              GIT_CHECKOUT_NOTIFY_DIRTY = #x0002
              GIT_CHECKOUT_NOTIFY_UPDATED = #x0004
              GIT_CHECKOUT_NOTIFY_UNTRACKED = #x0008
              GIT_CHECKOUT_NOTIFY_IGNORED = #x0010
              GIT_CHECKOUT_NOTIFY_ALL = #x0FFFF)))

(define-cstruct _git_checkout_perfdata
  ([mkdir_calls _size]
   [stat_calls _size]
   [chmod_calls _size]))

(define _git_checkout_notify_cb
  (_fun _git_checkout_notify_t _string _git_diff_file-pointer _git_diff_file-pointer _git_diff_file-pointer _bytes -> _int))
(define _git_checkout_progress_cb
  (_fun _string _size _size _bytes -> _void))
(define _git_checkout_perfdata_cb
  (_fun _git_checkout_perfdata-pointer _bytes -> _void))

(define-cstruct _git_checkout_opts
  ([version _uint]
   [checkout_strategy _git_checkout_strategy_t]
   [disable_filters _int]
   [dir_mode _uint]
   [file_mode _uint]
   [file_open_flags _int]
   [notify_flags _uint]
   [notify_cb _git_checkout_notify_cb]
   [notify_payload _bytes]
   [progress_cb _git_checkout_progress_cb]
   [progress_payload _bytes]
   [paths _strarray]
   [baseline _tree]
   [baseline_index _index]
   [target_directory _string]
   [ancestor_label _string]
   [our_label _string]
   [their_label _string]
   [perfdata_cb _git_checkout_perfdata_cb]
   [perfdata_payload _bytes]))

; Functions

(define-libgit2/check git_checkout_head
  (_fun _repository _git_checkout_opts-pointer/null -> _int))

(define-libgit2/check git_checkout_index
  (_fun _repository _index/null _git_checkout_opts-pointer/null -> _int))

(define-libgit2/check git_checkout_init_options
  (_fun _git_checkout_opts-pointer _uint -> _int))

(define-libgit2/check git_checkout_tree
  (_fun _repository _object/null _git_checkout_opts-pointer/null -> _int))
