#lang racket

(require ffi/unsafe
         "buffer.rkt"
         (only-in "types.rkt"
                  _git_repository
                  _git_blob
                  _git_writestream)
         libgit2/private)

(provide (all-defined-out))

; Types

(define _git_filter_mode_t
  (_enum '(GIT_FILTER_TO_WORKTREE = 0
           GIT_FILTER_SMUDGE = 0
           GIT_FILTER_TO_ODB = 1
           GIT_FILTER_CLEAN = 1)))

(define _git_filter_flag_t
  (_bitmask '(GIT_FILTER_DEFAULT = 0
              GIT_FILTER_ALLOW_UNSAFE = 1)))

(define _filter_list (_cpointer 'git_filter_list))

; Functions

(define-libgit2/dealloc git_filter_list_free
  (_fun _filter_list -> _void))

(define-libgit2/check git_filter_list_apply_to_blob
  (_fun _buf _filter_list _git_blob -> _int))

(define-libgit2/check git_filter_list_apply_to_data
  (_fun _buf _filter_list _buf -> _int))

(define-libgit2/check git_filter_list_apply_to_file
  (_fun _buf _filter_list _git_repository _string -> _int))

(define-libgit2 git_filter_list_contains
  (_fun _filter_list _string -> _bool))

(define-libgit2 git_filter_list_length
  (_fun _filter_list -> _size))

(define-libgit2/alloc git_filter_list_load
  (_fun _filter_list _git_repository _git_blob _string _git_filter_mode_t _uint32 -> _int)
  git_filter_list_free)

(define-libgit2/alloc git_filter_list_new
  (_fun _filter_list _git_repository _git_filter_mode_t _uint32 -> _int)
  git_filter_list_free)

(define-libgit2/check git_filter_list_stream_blob
  (_fun _filter_list _git_blob _git_writestream -> _int))

(define-libgit2/check git_filter_list_stream_data
  (_fun _filter_list _buf _git_writestream -> _int))

(define-libgit2/check git_filter_list_stream_file
  (_fun _filter_list _git_repository _string _git_writestream -> _int))
