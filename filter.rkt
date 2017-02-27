#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "buffer.rkt")
(provide (all-defined-out))


(define _git_filter_mode_t
  (_enum '(GIT_FILTER_TO_WORKTREE = 0
           GIT_FILTER_SMUDGE = 0
           GIT_FILTER_TO_ODB = 1
           GIT_FILTER_CLEAN = 1)))

(define _git_filter_flag_t
  (_bitmask '(GIT_FILTER_DEFAULT = 0
              GIT_FILTER_ALLOW_UNSAFE = 1)))

(define _filter (_cpointer 'git_filter))

(define-libgit2 git_filter_list_load
  (_fun (_cpointer _filter) _repository _blob _string _git_filter_mode_t _uint32 -> _int))
(define-libgit2 git_filter_list_contains
  (_fun _filter _string -> _bool))
(define-libgit2 git_filter_list_apply_to_data
  (_fun _buf _filter _buf -> _int))
(define-libgit2 git_filter_list_apply_to_file
  (_fun _buf _filter _repository _string -> _int))
(define-libgit2 git_filter_list_apply_to_blob
  (_fun _buf _filter _blob -> _int))
(define-libgit2 git_filter_list_stream_data
  (_fun _filter _buf _writestream -> _int))
(define-libgit2 git_filter_list_stream_file
  (_fun _filter _repository _string _writestream -> _int))
(define-libgit2 git_filter_list_stream_blob
  (_fun _filter _blob _writestream -> _int))
(define-libgit2 git_filter_list_free
  (_fun _filter -> _void))

