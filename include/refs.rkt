#lang racket

(require ffi/unsafe
         ffi/unsafe/alloc
         "types.rkt"
         "oid.rkt"
         "strarray.rkt"
         "object.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define _git_reference_foreach_cb
  (_fun _reference _bytes -> _int))
(define _git_reference_foreach_name_cb
  (_fun _string _bytes -> _int))

(define _git_reference_normalize_t
  (_bitmask '(GIT_REF_FORMAT_NORMAL = 0
              GIT_REF_FORMAT_ALLOW_ONELEVEL = 1
              GIT_REF_FORMAT_REFSPEC_PATTERN = 2
              GIT_REF_FORMAT_REFSPEC_SHORTHAND = 4)))

; Functions

(define-libgit2/dealloc git_reference_free
  (_fun _reference -> _void))

(define-libgit2 git_reference__alloc
  (_fun _string _oid _oid -> _reference/null)
  #:wrap (allocator git_reference_free))

(define-libgit2 git_reference__alloc_symbolic
  (_fun _string _string -> _reference/null)
  #:wrap (allocator git_reference_free))

(define-libgit2 git_reference_cmp
  (_fun _reference _reference -> _int))

(define-libgit2/alloc git_reference_create
  (_fun _reference _repository _string _oid _bool _string -> _int)
  git_reference_free)

(define-libgit2/alloc git_reference_create_matching
  (_fun _reference _repository _string _oid _bool _oid _string -> _int)
  git_reference_free)

(define-libgit2/check git_reference_delete
  (_fun _reference -> _int))

(define-libgit2/alloc git_reference_dup
  (_fun _reference _reference -> _int)
  git_reference_free)

(define-libgit2/alloc git_reference_dwim
  (_fun _reference _repository _string -> _int)
  git_reference_free)

(define-libgit2/check git_reference_ensure_log
  (_fun _repository _string -> _int))

(define-libgit2/check git_reference_foreach
  (_fun _repository _git_reference_foreach_cb _bytes -> _int))

(define-libgit2/check git_reference_foreach_glob
  (_fun _repository _string _git_reference_foreach_name_cb _bytes -> _int))

(define-libgit2/check git_reference_foreach_name
  (_fun _repository _git_reference_foreach_name_cb _bytes -> _int))

(define-libgit2 git_reference_has_log
  (_fun _repository _string -> _bool))

(define-libgit2 git_reference_is_branch
  (_fun _reference -> _bool))

(define-libgit2 git_reference_is_note
  (_fun _reference -> _bool))

(define-libgit2 git_reference_is_remote
  (_fun _reference -> _bool))

(define-libgit2 git_reference_is_tag
  (_fun _reference -> _bool))

(define-libgit2 git_reference_is_valid_name
  (_fun _string -> _bool))

(define-libgit2/dealloc git_reference_iterator_free
  (_fun _reference_iterator -> _int))

(define-libgit2/alloc git_reference_iterator_glob_new
  (_fun _reference_iterator _repository _string -> _int)
  git_reference_iterator_free)

(define-libgit2/alloc git_reference_iterator_new
  (_fun _reference_iterator _repository -> _int)
  git_reference_iterator_free)

(define-libgit2/check git_reference_list
  (_fun _strarray _repository -> _int))

(define-libgit2/alloc git_reference_lookup
  (_fun _reference _repository _string -> _int)
  git_reference_free)

(define-libgit2 git_reference_name
  (_fun _reference -> _string))

(define-libgit2/check git_reference_name_to_id
  (_fun _oid _repository _string -> _int))

(define-libgit2/alloc git_reference_next
  (_fun _reference _reference_iterator -> _int)
  git_reference_free)

(define-libgit2/alloc git_reference_next_name
  (_fun _string _reference_iterator -> _int)
  git_reference_free)

(define-libgit2/check git_reference_normalize_name
  (_fun _string _size _string _uint -> _int))

(define-libgit2 git_reference_owner
  (_fun _reference -> _repository))

(define-libgit2/alloc git_reference_peel
  (_fun _object _reference _git_object_t -> _int)
  git_object_free)

(define-libgit2/check git_reference_remove
  (_fun _repository _string -> _int))

(define-libgit2/alloc git_reference_rename
  (_fun _reference _reference _string _int _string -> _int)
  git_reference_free)

(define-libgit2/alloc git_reference_resolve
  (_fun _reference _reference -> _int)
  git_reference_free)

(define-libgit2/alloc git_reference_set_target
  (_fun _reference _reference _oid _string -> _int)
  git_reference_free)

(define-libgit2 git_reference_shorthand
  (_fun _reference -> _string))

(define-libgit2/alloc git_reference_symbolic_create
  (_fun _reference _repository _string _string _bool _string -> _int)
  git_reference_free)

(define-libgit2/alloc git_reference_symbolic_create_matching
  (_fun _reference _repository _string _string _bool _string _string -> _int)
  git_reference_free)

(define-libgit2/alloc git_reference_symbolic_set_target
  (_fun _reference _reference _string _string -> _int)
  git_reference_free)

(define-libgit2 git_reference_symbolic_target
  (_fun _reference -> _string))

(define-libgit2 git_reference_target
  (_fun _reference -> _oid))

(define-libgit2 git_reference_target_peel
  (_fun _reference -> _oid))

(define-libgit2 git_reference_type
  (_fun _reference -> _git_reference_t))
