#lang info

(define collection 'multi)

(define deps
  (list "base"
        "rackunit-lib"
        '("libgit2-x86_64-linux-natipkg" #:platform "x86_64-linux-natipkg")))

(define build-deps
  (list "rackunit-lib"
        "scribble-lib"
        "racket-doc"))
