#lang info

(define collection "libgit2")
(define pkg-desc "Low-level api bindings to the libgit2 C library")

(define scribblings
  '(("scribblings/libgit2.scrbl" (multi-page))))

(define deps
  '("base"
    "rackunit-lib"
    ["libgit2-x86_64-macosx" #:platform "x86_64-macosx"]
    ["libgit2-x86_64-linux"
     #:platform #rx"^x86_64-linux(?:-natipkg)?$"]
    ;;["libgit2-i386-linux" #:platform "i386-linux"]
    ["libgit2-win32-x86_64" #:platform "win32\\x86_64"]))

(define build-deps
  '("rackunit-lib"
    "scribble-lib"
    "racket-doc"))
