#lang racket

(require ffi/unsafe
         (only-in "net.rkt" _git_direction)
         "buffer.rkt"
         (only-in "types.rkt"
                  _git_refspec)
         libgit2/private)

(provide (all-defined-out))

(define-libgit2 git_refspec_direction
  (_fun _git_refspec -> _git_direction))

(define-libgit2 git_refspec_dst
  (_fun _git_refspec -> _string))

(define-libgit2 git_refspec_dst_matches
  (_fun _git_refspec _string -> _bool))

(define-libgit2 git_refspec_force
  (_fun _git_refspec -> _bool))

(define-libgit2/check git_refspec_transform
  (_fun _buf _git_refspec _string -> _int))

(define-libgit2 git_refspec_src
  (_fun _git_refspec -> _string))

(define-libgit2 git_refspec_src_matches
  (_fun _git_refspec _string -> _bool))

(define-libgit2 git_refspec_string
  (_fun _git_refspec -> _string))

(define-libgit2/check git_refspec_rtransform
  (_fun _buf _git_refspec _string -> _int))

