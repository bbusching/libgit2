#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "object.rkt"
         "strarray.rkt")
(provide (all-defined-out))


(define-libgit2 git_tag_lookup
  (_fun (_cpointer _tag) _repository _oid -> _int))
(define-libgit2 git_tag_lookup_prefix
  (_fun (_cpointer _tag) _repository _oid _size -> _int))
(define-libgit2 git_tag_free
  (_fun _tag -> _void))
(define-libgit2 git_tag_id
  (_fun _tag -> _oid))
(define-libgit2 git_tag_owner
  (_fun _tag -> _repository))
(define-libgit2 git_tag_target
  (_fun (_cpointer _object) _tag -> _int))
(define-libgit2 git_tag_target_id
  (_fun _tag -> _oid))
(define-libgit2 git_tag_target_type
  (_fun _tag -> _git_otype))
(define-libgit2 git_tag_name
  (_fun _tag -> _string))
(define-libgit2 git_tag_tagger
  (_fun _tag -> _signature))
(define-libgit2 git_tag_message
  (_fun _tag -> _string))
(define-libgit2 git_tag_create
  (_fun _oid _repository _string _object _signature _string _int -> _int))
(define-libgit2 git_tag_annotation_create
  (_fun _oid _repository _string _object _signature _string -> _int))
(define-libgit2 git_tag_create_frombuffer
  (_fun _oid _repository _string _int -> _int))
(define-libgit2 git_tag_create_lightweight
  (_fun _oid _repository _string _object _int -> _int))
(define-libgit2 git_tag_delete
  (_fun _repository _string -> _int))
(define-libgit2 git_tag_list
  (_fun _strarray _repository -> _int))
(define-libgit2 git_tag_list_match
  (_fun _strarray _string _repository -> _int))

(define _git_tag_foreach_cb
  (_fun _string _oid (_cpointer _void) -> _int))

(define-libgit2 git_tag_foreach
  (_fun _repository _git_tag_foreach_cb (_cpointer _void) -> _int))
(define-libgit2 git_tag_peel
  (_fun (_cpointer _object) _tag -> _int))
(define-libgit2 git_tag_dup
  (_fun (_cpointer _tag) _tag -> _int))

