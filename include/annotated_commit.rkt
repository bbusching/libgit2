#lang racket

(require ffi/unsafe
         "types.rkt"
         (submod "oid.rkt" private)
         libgit2/private)
(provide (all-defined-out))

(define-libgit2/dealloc git_annotated_commit_free
  (_fun _annotated_commit -> _void))

(define-libgit2/alloc git_annotated_commit_from_fetchhead
  (_fun _annotated_commit _repository _string _string _git_oid-pointer -> _int)
  git_annotated_commit_free)

(define-libgit2/alloc git_annotated_commit_from_ref
  (_fun _annotated_commit _repository _reference -> _int)
  git_annotated_commit_free)

(define-libgit2/alloc git_annotated_commit_from_revspec
  (_fun _annotated_commit _repository _string -> _int)
  git_annotated_commit_free)

(define-libgit2 git_annotated_commit_id
  (_fun _annotated_commit -> _git_oid-pointer))

(define-libgit2/alloc git_annotated_commit_lookup
  (_fun _annotated_commit _repository _git_oid-pointer -> _int)
  git_annotated_commit_free)
