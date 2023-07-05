#lang info

(define pkg-name "libgit2")
(define collection "libgit2")
(define pkg-desc "Low-level api bindings to the libgit2 C library")

(define scribblings
  '(("scribblings/libgit2.scrbl" (multi-page) ("Git"))))

(define version "0.1")

(define update-implies
  '("libgit2-native-libs"))

(define deps
  '("base"
    ["libgit2-native-libs" #:version "0.1"]
    "rackunit-lib"))

(define build-deps
  '("rackunit-lib"
    "rackunit-spec"
    "scribble-lib"
    "racket-doc"))

(define license
  'MIT)
