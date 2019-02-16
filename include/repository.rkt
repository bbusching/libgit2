#lang racket

(require ffi/unsafe
         "buffer.rkt"
         "config.rkt"
         "refs.rkt"
         "index.rkt"
         "odb.rkt"
         "refdb.rkt"
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository
                  git_repository?
                  _git_object_t
                  _git_odb
                  _git_config
                  _git_reference/null
                  _git_index
                  _git_refdb
                  _git_annotated_commit)
         libgit2/private)

(provide (except-out (all-defined-out)
                     ;git_repository_free
                     git_repository_open
                     #|...|#)
         (contract-out
          [git_repository_open
           (->c path-string? git_repository?)]
          ))

#|
;; not here:
git_repository_open_from_worktree
|#

(define-libgit2/dealloc git_repository_free
  (_fun _git_repository -> _void))

(define-libgit2/alloc git_repository_open
  (_fun _git_repository _path -> _git_error_code)
  git_repository_free)

(define-libgit2/alloc git_repository_wrap_odb
  (_fun _git_repository _git_odb -> _git_error_code)
  git_repository_free)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Types

(define-bitmask _git_repository_open_flag_t
  [GIT_REPOSITORY_OPEN_NO_SEARCH = 0]
  [GIT_REPOSITORY_OPEN_CROSS_FS = 2]
  [GIT_REPOSITORY_OPEN_BARE = 4]
  [GIT_REPOSITORY_OPEN_NO_DOTGIT = 8]
  [GIT_REPOSITORY_OPEN_FROM_ENV = 16])

(define-bitmask _git_repository_int_flag_t
  #:base _uint32
  [GIT_REPOSITORY_INIT_BARE = 1]
  [GIT_REPOSITORY_INIT_NO_REINIT = 2]
  [GIT_REPOSITORY_INIT_NO_DOTGIT_DIR = 4]
  [GIT_REPOSITORY_INIT_MKDIR = 8]
  [GIT_REPOSITORY_INIT_MKPATH = 16]
  [GIT_REPOSITORY_INIT_EXTERNAL_TEMPLATE = 32]
  [GIT_REPOSITORY_INIT_RELATIVE_GITLINK = 64])

(define-enum _git_repository_init_mode_t
  #:base _uint32
  [GIT_REPOSITORY_INIT_SHARED_UMASK = 0]
  [GIT_REPOSITORY_INIT_SHARED_GROUP = #o0002775]
  [GIT_REPOSITORY_INIT_SHARED_ALL = #o0002777])

(define-cstruct _git_repository_init_opts
  ([version _uint]
   [flags _git_repository_int_flag_t]
   [mode _git_repository_init_mode_t]
   [workdir_path _path] ;; const
   [description _string] ;; const
   [template_path _path] ;; const
   [initial_head _string] ;; const
   [origin_url _string])) ;; const

(define GIT_REPOSITORY_INIT_OPTS_VERSION 1)

(define _git_repository_fetchhead_foreach_cb
  (_fun _string _string _git_oid-pointer _uint _bytes -> _int))

(define _git_repository_mergehead_foreach_cb
  (_fun _git_oid-pointer _bytes -> _int))

(define-enum _git_repository_state_t
  GIT_REPOSITORY_STATE_NONE
  GIT_REPOSITORY_STATE_MERGE
  GIT_REPOSITORY_STATE_REVERT
  GIT_REPOSITORY_STATE_REVERT_SEQUENCE
  GIT_REPOSITORY_STATE_CHERRYPICK
  GIT_REPOSITORY_STATE_CHERRYPICK_SEQUENCE
  GIT_REPOSITORY_STATE_BISECT
  GIT_REPOSITORY_STATE_REBASE
  GIT_REPOSITORY_STATE_REBASE_INTERACTIVE
  GIT_REPOSITORY_STATE_REBASE_MERGE
  GIT_REPOSITORY_STATE_APPLY_MAILBOX
  GIT_REPOSITORY_STATE_APPLY_MAILBOX_OR_REBASE)

; Functions

(define-libgit2/alloc git_repository_config
  (_fun _git_config _git_repository -> _int)
  git_config_free)

(define-libgit2/alloc git_repository_config_snapshot
  (_fun _git_config _git_repository -> _int)
  git_config_free)

(define-libgit2/check git_repository_detach_head
  (_fun _git_repository -> _int))

(define-libgit2/check git_repository_discover
  (_fun _buf _string _int _string -> _int))

(define-libgit2/check git_repository_fetchhead_foreach
  (_fun _git_repository _git_repository_fetchhead_foreach_cb _bytes -> _int))

(define-libgit2 git_repository_get_namespace
  (_fun _git_repository -> _string))

(define-libgit2/check git_repository_hashfile
  (_fun _git_oid-pointer _git_repository _path _git_object_t _string -> _int))

(define-libgit2/alloc git_repository_head
  (_fun _git_reference/null _git_repository -> _int)
  git_reference_free)

(define-libgit2 git_repository_head_detached
  (_fun _git_repository -> _bool))

(define-libgit2 git_repository_head_unborn
  (_fun _git_repository -> (v : _int)
        -> (cond
             [(eq? v 0) #f]
             [(eq? v 1) #t]
             [else (check-git_error_code v v 'git_repository_head_unborn)])))

(define-libgit2 git_repository_ident
  (_fun (name : (_ptr o _string)) (email : (_ptr o _string)) _git_repository -> (v : _int)
        -> (check-git_error_code v (λ () (values name email)) 'git_repostiory_ident)))

(define-libgit2/alloc git_repository_index
  (_fun _git_index _git_repository -> _int)
  git_index_free)

(define-libgit2/alloc git_repository_init
  (_fun _git_repository _string _bool -> _int)
  git_repository_free)

(define-libgit2/alloc git_repository_init_ext
  (_fun _git_repository _string _git_repository_init_opts-pointer -> _int))

(define-libgit2/check git_repository_init_init_options
  (_fun _git_repository_init_opts-pointer _uint -> _int))

(define-libgit2 git_repository_is_bare
  (_fun _git_repository -> _bool))

(define-libgit2 git_repository_is_empty
  (_fun _git_repository -> _bool))

(define-libgit2 git_repository_is_shallow
  (_fun _git_repository -> _bool))

(define-libgit2/check git_repository_mergehead_foreach
  (_fun _git_repository _git_repository_mergehead_foreach_cb _bytes -> _int))

(define-libgit2/check git_repository_message
  (_fun _buf _git_repository -> _int))

(define-libgit2/check git_repository_message_remove
  (_fun _git_repository -> _int))

(define-libgit2/alloc git_repository_new
  (_fun _git_repository -> _int)
  git_repository_free)

(define-libgit2/alloc git_repository_odb
  (_fun _git_odb _git_repository -> _int)
  git_odb_free)

(define-libgit2/alloc git_repository_open_bare
  (_fun _git_repository _string -> _int)
  git_repository_free)

(define-libgit2/alloc git_repository_open_ext
  (_fun _git_repository _string _uint _string -> _int)
  git_repository_free)

(define-libgit2 git_repository_path
  (_fun _git_repository -> _string))

(define-libgit2/alloc git_repository_refdb
  (_fun _git_refdb _git_repository -> _int)
  git_refdb_free)

(define-libgit2/check git_repository_reinit_filesystem
  (_fun _git_repository _int -> _int))

(define-libgit2/check git_repository_set_bare
  (_fun _git_repository -> _int))

(define-libgit2 git_repository_set_config
  (_fun _git_repository _git_config -> _void))

(define-libgit2/check git_repository_set_head
  (_fun _git_repository _string -> _int))

(define-libgit2/check git_repository_set_head_detached
  (_fun _git_repository _git_oid-pointer -> _int))

(define-libgit2/check git_repository_set_head_detached_from_annotated
  (_fun _git_repository _git_annotated_commit -> _int))

(define-libgit2/check git_repository_set_ident
  (_fun _git_repository _string _string -> _int))

(define-libgit2 git_repository_set_index
  (_fun _git_repository _git_index -> _void))

(define-libgit2/check git_repository_set_namespace
  (_fun _git_repository _string -> _int))

(define-libgit2 git_repository_set_odb
  (_fun _git_repository _git_odb -> _void))

(define-libgit2 git_repository_set_refdb
  (_fun _git_repository _git_refdb -> _void))

(define-libgit2/check git_repository_set_workdir
  (_fun _git_repository _string _bool -> _int))

(define-libgit2 git_repository_state
  (_fun _git_repository -> _git_repository_state_t))

(define-libgit2/check git_repository_state_cleanup
  (_fun _git_repository -> _int))

(define-libgit2 git_repository_workdir
  (_fun _git_repository -> _string))


