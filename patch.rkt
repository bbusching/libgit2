#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "diff.rkt"
         "buffer.rkt")
(provide (all-defined-out))


(define-libgit2 git_patch_from_diff
  (_fun (_cpointer _patch) _diff _size -> _int))
(define-libgit2 git_patch_from_blobs
  (_fun (_cpointer _patch) _blob _string _blob _string _git_diff_opts-pointer -> _int))
(define-libgit2 git_patch_from_blob_and_buffer
  (_fun (_cpointer _patch) _blob _string _string _size _string _git_diff_opts-pointer -> _int))
(define-libgit2 git_patch_from_buffers
  (_fun (_cpointer _patch) (_cpointer _void) _size _string _string _size _string _git_diff_opts-pointer -> _int))
(define-libgit2 git_patch_free
  (_fun _patch -> _void))
(define-libgit2 git_patch_get_delta
  (_fun _patch -> _git_diff_delta-pointer))
(define-libgit2 git_patch_line_stats
  (_fun (_cpointer _size) (_cpointer _size) (_cpointer _size) _patch  -> _int))
(define-libgit2 git_patch_get_hunk
  (_fun _git_diff_hunk-pointer (_cpointer _size) _patch _size -> _int))
(define-libgit2 git_patch_num_lines_in_hunk
  (_fun _patch _size -> _int))
(define-libgit2 git_patch_get_line_in_hunk
  (_fun (_cpointer _git_diff_line-pointer) _patch _size _size -> _int))
(define-libgit2 git_patch_size
  (_fun _patch _int _int _int -> _size))
(define-libgit2 git_patch_print
  (_fun _patch _git_diff_line_cb (_cpointer _void) -> _int))
(define-libgit2 git_patch_to_buf
  (_fun _buf _patch -> _int))

