#lang racket

(require ffi/unsafe
         "diff.rkt"
         (only-in "types.rkt"
                  _git_patch
                  _git_blob/null
                  _git_diff)
         libgit2/private)

(provide (all-defined-out))

(define-libgit2/dealloc git_patch_free
  (_fun _git_patch -> _void))

(define-libgit2/alloc git_patch_from_blob_and_buffer
  (_fun _git_patch _git_blob/null _string _string _size _string _git_diff_opts-pointer/null -> _int)
  git_patch_free)

(define-libgit2/alloc git_patch_from_blobs
  (_fun _git_patch _git_blob/null _string _git_blob/null _string _git_diff_opts-pointer/null -> _int)
  git_patch_free)

(define-libgit2/alloc git_patch_from_buffers
  (_fun _git_patch _bytes _size _string _string _size _string _git_diff_opts-pointer/null -> _int)
  git_patch_free)

(define-libgit2/alloc git_patch_from_diff
  (_fun _git_patch _git_diff _size -> _int)
  git_patch_free)

(define-libgit2 git_patch_get_delta
  (_fun _git_patch -> _git_diff_delta-pointer))

(define-libgit2/check git_patch_get_hunk
  (_fun [out : (_ptr o _git_diff_hunk)]
        [lines : (_ptr o _size)]
        _git_patch
        _size
        -> [v : _git_error_code]
        -> (values out lines)))

(define-libgit2/alloc git_patch_get_line_in_hunk
  (_fun _git_diff_line-pointer _git_patch _size _size -> _int))

(define-libgit2/check git_patch_line_stats
  (_fun [context : (_ptr o _size)]
        [additions : (_ptr o _size)]
        [deletions : (_ptr o _size)]
        _git_patch
        -> [v : _git_error_code]
        -> (values context additions deletions)))

(define-libgit2 git_patch_num_hunks
  (_fun _git_patch -> _size))

(define-libgit2/check git_patch_num_lines_in_hunk
  (_fun _git_patch _size -> _int))

(define-libgit2/check git_patch_print
  (_fun _git_patch _git_diff_line_cb _bytes -> _int))

(define-libgit2 git_patch_size
  (_fun _git_patch _int _int _int -> _size))

(define-libgit2/check git_patch_to_buf
  (_fun (_git_buf/bytes-or-null) _git_patch -> _int))
