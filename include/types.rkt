#lang racket

(require ffi/unsafe
         libgit2/private)

;; TODO: refactor away this module;
;; keep type definitions with uses

;; TODO: fix the "this is wrong"s enums

(provide _git_time_t
         _git_off_t
         _git_object_t
         _git_odb
         git_odb?
         _git_odb_backend
         _git_odb_object
         _git_refdb
         _git_refdb_backend
         _git_repository
         git_repository?
         _git_object
         _git_object/null
         _git_revwalk
         _git_tag
         _git_blob
         _git_blob/null
         _git_commit
         _git_tree_entry
         _git_tree_entry/null
         _git_tree
         _git_tree/null
         _git_treebuilder
         _git_index
         _git_index/null
         _git_index_conflict_iterator
         _git_config
         _git_config_backend
         _git_reflog_entry
         _git_reflog
         _git_note
         _git_packbuilder
         _git_time
         _git_time-pointer
         _git_signature-pointer
         _git_signature-pointer/null
         _git_reference
         _git_reference/null
         _git_reference_iterator
         _git_transaction
         _git_annotated_commit
         _git_annotated_commit/null
         _git_status_list
         _git_rebase
         _git_reference_t
         _git_branch_t
         _git_filemode_t
         _git_refspec
         _git_remote
         _git_transport
         _git_push
         _git_transfer_progress
         _git_transfer_progress-pointer
         _git_transfer_progress_cb
         _git_transport_message_cb
         _git_cert_t
         _git_cert
         _git_transport_certificate_check_cb
         _git_submodule
         _git_submodule_update_t
         _git_submodule_ignore_t
         _git_submodule_recurse_t
         _git_writestream
         _git_blame ;; not from types.h
         _git_diff ;; not from types.h
         _git_merge_result ;; not from types.h
         _git_patch) ;; not from types.h

(define _git_time_t _int64)
(define _git_off_t _int64)

(define-enum _git_object_t
  #:base _fixint
  [GIT_OBJECT_ANY -2]
  [GIT_OBJECT_INVALID -1]
  [GIT_OBJECT_COMMIT 1]
  [GIT_OBJECT_TREE 2]
  [GIT_OBJECT_BLOB 3]
  [GIT_OBJECT_TAG 4]
  [GIT_OBJECT_OFS_DELTA 6]
  [GIT_OBJECT_REF_DELTA 7])

(define-cpointer-type _git_odb)
(define-cpointer-type _git_odb_backend)
(define-cpointer-type _git_odb_object)
(define-cpointer-type _git_refdb)
(define-cpointer-type _git_refdb_backend)
(define-cpointer-type _git_repository)
;; not here: _git_worktree
(define-cpointer-type _git_object)
(define-cpointer-type _git_revwalk)
(define-cpointer-type _git_tag)
(define-cpointer-type _git_blob)
(define-cpointer-type _git_commit)
(define-cpointer-type _git_tree_entry)
(define-cpointer-type _git_tree)
(define-cpointer-type _git_treebuilder)
(define-cpointer-type _git_index)
;; not here: _git_index_iterator
(define-cpointer-type _git_index_conflict_iterator)
(define-cpointer-type _git_config)
(define-cpointer-type _git_config_backend)
(define-cpointer-type _git_reflog_entry)
(define-cpointer-type _git_reflog)
(define-cpointer-type _git_note)
(define-cpointer-type _git_packbuilder)


(define-cstruct _git_time
  ([time _git_time_t]
   [offset _int]))

(define-cstruct _git_signature
  ([name _string]
   [email _string]
   [when _git_time]))


(define-cpointer-type _git_reference)
(define-cpointer-type _git_reference_iterator)
(define-cpointer-type _git_transaction)
(define-cpointer-type _git_annotated_commit)
(define-cpointer-type _git_status_list)
(define-cpointer-type _git_rebase)


(define-enum _git_reference_t
  [GIT_REFERENCE_INVALID 0]
  [GIT_REFERENCE_DIRECT 1]
  [GIT_REFERENCE_SYMBOLIC 2]
  [GIT_REFERENCE_ALL
   (bitwise-ior GIT_REFERENCE_DIRECT GIT_REFERENCE_SYMBOLIC)])

(define-enum _git_branch_t
  [GIT_BRANCH_LOCAL 1]
  [GIT_BRANCH_REMOTE 2]
  [GIT_BRANCH_ALL
   (bitwise-ior GIT_BRANCH_LOCAL GIT_BRANCH_REMOTE)])

(define-enum _git_filemode_t
  [GIT_FILEMODE_UNREADABLE 0]
  [GIT_FILEMODE_TREE #o0040000]
  [GIT_FILEMODE_BLOB #o0100644]
  [GIT_FILEMODE_BLOB_EXECUTABLE #o0100755]
  [GIT_FILEMODE_LINK #o0120000]
  [GIT_FILEMODE_COMMIT #o0160000])


(define-cpointer-type _git_refspec)
(define-cpointer-type _git_remote)
(define-cpointer-type _git_transport)
(define-cpointer-type _git_push)
;; not here: _git_remote_callbacks


(define-cstruct _git_transfer_progress
  ([total_objects _uint]
   [indexed_objects _uint]
   [received_objects _uint]
   [local_objects _uint]
   [total_deltas _uint]
   [indexed_deltas _uint]
   [received_bytes _size]))

(define _git_transfer_progress_cb
  (_fun _git_transfer_progress-pointer _bytes -> _int))

(define _git_transport_message_cb
  (_fun _string _int _bytes -> _int))

(define-enum _git_cert_t
  GIT_CERT_NONE
  GIT_CERT_X509
  GIT_CERT_HOSTKEY_LIBSSH2
  GIT_CERT_STRARRAY)

(define-cstruct _git_cert
  ([cert_type _git_cert_t]))

(define _git_transport_certificate_check_cb
  (_fun _git_cert-pointer _int _string _bytes -> _int))

(define-cpointer-type _git_submodule)

(define-enum _git_submodule_update_t
  GIT_SUBMODULE_UPDATE_DEFAULT
  GIT_SUBMODULE_UPDATE_CHECKOUT
  GIT_SUBMODULE_UPDATE_REBASE
  GIT_SUBMODULE_UPDATE_MERGE
  GIT_SUBMODULE_UPDATE_NONE)

(define-enum _git_submodule_ignore_t
  #:base _fixint
  [GIT_SUBMODULE_IGNORE_UNSPECIFIED -1]
  [GIT_SUBMODULE_IGNORE_NONE 1]
  GIT_SUBMODULE_IGNORE_UNTRACKED
  GIT_SUBMODULE_IGNORE_DIRTY
  GIT_SUBMODULE_IGNORE_ALL)

(define-enum _git_submodule_recurse_t
  GIT_SUBMODULE_RECURSE_NO
  GIT_SUBMODULE_RECURSE_YES
  GIT_SUBMODULE_RECURSE_ONDEMAND)


;; TODO _git_writestream is a public struct
(define-cpointer-type _git_writestream)

;; not here: _git_mailmap

(define-cpointer-type _git_blame)
(define-cpointer-type _git_diff)
(define-cpointer-type _git_merge_result)
(define-cpointer-type _git_patch)













