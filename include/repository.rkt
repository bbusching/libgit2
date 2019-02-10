#lang racket

(require ffi/unsafe
         "types.rkt"
         "buffer.rkt"
         "config.rkt"
         "refs.rkt"
         "index.rkt"
         "odb.rkt"
         "refdb.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define _git_repository_open_flag_t
  (_bitmask '(GIT_REPOSITORY_OPEN_NO_SEARCH = 0
              GIT_REPOSITORY_OPEN_CROSS_FS = 2
              GIT_REPOSITORY_OPEN_BARE = 4
              GIT_REPOSITORY_OPEN_NO_DOTGIT = 8
              GIT_REPOSITORY_OPEN_FROM_ENV = 16)))

(define _git_repository_int_flag_t
  (_bitmask '(GIT_REPOSITORY_INIT_BARE = 1
              GIT_REPOSITORY_INIT_NO_REINIT = 2
              GIT_REPOSITORY_INIT_NO_DOTGIT_DIR = 4
              GIT_REPOSITORY_INIT_MKDIR = 8
              GIT_REPOSITORY_INIT_MKPATH = 16
              GIT_REPOSITORY_INIT_EXTERNAL_TEMPLATE = 32
              GIT_REPOSITORY_INIT_RELATIVE_GITLINK = 64)))

(define _git_repository_init_mode_t
  (_enum '(GIT_REPOSITORY_INIT_SHARED_UMASK = 0
           GIT_REPOSITORY_INIT_SHARED_GROUP = #o0002775
           GIT_REPOSITORY_INIT_SHARED_ALL = #o0002777)))

(define-cstruct _git_repository_init_opts
  ([version _uint]
   [flags _uint32]
   [mode _uint32]
   [workdir_path _string]
   [description _string]
   [template_path _string]
   [initial_head _string]
   [origin_url _string]))

(define GIT_REPOSITORY_INIT_OPTS_VERSION 1)

(define _git_repository_fetchhead_foreach_cb
  (_fun _string _string _oid _uint _bytes -> _int))

(define _git_repository_mergehead_foreach_cb
  (_fun _oid _bytes -> _int))

(define _git_repository_state_t
  (_enum '(GIT_REPOSITORY_STATE_NONE
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
           GIT_REPOSITORY_STATE_APPLY_MAILBOX_OR_REBASE)))

; Functions

(define-libgit2/alloc git_repository_config
  (_fun _config _repository -> _int)
  git_config_free)

(define-libgit2/alloc git_repository_config_snapshot
  (_fun _config _repository -> _int)
  git_config_free)

(define-libgit2/check git_repository_detach_head
  (_fun _repository -> _int))

(define-libgit2/check git_repository_discover
  (_fun _buf _string _int _string -> _int))

(define-libgit2/check git_repository_fetchhead_foreach
  (_fun _repository _git_repository_fetchhead_foreach_cb _bytes -> _int))

(define-libgit2/dealloc git_repository_free
  (_fun _repository -> _void))

(define-libgit2 git_repository_get_namespace
  (_fun _repository -> _string))

(define-libgit2/check git_repository_hashfile
  (_fun _oid _repository _path _git_object_t _string -> _int))

(define-libgit2/alloc git_repository_head
  (_fun _reference/null _repository -> _int)
  git_reference_free)

(define-libgit2 git_repository_head_detached
  (_fun _repository -> _bool))

(define-libgit2 git_repository_head_unborn
  (_fun _repository -> (v : _int)
        -> (cond
             [(eq? v 0) #f]
             [(eq? v 1) #t]
             [else (check-git_error_code v v 'git_repository_head_unborn)])))

(define-libgit2 git_repository_ident
  (_fun (name : (_ptr o _string)) (email : (_ptr o _string)) _repository -> (v : _int)
        -> (check-git_error_code v (λ () (values name email)) 'git_repostiory_ident)))

(define-libgit2/alloc git_repository_index
  (_fun _index _repository -> _int)
  git_index_free)

(define-libgit2/alloc git_repository_init
  (_fun _repository _string _bool -> _int)
  git_repository_free)

(define-libgit2/alloc git_repository_init_ext
  (_fun _repository _string _git_repository_init_opts-pointer -> _int))

(define-libgit2/check git_repository_init_init_options
  (_fun _git_repository_init_opts-pointer _uint -> _int))

(define-libgit2 git_repository_is_bare
  (_fun _repository -> _bool))

(define-libgit2 git_repository_is_empty
  (_fun _repository -> _bool))

(define-libgit2 git_repository_is_shallow
  (_fun _repository -> _bool))

(define-libgit2/check git_repository_mergehead_foreach
  (_fun _repository _git_repository_mergehead_foreach_cb _bytes -> _int))

(define-libgit2/check git_repository_message
  (_fun _buf _repository -> _int))

(define-libgit2/check git_repository_message_remove
  (_fun _repository -> _int))

(define-libgit2/alloc git_repository_new
  (_fun _repository -> _int)
  git_repository_free)

(define-libgit2/alloc git_repository_odb
  (_fun _odb _repository -> _int)
  git_odb_free)

(define-libgit2/alloc git_repository_open
  (_fun _repository _string -> _int)
  git_repository_free)

(define-libgit2/alloc git_repository_open_bare
  (_fun _repository _string -> _int)
  git_repository_free)

(define-libgit2/alloc git_repository_open_ext
  (_fun _repository _string _uint _string -> _int)
  git_repository_free)

(define-libgit2 git_repository_path
  (_fun _repository -> _string))

(define-libgit2/alloc git_repository_refdb
  (_fun _refdb _repository -> _int)
  git_refdb_free)

(define-libgit2/check git_repository_reinit_filesystem
  (_fun _repository _int -> _int))

(define-libgit2/check git_repository_set_bare
  (_fun _repository -> _int))

(define-libgit2 git_repository_set_config
  (_fun _repository _config -> _void))

(define-libgit2/check git_repository_set_head
  (_fun _repository _string -> _int))

(define-libgit2/check git_repository_set_head_detached
  (_fun _repository _oid -> _int))

(define-libgit2/check git_repository_set_head_detached_from_annotated
  (_fun _repository _annotated_commit -> _int))

(define-libgit2/check git_repository_set_ident
  (_fun _repository _string _string -> _int))

(define-libgit2 git_repository_set_index
  (_fun _repository _index -> _void))

(define-libgit2/check git_repository_set_namespace
  (_fun _repository _string -> _int))

(define-libgit2 git_repository_set_odb
  (_fun _repository _odb -> _void))

(define-libgit2 git_repository_set_refdb
  (_fun _repository _refdb -> _void))

(define-libgit2/check git_repository_set_workdir
  (_fun _repository _string _bool -> _int))

(define-libgit2 git_repository_state
  (_fun _repository -> _git_repository_state_t))

(define-libgit2/check git_repository_state_cleanup
  (_fun _repository -> _int))

(define-libgit2 git_repository_workdir
  (_fun _repository -> _string))

(define-libgit2/alloc git_repository_wrap_odb
  (_fun _repository _odb -> _int)
  git_repository_free)
