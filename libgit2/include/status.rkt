#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "diff.rkt"
         "strarray.rkt"
         "utils.rkt")
(provide (all-defined-out))


; Types

(define _git_status_t
  (_bitmask '(GIT_STATUS_CURRENT = 0
              GIT_STATUS_INDEX_NEW = #x0001
              GIT_STATUS_INDEX_MODIFIED = #x0002
              GIT_STATUS_INDEX_DELETED = #x0004
              GIT_STATUS_INDEX_RENAMED = #x0008
              GIT_STATUS_INDEX_TYPECHANGE = #x0010
              GIT_STATUS_WT_NEW = #x0080
              GIT_STATUS_WT_MODIFIED = #x0100
              GIT_STATUS_WT_DELETED = #x0200
              GIT_STATUS_WT_TYPECHANGE = #x0400
              GIT_STATUS_WT_RENAMED = #x0800
              GIT_STATUS_WT_UNREADABLE = #x1000
              GIT_STATUS_IGNORED = #x4000
              GIT_STATUS_CONFLICTED = #x8000)))

(define _git_status_cb
  (_fun _string _git_status_t _bytes -> _int))

(define _git_status_show_t
  (_enum '(GIT_STATUS_SHOW_INDEX_AND_WORKDIR = 0
           GIT_STATUS_SHOW_INDEX_ONLY
           GIT_STATUS_SHOW_WORKDIR_ONLY)))

(define _git_status_opt_t
  (_bitmask '(GIT_STATUS_OPT_INCLUDE_UNTRACKED = #x0001
              GIT_STATUS_OPT_INCLUDE_IGNORED = #x0002
              GIT_STATUS_OPT_INCLUDE_UNMODIFIED = #x0004
              GIT_STATUS_OPT_EXCLUDE_SUBMODULES = #x0008
              GIT_STATUS_OPT_RECURSE_UNTRACKED_DIRS = #x0010
              GIT_STATUS_OPT_DISABLE_PATHSPEC_MATCH = #x0020
              GIT_STATUS_OPT_RECURSE_IGNORED_DIRS = #x0040
              GIT_STATUS_OPT_RENAMES_HEAD_TO_INDEX = #x0080
              GIT_STATUS_OPT_RENAMES_INDEX_TO_WORKDIR = #x0100
              GIT_STATUS_OPT_SORT_CASE_SENSITIVELY = #x0200
              GIT_STATUS_OPT_SORT_CASE_INSENSITIVELY = #x0400
              GIT_STATUS_OPT_RENAMES_FROM_REWRITES = #x0800
              GIT_STATUS_OPT_NO_REFRESH = #x1000
              GIT_STATUS_OPT_UPDATE_INDEX = #x2000
              GIT_STATUS_OPT_INCLUDE_UNREADABLE = #x4000
              GIT_STATUS_OPT_INCLUDE_UNREADABLE_AS_UNTRACKED = #x8000)))

(define GIT_STATUS_OPT_DEFAULTS
  '(GIT_STATUS_OPT_INCLUDE_IGNORED
    GIT_STATUS_OPT_INCLUDE_UNTRACKED
    GIT_STATUS_OPTS_RECURSE_UNTRACKED_DIRS))

(define-cstruct _git_status_opts
  ([version _uint]
   [show _git_status_show_t]
   [flags _uint]
   [pathspec _strarray]))

(define GIT_STATUS_OPTS_VERSION 1)

(define-cstruct _git_status_entry
  ([status _git_status_t]
   [head_to_index _git_diff_delta-pointer]
   [index_to_workdir _git_diff_delta-pointer]))

; Functions

(define-libgit2 git_status_byindex
  (_fun _status_list _size -> _git_status_entry-pointer/null))

(define-libgit2/alloc git_status_file
  (_fun _uint _repository _string -> _int))

(define-libgit2/check git_status_foreach
  (_fun _repository _git_status_cb _bytes -> _int))

(define-libgit2/check git_status_foreach_ext
  (_fun _repository _git_status_opts-pointer _git_status_cb _bytes -> _int))

(define-libgit2/check git_status_init_options
  (_fun _git_status_opts-pointer _uint -> _int))

(define-libgit2 git_status_list_entrycount
  (_fun _status_list -> _size))

(define-libgit2/dealloc git_status_list_free
  (_fun _status_list -> _void))

(define-libgit2/alloc git_status_list_new
  (_fun _status_list _repository _git_status_opts-pointer -> _int)
  git_status_list_free)

(define-libgit2/alloc git_status_should_ignore
  (_fun _bool _repository _string -> _int))
