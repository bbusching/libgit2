#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "repository.rkt"
         "utils.rkt")
(provide (all-defined-out))

(define-libgit2/alloc git_annotated_commit_from_ref
  (_fun _annotated_commit _repository _reference -> _int))
(define-libgit2/alloc git_annotated_commit_from_fetchhead
  (_fun _annotated_commit _repository _string _string _oid -> _int))
(define-libgit2/alloc git_annotated_commit_lookup
  (_fun _annotated_commit _repository _oid -> _int))
(define-libgit2/alloc git_annotated_commit_from_revspec
  (_fun _annotated_commit _repository _string -> _int))
(define-libgit2 git_annotated_commit_id
  (_fun _annotated_commit -> _oid))
(define-libgit2 git_annotated_commit_free
  (_fun _annotated_commit -> _void))


