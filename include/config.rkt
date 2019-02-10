#lang racket

(require ffi/unsafe
         "types.rkt"
         "buffer.rkt"
         libgit2/private)
(provide (all-defined-out))


; Types

(define _git_config_level_t
  (_enum '(GIT_CONFIG_LEVEL_PROGRAM_DATA = 1
           GIT_CONFIG_LEVEL_SYSTEM
           GIT_CONFIG_LEVEL_XDG
           GIT_CONFIG_LEVEL_GLOBAL
           GIT_CONFIG_LEVEL_LOCAL
           GIT_CONFIG_LEVEL_APP
           GIT_CONFIG_LEVEL_HIGHEST_LEVEL = -1)))

(define-cstruct _git_config_entry
  ([name _string]
   [value _string]
   [level _git_config_level_t]
   [free (_fun _git_config_entry-pointer -> _void)]
   [payload _bytes]))
(define _config_entry _git_config_entry-pointer)

(define _git_config_foreach_cb
  (_fun _git_config_entry-pointer _bytes -> _int))

(define _config_iterator (_cpointer 'git_config_iterator))

(define _git_cvar_t
  (_enum '(GIT_CVAR_FALSE
           GIT_CVAR_TRUE
           GIT_CVAR_INT32
           GIT_CVAR_STRING)))

(define-cstruct _git_cvar_map
  ([cvar_type _git_cvar_t]
   [str_match _string]
   [map_value _int]))

; Functions

(define-libgit2/check git_config_add_backend
  (_fun _config _config_backend _git_config_level_t _bool -> _int))

(define-libgit2/check git_config_add_file_ondisk
  (_fun _config _string _git_config_level_t _bool -> _int))

(define-libgit2/check git_config_backend_foreach_match
  (_fun _config_backend _string _git_config_foreach_cb _bytes -> _int))

(define-libgit2/check git_config_delete_entry
  (_fun _config _string -> _int))

(define-libgit2/check git_config_delete_multivar
  (_fun _config _string _string -> _int))

(define-libgit2/dealloc git_config_entry_free
  (_fun _config_entry -> _void))

(define-libgit2/check git_config_find_global
  (_fun _buf -> _int))

(define-libgit2/check git_config_find_programdata
  (_fun _buf -> _int))

(define-libgit2/check git_config_find_system
  (_fun _buf -> _int))

(define-libgit2/check git_config_find_xdg
  (_fun _buf -> _int))

(define-libgit2/check git_config_foreach
  (_fun _config _git_config_foreach_cb _bytes -> _int))

(define-libgit2/check git_config_foreach_match
  (_fun _config _string _git_config_foreach_cb _bytes -> _int))

(define-libgit2/dealloc git_config_free
  (_fun _config -> _void))

(define-libgit2/alloc git_config_get_bool
  (_fun _bool _config _string -> _int))

(define-libgit2/alloc git_config_get_entry
  (_fun _config_entry _config _string -> _int)
  git_config_entry_free)

(define-libgit2/alloc git_config_get_int32
  (_fun _int32 _config _string -> _int))

(define-libgit2/alloc git_config_get_int64
  (_fun _int64 _config _string -> _int))

(define-libgit2/alloc git_config_get_mapped
  (_fun _int _config _string _git_cvar_map-pointer _size -> _int))

(define-libgit2/check git_config_get_multivar_foreach
  (_fun _config _string _string _git_config_foreach_cb _bytes -> _int))

(define-libgit2/check git_config_get_path
  (_fun _buf _config _string -> _int))

(define-libgit2/alloc git_config_get_string
  (_fun _string _config _string -> _int))

(define-libgit2/check git_config_get_string_buf
  (_fun _buf _config _string -> _int))

(define-libgit2/check git_config_init_backend
  (_fun _config_backend _uint -> _int))

(define-libgit2/dealloc git_config_iterator_free
  (_fun _config_iterator -> _void))

(define-libgit2/alloc git_config_iterator_glob_new
  (_fun _config_iterator _config _string -> _int)
  git_config_iterator_free)

(define-libgit2/alloc git_config_iterator_new
  (_fun _config_iterator _config -> _int)
  git_config_iterator_free)

(define-libgit2/alloc git_config_lock
  (_fun _transaction _config -> _int)) ; force explicit freeing on lock

(define-libgit2/alloc git_config_lookup_map_value
  (_fun _int _git_cvar_map-pointer _size _string -> _int))

(define-libgit2/alloc git_config_multivar_iterator_new
  (_fun _config_iterator _config _string _string -> _int)
  git_config_iterator_free)

(define-libgit2/alloc git_config_new
  (_fun _config -> _int)
  git_config_free)

(define-libgit2/alloc git_config_next
  (_fun _config_entry _config_iterator -> _int)
  git_config_entry_free)

(define-libgit2/alloc git_config_open_default
  (_fun _config -> _int)
  git_config_free)

(define-libgit2/alloc git_config_open_global
  (_fun _config _config -> _int)
  git_config_free)

(define-libgit2/alloc git_config_open_level
  (_fun _config _config _git_config_level_t -> _int)
  git_config_free)

(define-libgit2/alloc git_config_open_ondisk
  (_fun _config _string -> _int)
  git_config_free)

(define-libgit2/alloc git_config_parse_bool
  (_fun _bool _string -> _int))

(define-libgit2/alloc git_config_parse_int32
  (_fun _int32 _string -> _int))

(define-libgit2/alloc git_config_parse_int64
  (_fun _int64 _string -> _int))

(define-libgit2/check git_config_parse_path
  (_fun _buf _string -> _int))

(define-libgit2/check git_config_set_bool
  (_fun _config _string _bool -> _int))

(define-libgit2/check git_config_set_int32
  (_fun _config _string _int32 -> _int))

(define-libgit2/check git_config_set_int64
  (_fun _config _string _int64 -> _int))

(define-libgit2/check git_config_set_multivar
  (_fun _config _string _string _string -> _int))

(define-libgit2/check git_config_set_string
  (_fun _config _string _string -> _int))

(define-libgit2/alloc git_config_snapshot
  (_fun _config _config -> _int))
