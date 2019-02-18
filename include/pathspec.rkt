#lang racket

(require ffi/unsafe
         "strarray.rkt"
         "diff.rkt"
         (only-in "types.rkt"
                  _git_repository
                  _git_diff
                  _git_index
                  _git_tree)
         libgit2/private)

(provide (all-defined-out))

; Types

(define _pathspec (_cpointer 'git_pathspec))
(define _pathspec_match_list (_cpointer 'git_pathspec_match_list))

(define-bitmask _git_pathspec_flag_t
  [GIT_PATHSPEC_DEFAULT = #x0000]
  [GIT_PATHSPEC_IGNORE_CASE = #x0001]
  [GIT_PATHSPEC_USE_CASE = #x0002]
  [GIT_PATHSPEC_NO_GLOB = #x0004]
  [GIT_PATHSPEC_NO_MATCH_ERROR = #x0008]
  [GIT_PATHSPEC_FIND_FAILURES = #x0010]
  [GIT_PATHSPEC_FAILURES_ONLY = #x0020])

; Functions

(define-libgit2/dealloc git_pathspec_free
  (_fun _pathspec -> _void))

(define-libgit2/dealloc git_pathspec_match_list_free
  (_fun _pathspec_match_list -> _int))

(define-libgit2/alloc git_pathspec_match_diff
  (_fun _pathspec_match_list _git_diff _uint32 _pathspec -> _int)
  git_pathspec_match_list_free)

(define-libgit2/alloc git_pathspec_match_index
  (_fun _pathspec_match_list _git_index _uint32 _pathspec -> _int)
  git_pathspec_match_list_free)

(define-libgit2 git_pathspec_match_list_diff_entry
  (_fun _pathspec_match_list _size -> _git_diff_delta-pointer))

(define-libgit2 git_pathspec_match_list_entry
  (_fun _pathspec_match_list _size -> _string))

(define-libgit2 git_pathspec_match_list_entrycount
  (_fun _pathspec_match_list -> _size))

(define-libgit2 git_pathspec_match_list_failed_entry
  (_fun _pathspec_match_list _size -> _string))

(define-libgit2 git_pathspec_match_list_failed_entrycount
  (_fun _pathspec_match_list -> _size))

(define-libgit2/alloc git_pathspec_match_tree
  (_fun _pathspec_match_list _git_tree _uint32 _pathspec -> _int)
  git_pathspec_match_list_free)

(define-libgit2/alloc git_pathspec_match_workdir
  (_fun _pathspec_match_list _git_repository _uint32 _pathspec -> _int))

(define-libgit2 git_pathspec_matches_path
  (_fun _pathspec _uint32 _string -> _int))

(define-libgit2/alloc git_pathspec_new
  (_fun _pathspec _strarray -> _int )
  git_pathspec_free)
