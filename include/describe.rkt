#lang racket

(require ffi/unsafe
         (only-in "types.rkt"
                  _git_object
                  _git_repository)
         libgit2/private)

(provide (all-defined-out))


; Types

(define _git_describe_strategy_t
  (_enum '(GIT_CESCRIBE_DEFAULT
           GIT_CESCRIBE_TAGS
           GIT_CESCRIBE_ALL)))

(define-cstruct _git_describe_opts
  ([version _uint]
   [max_candidate_tags _uint]
   [describe_strategy _uint]
   [pattern _string]
   [only_follow_first_parent _int]
   [show_connit_oid_as_fallback _int]))

(define GIT_DESCRIBE_DEFAULT_MAX_CANDIDATES_TAGS 10)
(define GIT_DESCRIBE_DEFAULT_ABBREVIATED_SIZE 7)
(define GIT_DESCRIBE_OPTS_VERSION 1)

(define-cstruct _git_describe_format_opts
  ([version _uint]
   [abbreviated_size _uint]
   [always_use_long_format _int]
   [dirty_suffix _string]))

(define GIT_DESCRIBE_FORMAT_OPTS_VERSION 1)

(define _describe_result (_cpointer 'git_describe_result))

; Functions

(define-libgit2/dealloc git_describe_result_free
  (_fun _describe_result -> _void))

(define-libgit2/alloc git_describe_commit
  (_fun _describe_result _git_object _git_describe_opts-pointer/null -> _int)
  git_describe_result_free)

(define-libgit2/check git_describe_format
  (_fun (_git_buf/bytes-or-null) _describe_result _git_describe_format_opts-pointer/null -> _int))

(define-libgit2/alloc git_describe_workdir
  (_fun _describe_result _git_repository _git_describe_opts-pointer/null -> _int)
  git_describe_result_free)

(define-libgit2/check git_describe_init_options
  (_fun _git_describe_opts-pointer _uint -> _int))

(define-libgit2/check git_describe_init_format_options
  (_fun _git_describe_format_opts-pointer _uint -> _int))
