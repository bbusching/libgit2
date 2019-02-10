#lang racket

(require ffi/unsafe
         "types.rkt"
         "object.rkt"
         "strarray.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define _git_tag_foreach_cb
  (_fun _string _oid _bytes -> _int))

; Functions

(define-libgit2/check git_tag_annotation_create
  (_fun _oid _repository _string _object _signature _string -> _int))

(define-libgit2/check git_tag_create
  (_fun _oid _repository _string _object _signature _string _bool -> _int))

(define-libgit2/check git_tag_create_frombuffer
  (_fun _oid _repository _string _bool -> _int))

(define-libgit2/check git_tag_create_lightweight
  (_fun _oid _repository _string _object _bool -> _int))

(define-libgit2/check git_tag_delete
  (_fun _repository _string -> _int))

(define-libgit2/dealloc git_tag_free
  (_fun _tag -> _void))

(define-libgit2/alloc git_tag_dup
  (_fun _tag _tag -> _int)
  git_tag_free)

(define-libgit2/check git_tag_foreach
  (_fun _repository _git_tag_foreach_cb _bytes -> _int))

(define-libgit2 git_tag_id
  (_fun _tag -> _oid))

(define-libgit2/check git_tag_list
  (_fun _strarray _repository -> _int))

(define-libgit2/check git_tag_list_match
  (_fun _strarray _string _repository -> _int))

(define-libgit2/alloc git_tag_lookup
  (_fun _tag _repository _oid -> _int)
  git_tag_free)

(define-libgit2/alloc git_tag_lookup_prefix
  (_fun _tag _repository _oid _size -> _int)
  git_tag_free)

(define-libgit2 git_tag_message
  (_fun _tag -> _string))

(define-libgit2 git_tag_name
  (_fun _tag -> _string))

(define-libgit2 git_tag_owner
  (_fun _tag -> _repository))

(define-libgit2/alloc git_tag_peel
  (_fun _object _tag -> _int)
  git_object_free)

(define-libgit2 git_tag_tagger
  (_fun _tag -> _signature/null))

(define-libgit2/alloc git_tag_target
  (_fun _object _tag -> _int)
  git_object_free)

(define-libgit2 git_tag_target_id
  (_fun _tag -> _oid))

(define-libgit2 git_tag_target_type
  (_fun _tag -> _git_object_t))
