#lang racket

(require scribble/manual
         syntax/parse/define
         scribble/example
         (for-label racket
                    (except-in ffi/unsafe ->)
                    libgit2))

(provide defmodule-lg2
         make-libgit2-eval
         (all-from-out scribble/example)
         (for-label (all-from-out racket)
                    (all-from-out ffi/unsafe)
                    (all-from-out libgit2)))

(define-simple-macro (defmodule-lg2 mod:id)
  (begin (defmodule mod #:no-declare)
         (declare-exporting mod libgit2)))

(define make-libgit2-eval
  (make-eval-factory '(libgit2 racket)))
