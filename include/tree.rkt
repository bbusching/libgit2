#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oid.rkt"
         "object.rkt")
(provide (all-defined-out))


(define-libgit2 git_tree_lookup
  (_fun (_cpointer _tree) _repository _oid -> _int))
(define-libgit2 git_tree_lookup_prefix
  (_fun (_cpointer _tree) _repository _oid _size -> _int))
(define-libgit2 git_tree_free
  (_fun _tree -> _void))
(define-libgit2 git_tree_id
  (_fun _tree -> _oid))
(define-libgit2 git_tree_owner
  (_fun _tree -> _repository))
(define-libgit2 git_tree_entrycount
  (_fun _tree -> _size))
(define-libgit2 git_tree_entry_byname
  (_fun _tree _string -> _tree_entry))
(define-libgit2 git_tree_entry_byindex
  (_fun _tree _size -> _tree_entry))
(define-libgit2 git_tree_entry_byid
  (_fun _tree _oid -> _tree_entry))
(define-libgit2 git_tree_entry_bypath
  (_fun (_cpointer _tree_entry) _tree _string -> _int))
(define-libgit2 git_tree_entry_dup
  (_fun (_cpointer _tree_entry) _tree_entry -> _int))
(define-libgit2 git_tree_entry_free
  (_fun (_cpointer _tree_entry) -> _void))
(define-libgit2 git_tree_entry_name
  (_fun _tree_entry -> _string))
(define-libgit2 git_tree_entry_id
  (_fun _tree_entry -> _oid))
(define-libgit2 git_tree_entry_type
  (_fun _tree_entry -> _git_otype))
(define-libgit2 git_tree_entry_filemode_raw
  (_fun _tree_entry -> _git_filemode_t ))
(define-libgit2 git_tree_entry_cmp
  (_fun _tree_entry _tree_entry -> _int))
(define-libgit2 git_tree_entry_to_object
  (_fun (_cpointer _object) _repository _tree_entry -> _int))
(define-libgit2 git_treebuilder_new
  (_fun (_cpointer _treebuilder) _repository _tree -> _int))
(define-libgit2 git_treebuilder_clear
  (_fun _treebuilder -> _void))
(define-libgit2 git_treebuilder_entrycount
  (_fun _treebuilder -> _uint))
(define-libgit2 git_treebuilder_free
  (_fun _treebuilder -> _void))
(define-libgit2 git_treebuilder_get
  (_fun _treebuilder _string -> _tree_entry))
(define-libgit2 git_treebuilder_insert
  (_fun (_cpointer _tree_entry) _treebuilder _string _oid _git_filemode_t -> _int))
(define-libgit2 git_treebuilder_remove
  (_fun _treebuilder _string -> _int))

(define _git_treebuilder_filter_cb
  (_fun _tree_entry (_cpointer _void) -> _int))
(define-libgit2 git_treebuilder_filter
  (_fun _treebuilder _git_treebuilder_filter_cb (_cpointer _void) -> _int))
(define-libgit2 git_treebuilder_write
  (_fun _oid _treebuilder -> _int))


(define _git_treewalk_cb
  (_fun _string _tree_entry (_cpointer _void) -> _int))

(define _git_treewalk_mode
  (_enum '(GIT_TREEWALK_PRE
           GIT_TREEWALK_POST)))

(define-libgit2 git_tree_walk
  (_fun _tree _git_treewalk_mode _git_treewalk_cb (_cpointer _void) -> _int))
(define-libgit2 git_tree_dup
  (_fun (_cpointer _tree) _tree -> _int))

(define _git_tree_update_t
  (_enum '(GIT_TREE_UPDATE_UPSERT
           GIT_TREE_UPDATE_REMOVE)))

(define-cstruct _git_tree_update
  ([action _git_tree_update_t]
   [id _oid]
   [filemode _git_filemode_t]
   [path _string]))

(define-libgit2 git_tree_create_updated
  (_fun _oid _repository _tree _size _git_tree_update-pointer -> _int))



