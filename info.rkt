#lang info

(define collection "libgit2")
(define pkg-desc "Low-level api bindings to the libgit2 C library")

(define scribblings
  '(("scribblings/libgit2.scrbl" (multi-page))))

(define deps
  '("base"
    "rackunit-lib"
    ["libgit2-x86_64-macosx" #:platform "x86_64-macosx"]
    ["libgit2-x86_64-linux" #:platform "x86_64-linux"]
    ["libgit2-x86_64-linux-natipkg" #:platform "x86_64-linux-natipkg"]))

(define build-deps
  '("rackunit-lib"
    "scribble-lib"
    "racket-doc"))
