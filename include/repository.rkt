#lang racket/base

(require ffi/unsafe
         racket/path
         racket/bytes
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
                  git_odb?
                  _git_config
                  _git_reference/null
                  _git_index
                  _git_refdb
                  _git_annotated_commit)
         libgit2/private)

(provide git_repository_open_flag/c
         ;; this is just to keep the build succeeding
         (except-out (all-defined-out)
                     git_repository_free
                     git_repository_open
                     git_repository_wrap_odb
                     git_repository_discover
                     git_repository_open_flag/c
                     git_repository_open_ext
                     git_repository_open_bare
                     git_repository_init
                     #|...|#)
         (contract-out
          ;; open
          [git_repository_open
           (->c path-string? git_repository?)]
          [git_repository_wrap_odb
           (->c git_odb? git_repository?)]
          [git_repository_discover
           (->* [path-string?]
                [#:across-fs? any/c
                 #:ceiling-dirs (listof path-string?)]
                (or/c #f path?))]
          [git_repository_open_ext
           (->* [(or/c #f path-string?)
                 git_repository_open_flag/c]
                [(listof path-string?)]
                git_repository?)]
          [git_repository_open_bare
           (->c path-string? git_repository?)]
          ;; init
          [git_repository_init
           (->* [path-string?] [#:bare? any/c] git_repository?)]
          ))

(module+ free
  ;; TODO this should *really* be private
  (provide git_repository_free))

(define-libgit2/dealloc git_repository_free
  ;; Note that after a repository is free'd, all the objects it has spawned
  ;; will still exist until they are manually closed by the user
  ;; with `git_object_free`, but accessing any of the attributes of
  ;; an object without a backing repository will result in undefined
  ;; behavior
  (_fun _git_repository -> _void))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Open
;;;;;;
;; not here: git_repository_open_from_worktree

(define-libgit2/alloc git_repository_open
  (_fun _git_repository (_path/guard) -> (_git_error_code/check))
  git_repository_free)

(define-libgit2/alloc git_repository_wrap_odb
  (_fun _git_repository _git_odb -> (_git_error_code/check))
  git_repository_free)


(define (join-ceiling-dirs ceiling-dirs)
  (and (pair? ceiling-dirs)
       (bytes-join
        (for/list ([pth (in-list ceiling-dirs)])
          ;; should these consult the security guard?
          (path->bytes
           (simple-form-path pth)))
        GIT_PATH_LIST_SEPARATOR)))

(define-libgit2 git_repository_discover
  (_fun (start-path #:across-fs? [across-fs #f]
                    #:ceiling-dirs [ceiling-dirs null])
        ::
        [bs : (_git_buf/bytes-or-null) = #f]
        [(_path/guard) = start-path]
        [_bool = across-fs]
        [_bytes/nul-terminated = (join-ceiling-dirs ceiling-dirs)]
        -> [code : (_git_error_code/check #:handle '(GIT_ENOTFOUND))]
        -> (and bs
                (not (eq? code 'GIT_ENOTFOUND))
                (bytes->path bs))))

(define-bitmask _git_repository_open_flag_t
  #:contract git_repository_open_flag/c
  [GIT_REPOSITORY_OPEN_NO_SEARCH (1<< 0)]
  [GIT_REPOSITORY_OPEN_CROSS_FS (1<< 1)]
  [GIT_REPOSITORY_OPEN_BARE (1<< 2)]
  [GIT_REPOSITORY_OPEN_NO_DOTGIT (1<< 3)]
  [GIT_REPOSITORY_OPEN_FROM_ENV (1<< 4)])

(define-libgit2/alloc git_repository_open_ext
  (_fun (start-path flags [ceiling-dirs null]) ::
        _git_repository
        [(_path/guard) = start-path] ;; null ok if GIT_REPOSITORY_OPEN_FROM_ENV
        [_git_repository_open_flag_t = flags]
        [_bytes/nul-terminated = (join-ceiling-dirs ceiling-dirs)]
        -> (_git_error_code/check))
  git_repository_free)

(define-libgit2/alloc git_repository_open_bare
  (_fun _git_repository (_path/guard) -> (_git_error_code/check))
  git_repository_free)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Init

(define-libgit2/alloc git_repository_init
  (_fun (pth #:bare? [bare? #f]) ::
        _git_repository
        [(_path/guard) = pth]
        [_bool = bare?]
        -> _int)
  git_repository_free)

(define-bitmask _git_repository_int_flag_t
  #:base _uint32
  [GIT_REPOSITORY_INIT_BARE = 1]
  [GIT_REPOSITORY_INIT_NO_REINIT = 2]
  [GIT_REPOSITORY_INIT_NO_DOTGIT_DIR = 4]
  [GIT_REPOSITORY_INIT_MKDIR = 8]
  [GIT_REPOSITORY_INIT_MKPATH = 16]
  [GIT_REPOSITORY_INIT_EXTERNAL_TEMPLATE = 32]
  [GIT_REPOSITORY_INIT_RELATIVE_GITLINK = 64])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Types



(define-enum _git_repository_init_mode_t
  #:base _uint32
  #:unknown values
  [GIT_REPOSITORY_INIT_SHARED_UMASK = 0]
  [GIT_REPOSITORY_INIT_SHARED_GROUP = #o0002775]
  [GIT_REPOSITORY_INIT_SHARED_ALL = #o0002777])

(define-cstruct _git_repository_init_opts
  ([version _uint]
   [flags _git_repository_int_flag_t]
   [mode _git_repository_init_mode_t]
   [workdir_path ;; const, null ok
    (_path/guard #:who '_git_repository_init_opts)]
   [description _string] ;; const, null ok
   [template_path ;; const, null ok
    (_path/guard #:who '_git_repository_init_opts)]
   [initial_head _string] ;; const, null ok
   [origin_url _string])) ;; const, null ok

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
  (_fun _git_config _git_repository -> (_git_error_code/check))
  git_config_free)

(define-libgit2/alloc git_repository_config_snapshot
  (_fun _git_config _git_repository -> (_git_error_code/check))
  git_config_free)

(define-libgit2 git_repository_detach_head
  (_fun _git_repository -> (_git_error_code/check)))

(define-libgit2 git_repository_fetchhead_foreach
  (_fun _git_repository _git_repository_fetchhead_foreach_cb _bytes
        -> (_git_error_code/check)))

(define-libgit2 git_repository_get_namespace
  (_fun _git_repository -> _string))

(define-libgit2 git_repository_hashfile
  (_fun _git_oid-pointer _git_repository _path _git_object_t _string
        -> (_git_error_code/check)))

(define-libgit2/alloc git_repository_head
  (_fun _git_reference/null _git_repository -> (_git_error_code/check))
  git_reference_free)

(define-libgit2 git_repository_head_detached
  (_fun _git_repository -> _bool))

(define-libgit2 git_repository_head_unborn
  (_fun _git_repository
        -> [v : (_git_error_code/check/int
                 #:handle '(0 1))]
        -> (case v
             [(0) #f]
             [(1) #t])))

(define-libgit2 git_repository_ident
  (_fun [name : (_ptr o _string)]
        [email : (_ptr o _string)]
        _git_repository
        -> [v : (_git_error_code/check)]
        -> (values name email)))

(define-libgit2/alloc git_repository_index
  (_fun _git_index _git_repository -> (_git_error_code/check))
  git_index_free)



(define-libgit2/alloc git_repository_init_ext
  (_fun _git_repository _string _git_repository_init_opts-pointer -> _int))

(define-libgit2 git_repository_init_init_options
  (_fun _git_repository_init_opts-pointer _uint
        -> (_git_error_code/check)))

(define-libgit2 git_repository_is_bare
  (_fun _git_repository -> _bool))

(define-libgit2 git_repository_is_empty
  (_fun _git_repository -> _bool))

(define-libgit2 git_repository_is_shallow
  (_fun _git_repository -> _bool))

(define-libgit2 git_repository_mergehead_foreach
  (_fun _git_repository _git_repository_mergehead_foreach_cb _bytes
        -> (_git_error_code/check)))

(define-libgit2 git_repository_message
  (_fun (_git_buf/bytes-or-null) _git_repository
        -> (_git_error_code/check)))

(define-libgit2 git_repository_message_remove
  (_fun _git_repository
        -> (_git_error_code/check)))

(define-libgit2/alloc git_repository_new
  (_fun _git_repository -> (_git_error_code/check))
  git_repository_free)

(define-libgit2/alloc git_repository_odb
  (_fun _git_odb _git_repository -> (_git_error_code/check))
  git_odb_free)



(define-libgit2 git_repository_path
  (_fun _git_repository -> _string))

(define-libgit2/alloc git_repository_refdb
  (_fun _git_refdb _git_repository -> (_git_error_code/check))
  git_refdb_free)

(define-libgit2 git_repository_reinit_filesystem
  (_fun _git_repository _int -> (_git_error_code/check)))

(define-libgit2 git_repository_set_bare
  (_fun _git_repository -> (_git_error_code/check)))

(define-libgit2 git_repository_set_config
  (_fun _git_repository _git_config -> _void))

(define-libgit2 git_repository_set_head
  (_fun _git_repository _string -> (_git_error_code/check)))

(define-libgit2 git_repository_set_head_detached
  (_fun _git_repository _git_oid-pointer -> (_git_error_code/check)))

(define-libgit2 git_repository_set_head_detached_from_annotated
  (_fun _git_repository _git_annotated_commit -> (_git_error_code/check)))

(define-libgit2 git_repository_set_ident
  (_fun _git_repository _string _string -> (_git_error_code/check)))

(define-libgit2 git_repository_set_index
  (_fun _git_repository _git_index -> _void))

(define-libgit2 git_repository_set_namespace
  (_fun _git_repository _string -> (_git_error_code/check)))

(define-libgit2 git_repository_set_odb
  (_fun _git_repository _git_odb -> _void))

(define-libgit2 git_repository_set_refdb
  (_fun _git_repository _git_refdb -> _void))

(define-libgit2 git_repository_set_workdir
  (_fun _git_repository _string _bool -> (_git_error_code/check)))

(define-libgit2 git_repository_state
  (_fun _git_repository -> _git_repository_state_t))

(define-libgit2 git_repository_state_cleanup
  (_fun _git_repository -> (_git_error_code/check)))

(define-libgit2 git_repository_workdir
  (_fun _git_repository -> _string))


