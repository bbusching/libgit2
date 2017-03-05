#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "object.rkt"
         "buffer.rkt")
(provide (all-defined-out))


(define-libgit2 git_commit_lookup
  (_fun (_cpointer _commit) _repository _oid -> _int))
(define-libgit2 git_commit_lookup_prefix
  (_fun (_cpointer _commit) _repository _oid _size -> _int))
(define-libgit2 git_commit_free
  (_fun _commit -> _void))
(define-libgit2 git_commit_id
  (_fun _commit -> _oid))
(define-libgit2 git_commit_owner
  (_fun _commit -> _repository))
(define-libgit2 git_commit_message_encoding
  (_fun _commit -> _string))
(define-libgit2 git_commit_message
  (_fun _commit -> _string))
(define-libgit2 git_commit_message_raw
  (_fun _commit -> _string))
(define-libgit2 git_commit_summary
  (_fun _commit -> _string))
(define-libgit2 git_commit_body
  (_fun _commit -> _string))
(define-libgit2 git_commit_time
  (_fun _commit -> _git_time_t))
(define-libgit2 git_commit_time_offset
  (_fun _commit -> _int))
(define-libgit2 git_commit_committer
  (_fun _commit -> _signature))
(define-libgit2 git_commit_author
  (_fun _commit -> _signature))
(define-libgit2 git_commit_raw_header
  (_fun _commit -> _string))
(define-libgit2 git_commit_tree
  (_fun (_cpointer _tree) _commit -> _int))
(define-libgit2 git_commit_tree_id
  (_fun _commit -> _oid))
(define-libgit2 git_commit_parentcount
  (_fun _commit -> _uint))
(define-libgit2 git_commit_parent
  (_fun (_cpointer _commit) _commit _uint -> _int))
(define-libgit2 git_commit_parent_id
  (_fun _commit _uint -> _oid))
(define-libgit2 git_commit_nth_gen_ancestor
  (_fun (_cpointer _commit) _commit _uint -> _int))
(define-libgit2 git_commit_header_field
  (_fun _buf _commit _string -> _int))
(define-libgit2 git_commit_extract_signature
  (_fun _buf _buf _repository _oid _string -> _int))
(define-libgit2 git_commit_create
  (_fun _oid _repository _string _signature _signature _string _string _tree _size (_cpointer (_cpointer _commit)) -> _int))
(define-libgit2 git_commit_amend
  (_fun _oid _commit _string _signature _signature _string _string _tree -> _int))
(define-libgit2 git_commit_create_buffer
  (_fun _buf _repository _signature _signature _string _string _tree _size (_cpointer (_cpointer _commit)) -> _int))
(define-libgit2 git_commit_create_with_signature
  (_fun _oid _repository _string _string _string -> _int))
(define-libgit2 git_commit_dup
  (_fun (_cpointer _commit) _commit -> _int))

