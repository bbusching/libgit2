#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "diff.rkt"
         "buffer.rkt"
         "utils.rkt")
(provide (all-defined-out))


(define-libgit2/dealloc git_patch_free
  (_fun _patch -> _void))

(define-libgit2/alloc git_patch_from_blob_and_buffer
  (_fun _patch _blob/null _string _string _size _string _git_diff_opts-pointer/null -> _int)
  git_patch_free)

(define-libgit2/alloc git_patch_from_blobs
  (_fun _patch _blob/null _string _blob/null _string _git_diff_opts-pointer/null -> _int)
  git_patch_free)

(define-libgit2/alloc git_patch_from_buffers
  (_fun _patch _bytes _size _string _string _size _string _git_diff_opts-pointer/null -> _int)
  git_patch_free)

(define-libgit2/alloc git_patch_from_diff
  (_fun _patch _diff _size -> _int)
  git_patch_free)

(define-libgit2 git_patch_get_delta
  (_fun _patch -> _git_diff_delta-pointer))

(define-libgit2 git_patch_get_hunk
  (_fun (out : (_ptr o _git_diff_hunk-pointer)) (lines : (_ptr o _size)) _patch _size -> (v : _int)
        -> (check-lg2 v (λ () (values out lines)) 'git_patch_get_hunk)))

(define-libgit2/alloc git_patch_get_line_in_hunk
  (_fun _git_diff_line-pointer _patch _size _size -> _int))

(define-libgit2 git_patch_line_stats
  (_fun (context : (_ptr o _size)) (additions : (_ptr o _size)) (deletions : (_ptr o _size)) _patch  -> (v : _int)
        -> (check-lg2 v (λ () (values context additions deletions)) 'git_patch_line_stats)))

(define-libgit2 git_patch_num_hunks
  (_fun _patch -> _size))

(define-libgit2/check git_patch_num_lines_in_hunk
  (_fun _patch _size -> _int))

(define-libgit2/check git_patch_print
  (_fun _patch _git_diff_line_cb _bytes -> _int))

(define-libgit2 git_patch_size
  (_fun _patch _int _int _int -> _size))

(define-libgit2/check git_patch_to_buf
  (_fun _buf _patch -> _int))
