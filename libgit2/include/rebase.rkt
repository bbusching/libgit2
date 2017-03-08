#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "merge.rkt"
         "checkout.rkt"
         "index.rkt"
         "utils.rkt")
(provide (all-defined-out))


; Types

(define-cstruct _git_rebase_opts
  ([version _uint]
   [quiet _int]
   [inmemory _int]
   [rewrite_notes_ref _string]
   [merge_options _git_merge_opts]
   [checkout_options _git_checkout_opts]))

(define GIT_REBASE_OPTS_VERSION 1)

(define _git_rebase_operation_t
  (_enum '(GIT_REBASE_OPERATION_PICK
           GIT_REBASE_OPERATION_REWORD
           GIT_REBASE_OPERATION_EDIT
           GIT_REBASE_OPERATION_SQUASH
           GIT_REBASE_OPERATION_FIXUP
           GIT_REBASE_OPERATION_EXEC)))

(define-cstruct _git_rebase_operation
  ([type _git_rebase_operation_t]
   [id _git_oid]
   [exec _string]))

; Functions

(define-libgit2/check git_rebase_abort
  (_fun _rebase -> _int))

(define-libgit2/check git_rebase_commit
  (_fun _oid _rebase _signature/null _signature _string _string -> _int))

(define-libgit2/check git_rebase_finish
  (_fun _rebase _signature -> _int))

(define-libgit2/dealloc git_rebase_free
  (_fun _rebase -> _void))

(define-libgit2/alloc git_rebase_init
  (_fun _rebase _repository _annotated_commit/null _annotated_commit/null  _annotated_commit/null _git_rebase_opts-pointer/null -> _int)
  git_rebase_free)

(define-libgit2/check git_rebase_init_options
  (_fun _git_rebase_opts-pointer _uint -> _int))

(define-libgit2/alloc git_rebase_inmemory_index
  (_fun _index _rebase -> _int)
  git_index_free)

(define-libgit2/alloc git_rebase_next
  (_fun _git_rebase_operation-pointer _rebase -> _int))

(define-libgit2/alloc git_rebase_open
  (_fun _rebase _repository _git_rebase_opts-pointer -> _int)
  git_rebase_free)

(define-libgit2 git_rebase_operation_byindex
  (_fun _rebase _size -> _git_rebase_operation-pointer))

(define-libgit2 git_rebase_operation_current
  (_fun _rebase -> _size))

(define-libgit2 git_rebase_operation_entrycount
  (_fun _rebase -> _size))
