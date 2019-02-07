#lang racket

(require ffi/unsafe
         "define.rkt"
         "types.rkt"
         "oidarray.rkt"
         "checkout.rkt"
         "index.rkt"
         "diff.rkt"
         "utils.rkt")
(provide (all-defined-out))


; Types

(define-cstruct _git_merge_file_input
  ([version _uint]
   [ptr _string]
   [size _size]
   [path _string]
   [mode _uint]))

(define GIT_MERGE_FILE_INPUT_VERSION 1)

(define _git_merge_flag_t
  (_bitmask '(GIT_MERGE_FIND_RENAMES = #x0001
              GIT_MERGE_FAIL_ON_CONFLICT = #x0002
              GIT_MERGE_SKIP_REUC = #x0004
              GIT_MERGE_NO_RECURSIVE = #x0008)))

(define _git_merge_file_favor_t
  (_enum '(GIT_MERGE_FILE_FAVOR_NORMAL
           GIT_MERGE_FILE_FAVOR_OURS
           GIT_MERGE_FILE_FAVOR_THEIRS
           GIT_MERGE_FILE_FAVOR_UNION)))

(define _git_merge_file_flag_t
  (_bitmask '(GIT_MERGE_FILE_DEFAULT = #x0000
              GIT_MERGE_FILE_STYLE_MERGE = #x0001
              GIT_MERGE_FILE_STYLE_DIFF3 = #x0002
              GIT_MERGE_FILE_SIMPLIFY_ALNUM = #x0004
              GIT_MERGE_FILE_IGNORE_WHITESPACE = #x0008
              GIT_MERGE_FILE_IGNORE_WHITESPACE_CHANGE = #x0010
              GIT_MERGE_FILE_IGNORE_WHITESPACE_EOL = #x0020
              GIT_MERGE_FILE_DIFF_PATIENCE = #x0040
              GIT_MERGE_FILE_DIFF_MINIMAL = #x0080)))

(define-cstruct _git_merge_file_opts
  ([version _uint]
   [ancestor_label _string]
   [our_label _string]
   [their_label _string]
   [favor _git_merge_file_favor_t]
   [flags _git_merge_file_flag_t]))

(define GIT_MERGE_FILE_OPTS_VERSION 1)

(define-cstruct _git_merge_file_result
  ([automergeable _uint]
   [path _string]
   [mode _uint]
   [ptr _string]
   [len _size]))

(define-cstruct _git_merge_opts
  ([version _uint]
   [flags _git_merge_flag_t]
   [rename_threshold _uint]
   [target_limit _uint]
   [metric _git_diff_similarity_metric-pointer]
   [recursion_limit _uint]
   [default_driver _string]
   [file_favor _git_merge_file_favor_t]
   [file_flags _git_merge_file_flag_t]))

(define GIT_MERGE_OPTS_VERSION 1)

(define _git_merge_analysis_t
  (_bitmask '(GIT_MERGE_ANALYSIS_NONE = #x0000
              GIT_MERGE_ANALYSIS_NORMAL = #x0001
              GIT_MERGE_ANALYSIS_UP_TO_DATE = #x0002
              GIT_MERGE_ANALYSIS_FASTFORWARD = #x0004
              GIT_MERGE_ANALYSIS_UNBORN = #x0008)))

(define _git_merge_preference_t
  (_enum '(GIT_MERGE_PREFERENCE_NONE
           GIT_MERGE_PREFERENCE_NO_FASTFORWARD
           GIT_MERGE_PREFERENCE_FASTFORWARD_ONLY)))

; Functions

(define-libgit2/check git_merge
  (_fun _repository (_cpointer _annotated_commit) _size _git_merge_opts-pointer _git_checkout_opts-pointer -> _int))

(define-libgit2/check git_merge_analysis
  (_fun (_cpointer _git_merge_analysis_t) (_cpointer _git_merge_preference_t) _repository (_cpointer _annotated_commit) _size -> _int))

(define-libgit2/check git_merge_base
  (_fun _oid _repository _oid _oid -> _int))

(define-libgit2/check git_merge_base_many
  (_fun _oid _repository _size (_cpointer _oid) -> _int))

(define-libgit2/check git_merge_base_octopus
  (_fun _oid _repository _size (_cpointer _oid) -> _int))

(define-libgit2/check git_merge_bases
  (_fun _oidarray _repository _oid _oid -> _int))

(define-libgit2/check git_merge_bases_many
  (_fun _oidarray _repository _size (_cpointer _oid) -> _int))

(define-libgit2/alloc git_merge_commits
  (_fun _index _repository _commit _commit _commit _git_merge_opts-pointer -> _int)
  git_index_free)

(define-libgit2/check git_merge_file
  (_fun _git_merge_file_result-pointer _git_merge_file_input-pointer _git_merge_file_input-pointer _git_merge_file_input-pointer _git_merge_file_opts-pointer -> _int))

(define-libgit2/check git_merge_file_from_index
  (_fun _git_merge_file_result-pointer _repository _index_entry _index_entry _index_entry _git_merge_file_opts-pointer -> _int))

(define-libgit2/check git_merge_file_init_input
  (_fun _git_merge_file_input-pointer _uint -> _int))

(define-libgit2/check git_merge_file_init_options
  (_fun _git_merge_file_opts-pointer _uint -> _int))

(define-libgit2/dealloc git_merge_file_result_free
  (_fun _git_merge_file_result-pointer -> _void))

(define-libgit2/check git_merge_init_options
  (_fun _git_merge_opts-pointer _uint -> _int))

(define-libgit2/alloc git_merge_trees
  (_fun _index _repository _tree _tree _tree _git_merge_opts-pointer -> _int)
  git_index_free)
