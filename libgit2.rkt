#lang racket

(require ffi/unsafe)
(require ffi/unsafe/define)

(define libgit2 (ffi-lib "libgit2" '(#f)))
(define-ffi-definer define-libgit2 libgit2)

; global.h

(define-libgit2 git-libgit2-init (_fun -> _int))
(define-libgit2 git-libgit2-shutdown (_fun -> _int))

; types.h

(define _git_time_t _int64)
(define _git_off_t _int64)

(define _git_otype
  (_enum '(GIT_OBJ_ANY = -2
           GIT_OBJ_BAD
           GIT_OBJ_EXT1
           GIT_OBJ_COMMIT
           GIT_OBJ_TREE
           GIT_OBJ_BLOB
           GIT_OBJ_TAG
           GIT_OBJ__EXT2
           GIT_OBJ_OFS_DELTA
           GIT_OBJ_REF_DELTA)))

(define _git_branch_t
  (_enum '(GIT_BRANCH_LOCAL = 1
           GIT_BRANCH_REMOTE
           GIT_BRANCH_ALL)))

(define _annotated_commit (_pointer 'git_annotated_commit))
(define _commit (_pointer 'git_commit))
(define _config (_pointer 'git_config))
(define _config_backend (_pointer 'git_config_backend))
(define _blame (_pointer 'git_blame))
(define _blob (_pointer 'git_blob))
(define _diff (_pointer 'git_diff))
(define _index (_pointer 'git_index))
(define _index_conflict_iterator (_pointer 'git_index_conflict_iterator))
(define _merge_result (_pointer 'git_merge_result))
(define _note (_pointer 'git_note))
(define _object (_pointer 'git_object))
(define _oid (_pointer 'git_oid))
(define _odb (_pointer 'git_odb))
(define _odb_backend (_pointer 'git_odb_backend))
(define _odb_object (_pointer 'git_odb_object))
(define _odb_stream (_pointer 'git_odb_stream))
(define _odb_writepack (_pointer 'git_odb_writepack))
(define _packbuilder (_pointer 'git_packbuilder))
(define _patch (_pointer 'git_patch))
(define _push (_pointer 'git_push))
(define _rebase (_pointer 'git_rebase))
(define _refdb (_pointer 'git_refdb))
(define _refdb_backend (_pointer 'git_refdb_backend))
(define _reference (_pointer 'git_reference))
(define _reference_iterator (_pointer 'git_reference_iterator))
(define _reflog (_pointer 'git_reflog))
(define _reflog_entry (_pointer 'git_reflog_entry))
(define _refspec (_pointer 'git_refspec))
(define _remote (_pointer 'git_remote))
(define _remote_callbacks (_pointer 'git_remote_callbacks))
(define _remote_head (_pointer 'git_remote_head))
(define _repository (_pointer 'git_repository))
(define _revwalk (_pointer 'git_revwalk))
(define _submodule (_pointer 'git_submodule))
(define _status_list (_pointer 'git_status_list))
(define _transaction (_pointer 'git_transaction))
(define _transport (_pointer 'git_transport))
(define _tag (_pointer 'git_tag))
(define _tree (_pointer 'git_tree))
(define _tree_builder (_pointer 'git_tree_builder))
(define _tree_entry (_pointer 'git_tree_entry))
(define _writestream (_pointer 'git_writestream))

(define-cstruct _git_time
  ([time _git_time_t]
   [offset _int]))

(define-cstruct _git_signature
  ([name _string]
   [email _string]
   [when _git_time]))
(define _signature _git_signature-pointer)

(define _git_ref_t
  (_enum '(GIT_REF_INVALID
           GIT_REF_OID
           GIT_REF_SYMBOLIC
           GIT_REF_LISTALL)))

(define _git_filemode_t
  (_enum '(GIT_FILEMODE_UNREADABLE = 0
           GIT_FILEMODE_TREE = #o0040000
           GIT_FILEMODE_BLOB = #o0100644
           GIT_FILEMODE_BLOB_EXECUTABLE #o0100755
           GIT_FILEMODE_LINK = #o0120000
           GIT_FILEMODE_COMMIT = #o0160000)))

(define-cstruct _git_transfer_progress
  ([total_objects _uint]
   [indexed_objects _uint]
   [received_objects _uint]
   [local_objects _uint]
   [total_deltas _uint]
   [indexed_deltas _uint]
   [received_bytes _size]))

(define _git_transfer_progress_cb
  (_fun _git_transfer_progress-pointer (_pointer _void) -> _int))

(define _git_transport_message_cb
  (_fun _string _int (_pointer _void) -> _int))

(define _git_cert_t
  (_enum '(GIT_CERT_NONE
           GIT_CERT_X509
           GIT_CERT_HOSTKEY_LIBSSH2
           GIT_CERT_STRARRAY)))

(define-cstruct _git_cert
  ([cert_type _git_cert_t]))
(define _cert _git_cert-pointer)

(define _git_transport_certificate_check_cb
  (_fun _cert _int _string (_pointer _void) -> _int))

(define _git_submodule_update_t
  (_enum '(GIT_SUBMODULE_UPDATE_DEFAULT
           GIT_SUBMODULE_UPDATE_CHECKOUT
           GIT_SUBMODULE_UPDATE_REBASE
           GIT_SUBMODULE_UPDATE_MERGE
           GIT_SUBMODULE_UPDATE_NONE)))
(define _git_submodule_ignore_t
  (_enum '(GIT_SUBMODULE_IGNORE_UNSPECIFIED = -1
           GIT_SUBMODULE_IGNORE_NONE = 1
           GIT_SUBMODULE_IGNORE_UNTRACKED
           GIT_SUBMODULE_IGNORE_DIRTY
           GIT_SUBMODULE_IGNORE_ALL)))
(define _git_submodule_recurse_t
  (_enum '(GIT_SUBMODULE_RECURSE_NO
           GIT_SUBMODULE_RECURSE_YES
           GIT_SUBMODULE_RECURSE_ONDEMAND)))



; buffer.h

(define-cstruct _git_buf
  ([ptr _string]
   [asize _size]
   [size _size]))
(define _buf _git_buf-pointer)

(define-libgit2 git_buf_free (_fun _buf -> _void))
(define-libgit2 git_buf_grow (_fun _buf _size -> _int))
(define-libgit2 git_buf_set (_fun _buf _pointer _size -> _int))
(define-libgit2 git_buf_is_binary (_fun _buf -> _bool))
(define-libgit2 git_buf_contains_nul (_fun _buf -> _bool))

; strarray.h

(define-cstruct _git_strarray
  ([strings (_pointer _string)]
   [count _size]))
(define _strarray _git_strarray-pointer)

(define-libgit2 git_strarray_free
  (_fun _strarray -> _void))
(define-libgit2 git_strarray_copy
  (_fun _strarray _strarray -> _int))

; annotated_commit.h

(define-libgit2 git_annotated_commit_from_ref
  (_fun (_pointer _annotated_commit) _repository _reference -> _int))
(define-libgit2 git_annotated_commit_from_fetchhead
  (_fun (_pointer _annotated_commit) _repository _string _string _oid -> _int))
(define-libgit2 git_annotated_commit_lookup
  (_fun (_pointer _annotated_commit) _repository _oid -> _int))
(define-libgit2 git_annotated_commit_from_revspec
  (_fun (_pointer _annotated_commit) _repository _string -> _int))
(define-libgit2 git_annotated_commit_id
  (_fun _annotated_commit -> _oid))
(define-libgit2 git_annotated_commit_free
  (_fun _annotated_commit -> _void))

; blame.h

(define _git_blame_flag_t
  (_enum '(GIT_BLAME_NORMAL = 0
           GIT_BLAME_TRACK_COPIES_SAME_FILE = 1
           GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES = 2
           GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES = 4
           GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES = 8
           GIT_BLAME_FIRST_PARENT = 16)))

(define-cstruct _git_blame_opts
  ([version _uint]
  [flags _uint32]
  [min_match_chars _uint16]
  [newest_commit _oid]
  [oldest_commit _oid]
  [min_line _size]
  [max_line _size]))

(define-libgit2 git_blame_init_options
  (_fun _git_blame_opts-pointer _uint -> _int))

(define-cstruct _git_blame_hunk
  ([lines_in_hunk _size]
   [final_commit_id _oid]
   [final_start_line_number _size]
   [final_signature _signature]
   [orig_commit_id _oid]
   [orig_path _string]
   [orig_sart_line_number _size]
   [orig_signature _signature]
   [boundary _ubyte]))

(define-libgit2 git_blame_get_hunk_count
  (_fun _blame -> _uint32))
(define-libgit2 git_blame_get_hunk_byindex
  (_fun _blame _uint32 -> _git_blame_hunk-pointer))
(define-libgit2 git_blame_get_hunk_byline
  (_fun _blame _size -> _git_blame_hunk-pointer))
(define-libgit2 git_blame_file
  (_fun (_pointer _blame) _repository _string (_pointer _git_blame_opts) -> _int))
(define-libgit2 git_blame_buffer
  (_fun (_pointer _blame) _blame _string _size -> _int))
(define-libgit2 git_blame_free
  (_fun _blame -> _void))

; blob.h

(define-libgit2 git_blob_lookup
  (_fun (_pointer _blob) _repository _oid -> _int))
(define-libgit2 git_blob_lookup_prefix
  (_fun (_pointer _blob) _repository _oid _size -> _int))
(define-libgit2 git_blob_free
  (_fun _blob -> _void))
(define-libgit2 git_blob_id
  (_fun _blob -> _oid))
(define-libgit2 git_blob_owner
  (_fun _blob -> _repository))
(define-libgit2 git_blob_rawcontent
  (_fun _blob -> (_pointer _void)))
(define-libgit2 git_blob_rawsize
  (_fun _blob -> _git_off_t))
(define-libgit2 git_blob_filtered_content
  (_fun _buf _blob _string _int -> _int))
(define-libgit2 git_blob_create_fromworkdir
  (_fun _oid _repository _string -> _int))
(define-libgit2 git_blob_create_fromdisk
  (_fun _oid _repository _string -> _int))
(define-libgit2 git_blob_create_fromstream
  (_fun (_pointer _writestream) _repository _string -> _int))
(define-libgit2 git_blob_create_fromstream_commit
  (_fun _oid _writestream -> _int))
(define-libgit2 git_blob_create_frombuffer
  (_fun _oid _repository (_pointer _void) _size -> _int))
(define-libgit2 git_blob_is_binary
  (_fun _blob -> _bool))
(define-libgit2 git_blob_dup
  (_fun (_pointer _blob) _blob -> _int))

; branch.h

(define-libgit2 git_branch_create
  (_fun (_pointer _reference) _repository _string _commit _bool -> _int))
(define-libgit2 git_branch_create_from_annotated
  (_fun (_pointer _reference) _repository _string _annotated_commit _bool -> _int))
(define-libgit2 git_branch_delete (_fun _reference -> _int))

(define _branch_iter (_pointer 'git_branch_iterator))

(define-libgit2 git_branch_iterator_new
  (_fun (_pointer _branch_iter) _repository _git_branch_t -> _int))
(define-libgit2 git_branch_next
  (_fun (_pointer _branch_iter) (_pointer _git_branch_t) _branch_iter -> _int))
(define-libgit2 git_branch_move
  (_fun (_pointer _reference) _reference _string _bool -> _int))
(define-libgit2 git_branch_lookup
  (_fun (_pointer _reference) _repository _string _git_branch_t -> _int))
(define-libgit2 git_branch_name
  (_fun (_pointer _string) _reference -> _int))
(define-libgit2 git_branch_upstream
  (_fun (_pointer _reference) _reference -> _int))
(define-libgit2 git_branch_set_upstream
  (_fun _reference _string -> _int))
(define-libgit2 git_branch_upstream_name
  (_fun _buf _repository _string -> _int))
(define-libgit2 git_branch_is_head
  (_fun _reference -> _bool))
(define-libgit2 git_branch_remote_name
  (_fun _buf _repository _string -> _int))
(define-libgit2 git_branch_upstream_remote
  (_fun _buf _repository _string -> _int))

; diff.h

(define _git_diff_option_t
  (_bitmask '(GIT_DIFF_NORMAL = #x00000000
              GIT_DIFF_REVERSE = #x00000001
              GIT_DIFF_INCLUDE_IGNORED = #x00000002
              GIT_DIFF_RECURSE_IGNORED_DIRS = #x00000004
              GIT_DIFF_INCLUDE_UNTRACKED = #x00000008
              GIT_DIFF_RECURSE_UNTRACKED_DIRS = #x00000010
              GIT_DIFF_INCLUDE_UNMODIFIED = #x00000020
              GIT_DIFF_INCLUDE_TYPECHANGE = #x00000040
              GIT_DIFF_INCLUDE_TYPECHANGE_TREES = #x00000080
              GIT_DIFF_IGNORE_FILEMODE = #x00000100
              GIT_DIFF_IGNORE_SUBMODULES = #x00000200
              GIT_DIFF_IGNORE_CASE = #x00000400
              GIT_DIFF_IGNORE_INCLUDE_CASECHANGE = #x00000800
              GIT_DIFF_DISABLE_PATHSPEC_MATCH = #x00001000
              GIT_DIFF_SKIP_BINARY_CHECK = #x00002000
              GIT_DIFF_ENABLE_FAST_UNTRACKED_DIRS = #x00004000
              GIT_DIFF_UPDATE_INDEX = #x00008000
              GIT_DIFF_INCLUDE_UNREADABLE = #x00010000
              GIT_DIFF_INCLUDE_UNREADABLE_AS_UNTRACKED = #x00020000
              GIT_DIFF_FORCE_TEXT = #x00100000
              GIT_DIFF_FORCE_BINARY = #x00200000
              GIT_DIFF_IGNORE_WHITESPACE = #x00400000
              GIT_DIFF_IGNORE_WHITESPACE_CHANGE = #x00800000
              GIT_DIFF_IGNORE_WHITESPACE_EOL = #x01000000
              GIT_DIFF_SHOW_UNTRACKED_CONTENT = #x02000000
              GIT_DIFF_SHOW_UNMODIFIED = #x04000000
              GIT_DIFF_PATIENCE = #x10000000
              GIT_DIFF_MINIMAL = #x20000000
              GIT_DIFF_SHOW_BINARY = #x40000000)))

(define _git_diff_flag_t
  (_bitmask '(GIT_DIFF_FLAG_BINARY = #x0000
              GIT_DIFF_FLAG_NOT_BINARY = #x0001
              GIT_DIFF_FLAG_VALID_ID = #x0002
              GIT_DIFF_FLAG_EXISTS = #x0004)))

(define _git_delta_t
  (_enum '(GIT_DELTA_UNMODIFIED
           GIT_DELTA_ADDED
           GIT_DELTA_DELETED
           GIT_DELTA_MODIFIED
           GIT_DELTA_RENAMED
           GIT_DELTA_COPIED
           GIT_DELTA_IGNORED
           GIT_DELTA_UNTRACKED
           GIT_DELTA_TYPECHANGE
           GIT_DELTA_UNREADABLE
           GIT_DELTA_CONFLICTED)))

(define-cstruct _git_diff_file
  ([id _oid]
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
  (_fun _diff _git_diff_delta-pointer _string (_pointer _void) -> _int))
(define _git_diff_progress_cb
  (_fun _diff _string _string (_pointer _void) -> _int))

(define-cstruct _git_diff_opts
  ([version _int]
   [flags _uint32]
   [ignore_submodules _git_submodule_ignore_t]
   [pathspec _strarray]
   [notify_cb _git_diff_notify_cb]
   [progress_cb _git_diff_progress_cb]
   [payload (_pointer _void)]
   [context_lines _uint32]
   [interhunk_lines _uint32]
   [id_abbrev _uint16]
   [max_size _git_off_t]
   [old_prefix _string]
   [new_prefix _string]))

(define-libgit2 git_diff_init_options
  (_fun _git_diff_opts _uint -> _int))

(define _git_diff_file_cb
  (_fun _git_diff_delta-pointer _float (_pointer _void) -> _int))

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
  (_fun _git_diff_delta-pointer _git_diff_binary-pointer (_pointer _void) -> _int))

(define-cstruct _git_diff_hunk
 ([old_start _int]
  [old_lines _int]
  [new_start _int]
  [new_lines _int]
  [header_len _size]
  [header (_array _uint8 GIT_DIFF_HUNK_HEADER_SIZE)]))

(define _git_diff_hunk_cb
  (_fun _git_diff_delta-pointer _git_diff_hunk-pointer (_pointer _void) -> _int))

(define _git_diff_line_t
  (_enum '(GIT_DIFF_LINE_CONTEXT = 32; = ' '
           GIT_DIFF_LINE_ADDITION = 43; = '+'
           GIT_DIFF_LINE_DELETION = 45; = '-'
           GIT_DIFF_LINE_CONTEXT_EOFNL = 61; = '='
           GIT_DIFF_LINE_ADD_EOFNL = 62; = '>'
           GIT_DIFF_LINE_DEL_EOFNL = 60; = '<'
           GIT_DIFF_LINE_FILE_HDR = 70; = 'F'
           GIT_DIFF_LINE_HUNK_HDR = 72; = 'H'
           GIT_DIFF_LINE_BINARY = 66; = 'B'
           )))

(define-cstruct _git_diff_line
  ([origin _uint8]
   [old_lineno _int]
   [new_lineno _int]
   [num_lines _int]
   [content_len _size]
   [content_offset _git_off_t]
   [content _string]))

(define _git_diff_line_cb
  (_fun _git_diff_delta-pointer _git_diff_hunk-pointer _git_diff_line-pointer (_pointer _void) -> _int))

(define _git_diff_find_t
  (_bitmask '(GIT_DIFF_FIND_BY_CONFIG = 0
              GIT_DIFF_FIND_RENAMES = #x00000001
              GIT_DIFF_FIND_RENAMES_FROM_REWRITES = #x00000002
              GIT_DIFF_FIND_COPIES = #x00000004
              GIT_DIFF_FIND_COPIES_FROM_UNMODIFIED = #x00000008
              GIT_DIFF_FIND_REWRITES = #x00000010
              GIT_DIFF_BREAK_REWRITES = #x00000020
              GIT_DIFF_FIND_AND_BREAK_REWRITES = #x00000030
              GIT_DIFF_FIND_FOR_UNTRACKED = #x00000040
              GIT_DIFF_FIND_ALL = #x000000FF
              GIT_DIFF_FIND_IGNORE_LEADING_WHITESPACE = 0
              GIT_DIFF_FIND_IGNORE_WHITESPACE = #x00001000
              GIT_DIFF_FIND_DONT_IGNORE_WHITESPACE = #x00002000
              GIT_DIFF_FIND_EXACT_MATCH_ONLY = #x00004000
              GIT_DIFF_BREAK_REWRITES_FOR_RENAMES_ONLY = #x00008000
              GIT_DIFF_FIND_REMOVE_UNMODIFIED = #x00010000)))

(define-cstruct _git_diff_similarity_metric
  ([file_signature (_fun (_pointer (_pointer _void))
                         _git_diff_file-pointer
                         _string
                         (_pointer _void)
                         -> _int)]
   [buffer_signature (_fun (_pointer (_pointer _void))
                         _git_diff_file-pointer
                         _string
                         _size
                         (_pointer _void)
                         -> _int)]
   [free_signature (_fun (_pointer _void) (_pointer _void) -> _void)]
   [similarity (_fun (_pointer _int) (_pointer _void) (_pointer _void) (_pointer _void) -> _int)]
   [payload (_pointer _void)]))

(define-cstruct _git_diff_find_options
  ([version _int]
   [flags _uint32]
   [rename_threshold _uint16]
   [rename_from_rewrite_threshold _uint16]
   [copy_threshold _uint16]
   [break_rewrite_threshold _uint16]
   [rename_limit _size]
   [metric _git_diff_similarity_metric-pointer]))

(define-libgit2 git_diff_find_init_options
  (_fun _git_diff_find_options-pointer _uint -> _int))
(define-libgit2 git_diff_free
  (_fun _diff -> _void))
(define-libgit2 git_diff_tree_to_tree
  (_fun (_pointer _diff) _repository _tree _tree _git_diff_opts-pointer -> _int))
(define-libgit2 git_diff_tree_to_index
  (_fun (_pointer _diff) _repository _tree _index _git_diff_opts-pointer -> _int))
(define-libgit2 git_diff_index_to_workdir
  (_fun (_pointer _diff) _repository _index _git_diff_opts-pointer -> _int))
(define-libgit2 git_diff_tree_to_workdir
  (_fun (_pointer _diff) _repository _tree _git_diff_opts-pointer -> _int))
(define-libgit2 git_diff_tree_to_workdir_with_index
  (_fun (_pointer _diff) _repository _tree _git_diff_opts-pointer -> _int))
(define-libgit2 git_diff_index_to_index
  (_fun (_pointer _diff) _repository _index _index _git_diff_opts-pointer -> _int))
(define-libgit2 git_diff_merge
  (_fun _diff _diff -> _int))
(define-libgit2 git_diff_find_similar
  (_fun _diff _git_diff_opts-pointer -> _int))
(define-libgit2 git_diff_num_deltas
  (_fun _diff -> _size))
(define-libgit2 git_diff_num_deltas_of_type
  (_fun _diff _git_delta_t -> _size))
(define-libgit2 git_diff_get_delta
  (_fun _diff _size -> _git_diff_delta-pointer))
(define-libgit2 git_diff_is_sorted_icase
  (_fun _diff -> _bool))
(define-libgit2 git_diff_foreach
  (_fun _diff _git_diff_file_cb _git_diff_binary_cb _git_diff_hunk_cb _git_diff_line_cb (_pointer _void) -> _int))
(define-libgit2 git_diff_status_char
  (_fun _git_delta_t -> _uint8))

(define _git_diff_format_t
  (_enum '(GIT_DIFF_FORMAT_PATCH = 1
           GIT_DIFF_FORMAT_PATCH_HEADER = 2
           GIT_DIFF_FORMAT_RAW = 3
           GIT_DIFF_FORMAT_NAME_ONLY = 4
           GIT_DIFF_FORMAT_NAME_STATUS = 5)))

(define-libgit2 git_diff_print
  (_fun _diff _git_diff_format_t _git_diff_line_cb (_pointer _void) -> _int))
(define-libgit2 git_diff_to_buf
  (_fun _buf _diff _git_diff_format_t -> _int))

; checkout.h

(define _git_checkout_strategy_t
  (_bitmask '(GIT_CHECKOUT_NONE = #x00000000
              GIT_CHECKOUT_SAFE = #x00000001
              GIT_CHECKOUT_FORCE = #x00000002
              GIT_CHECKOUT_RECREATE_MISSING = #x00000004
              GIT_CHECKOUT_ALLOW_CONFLICTS = #x00000010
              GIT_CHECKOUT_REMOVE_UNTRACKED = #x00000020
              GIT_CHECKOUT_REMOVE_IGNORED = #x00000040
              GIT_CHECKOUT_UPDATE_ONLY = #x00000080
              GIT_CHECKOUT_DONT_UPDATE_INDEX = #x00000100
              GIT_CHECKOUT_NO_REFRESH = #x00000200
              GIT_CHECKOUT_SKIP_UNMERGED = #x00000400
              GIT_CHECKOUT_USE_OURS = #x00000800
              GIT_CHECKOUT_USE_THEIRS = #x00001000
              GIT_CHECKOUT_DISABLE_PATHSPEC_MATCH = #x00002000
              GIT_CHECKOUT_SKIP_LOCKED_DIRECTORIES = #x00040000
              GIT_CHECKOUT_DONT_OVERWRITE_IGNORED = #x00080000
              GIT_CHECKOUT_CONFLICT_STYLE_MERGE = #x00100000
              GIT_CHECKOUT_CONFLICT_STYLE_DIFF3 = #x00200000
              GIT_CHECKOUT_DONT_REMOVE_EXISTING = #x00400000
              GIT_CHECKOUT_DONT_WRITE_INDEX = #x00800000)))

(define _git_checkout_notify_t
  (_bitmask '(GIT_CHECKOUT_NOTIFY_NONE = #x0000
              GIT_CHECKOUT_NOTIFY_CONFLICT = #x0001
              GIT_CHECKOUT_NOTIFY_DIRTY = #x0002
              GIT_CHECKOUT_NOTIFY_UPDATED = #x0004
              GIT_CHECKOUT_NOTIFY_UNTRACKED = #x0008
              GIT_CHECKOUT_NOTIFY_IGNORED = #x0010
              GIT_CHECKOUT_NOTIFY_ALL = #x0FFFF)))

(define-cstruct _git_checkout_perfdata
  ([mkdir_calls _size]
   [stat_calls _size]
   [chmod_calls _size]))

(define _git_checkout_notify_cb
  (_fun _git_checkout_notify_t _string _git_diff_file-pointer _git_diff_file-pointer _git_diff_file-pointer (_pointer _void) -> _int))
(define _git_checkout_progress_cb
  (_fun _string _size _size (_pointer _void) -> _void))
(define _git_checkout_perfdata_cb
  (_fun _git_checkout_perfdata-pointer (_pointer _void) -> _void))

(define-cstruct _git_checkout_opts
  ([version _uint]
   [checkout_strategy _uint]
   [disable_filters _int]
   [dir_mode _uint]
   [file_mode _uint]
   [file_open_flags _int]
   [notify_flags _uint]
   [notify_cb _git_checkout_notify_cb]
   [notify_payload (_pointer _void)]
   [progress_cb _git_checkout_progress_cb]
   [progress_payload (_pointer _void)]
   [paths _strarray]
   [baseline _tree]
   [baseline_index _index]
   [target_directory _string]
   [ancestor_label _string]
   [our_label _string]
   [their_label _string]
   [perfdata_cb _git_checkout_perfdata_cb]
   [perfdata_payload (_pointer _void)]))

(define-libgit2 git_checkout_init_options
  (_fun _git_checkout_opts-pointer _uint -> _int))

(define-libgit2 git_checkout_head
  (_fun _repository _git_checkout_opts-pointer -> _int))
(define-libgit2 git_checkout_index
  (_fun _repository _index _git_checkout_opts-pointer -> _int))
(define-libgit2 git_checkout_tree
  (_fun _repository _object _git_checkout_opts-pointer -> _int))

; net.h

(define GIT_DEFAULT_PORT 9418)

(define _git_direction
  (_enum '(GIT_DIRECTION_FETCH
           GIT_DIRECTION_PUSH)))

(define-cstruct _git_remote_head
  ([local _int]
   [oid _oid]
   [name _string]
   [symref_target _string]))

(define _git_headlist_cb
  (_fun _remote_head (_pointer _void) -> _int))

; transport.h

(define _git_transport_cb
  (_fun (_pointer _transport) _remote (_pointer _void) -> _int))

(define _git_cert_ssh_t
  ('bitmask '(GIT_CERT_SSH_MD5 = #x0001
              GIT_CERT_SSH_SHA1 = #x0002)))
(define-cstruct _git_cert_hostkey
  ([parent _cert]
   [type _git_cert_ssh_t]
   [hash_md5 (_array _uint8 16)]
   [hash_sha1 (_array _uint8 20)]))

(define-cstruct _git_cert_x509
  ([parent _cert]
   [data (_pointer _void)]
   [len _size]))

(define _git_credtype_t
  (_bitmask '(GIT_CREDTYPE_USERPASS_PLAINTEXT = #x0001
              GIT_CREDTYPE_SSH_KEY = #x0002
              GIT_CREDTYPE_SSH_CUSTOM = #x0004
              GIT_CREDTYPE_DEFAULT = #x0008
              GIT_CREDTYPE_SSH_INTERACTIVE = #x0010
              GIT_CREDTYPE_USERNAME = #x0020
              GIT_CREDTYPE_SSH_MEMORY = #x0040)))

(define _cred (_pointer 'git_cred))

(define-cstruct _git_cred_userpass_plaintext
  ([parent _cred]
   [username _string]
   [password _string]))

(define _git_cred_sign_callback
  (_fun (_pointer 'LIBSSH2_SESSION) (_pointer _string) (_pointer _size) _string _size (_pointer (_pointer _void)) -> _int))
(define _git_cred_ssh_interactive_callback
  (_fun _string _int _string _int _int (_pointer 'LIBSSH_USERAUTH_KBDINT_PROMPT) (_pointer 'LIBSSH_USERAUTH_KBDINT_RESPONSE) (_pointer (_pointer _void)) -> _void))

(define-cstruct _git_cred_ssh_key
  ([parent _cred]
   [username _string]
   [publickey _string]
   [privatekey _string]
   [passphrase _string]))
(define-cstruct _git_cred_ssh_interactive
  ([parent _cred]
   [username _string]
   [prompt_callback _git_cred_ssh_interactive_callback]
   [payload (_pointer _void)]))
(define-cstruct _git_cred_ssh_custom
  ([parent _cred]
   [username _string]
   [publickey _string]
   [publickey_len _size]
   [sign_callback _git_cred_sign_callback]
   [payload (_pointer _void)]))
(define-cstruct _git_cred_username
  ([parent _cred]
   [username (_array _int8 1)]))

(define-libgit2 git_cred_has_username
  (_fun _cred -> _bool))
(define-libgit2 git_cred_userpass_plaintext_new
  (_fun (_pointer _cred) _string _string -> _int))
(define-libgit2 git_cred_ssh_key_new
  (_fun (_pointer _cred) _string _string _string _string -> _int))
(define-libgit2 git_cred_ssh_interactive_new
  (_fun (_pointer _cred) _string _git_cred_ssh_interactive_callback (_pointer _void) -> _int))
(define-libgit2 git_cred_ssh_key_from_agent
  (_fun (_pointer _cred) _string -> _int))
(define-libgit2 git_cred_ssh_custom_new
  (_fun (_pointer _cred) _string _string _size _git_cred_sign_callback (_pointer _void) -> _int))
(define-libgit2 git_cred_default_new
  (_fun (_pointer _cred) -> _int))
(define-libgit2 git_cred_username_new
  (_fun (_pointer _cred) _string -> _int))
(define-libgit2 git_cred_ssh_key_memory_new
  (_fun (_pointer _cred) _string _string _string _string -> _int))
(define-libgit2 git_cred_free
  (_fun _cred -> _void))

(define _git_cred_acquire_cb
  (_fun (_pointer _cred) _string _string _uint (_pointer _void) -> _int))


; proxy.h

(define _git_proxy_t
  (_enum '(GIT_PROXY_NONE
           GIT_PROXY_AUTO
           GIT_PROXY_SPECIFIED)))

(define-cstruct _git_proxy_opts
  ([version _uint]
   [type _git_proxy_t]
   [url _string]
   [credentials _git_cred_acquire_cb]
   [certificate_check _git_transport_certificate_check_cb]
   [payload (_pointer _void)]))

(define-libgit2 git_proxy_init_options
  (_fun _git_proxy_opts-pointer _uint -> _int))

; pack.h
(define _git_packbuilder_stage_t
  (_enum '(GIT_PACKBUILDER_ADDING_OBJECTS
           GIT_PACKBUILDER_DELTAFICATION)))

(define-libgit2 git_packbuilder_new
  (_fun (_pointer _packbuilder) _repository -> _int))
(define-libgit2 git_packbuilder_set_threads
  (_fun _packbuilder _uint -> _uint))
(define-libgit2 git_packbuilder_insert
  (_fun _packbuilder _oid _string -> _int))
(define-libgit2 git_packbuilder_insert_tree
  (_fun _packbuilder _oid -> _int))
(define-libgit2 git_packbuilder_insert_commit
  (_fun _packbuilder _oid -> _int))
(define-libgit2 git_packbuilder_insert_walk
  (_fun _packbuilder _revwalk -> _int))
(define-libgit2 git_packbuilder_insert_recur
  (_fun _packbuilder _oid _string -> _int))
(define-libgit2 git_packbuilder_write_buf
  (_fun _buf _packbuilder -> _int))
(define-libgit2 git_packbuilder_write
  (_fun _packbuilder _string _uint _git_transfer_progress_cb (_pointer _void) -> _int))
(define-libgit2 git_packbuilder_hash
  (_fun _packbuilder -> _oid))

(define _git_packbuilder_foreach_cb
  (_fun (_pointer _void) _size (_pointer _void) -> _int))

(define-libgit2 git_packbuilder_foreach
  (_fun _packbuilder _git_packbuilder_foreach_cb (_pointer _void) -> _int))
(define-libgit2 git_packbuilder_written
  (_fun _packbuilder -> _size))

(define _git_packbuilder_progress
  (_fun _int _uint32 _uint32 (_pointer _void) -> _int))

(define-libgit2 git_packbuilder_set_callbacks
  (_fun _packbuilder _git_packbuilder_progress (_pointer _void) -> _int))
(define-libgit2 git_packbuilder_free
  (_fun _packbuilder -> _void))

; remote.h

(define-libgit2 git_remote_create
  (_fun (_pointer _remote) _repository _string _string -> _int))
(define-libgit2 git_remote_create_with_fetchspec
  (_fun (_pointer _remote) _repository _string _string _string -> _int))
(define-libgit2 git_remote_create_anonymous
  (_fun (_pointer _remote) _repository _string -> _int))
(define-libgit2 git_remote_lookup
  (_fun (_pointer _remote) _repository _string -> _int))
(define-libgit2 git_remote_dup
  (_fun (_pointer _remote) _remote -> _int))
(define-libgit2 git_remote_owner
  (_fun _remote -> _repository))
(define-libgit2 git_remote_name
  (_fun _remote -> _string))
(define-libgit2 git_remote_url
  (_fun _remote -> _string))
(define-libgit2 git_remote_pushurl
  (_fun _remote -> _string))
(define-libgit2 git_remote_set_url
  (_fun _repository _remote _string -> _int))
(define-libgit2 git_remote_set_pushurl
  (_fun _repository _remote _string -> _int))
(define-libgit2 git_remote_add_fetch
  (_fun _repository _remote _string -> _int))
(define-libgit2 git_remote_get_fetch_refspecs
  (_fun _strarray _remote -> _int))
(define-libgit2 git_remote_add_push
  (_fun _repository _remote _string -> _int))
(define-libgit2 git_remote_refspec_count
  (_fun _remote -> _size))
(define-libgit2 git_remote_get_refspec
  (_fun _remote _size -> _refspec))
(define-libgit2 git_remote_connect
  (_fun _remote _git_direction _remote_callbacks _git_proxy_opts-pointer _strarray -> _int))
(define-libgit2 git_remote_ls
  (_fun (_pointer (_pointer _remote_head)) _size _remote -> _int))
(define-libgit2 git_remote_connected
  (_fun _remote -> _bool))
(define-libgit2 git_remote_stop
  (_fun _remote -> _void))
(define-libgit2 git_remote_disconnect
  (_fun _remote -> _void))
(define-libgit2 git_remote_free
  (_fun _remote -> _void))
(define-libgit2 git_remote_list
  (_fun _strarray _repository -> _int))

(define _git_remote_completion_type
  (_enum '(GIT_REMOTE_COMPLETION_DOWNLOAD
           GIT_REMOTE_COMPLETION_INDEXING
           GIT_REMOTE_COMPLETION_ERROR)))

(define _git_push_transfer_progress
  (_fun _uint _uint _size (_pointer _void) -> _int))

(define-cstruct _git_push_update
  ([src_name _string]
   [dst_name _string]
   [src _oid]
   [dst _oid]))
(define _push_update _git_push_update-pointer)

(define _git_push_negotiation
  (_fun (_pointer _push_update) _size (_pointer _void) -> _int))

(define-cstruct _git_remote_callbacks
  ([version _uint]
   [sideband_progress _git_transport_message_cb]
   [completion (_fun _git_remote_completion_type (_pointer _void) -> _int)]
   [credentials _git_cred_acquire_cb]
   [certificate_check _git_transport_certificate_check_cb]
   [transfer_progress _git_transfer_progress_cb]
   [update_tips (_fun _string _oid _oid (_pointer _void) -> _int)]
   [pack_progress _git_packbuilder_progress]
   [push_transfer_progress _git_push_transfer_progress]
   [push_update_reference (_fun _string _string (_pointer _void) -> _int)]
   [push_negotiation _git_push_negotiation]
   [transport _git_transport_cb]
   [payload (_pointer _void)]))

(define-libgit2 git_remote_init_callbacks
  (_fun _git_remote_callbacks-pointer _uint -> _int))
(define _git_fetch_prune_t
  (_enum '(GIT_FETCH_PRUNE_UNSPECIFIED
           GIT_FETCH_PRUNE_PRUNE
           GIT_FETCH_PRUNE_NO_PRUNE)))
(define _git_remote_autotag_option_t
  (_enum '(GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED
           GIT_REMOTE_DOWNLOAD_TAGS_AUTO
           GIT_REMOTE_DOWNLOAD_TAGS_NONE
           GIT_REMOTE_DOWNLOAD_TAGS_ALL)))

(define-cstruct _git_fetch_opts
  ([version _int]
   [callbacks _git_remote_callbacks]
   [prune _git_fetch_prune_t]
   [update_fetchhead _int]
   [download_tags _git_remote_autotag_option_t]
   [proxy_opts _git_proxy_opts]
   [custom_headers _strarray]))

(define-libgit2 git_fetch_init_options
  (_fun _git_fetch_opts-pointer _uint -> _int))

(define-cstruct _git_push_opts
  ([version _uint]
   [pb_parallelism _uint]
   [callbacks _git_remote_callbacks]
   [proxy_opts _git_proxy_opts]
   [cusotm_headers _strarray]))

(define-libgit2 git_push_init_options
  (_fun _git_push_opts-pointer _uint -> _int))
(define-libgit2 git_remote_download
  (_fun _remote _strarray _git_fetch_opts-pointer -> _int))
(define-libgit2 git_remote_upload
  (_fun _remote _strarray _git_push_opts-pointer  -> _int))
(define-libgit2 git_remote_update_tips
  (_fun _remote _git_remote_callbacks-pointer _int _git_remote_autotag_option_t _string -> _int))
(define-libgit2 git_remote_fetch
  (_fun _remote _strarray _git_fetch_opts-pointer _string -> _int))
(define-libgit2 git_remote_prune
  (_fun _remote _git_remote_callbacks-pointer -> _int))
(define-libgit2 git_remote_push
  (_fun _remote _strarray _git_push_opts-pointer -> _int))
(define-libgit2 git_remote_stats
  (_fun _remote -> _git_transfer_progress-pointer))
(define-libgit2 git_remote_autotag
  (_fun _remote -> _git_remote_autotag_option_t))
(define-libgit2 git_remote_set_autotag
  (_fun _repository _string _git_remote_autotag_option_t -> _int))
(define-libgit2 git_remote_prune_refs
  (_fun _remote -> _int))
(define-libgit2 git_remote_rename
  (_fun _strarray _repository _string _string -> _int))
(define-libgit2 git_remote_delete
  (_fun _repository _string -> _int))
(define-libgit2 git_remote_default_branch
  (_fun _buf _remote -> _int))


; clone.h

(define _git_clone_local_t
  (_enum '(GIT_CLONE_LOCAL_AUTO
           GIT_CLONE_LOCAL
           GIT_CLONE_NO_LOCAL
           GIT_CLONE_LOCAL_NO_LINKS)))

(define _git_remote_create_cb
  (_fun (_pointer _remote) _repository _string _string (_pointer _void) -> _int))
(define _git_repository_create_cb
  (_fun (_pointer _repository) _string _int (_pointer _void) -> _int))

(define-cstruct _git_clone_opts
  ([version _uint]
   [checkout_opts _git_checkout_opts]
   [fetch_opts _git_fetch_opts]
   [bare _int]
   [local _git_clone_local_t]
   [checkout_branch _string]
   [repository_cb _git_repository_create_cb]
   [repository_cb_payload (_pointer _void)]
   [remote_cb _git_remote_create_cb]
   [remote_cb_payload (_pointer _void)]))

(define-libgit2 git_clone_init_options
  (_fun _git_clone_opts-pointer _uint -> _int))
(define-libgit2 git_clone
  (_fun (_pointer _repository) _string _string _git_clone_opts-pointer -> _int))

; merge.h

(define-cstruct _git_merge_file_input
  ([version _uint]
   [ptr _string]
   [size _size]
   [path _string]
   [mode _uint]))

(define-libgit2 git_merge_file_init_input
  (_fun _git_merge_file_input-pointer _uint -> _int))

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

(define-libgit2 git_merge_file_init_options
  (_fun _git_merge_file_opts-pointer _uint -> _int))

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

(define-libgit2 git_merge_init_options
  (_fun _git_merge_opts-pointer _uint -> _int))

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

(define-libgit2 git_merge_analysis
  (_fun (_pointer _git_merge_analysis_t) (_pointer _git_merge_preference_t) _repository (_pointer _annotated_commit) _size -> _int))
(define-libgit2 git_merge_base
  (_fun _oid _repository _oid _oid -> _int))
(define-libgit2 git_merge_bases
  (_fun _oidarray _repository _oid _oid -> _int))
(define-libgit2 git_merge_base_many
  (_fun _oid _repository _size (_array _oid) -> _int))
(define-libgit2 git_merge_bases_many
  (_fun _oidarray _repository _size (_array _oid) -> _int))
(define-libgit2 git_merge_base_octopus
  (_fun _oid _repository _size (_array _oid) -> _int))
(define-libgit2 git_merge_file
  (_fun _git_merge_file_result-pointer _git_merge_file_input-pointer _git_merge_file_input-pointer _git_merge_file_input-pointer _git_merge_file_opts-pointer -> _int))
(define-libgit2 git_merge_file_from_index
  (_fun _git_merge_file_result-pointer _repository _index_entry _index_entry _index_entry _git_merge_file_opts-pointer -> _int))
(define-libgit2 git_merge_file_result_free
  (_fun _git_merge-file_result-pointer -> _void))
(define-libgit2 git_merge_trees
  (_fun (_pointer _index) _repository _tree _tree _tree _git_merge_opts-pointer -> _int))
(define-libgit2 git_merge_commits
  (_fun (_pointer _index) _repository _commit _commit _commit _git_merge_opts-pointer -> _int))
(define-libgit2 git_merge
  (_fun _repository (_pointer _annotated_commit) _size _git_merge_opts-pointer _git_checkout_opts-pointer -> _int))

; cherrypick.h

(define-cstruct _git_cherrypick_opts
  ([version _uint]
   [mainline _uint]
   [merge_opts _git_merge_opts]
   [checkout_opts _git_checkout_opts]))