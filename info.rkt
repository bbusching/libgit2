#lang info

(define pkg-name "libgit2")
(define collection "libgit2")
(define pkg-desc "Low-level api bindings to the libgit2 C library")

(define scribblings
  '(("scribblings/libgit2.scrbl" (multi-page))))

(define deps
  '("base"
    "rackunit-lib"
    "libgit2-native-libs"))

(define build-deps
  '("rackunit-lib"
    "rackunit-spec"
    "scribble-lib"
    "racket-doc"))

(define license
  'MIT)
