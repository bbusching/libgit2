#lang racket

(require ffi/unsafe
         "strarray.rkt"
         (submod "oid.rkt" private)
         (only-in "types.rkt"
                  _git_repository
                  _git_off_t
                  _git_submodule_ignore_t
                  _git_diff
                  _git_signature-pointer
                  _git_blob/null
                  _git_commit
                  _git_index
                  _git_tree)
         libgit2/private)

(provide (all-defined-out))

; Types

(define-bitmask _git_diff_option_t
  [GIT_DIFF_NORMAL = #x00000000]
  [GIT_DIFF_REVERSE = #x00000001]
  [GIT_DIFF_INCLUDE_IGNORED = #x00000002]
  [GIT_DIFF_RECURSE_IGNORED_DIRS = #x00000004]
  [GIT_DIFF_INCLUDE_UNTRACKED = #x00000008]
  [GIT_DIFF_RECURSE_UNTRACKED_DIRS = #x00000010]
  [GIT_DIFF_INCLUDE_UNMODIFIED = #x00000020]
  [GIT_DIFF_INCLUDE_TYPECHANGE = #x00000040]
  [GIT_DIFF_INCLUDE_TYPECHANGE_TREES = #x00000080]
  [GIT_DIFF_IGNORE_FILEMODE = #x00000100]
  [GIT_DIFF_IGNORE_SUBMODULES = #x00000200]
  [GIT_DIFF_IGNORE_CASE = #x00000400]
  [GIT_DIFF_IGNORE_INCLUDE_CASECHANGE = #x00000800]
  [GIT_DIFF_DISABLE_PATHSPEC_MATCH = #x00001000]
  [GIT_DIFF_SKIP_BINARY_CHECK = #x00002000]
  [GIT_DIFF_ENABLE_FAST_UNTRACKED_DIRS = #x00004000]
  [GIT_DIFF_UPDATE_INDEX = #x00008000]
  [GIT_DIFF_INCLUDE_UNREADABLE = #x00010000]
  [GIT_DIFF_INCLUDE_UNREADABLE_AS_UNTRACKED = #x00020000]
  [GIT_DIFF_FORCE_TEXT = #x00100000]
  [GIT_DIFF_FORCE_BINARY = #x00200000]
  [GIT_DIFF_IGNORE_WHITESPACE = #x00400000]
  [GIT_DIFF_IGNORE_WHITESPACE_CHANGE = #x00800000]
  [GIT_DIFF_IGNORE_WHITESPACE_EOL = #x01000000]
  [GIT_DIFF_SHOW_UNTRACKED_CONTENT = #x02000000]
  [GIT_DIFF_SHOW_UNMODIFIED = #x04000000]
  [GIT_DIFF_PATIENCE = #x10000000]
  [GIT_DIFF_MINIMAL = #x20000000]
  [GIT_DIFF_SHOW_BINARY = #x40000000])

(define-bitmask _git_diff_flag_t
  [GIT_DIFF_FLAG_BINARY = #x0000]
  [GIT_DIFF_FLAG_NOT_BINARY = #x0001]
  [GIT_DIFF_FLAG_VALID_ID = #x0002]
  [GIT_DIFF_FLAG_EXISTS = #x0004])

(define-enum _git_delta_t
  GIT_DELTA_UNMODIFIED
  GIT_DELTA_ADDED
  GIT_DELTA_DELETED
  GIT_DELTA_MODIFIED
  GIT_DELTA_RENAMED
  GIT_DELTA_COPIED
  GIT_DELTA_IGNORED
  GIT_DELTA_UNTRACKED
  GIT_DELTA_TYPECHANGE
  GIT_DELTA_UNREADABLE
  GIT_DELTA_CONFLICTED)

(define-cstruct _git_diff_file
  ([id _git_oid-pointer]
   [path _string]
   [size _git_off_t]
   [flags _uint32]
   [mode _uint16]
   [id_abbrev _uint16]))

(define-cstruct _git_diff_delta
  ([status _git_delta_t]
   [flags _uint32]
   [similarity _uint16]
   [nfiles _uint16]
   [old_file _git_diff_file]
   [new_file _git_diff_file]))

(define _git_diff_notify_cb
  (_fun _git_diff _git_diff_delta-pointer _string _bytes -> _int))
(define _git_diff_progress_cb
  (_fun _git_diff _string _string _bytes -> _int))

(define-cstruct _git_diff_opts
  ([version _int]
   [flags _uint32]
   [ignore_submodules _git_submodule_ignore_t]
   [pathspec _strarray]
   [notify_cb _git_diff_notify_cb]
   [progress_cb _git_diff_progress_cb]
   [payload _bytes]
   [context_lines _uint32]
   [interhunk_lines _uint32]
   [id_abbrev _uint16]
   [max_size _git_off_t]
   [old_prefix _string]
   [new_prefix _string]))

(define GIT_DIFF_OPTS_VERSION 1)

(define _git_diff_file_cb
  (_fun _git_diff_delta-pointer _float _bytes -> _int))

(define GIT_DIFF_HUNK_HEADER_SIZE 128)

(define _git_diff_binary_t
  (_enum '(GIT_DIFF_BINARY_NONE
           GIT_DIFF_BINARY_LITERAL
           GIT_DIFF_BINARY_DELTA)))

(define-cstruct _git_diff_binary_file
  ([type _git_diff_binary_t]
   [data _string]
   [datalen _size]
   [inflatedlen _size]))

(define-cstruct _git_diff_binary
  ([contains_data _uint]
   [old_file _git_diff_binary_file]
   [new_file _git_diff_binary_file]))

(define _git_diff_binary_cb
  (_fun _git_diff_delta-pointer _git_diff_binary-pointer _bytes -> _int))

(define-cstruct _git_diff_hunk
  ([old_start _int]
   [old_lines _int]
   [new_start _int]
   [new_lines _int]
   [header_len _size]
   [header (_array _uint8 GIT_DIFF_HUNK_HEADER_SIZE)]))

(define _git_diff_hunk_cb
  (_fun _git_diff_delta-pointer _git_diff_hunk-pointer _bytes -> _int))

(define-enum _git_diff_line_t
  [GIT_DIFF_LINE_CONTEXT = 32] ; = ' '
  [GIT_DIFF_LINE_ADDITION = 43] ; = '+'
  [GIT_DIFF_LINE_DELETION = 45] ; = '-'
  [GIT_DIFF_LINE_CONTEXT_EOFNL = 61] ; = '='
  [GIT_DIFF_LINE_ADD_EOFNL = 62] ; = '>'
  [GIT_DIFF_LINE_DEL_EOFNL = 60] ; = '<'
  [GIT_DIFF_LINE_FILE_HDR = 70] ; = 'F'
  [GIT_DIFF_LINE_HUNK_HDR = 72] ; = 'H'
  [GIT_DIFF_LINE_BINARY = 66] ; = 'B'
  )

(define-cstruct _git_diff_line
  ([origin _uint8]
   [old_lineno _int]
   [new_lineno _int]
   [num_lines _int]
   [content_len _size]
   [content_offset _git_off_t]
   [content _string]))

(define _git_diff_line_cb
  (_fun _git_diff_delta-pointer _git_diff_hunk-pointer _git_diff_line-pointer _bytes -> _int))

(define-bitmask _git_diff_find_t
  [GIT_DIFF_FIND_BY_CONFIG = 0]
  [GIT_DIFF_FIND_RENAMES = #x00000001]
  [GIT_DIFF_FIND_RENAMES_FROM_REWRITES = #x00000002]
  [GIT_DIFF_FIND_COPIES = #x00000004]
  [GIT_DIFF_FIND_COPIES_FROM_UNMODIFIED = #x00000008]
  [GIT_DIFF_FIND_REWRITES = #x00000010]
  [GIT_DIFF_BREAK_REWRITES = #x00000020]
  [GIT_DIFF_FIND_AND_BREAK_REWRITES = #x00000030]
  [GIT_DIFF_FIND_FOR_UNTRACKED = #x00000040]
  [GIT_DIFF_FIND_ALL = #x000000FF]
  [GIT_DIFF_FIND_IGNORE_LEADING_WHITESPACE = 0]
  [GIT_DIFF_FIND_IGNORE_WHITESPACE = #x00001000]
  [GIT_DIFF_FIND_DONT_IGNORE_WHITESPACE = #x00002000]
  [GIT_DIFF_FIND_EXACT_MATCH_ONLY = #x00004000]
  [GIT_DIFF_BREAK_REWRITES_FOR_RENAMES_ONLY = #x00008000]
  [GIT_DIFF_FIND_REMOVE_UNMODIFIED = #x00010000])

(define-cstruct _git_diff_similarity_metric
  ([file_signature (_fun (_cpointer _bytes)
                         _git_diff_file-pointer
                         _string
                         _bytes
                         -> _int)]
   [buffer_signature (_fun (_cpointer _bytes)
                           _git_diff_file-pointer
                           _string
                           _size
                           _bytes
                           -> _int)]
   [free_signature (_fun _bytes _bytes -> _void)]
   [similarity (_fun (_cpointer _int) _bytes _bytes _bytes -> _int)]
   [payload _bytes]))

(define-cstruct _git_diff_find_options
  ([version _int]
   [flags _uint32]
   [rename_threshold _uint16]
   [rename_from_rewrite_threshold _uint16]
   [copy_threshold _uint16]
   [break_rewrite_threshold _uint16]
   [rename_limit _size]
   [metric _git_diff_similarity_metric-pointer]))

(define GIT_DIFF_FIND_OPTS_VERSION 1)

(define-enum _git_diff_format_t
  [GIT_DIFF_FORMAT_PATCH = 1]
  [GIT_DIFF_FORMAT_PATCH_HEADER = 2]
  [GIT_DIFF_FORMAT_RAW = 3]
  [GIT_DIFF_FORMAT_NAME_ONLY = 4]
  [GIT_DIFF_FORMAT_NAME_STATUS = 5])

(define-cpointer-type _diff_stats)

(define-bitmask _git_diff_stats_format_t
  [GIT_DIFF_STATS_NONE = 0]
  [GIT_DIFF_STATS_FULL = 1]
  [GIT_DIFF_STATS_SHORT = 2]
  [GIT_DIFF_STATS_NUMBER = 4]
  [GIT_DIFF_STATS_INCLUDE_SUMMARY = 8])

(define-bitmask _git_diff_format_email_flags_t
  [GIT_DIFF_FORMAT_EMAIL_NONE = 0]
  [GIT_DIFF_FORMAT_EMAIL_EXCLUDE_SUBJECT_PATCH_MARKER = 1])

(define-cstruct _git_diff_format_email_opts
  ([version _uint]
   [flags _git_diff_format_email_flags_t]
   [patch_no _size]
   [total_patches _size]
   [id _git_oid-pointer]
   [summary _string]
   [body _string]
   [author _git_signature-pointer]))

(define GIT_DIFF_FORMAT_EMAIL_OPTS_VERSION 1)

; Functions

(define-libgit2/dealloc git_diff_free
  (_fun _git_diff -> _void))

(define-libgit2/dealloc git_diff_stats_free
  (_fun _diff_stats -> _void))

(define-libgit2/check git_diff_blob_to_buffer
  (_fun _git_blob/null _string _string _size _string _git_diff_opts-pointer/null _git_diff_file_cb _git_diff_binary_cb _git_diff_hunk_cb _git_diff_line_cb _bytes -> _int))

(define-libgit2/check git_diff_blobs
  (_fun _git_blob/null _string _git_blob/null _string _git_diff_opts-pointer/null _git_diff_file_cb _git_diff_binary_cb _git_diff_hunk_cb _git_diff_line_cb _bytes -> _int))

(define-libgit2/check git_diff_buffers
  (_fun _bytes _size _string _bytes _size _string _git_diff_opts-pointer/null _git_diff_file_cb _git_diff_binary_cb _git_diff_hunk_cb _git_diff_line_cb _bytes -> _int))

(define-libgit2/check git_diff_commit_as_email
  (_fun (_git_buf/bytes-or-null) _git_repository _git_commit _size _size _git_diff_format_email_flags_t _git_diff_opts-pointer/null -> _int))

(define-libgit2/check git_diff_find_init_options
  (_fun _git_diff_find_options-pointer _uint -> _int))

(define-libgit2/check git_diff_find_similar
  (_fun _git_diff _git_diff_opts-pointer/null -> _int))

(define-libgit2/check git_diff_foreach
  (_fun _git_diff _git_diff_file_cb _git_diff_binary_cb _git_diff_hunk_cb _git_diff_line_cb _bytes -> _int))

(define-libgit2/check git_diff_format_email
  (_fun (_git_buf/bytes-or-null) _git_diff _git_diff_format_email_opts-pointer/null -> _int))

(define-libgit2/check git_diff_format_email_init_options
  (_fun _git_diff_format_email_opts-pointer _uint -> _int))

(define-libgit2/alloc git_diff_from_buffer
  (_fun _git_diff _string _size -> _int)
  git_diff_free)

(define-libgit2 git_diff_get_delta
  (_fun _git_diff _size -> _git_diff_delta-pointer/null))

(define-libgit2/alloc git_diff_get_stats
  (_fun _diff_stats _git_diff -> _int)
  git_diff_stats_free)

(define-libgit2/alloc git_diff_index_to_index
  (_fun _git_diff _git_repository _git_index _git_index _git_diff_opts-pointer/null -> _int)
  git_diff_free)

(define-libgit2/alloc git_diff_index_to_workdir
  (_fun _git_diff _git_repository _git_index _git_diff_opts-pointer -> _int)
  git_diff_free)

(define-libgit2 git_diff_init_options
  (_fun _git_diff_opts _uint -> _int))

(define-libgit2 git_diff_is_sorted_icase
  (_fun _git_diff -> _bool))

(define-libgit2/check git_diff_merge
  (_fun _git_diff _git_diff -> _int))

(define-libgit2 git_diff_num_deltas
  (_fun _git_diff -> _size))

(define-libgit2 git_diff_num_deltas_of_type
  (_fun _git_diff _git_delta_t -> _size))

(define-libgit2/check git_diff_print
  (_fun _git_diff _git_diff_format_t _git_diff_line_cb _bytes -> _int))

(define-libgit2 git_diff_stats_deletions
  (_fun _diff_stats -> _size))

(define-libgit2 git_diff_stats_files_changed
  (_fun _diff_stats -> _size))

(define-libgit2 git_diff_stats_insertions
  (_fun _diff_stats -> _size))

(define-libgit2/check git_diff_stats_to_buf
  (_fun (_git_buf/bytes-or-null) _diff_stats _git_diff_stats_format_t _size -> _int))

(define-libgit2 git_diff_status_char
  (_fun _git_delta_t -> _uint8))

(define-libgit2/check git_diff_to_buf
  (_fun (_git_buf/bytes-or-null) _git_diff _git_diff_format_t -> _int))

(define-libgit2/alloc git_diff_tree_to_index
  (_fun _git_diff _git_repository _git_tree _git_index _git_diff_opts-pointer -> _int)
  git_diff_free)

(define-libgit2/alloc git_diff_tree_to_tree
  (_fun _git_diff _git_repository _git_tree _git_tree _git_diff_opts-pointer -> _int)
  git_diff_free)

(define-libgit2/alloc git_diff_tree_to_workdir
  (_fun _git_diff _git_repository _git_tree _git_diff_opts-pointer -> _int)
  git_diff_free)

(define-libgit2/alloc git_diff_tree_to_workdir_with_index
  (_fun _git_diff _git_repository _git_tree _git_diff_opts-pointer -> _int)
  git_diff_free)
