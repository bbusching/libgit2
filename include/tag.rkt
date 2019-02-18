#lang racket

(require ffi/unsafe
         "object.rkt"
         "strarray.rkt"
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository
                  _git_object
                  _git_object_t
                  _git_signature-pointer
                  _git_signature-pointer/null
                  _git_tag )
         libgit2/private)

(provide (all-defined-out))

; Types

(define _git_tag_foreach_cb
  (_fun _string _git_oid-pointer _bytes -> _int))

; Functions

(define-libgit2/check git_tag_annotation_create
  (_fun _git_oid-pointer _git_repository _string _git_object _git_signature-pointer _string -> _int))

(define-libgit2/check git_tag_create
  (_fun _git_oid-pointer _git_repository _string _git_object _git_signature-pointer _string _bool -> _int))

(define-libgit2/check git_tag_create_frombuffer
  (_fun _git_oid-pointer _git_repository _string _bool -> _int))

(define-libgit2/check git_tag_create_lightweight
  (_fun _git_oid-pointer _git_repository _string _git_object _bool -> _int))

(define-libgit2/check git_tag_delete
  (_fun _git_repository _string -> _int))

(define-libgit2/dealloc git_tag_free
  (_fun _git_tag -> _void))

(define-libgit2/alloc git_tag_dup
  (_fun _git_tag _git_tag -> _int)
  git_tag_free)

(define-libgit2/check git_tag_foreach
  (_fun _git_repository _git_tag_foreach_cb _bytes -> _int))

(define-libgit2 git_tag_id
  (_fun _git_tag -> _git_oid-pointer))

(define-libgit2/check git_tag_list
  (_fun _strarray _git_repository -> _int))

(define-libgit2/check git_tag_list_match
  (_fun _strarray _string _git_repository -> _int))

(define-libgit2/alloc git_tag_lookup
  (_fun _git_tag _git_repository _git_oid-pointer -> _int)
  git_tag_free)

(define-libgit2/alloc git_tag_lookup_prefix
  (_fun _git_tag _git_repository _git_oid-pointer _size -> _int)
  git_tag_free)

(define-libgit2 git_tag_message
  (_fun _git_tag -> _string))

(define-libgit2 git_tag_name
  (_fun _git_tag -> _string))

(define-libgit2 git_tag_owner
  (_fun _git_tag -> _git_repository))

(define-libgit2/alloc git_tag_peel
  (_fun _git_object _git_tag -> _int)
  git_object_free)

(define-libgit2 git_tag_tagger
  (_fun _git_tag -> _git_signature-pointer/null))

(define-libgit2/alloc git_tag_target
  (_fun _git_object _git_tag -> _int)
  git_object_free)

(define-libgit2 git_tag_target_id
  (_fun _git_tag -> _git_oid-pointer))

(define-libgit2 git_tag_target_type
  (_fun _git_tag -> _git_object_t))
