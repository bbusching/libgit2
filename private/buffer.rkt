#lang racket/base

(require ffi/unsafe
         racket/match
         "base.rkt")

(provide (protect-out _git_buf/bytes-or-null))

;; https://github.com/libgit2/libgit2/pull/6017
;; > A git_buf is now a read-only structure as far as callers are concerned.
;; > This is a mechanism that we can return data to callers using memory that
;; > is owned by the library and can be cleaned up by callers (using git_buf_dispose).
;; >
;; > A git_buf can no longer be allocated by callers or provided to the library.

(define-cstruct _git_buf
  ([ptr (_or-null _pointer)]
   [asize _size]
   [size _size]))

(define-libgit2 git_buf_dispose
  ;; "Note that this does not free the git_buf itself,
  ;; just the memory pointed to by buffer->ptr."
  ;; (We allocate the git_buf in 'atomic mode.)
  (_fun _git_buf-pointer -> _void))

(define-fun-syntax _git_buf/bytes-or-null
  (syntax-parser
    [(_)
     #`(type: _git_buf-pointer
              pre: (make-git_buf #f 0 0)
              post: (buf => (_git_buf-consume/dispose buf)))]))

(define (_git_buf-consume/dispose buf)
  (match-define (git_buf ptr _ size) buf)
  (cond
    [ptr
     (define bs (make-bytes size))
     (memcpy bs 0 ptr 0 size _byte)
     (git_buf_dispose buf)
     bs]
    [else
     #f]))
