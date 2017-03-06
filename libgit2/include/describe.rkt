#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "buffer.rkt"
         "utils.rkt")
(provide (all-defined-out))


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

(define git_describe_init_options
  (_fun _git_describe_opts-pointer _uint -> _int))

(define-cstruct _git_describe_format_opts
  ([version _uint]
   [abbreviated_size _uint]
   [always_use_long_format _int]
   [dirty_suffix _string]))

(define git_describe_init_format_options
  (_fun _git_describe_format_opts-pointer _uint -> _int))

(define _describe_result (_cpointer 'git_describe_result))

(define-libgit2/alloc git_describe_commit
  (_fun _describe_result _object _git_describe_opts-pointer -> _int))
(define-libgit2/alloc git_describe_workdir
  (_fun _describe_result _repository _git_describe_opts-pointer -> _int))
(define-libgit2/check git_describe_format
  (_fun _buf _describe_result _git_describe_format_opts-pointer -> _int))
(define-libgit2 git_describe_result_free
  (_fun _describe_result -> _void))

