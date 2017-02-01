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

; oidarray.h

(define-cstruct _git_oidarray
  ([oid _oid]
   [count _size]))
(define _oidarray _git_oidarray-pointer)

(define-libgit2 git_oidarray_free
  (_fun _oidarray -> _void))

; oid.h

(define GIT_OID_RAWSZ 20)
(define GIT_OID_HEXSZ (* GIT_OID_RAWSZ 2))
(define GIT_OID_MINPREFIXLEN 4)

(define-cstruct _git_oid
  ([id (_array _uint8 GIT_OID_RAWSZ)]))

(define _oid_shorten (_pointer 'git_oid_shorten))

(define-libgit2 git_oid_fromstr
  (_fun _oid _string -> _int))
(define-libgit2 git_oid_fromstrp
  (_fun _oid _string -> _int))
(define-libgit2 git_oid_fromstrn
  (_fun _oid _string _size -> _int))
(define-libgit2 git_oid_fromraw
  (_fun _oid (_pointer _uint8) -> _void))
(define-libgit2 git_oid_fmt
  (_fun _string _oid -> _void))
(define-libgit2 git_oid_nfmt
  (_fun _string _size _oid -> _void))
(define-libgit2 git_oid_pathfmt
  (_fun _string _oid -> _void))
(define-libgit2 git_oid_tostr_s
  (_fun _oid -> _string))
(define-libgit2 git_oid_tostr
  (_fun _oid -> _string))
(define-libgit2 git_oid_cmp
  (_fun _oid _oid -> _int))
(define-libgit2 git_oid_equal
  (_fun _oid _oid -> _bool))
(define-libgit2 git_oid_ncmp
  (_fun _oid _oid _size -> _int))
(define-libgit2 git_oid_streq
  (_fun _oid _string -> _int))
(define-libgit2 git_oid_strcmp
  (_fun _oid _string -> _int))
(define-libgit2 git_oid_iszero
  (_fun _oid -> _bool))
(define-libgit2 git_oid_shorten_new
  (_fun _size -> _oid_shorten))
(define-libgit2 git_oid_shorten_add
  (_fun _oid_shorten _string -> _int))
(define-libgit2 git_oid_shorten_free
  (_fun _oid_shorten -> _void))

; index.h

(define-cstruct _git_index_time
  ([seconds _int32]
   [nanoseconds _uint32]))

(define-cstruct _git_index_entry
  ([ctime _git_index_time]
   [mtime _git_index_time]
   [dev _uint32]
   [ino _uint32]
   [mode _uint32]
   [uid _uint32]
   [gid _uint32]
   [file_size _uint32]
   [id _git_oid]
   [flags _uint16]
   [flags_extended _uint16]
   [path _string]))
(define _index_entry _git_index_entry-pointer)

(define _git_indxentry_flag_t
  (_enum '(GIT_IDXENTRY_EXTENDED = #x4000
           GIT_IDXENTRY_VALID = #x8000)))

(define _git_idxentry_extended_flag_t
  (_bitmask '(GIT_IDXENTRY_INTENT_TO_ADD = #x2000
              GIT_IDXENTRY_SKIP_WORKTREE = #x4000
              GIT_IDXENTRY_EXTENDED2 = #x8000
              GIT_IDXENTRY_EXTENDED_FLAGS = #x6000
              GIT_IDXENTRY_UPDATE = #x0001
              GIT_IDXENTRY_REMOTE = #x0002
              GIT_IDXENTRY_UPTODATE = #x0004
              GIT_IDXENTRY_ADDED = #x0008
              GIT_IDXENTRY_HASHED = #x0010
              GIT_IDXENTRY_UNHASHED = #x0020
              GIT_IDXENTRY_WT_REMOVE = #x0040
              GIT_IDXENTRY_CONFLICTED = #x0080
              GIT_IDXENTRY_UNPACKED = #x0100
              GIT_IDXENTRY_NEW_SKIP_WORKTREE = #x0200)))

(define _git_indexcap_t
  (_enum '(GIT_INDEXCAP_IGNORE_CASE = 1
           GIT_INDEXCAP_NO_FILEMODE = 2
           GIT_INDEXCAP_NO_SYMLINKS = 4
           GIT_INDEXCAP_FROM_OWNER = -1)))

(define _git_index_matched_path_cb
  (_fun _string _string (_pointer _void) -> _int))

(define _git_index_add_option_t
  (_bitmask '(GIT_INDEX_ADD_DEFAULT = 0
              GIT_INDEX_ADD_FORCE = 1
              GIT_INDEX_ADD_DISABLE_PATHSPEC_MATCH = 2
              GIT_INDEX_ADD_CHECK_PATHSPEC = 4)))

(define _git_index_stage_t
  (_enum '(GIT_INDEX_STAGE_ANY = -1
           GIT_INDEX_STAGE_NORMAL
           GIT_INDEX_STAGE_ANCESTOR
           GIT_INDEX_STAGE_OURS
           GIT_INDEX_STAGE_THEIRS)))

(define-libgit2 git_index_open
  (_fun (_pointer _index) _string -> _int))
(define-libgit2 git_index_new
  (_fun (_pointer _index) -> _int))
(define-libgit2 git_index_free
  (_fun _index -> _void))
(define-libgit2 git_index_owner
  (_fun _index -> _repository))
(define-libgit2 git_index_caps
  (_fun _index -> _int))
(define-libgit2 git_index_set_caps
  (_fun _index _int -> _int))
(define-libgit2 git_index_version
  (_fun _index -> _uint))
(define-libgit2 git_index_set_version
  (_fun _index _uint -> _int))
(define-libgit2 git_index_read
  (_fun _index _int -> _int))
(define-libgit2 git_index_write
  (_fun _index -> _int))
(define-libgit2 git_index_path
  (_fun _index -> _string))
(define-libgit2 git_index_read_tree
  (_fun _index _tree -> _int))
(define-libgit2 git_index_write_tree_to
  (_fun _oid _index _repository -> _int))
(define-libgit2 git_index_entry_count
  (_fun _index -> _size))
(define-libgit2 git_index_get_byindex
  (_fun _index _size -> _index_entry))
(define-libgit2 git_index_get_bypath
  (_fun _index _string _int -> _index_entry))
(define-libgit2 git_index_remove
  (_fun _index _string _int -> _int))
(define-libgit2 git_index_remove_directory
  (_fun _index _string _int -> _int))
(define-libgit2 git_index_add
  (_fun _index _index_entry -> _int))
(define-libgit2 git_index_entry_stage
  (_fun _index_entry -> _int))
(define-libgit2 git_index_entry_is_conflict
  (_fun _index_entry -> _bool))
(define-libgit2 git_index_add_bypath
  (_fun _index _string -> _int))
(define-libgit2 git_index_add_frombuffer
  (_fun _index _index_entry (_pointer _void) _size -> _int))
(define-libgit2 git_index_remove_bypath
  (_fun _index _string -> _int))
(define-libgit2 git_index_add_all
  (_fun _index _strarray _uint _git_index_matched_path_cb (_pointer _void) -> _int))
(define-libgit2 git_index_remove_all
  (_fun _index _strarray _git_index_matched_path_cb (_pointer _void) -> _int))
(define-libgit2 git_index_update_all
  (_fun _index _strarray _git_index_matched_path_cb (_pointer _void) -> _int))
(define-libgit2 git_index_find_prefix
  (_fun (_pointer _size) _index _string -> _int))
(define-libgit2 git_index_conflict_add
  (_fun _index _index_entry _index_entry _index_entry -> _int))
(define-libgit2 git_index_conflict_get
  (_fun (_pointer _index_entry) (_pointer _index_entry) (_pointer _index_entry) _index _string -> _int))
(define-libgit2 git_index_conflict_remove
  (_fun _index _string -> _int))
(define-libgit2 git_index_conflict_cleanup
  (_fun _index -> _int))
(define-libgit2 git_index_has_conflicts
  (_fun _index -> _bool))
(define-libgit2 git_index_conflict_iterator_new
  (_fun (_pointer _index_conflict_iterator) _index -> _bool))
(define-libgit2 git_index_conflict_next
  (_fun (_pointer _index_entry) (_pointer _index_entry) (_pointer _index_entry) _index_conflict_iterator -> _bool))
(define-libgit2 git_index_conflict_iterator_free
  (_fun _index_conflict_iterator -> _void))

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
  (_fun _git_merge_file_result-pointer -> _void))
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

(define-libgit2 git_cherrypick_init_options
  (_fun _git_cherrypick_opts-pointer _uint -> _int))
(define-libgit2 git_cherrypick_commit
  (_fun (_pointer _index) _repository _commit _commit _uint _git_merge_opts-pointer -> _int))
(define-libgit2 git_cherrypick
  (_fun _repository _commit _git_cherrypick_opts-pointer -> _int))

; commit.h

(define-libgit2 git_commit_lookup
  (_fun (_pointer _commit) _repository _oid -> _int))
(define-libgit2 git_commit_lookup_prefix
  (_fun (_pointer _commit) _repository _oid _size -> _int))
(define-libgit2 git_commit_free
  (_fun _commit -> _void))
(define-libgit2 git_commit_id
  (_fun _commit -> _oid))
(define-libgit2 git_commit_owner
  (_fun _commit -> _repository))
(define-libgit2 git_commit_message_encoding
  (_fun _commit -> _string))
(define-libgit2 git_commit_message
  (_fun _commit -> _string))
(define-libgit2 git_commit_message_raw
  (_fun _commit -> _string))
(define-libgit2 git_commit_summary
  (_fun _commit -> _string))
(define-libgit2 git_commit_body
  (_fun _commit -> _string))
(define-libgit2 git_commit_time
  (_fun _commit -> _git_time_t))
(define-libgit2 git_commit_time_offset
  (_fun _commit -> _int))
(define-libgit2 git_commit_commiter
  (_fun _commit -> _signature))
(define-libgit2 git_commit_author
  (_fun _commit -> _signature))
(define-libgit2 git_commit_raw_header
  (_fun _commit -> _string))
(define-libgit2 git_commit_tree
  (_fun (_pointer _tree) _commit -> _int))
(define-libgit2 git_commit_tree_id
  (_fun _commit -> _oid))
(define-libgit2 git_commit_parentcount
  (_fun _commit -> _uint))
(define-libgit2 git_commit_parent
  (_fun (_pointer _commit) _commit _uint -> _int))
(define-libgit2 git_commit_parent_id
  (_fun _commit _uint -> _oid))
(define-libgit2 git_commit_nth_gen_ancestor
  (_fun (_pointer _commit) _commit _uint -> _int))
(define-libgit2 git_commit_header_field
  (_fun _buf _commit _string -> _int))
(define-libgit2 git_commit_extract_signature
  (_fun _buf _buf _repository _oid _string -> _int))
(define-libgit2 git_commit_create
  (_fun _oid _repository _string _signature _signature _string _string _tree _size (_pointer (_array _commit)) -> _int))
(define-libgit2 git_commit_ammend
  (_fun _oid _commit _string _signature _signature _string _string _tree -> _int))
(define-libgit2 git_commit_create_buffer
  (_fun _buf _repository _signature _signature _string _string _tree _size (_pointer (_array _commit)) -> _int))
(define-libgit2 git_commit_create_with_signature
  (_fun _oid _repository _string _string _string -> _int))
(define-libgit2 git_commit_dup
  (_fun (_pointer _commit) _commit -> _int))

; config.h

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
   [payload (_pointer _void)]))
(define _config_entry _git_config_entry-pointer)

(define-libgit2 git_config_entry_free
  (_fun _config_entry -> _void))

(define _git_config_foreach_cb
  (_fun _git_config_entry-pointer (_pointer _void) -> _int))
(define _config_iterator (_pointer 'git_config_iterator))
(define _git_cvar_t
  (_enum '(GIT_CVAR_FALSE
           GIT_CVAR_TRUE
           GIT_CVAR_INT32
           GIT_CVAR_STRING)))

(define-cstruct _git_cvar_map
  ([cvar_type _git_cvar_t]
   [str_match _string]
   [map_value _int]))

(define-libgit2 git_config_find_global
  (_fun _buf -> _int))
(define-libgit2 git_config_find_xdg
  (_fun _buf -> _int))
(define-libgit2 git_config_find_system
  (_fun _buf -> _int))
(define-libgit2 git_config_find_programdata
  (_fun _buf -> _int))
(define-libgit2 git_config_open_default
  (_fun (_pointer _config) -> _int))
(define-libgit2 git_config_new
  (_fun (_pointer _config) -> _int))
(define-libgit2 git_config_add_file_ondisk
  (_fun _config _string _git_config_level_t _int -> _int))
(define-libgit2 git_config_open_ondisk
  (_fun (_pointer _config) _string -> _int))
(define-libgit2 git_config_open_level
  (_fun (_pointer _config) _config _git_config_level_t -> _int))
(define-libgit2 git_config_open_global
  (_fun (_pointer _config) _config -> _int))
(define-libgit2 git_config_snapshot
  (_fun (_pointer _config) _config -> _int))
(define-libgit2 git_config_free
  (_fun _config -> _void))
(define-libgit2 git_config_get_entry
  (_fun (_pointer _config_entry) _config _string -> _int))
(define-libgit2 git_config_get_int32
  (_fun (_pointer _int32) _config _string -> _int))
(define-libgit2 git_config_get_int64
  (_fun (_pointer _int64) _config _string -> _int))
(define-libgit2 git_config_get_bool
  (_fun (_pointer _bool) _config _string -> _int))
(define-libgit2 git_config_get_path
  (_fun _buf _config _string -> _int))
(define-libgit2 git_config_get_string
  (_fun (_pointer _string) _config _string -> _int))
(define-libgit2 git_config_get_string_buf
  (_fun _buf _config _string -> _int))
(define-libgit2 git_config_get_multivar_foreach
  (_fun _config _string _string _git_config_foreach_cb (_pointer _void) -> _int))
(define-libgit2 git_config_get_multivar_iterator_new
  (_fun (_pointer _config_iterator) _config _string _string -> _int))
(define-libgit2 git_config_next
  (_fun (_pointer _config_entry) _config_iterator -> _int))
(define-libgit2 git_config_iterator_free
  (_fun _config_iterator -> _void))
(define-libgit2 git_config_set_int32
  (_fun _config _string _int32 -> _int))
(define-libgit2 git_config_set_int64
  (_fun _config _string _int64 -> _int))
(define-libgit2 git_config_set_bool
  (_fun _config _string _bool -> _int))
(define-libgit2 git_config_set_string
  (_fun _config _string _string -> _int))
(define-libgit2 git_config_set_multivar
  (_fun _config _string _string _string -> _int))
(define-libgit2 git_config_delete_entry
  (_fun _config _string -> _int))
(define-libgit2 git_config_delete_multivar
  (_fun _config _string _string -> _int))
(define-libgit2 git_config_foreach
  (_fun _config _git_config_foreach_cb (_pointer _void) -> _int))
(define-libgit2 _git_config_iterator_new
  (_fun (_pointer _config_iterator) _config -> _int))
(define-libgit2 _git_config_iterator_glob_new
  (_fun (_pointer _config_iterator) _config _string -> _int))
(define-libgit2 _git_config_foreach_match
  (_fun _config _string _git_config_foreach_cb (_pointer _void) -> _int))
(define-libgit2 _git_config_get_mapped
  (_fun (_pointer _int) _config _string _git_cvar_map-pointer _size -> _int))
(define-libgit2 _git_config_lookup_map_value
  (_fun (_pointer _int) _git_cvar_map-pointer _size _string -> _int))
(define-libgit2 _git_config_parse_bool
  (_fun (_pointer _bool) _string -> _int))
(define-libgit2 _git_config_parse_int32
  (_fun (_pointer _int32) _string -> _int))
(define-libgit2 _git_config_parse_int64
  (_fun (_pointer _int64) _string -> _int))
(define-libgit2 _git_config_parse_path
  (_fun _buf _string -> _int))
(define-libgit2 _git_config_backend_foreach_match
  (_fun _config_backend _string _git_config_foreach_cb (_pointer _void) -> _int))
(define-libgit2 _git_config_lock
  (_fun (_pointer _transaction) _config -> _int))

; cred_helpers.h

(define-cstruct _git_cred_userpass_payload
  ([username _string]
   [password _string]))

(define-libgit2 git_cred_userpass
  (_fun (_pointer _cred) _string _string _uint (_pointer _void) -> _int))

; describe.h

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

(define _describe_result (_pointer 'git_describe_result))

(define-libgit2 git_describe_commit
  (_fun (_pointer _describe_result) _object _git_describe_opts-pointer -> _int))
(define-libgit2 git_describe_workdir
  (_fun (_pointer _describe_result) _repository _git_describe_opts-pointer -> _int))
(define-libgit2 git_describe_format
  (_fun _buf _describe_result _git_describe_format_opts-pointer -> _int))
(define-libgit2 git_describe_result_free
  (_fun _describe_result -> _void))

; errors.h

(define _git_error_code
  (_enum '(GIT_OK = 0
           GIT_ERROR = -1
           GIT_ENOTFOUND = -3
           GIT_EEXISTS = -4
           GIT_EAMBIGUOUS = -5
           GIT_EBUFS = -6
           GIT_EUSER = -7
           GIT_EBAREREPO = -8
           GIT_EUNBORNBRANCH = -9
           GIT_EUNMERGED = -10
           GIT_ENONFASTFORWARD = -11
           GIT_EINVALIDSPEC = -12
           GIT_ECONFLICT = -13
           GIT_ELOCKED = -14
           GIT_EMODIFIED = -15
           GIT_EAUTH = -16
           GIT_ECERTIFICATE = -17
           GIT_EAPPLIED = -18
           GIT_EPEEl = -19
           GIT_EEOF = -20
           GIT_EINVALID = -21
           GIT_EUNCOMMITTED = -22
           GIT_EDIRECTORY = -23
           GIT_EMERGECONFLICT = -24
           GIT_PASSTHROUGH = -30
           GIT_ITEROVER = -31)))

(define-cstruct _git_error
  ([message _string]
   [klass _int]))
(define _error _git_error-pointer)

(define _git_error_t
  (_enum '(GITERR_NONE
           GITERR_NOMEMORY
           GITERR_OS
           GITERR_INVALID
           GITERR_REFERENCE
           GITERR_ZLIB
           GITERR_REPOSITORY
           GITERR_CONFIG
           GITERR_REGEX
           GITERR_ODB
           GITERR_INDEX
           GITERR_OBJECT
           GITERR_NET
           GITERR_TAG
           GITERR_TREE
           GITERR_INDEXER
           GITERR_SSL
           GITERR_SUBMODULE
           GITERR_THREAD
           GITERR_STASH
           GITERR_CHECKOUT
           GITERR_FETCHHEAD
           GITERR_MERGE
           GITERR_SSH
           GITERR_FILTER
           GITERR_REVERT
           GITERR_CALLBACK
           GITERR_CHERRYPICK
           GITERR_DESCRIBE
           GITERR_REBASE
           GITERR_FILESYSTEM
           GITERR_PATCH)))

(define-libgit2 git_errlast
  (_fun _void -> _error))
(define-libgit2 git_clear
  (_fun _void -> _void))
(define-libgit2 giterr_set_str
  (_fun _int _string -> _void))
(define-libgit2 git_set_oom
  (_fun _void -> _void))

; filter.h

(define _git_filter_mode_t
  (_enum '(GIT_FILTER_TO_WORKTREE = 0
           GIT_FILTER_SMUDGE = 'GITFILTER_TO_WORKTREE
           GIT_FILTER_TO_ODB = 1
           GIT_FILTER_CLEAN = 'GIT_FILTER_TO_OBD)))

(define _git_filter_flag_t
  (_bitmask '(GIT_FILTER_DEFAULT = 0
              GIT_FILTER_ALLOW_UNSAFE = 1)))

(define _filter (_pointer 'git_filter))

(define-libgit2 git_filter_list_load
  (_fun (_pointer _filter) _repository _blob _string _git_filter_mode_t _uint32 -> _int))
(define-libgit2 git_filter_list_contains
  (_fun _filter _string -> _bool))
(define-libgit2 git_filter_list_apply_to_data
  (_fun _buf _filter _buf -> _int))
(define-libgit2 git_filter_list_apply_to_file
  (_fun _buf _filter _repository _string -> _int))
(define-libgit2 git_filter_list_apply_to_blob
  (_fun _buf _filter _blob -> _int))
(define-libgit2 git_filter_list_stream_data
  (_fun _filter _buf _writestream -> _int))
(define-libgit2 git_filter_list_stream_file
  (_fun _filter _repository _string _writestream -> _int))
(define-libgit2 git_filter_list_stream_blob
  (_fun _filter _blob _writestream -> _int))
(define-libgit2 git_filter_list_free
  (_fun _filter -> _void))

; global.h

(define-libgit2 git_libgit2_init
  (_fun _void -> _int))
(define-libgit2 git_libgit2_shutdown
  (_fun _void -> _int))

; graph.h

(define-libgit2 git_graph_ahead_behind
  (_fun (_pointer _size) (_pointer _size) _repository _oid _oid -> _int))
(define-libgit2 git_graph_descendant_of
  (_fun _repository _oid _oid -> _int))

; ignore.h

(define-libgit2 git_ignore_add_rule
  (_fun _repository _string -> _int))
(define-libgit2 git_ignore_clear_internal_rules
  (_fun _repository -> _int))
(define-libgit2 git_ignore_path_is_ignored
  (_fun (_pointer _int) _repository _string -> _int))

; indexer.h

(define _indexer (_pointer 'git_indexer))

(define-libgit2 git_indexer_new
  (_fun (_pointer _indexer) _string _uint _odb _git_transfer_progress_cb (_pointer _void) -> _int))
(define-libgit2 git_indexer_append
  (_fun _indexer (_pointer _void) _size _git_transfer_progress-pointer -> _int))
(define-libgit2 git_indexer_commit
  (_fun _indexer _git_transfer_progress-pointer -> _int))
(define-libgit2 git_indexer_has
  (_fun _indexer -> _oid))
(define-libgit2 git_indexer_free
  (_fun _indexer -> _void))

; message.h

(define-libgit2 git_message_prettify
  (_fun _buf _string _int _int8 -> _int))

; notes.h

(define _git_note_foreach_cb
  (_fun _oid _oid (_pointer _void) -> _int))

(define _note_iterator (_pointer 'git_iterator))

(define-libgit2 git_note_iterator_new
  (_fun (_pointer _note_iterator) _repository _string -> _int))
(define-libgit2 git_note_iterator_free
  (_fun _note_iterator -> _void))
(define-libgit2 git_note_next
  (_fun _oid _oid _note_iterator -> _int))
(define-libgit2 git_note_read
  (_fun (_pointer _note) _repository _string _oid -> _int))
(define-libgit2 git_note_author
  (_fun _note -> _signature))
(define-libgit2 git_note_commiter
  (_fun _note -> _signature))
(define-libgit2 git_note_message
  (_fun _note -> _string))
(define-libgit2 git_note_id
  (_fun _note -> _oid))
(define-libgit2 git_note_create
  (_fun _oid _repository _string _signature _signature _oid _note _int -> _int))
(define-libgit2 git_note_remove
  (_fun _repository _string _signature _signature _oid -> _int))
(define-libgit2 git_note_free
  (_fun _note -> _void))
(define-libgit2 git_note_default_ref
  (_fun _buf _repository -> _int))
(define-libgit2 git_note_foreach
  (_fun _repository _string _git_note_foreach_cb (_pointer _void) -> _int))

; object.h

(define-libgit2 git_object_lookup
  (_fun (_pointer _object) _repository _oid _git_otype -> _int))
(define-libgit2 git_object_lookup_prefix
  (_fun (_pointer _object) _repository _oid _size _git_otype -> _int))
(define-libgit2 git_object_lookup_bypath
  (_fun (_pointer _object) _object _string _git_otype -> _int))
(define-libgit2 git_object_id
  (_fun _object -> _oid))
(define-libgit2 git_object_type
  (_fun _object -> _git_otype))
(define-libgit2 git_object_owner
  (_fun _object -> _repository))
(define-libgit2 git_object_free
  (_fun _object -> _void))
(define-libgit2 git_object_type2string
  (_fun _git_otype -> _string))
(define-libgit2 git_object_string2type
  (_fun _string -> _git_otype))
(define-libgit2 git_object_typeisloose
  (_fun _git_otype -> _bool))
(define-libgit2 git_object__size
  (_fun _git_otype -> _size))
(define-libgit2 git_object_peel
  (_fun (_pointer _object) _object _git_otype -> _int))
(define-libgit2 git_object_dup
  (_fun (_pointer _object) _object -> _int))

; odb.h

(define _git_odb_foreach_cb
  (_fun _oid (_pointer _void) -> _int))

(define-libgit2 git_odb_new
  (_fun (_pointer _odb) -> _int))
(define-libgit2 git_odb_open
  (_fun (_pointer _odb) _string -> _int))
(define-libgit2 git_odb_add_disk_alternate
  (_fun _odb _string -> _int))
(define-libgit2 git_odb_free
  (_fun _odb -> _void))
(define-libgit2 git_odb_read
  (_fun (_pointer _odb_object) _odb _oid -> _int))
(define-libgit2 git_odb_read_prefix
  (_fun (_pointer _odb_object) _odb _oid _size -> _int))
(define-libgit2 git_odb_read_header
  (_fun (_pointer _size) (_pointer _git_otype) _odb _oid -> _int))
(define-libgit2 git_odb_exists
  (_fun _odb _oid -> _bool))
(define-libgit2 git_odb_exists_prefix
  (_fun _oid _odb _oid _size -> _bool))

(define-cstruct _git_odb_expand_id
  ([id _oid]
   [length _ushort]
   [type _git_otype]))
(define _odb_expand_id _git_odb_expand_id-pointer)

(define-libgit2 git_odb_expand_ids
  (_fun _odb _odb_expand_id _size -> _int))
(define-libgit2 git_odb_refresh
  (_fun _odb -> _int))
(define-libgit2 git_odb_foreach
  (_fun _odb _git_odb_foreach_cb (_pointer _void) -> _int))
(define-libgit2 git_odb_write
  (_fun _oid _odb (_pointer _void) _size _git_otype -> _int))
(define-libgit2 git_odb_open_wstream
  (_fun (_pointer _odb_stream) _odb _git_off_t _git_otype -> _int))
(define-libgit2 git_odb_stream_write
  (_fun _odb_stream _string _size -> _int))
(define-libgit2 git_odb_stream_finalize_write
  (_fun _oid _odb_stream -> _int))
(define-libgit2 git_odb_stream_read
  (_fun _odb_stream _string _size -> _int))
(define-libgit2 git_odb_stream_free
  (_fun _odb_stream -> _void))
(define-libgit2 git_odb_open_rstream
  (_fun (_pointer _odb_stream) _odb _oid -> _int))
(define-libgit2 git_odb_write_pack
  (_fun (_pointer _odb_writepack) _odb _git_transfer_progress_cb (_pointer _void) -> _int))
(define-libgit2 git_odb_hash
  (_fun _oid (_pointer _void) _size _git_otype -> _int))
(define-libgit2 git_odb_hashfile
  (_fun _oid _string _git_otype -> _int))
(define-libgit2 git_odb_object_dup
  (_fun (_pointer _odb_object) _odb_object -> _int))
(define-libgit2 git_odb_object_id
  (_fun _odb_object -> _oid))
(define-libgit2 git_odb_object_data
  (_fun _odb_object -> (_pointer _void)))
(define-libgit2 git_odb_object_type
  (_fun _odb_object -> _git_otype))
(define-libgit2 git_odb_add_backend
  (_fun _odb _odb_backend _int -> _int))
(define-libgit2 git_odb_add_alternate
  (_fun _odb _odb_backend _int -> _int))
(define-libgit2 git_odb_num_backends
  (_fun _odb -> _size))
(define-libgit2 git_odb_get_backend
  (_fun (_pointer _odb_backend) _odb _size -> _int))

; odb_backend.h

(define-libgit2 git_odb_backend_loose
  (_fun (_pointer _odb_backend) _string _int _int _uint _uint -> _int))
(define-libgit2 git_odb_backend_one_pack
  (_fun (_pointer _odb_backend) _string -> _int))
(define _git_odb_stream_t
  (_enum '(GIT_STREAM_RDONLY = 2
           GIT_STREAM_WRONLY = 4
           GIT_STREAM_RW = 6)))

(define-cstruct _git_odb_stream
  ([backend _odb_backend]
   [mode _uint]
   [hash_ctx (_pointer _void)]
   [declared_size _git_off_t]
   [received_bytes _git_off_t]
   [read (_fun _git_odb_stream-pointer _string _size -> _int)]
   [write (_fun _git_odb_stream-pointer _string _size -> _int)]
   [finalize_write (_fun _git_odb_stream-pointer _oid -> _int)]
   [free (_fun _git_odb_stream-pointer -> _void)]))

(define-cstruct _git_odb_writepack
  ([backend _odb_backend]
   [append (_fun _git_odb_writepack-pointer (_pointer _void) _size _git_transfer_progress-pointer -> _int)]
   [commit (_fun _git_odb_writepack-pointer _git_transfer_progress-pointer -> _int)]
   [free (_fun _git_odb_writepack-pointer -> _void)]))

; patch.h

(define-libgit2 git_patch_from_diff
  (_fun (_pointer _patch) _diff _size -> _int))
(define-libgit2 git_patch_from_blobs
  (_fun (_pointer _patch) _blob _string _blob _string _git_diff_opts-pointer -> _int))
(define-libgit2 git_patch_from_blob_and_buffer
  (_fun (_pointer _patch) _blob _string _string _size _string _git_diff_opts-pointer -> _int))
(define-libgit2 git_patch_from_buffers
  (_fun (_pointer _patch) (_pointer _void) _size _string _string _size _string _git_diff_opts-pointer -> _int))
(define-libgit2 git_patch_free
  (_fun _patch -> _void))
(define-libgit2 git_patch_get_delta
  (_fun _patch -> _git_diff_delta-pointer))
(define-libgit2 git_patch_line_stats
  (_fun (_pointer _size) (_pointer _size) (_pointer _size) _patch  -> _int))
(define-libgit2 git_patch_get_hunk
  (_fun _git_diff_hunk-pointer (_pointer _size) _patch _size -> _int))
(define-libgit2 git_patch_num_lines_in_hunk
  (_fun _patch _size -> _int))
(define-libgit2 git_patch_get_line_in_hunk
  (_fun (_pointer _git_diff_line-pointer) _patch _size _size -> _int))
(define-libgit2 git_patch_size
  (_fun _patch _int _int _int -> _size))
(define-libgit2 git_patch_print
  (_fun _patch _git_diff_line_cb (_pointer _void) -> _int))
(define-libgit2 git_patch_to_buf
  (_fun _buf _patch -> _int))

; pathspec.h

(define _pathspec (_pointer 'git_pathspec))
(define _pathspec_match_list (_pointer 'git_pathspec_match_list))

(define _git_pathspec_flag_t
  (_bitmask '(GIT_PATHSPEC_DEFAULT = #x0000
              GIT_PATHSPEC_IGNORE_CASE = #x0001
              GIT_PATHSPEC_USE_CASE = #x0002
              GIT_PATHSPEC_NO_GLOB = #x0004
              GIT_PATHSPEC_NO_MATCH_ERROR = #x0008
              GIT_PATHSPEC_FIND_FAILURES = #x0010
              GIT_PATHSPEC_FAILURES_ONLY = #x0020)))

(define-libgit2 git_pathspec_new
  (_fun (_pointer _pathspec) _strarray -> _int ))
(define-libgit2 git_pathspec_free
  (_fun _pathspec -> _void))
(define-libgit2 git_pathspec_matches_path
  (_fun _pathspec _uint32 _string -> _int))
(define-libgit2 git_pathspec_match_workdir
  (_fun (_pointer _pathspec_match_list) _repository _uint32 _pathspec -> _int))
(define-libgit2 git_pathspec_match_index
  (_fun (_pointer _pathspec_match_list) _index _uint32 _pathspec -> _int))
(define-libgit2 git_pathspec_match_tree
  (_fun (_pointer _pathspec_match_list) _tree _uint32 _pathspec -> _int))
(define-libgit2 git_pathspec_match_diff
  (_fun (_pointer _pathspec_match_list) _diff _uint32 _pathspec -> _int))
(define-libgit2 git_pathspec_match_list_free
  (_fun _pathspec_match_list -> _int))
(define-libgit2 git_pathspec_match_list_entrycount
  (_fun _pathspec_match_list -> _size))
(define-libgit2 git_pathspec_match_list_entry
  (_fun _pathspec_match_list _size -> _string))
(define-libgit2 git_pathspec_match_list_diff_entry
  (_fun _pathspec_match_list _size -> _git_diff_delta-pointer))
(define-libgit2 git_pathspec_match_list_failed_entrycount
  (_fun _pathspec_match_list -> _size))
(define-libgit2 git_pathspec_match_list_failed_entry
  (_fun _pathspec_match_list _size -> _string))

; rebase.h

(define-cstruct _git_rebase_opts
  ([version _uint]
   [quiet _int]
   [inmemory _int]
   [rewrite_notes_ref _string]
   [merge_options _git_merge_opts]
   [checkout_options _git_checkout_opts]))

(define _git_rebase_operation_t
  (_enum '(GIT_REBASE_OPERATION_PICK
           GIT_REBASE_OPERATION_REWORD
           GIT_REBASE_OPERATION_EDIT
           GIT_REBASE_OPERATION_SQUASH
           GIT_REBASE_OPERATION_FIXUP
           GIT_REBASE_OPERATION_EXEC)))

(define-cstruct _git_rebase_operation
  ([type _git_rebase_operation_t]
   [id _git_oid]
   [exec _string]))

(define-libgit2 git_rebase_init_options
  (_fun _git_rebase_opts-pointer _uint -> _int))
(define-libgit2 git_rebase_init
  (_fun (_pointer _rebase) _repository _annotated_commit _annotated_commit  _annotated_commit _git_rebase_opts-pointer -> _int))
(define-libgit2 git_rebase_open
  (_fun (_pointer _rebase) _repository _git_rebase_opts-pointer -> _int))
(define-libgit2 git_rebase_operation_entrycount
  (_fun _rebase -> _size))
(define-libgit2 git_rebase_operation_current
  (_fun _rebase -> _git_rebase_operation-pointer))
(define-libgit2 git_rebase_operation_byindex
  (_fun _rebase _int -> _git_rebase_operation-pointer))
(define-libgit2 git_rebase_operation_next
  (_fun (_pointer _git_rebase_operation-pointer) _rebase -> _int))
(define-libgit2 git_rebase_inmemory_index
  (_fun (_pointer _index) _rebase -> _int))
(define-libgit2 git_rebase_commit
  (_fun _oid _rebase _signature _signature _string _string -> _int))
(define-libgit2 git_rebase_abort
  (_fun _rebase -> _int))
(define-libgit2 git_rebase_finish
  (_fun _rebase _signature -> _int))
(define-libgit2 git_rebase_free
  (_fun _rebase -> _void))

; refdb.h

(define-libgit2 git_refdb_new
  (_fun (_pointer _refdb) _repository -> _int))
(define-libgit2 git_refdb_open
  (_fun (_pointer _refdb) _repository -> _int))
(define-libgit2 git_refdb_compress
  (_fun _refdb -> _int))
(define-libgit2 git_refdb_free
  (_fun _refdb -> _void))

; reflog.h

(define-libgit2 git_reflog_read
  (_fun (_pointer _reflog) _repository _string -> _int))
(define-libgit2 git_reflog_write
  (_fun _reflog -> _int))
(define-libgit2 git_reflog_append
  (_fun _reflog _oid _signature _string -> _int))
(define-libgit2 git_reflog_rename
  (_fun _repository _string _string -> _int))
(define-libgit2 git_reflog_delete
  (_fun _repository _string -> _int))
(define-libgit2 git_reflog_entrycount
  (_fun _reflog -> _size))
(define-libgit2 git_reflog_entry_byindex
  (_fun _reflog _size -> _reflog_entry))
(define-libgit2 git_reflog_drop
  (_fun _reflog _size _int -> _int))
(define-libgit2 git_reflog_entry_id_old
  (_fun _reflog_entry -> _oid))
(define-libgit2 git_reflog_entry_id_new
  (_fun _reflog_entry -> _oid))
(define-libgit2 git_reflog_entry_committer
  (_fun _reflog_entry -> _signature))
(define-libgit2 git_reflog_entry_message
  (_fun _reflog_entry -> _string))
(define-libgit2 git_reflog_free
  (_fun _reflog -> _void))

; refs.h

(define-libgit2 git_reference_lookup
  (_fun (_pointer _reference) _repository _string -> _int))
(define-libgit2 git_reference_name_to_id
  (_fun _oid _repository _string -> _int))
(define-libgit2 git_reference_dwim
  (_fun (_pointer _reference) _repository _string -> _int))
(define-libgit2 git_reference_symbolic_create_matching
  (_fun (_pointer _reference) _repository _string _string _int _string _string -> _int))
(define-libgit2 git_reference_symbolic_create
  (_fun (_pointer _reference) _repository _string _string _int _string -> _int))
(define-libgit2 git_reference_create
  (_fun (_pointer _reference) _repository _string _oid _int _string -> _int))
(define-libgit2 git_reference_create_matching
  (_fun (_pointer _reference) _repository _string _oid _int _oid _string -> _int))
(define-libgit2 git_reference_target
  (_fun _reference -> _oid))
(define-libgit2 git_reference_target_peel
  (_fun _reference -> _oid))
(define-libgit2 git_reference_symbolic_target
  (_fun _reference -> _string))
(define-libgit2 git_reference_type
  (_fun _reference -> _git_ref_t))
(define-libgit2 git_reference_name
  (_fun _reference -> _string))
(define-libgit2 git_reference_resolve
  (_fun (_pointer _reference) _reference -> _int))
(define-libgit2 git_reference_owner
  (_fun _reference -> _repository))
(define-libgit2 git_reference_symbolic_set_target
  (_fun (_pointer _reference) _reference _string _string -> _int))
(define-libgit2 git_reference_set_target
  (_fun (_pointer _reference) _reference _oid _string -> _int))
(define-libgit2 git_reference_rename
  (_fun (_pointer _reference) _reference _string _int _string -> _int))
(define-libgit2 git_reference_delete
  (_fun _reference -> _int))
(define-libgit2 git_reference_remove
  (_fun _repository _string -> _int))
(define-libgit2 git_reference_list
  (_fun _strarray _repository -> _int))

(define _git_reference_foreach_cb (_fun _reference (_pointer _void) -> _int))
(define _git_reference_foreach_name_cb (_fun _string (_pointer _void) -> _int))

(define-libgit2 git_reference_foreach
  (_fun _repository _git_reference_foreach_cb (_pointer _void) -> _int))
(define-libgit2 git_reference_foreach_name
  (_fun _repository _git_reference_foreach_name_cb (_pointer _void) -> _int))
(define-libgit2 git_reference_dup
  (_fun (_pointer _reference) _reference -> _int))
(define-libgit2 git_reference_free
  (_fun _reference -> _void))
(define-libgit2 git_reference_cmp
  (_fun _repository _repository -> _int))
(define-libgit2 git_reference_iterator_new
  (_fun (_pointer _reference_iterator) _repository -> _int))
(define-libgit2 git_reference_iterator_glob_new
  (_fun (_pointer _reference_iterator) _repository _string -> _int))
(define-libgit2 git_reference_next
  (_fun (_pointer _reference) _reference_iterator -> _int))
(define-libgit2 git_reference_next_name
  (_fun (_pointer _string) _reference_iterator -> _int))
(define-libgit2 git_reference_iterator_free
  (_fun _reference_iterator -> _int))
(define-libgit2 git_reference_foreach_glob
  (_fun _repository _string _git_reference_foreach_name_cb (_pointer _void) -> _int))
(define-libgit2 git_reference_has_log
  (_fun _repository _string -> _int))
(define-libgit2 git_reference_ensure_log
  (_fun _repository _string -> _int))
(define-libgit2 git_reference_is_branch
  (_fun _reference -> _int))
(define-libgit2 git_reference_is_remote
  (_fun _reference -> _int))
(define-libgit2 git_reference_is_tag
  (_fun _reference -> _int))
(define-libgit2 git_reference_is_note
  (_fun _reference -> _int))

(define _git_reference_normalize_t
  (_bitmask '(GIT_REF_FORMAT_NORMAL = 0
              GIT_REF_FORMAT_ALLOW_ONELEVEL = 1
              GIT_REF_FORMAT_REFSPEC_PATTERN = 2
              GIT_REF_FORMAT_REFSPEC_SHORTHAND = 4)))

(define-libgit2 git_reference_normalize_name
  (_fun _string _size _string _uint -> _int))
(define-libgit2 git_reference_peel
  (_fun (_pointer _object) _reference _git_otype -> _int))
(define-libgit2 git_reference_is_valid_name
  (_fun _string -> _bool))
(define-libgit2 git_reference_shorthand
  (_fun _reference -> _string))

; refspec.h

(define-libgit2 git_refspec_src
  (_fun _refspec -> _string))
(define-libgit2 git_refspec_dst
  (_fun _refspec -> _string))
(define-libgit2 git_refspec_string
  (_fun _refspec -> _string))
(define-libgit2 git_refspec_force
  (_fun _refspec -> _int))
(define-libgit2 git_refspec_direction
  (_fun _refspec -> _git_direction))
(define-libgit2 git_refspec_src_matches
  (_fun _refspec _string -> _int))
(define-libgit2 git_refspec_dst_matches
  (_fun _refspec _string -> _int))
(define-libgit2 git_refspec_transform
  (_fun _buf _refspec _string -> _int))
(define-libgit2 git_refspec_rtransform
  (_fun _buf _refspec _string -> _int))

; repository.h

(define-libgit2 git_repository_open
  (_fun (_pointer _repository) _string -> _int))
(define-libgit2 git_repository_wrap_odb
  (_fun (_pointer _repository) _odb -> _int))
(define-libgit2 git_repository_discover
  (_fun _buf _string _int _string -> _int))

(define _git_repository_open_flag_t
  (_bitmask '(GIT_REPOSITORY_OPEN_NO_SEARCH = 0
              GIT_REPOSITORY_OPEN_CROSS_FS = 2
              GIT_REPOSITORY_OPEN_BARE = 4
              GIT_REPOSITORY_OPEN_NO_DOTGIT = 8
              GIT_REPOSITORY_OPEN_FROM_ENV = 16)))

(define-libgit2 git_repository_open_ext
  (_fun (_pointer _repository) _string _uint _string -> _int))
(define-libgit2 git_repository_open_bare
  (_fun (_pointer _repository) _string -> _int))
(define-libgit2 git_repository_free
  (_fun _repository -> _void))
(define-libgit2 git_repository_init
  (_fun (_pointer _repository) _string _uint -> _int))

(define _git_repository_int_flag_t
  (_bitmask '(GIT_REPOSITORY_INIT_BARE = 1
              GIT_REPOSITORY_INIT_NO_REINIT = 2
              GIT_REPOSITORY_INIT_NO_DOTGIT_DIR = 4
              GIT_REPOSITORY_INIT_MKDIR = 8
              GIT_REPOSITORY_INIT_MKPATH= 16
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

(define-libgit2 git_repository_init_init_options
  (_fun _git_repository_init_opts-pointer _uint -> _int))
(define-libgit2 git_repository_init_ext
  (_fun (_pointer _repository) _string _git_repository_init_opts-pointer -> _int))
(define-libgit2 git_repository_head
  (_fun (_pointer _reference) _repository -> _int))
(define-libgit2 git_repository_head_detached
  (_fun _repository -> _int))
(define-libgit2 git_repository_head_unborn
  (_fun _repository -> _int))
(define-libgit2 git_repository_is_empty
  (_fun _repository -> _int))
(define-libgit2 git_repository_path
  (_fun _repository -> _string))
(define-libgit2 git_repository_workdir
  (_fun _repository -> _string))
(define-libgit2 git_repository_set_workdir
  (_fun _repository _string _int -> _int))
(define-libgit2 git_repository_config
  (_fun (_pointer _config) _repository -> _int))
(define-libgit2 git_repository_config_snapshot
  (_fun (_pointer _config) _repository -> _int))
(define-libgit2 git_repository_odb
  (_fun (_pointer _odb) _repository -> _int))
(define-libgit2 git_repository_refdb
  (_fun (_pointer _refdb) _repository -> _int))
(define-libgit2 git_repository_index
  (_fun (_pointer _index) _repository  -> _int))
(define-libgit2 git_repository_message
  (_fun _buf _repository -> _int))
(define-libgit2 git_repository_message_remove
  (_fun _repository -> _int))
(define-libgit2 git_repository_state_cleanup
  (_fun _repository -> _int))

(define _git_repository_fetchhead_foreach_cb
  (_fun _string _string _oid _uint (_pointer _void) -> _int))

(define-libgit2 git_repository_fetchhead_foreach
  (_fun _repository _git_repository_fetchhead_foreach_cb (_pointer _void) -> _int))

(define _git_repository_mergehead_foreach_cb
  (_fun _oid (_pointer _void) -> _int))

(define-libgit2 git_repository_mergehead_foreach
  (_fun _repository _git_repository_mergehead_foreach_cb (_pointer _void) -> _int))
(define-libgit2 git_repository_hashfile
  (_fun _oid _repository _path _git_otype _string -> _int))
(define-libgit2 git_repository_set_head
  (_fun _repository _string -> _int))
(define-libgit2 git_repository_set_head_detached
  (_fun _repository _oid -> _int))
(define-libgit2 git_repository_set_head_detached_from_annotated
  (_fun _repository _annotated_commit -> _int))
(define-libgit2 git_repository_detach_head
  (_fun _repository -> _int))

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

(define-libgit2 git_repository_state
  (_fun _repository -> _int))
(define-libgit2 git_repository_set_namespace
  (_fun _repository _string -> _int))
(define-libgit2 git_repository_get_namespace
  (_fun _repository -> _string))
(define-libgit2 git_repository_is_shallow
  (_fun _repository -> _int))
(define-libgit2 git_repository_ident
  (_fun (_pointer _string) (_pointer _string) _repository -> _int))
(define-libgit2 git_repository_set_ident
  (_fun _repository _string _string -> _int))

; reset.h

(define _git_reset_t
  (_enum '(GIT_RESET_SOFT = 1
           GIT_RESET_MIXED = 2
           GIT_RESET_HARD = 3)))

(define-libgit2 git_reset
  (_fun _repository _object _git_reset_t _git_checkout_opts-pointer -> _int))
(define-libgit2 git_reset_from_annotated
  (_fun _repository _annotated_commit _git_reset_t _git_checkout_opts-pointer -> _int))
(define-libgit2 git_reset_default
  (_fun _repository _object _strarray -> _int))

; revert.h

(define-cstruct _git_revert_opts
  ([version _uint]
   [mainline _uint]
   [merge_opts _git_merge_opts]
   [checkout_opts _git_checkout_opts]))

(define-libgit2 git_revert_init_options
  (_fun _git_revert_opts-pointer _uint -> _int))
(define-libgit2 git_revert_commit
  (_fun (_pointer _index) _repository _commit _commit _uint _git_merge_opts-pointer -> _int))
(define-libgit2 git_revert
  (_fun _repository _commit _git_revert_opts-pointer -> _int))

; revparse.h

(define-libgit2 git_revparse_single
  (_fun (_pointer _object) _repository _string -> _int))
(define-libgit2 git_revparse_ext
  (_fun (_pointer _object) (_pointer _reference) _repository _string -> _int))

(define _git_revparse_mode_t
  (_bitmask '(GIT_REVPARSE_SINGLE = 1
              GIT_REVPARSE_RANGE = 2
              GIT_REVPARSE_MERGE_BASE = 4)))

(define-cstruct _git_revspec
  ([from _object]
   [to _object]
   [flags _uint]))

(define-libgit2 git_revparse
  (_fun _git_revspec-pointer _repository _string -> _int))

; revwalk.h

(define _git_sort_t
  (_bitmask '(GIT_SORT_NONE = 0
              GIT_SORT_TOPOLOGICAL = 1
              GIT_SORT_TIME = 2
              GIT_SORT_REVERSE = 4)))

(define-libgit2 git_revwalk_new
  (_fun (_pointer _revwalk) _repository -> _int))
(define-libgit2 git_revwalk_reset
  (_fun _revwalk -> _void))
(define-libgit2 git_revwalk_push
  (_fun _revwalk _oid -> _int))
(define-libgit2 git_revwalk_push_glob
  (_fun _revwalk _string -> _int))
(define-libgit2 git_revwalk_push_head
  (_fun _revwalk -> _int))
(define-libgit2 git_revwalk_hide
  (_fun _revwalk _oid -> _int))
(define-libgit2 git_revwalk_hide_glob
  (_fun _revwalk _string -> _int))
(define-libgit2 git_revwalk_hide_head
  (_fun _revwalk -> _int))
(define-libgit2 git_revwalk_push_ref
  (_fun _revwalk _string -> _int))
(define-libgit2 git_revwalk_hide_ref
  (_fun _revwalk _string -> _int))
(define-libgit2 git_revwalk_next
  (_fun _oid _revwalk -> _int))
(define-libgit2 git_revwalk_sorting
  (_fun _revwalk _uint -> _void))
(define-libgit2 git_revwalk_push_range
  (_fun _revwalk _string -> _int))
(define-libgit2 git_revwalk_simplify_first_parent
  (_fun _revwalk -> _void))
(define-libgit2 git_revwalk_free
  (_fun _revwalk -> _void))
(define-libgit2 git_revwalk_repository
  (_fun _revwalk -> _repository))

(define _git_revwalk_hide_cb
  (_fun _oid (_pointer _void) -> _int))

(define-libgit2 git_revwalk_add_hide_cb
  (_fun _revwalk _git_revwalk_hide_cb (_pointer _void) -> _int))

; signature.h

(define-libgit2 git_signature_new
  (_fun (_pointer _signature) _string _string _git_time_t _int -> _int))
(define-libgit2 git_signature_now
  (_fun (_pointer _signature) _string _string -> _int))
(define-libgit2 git_signature_default
  (_fun (_pointer _signature) _repository -> _int))
(define-libgit2 git_signature_from_buffer
  (_fun (_pointer _signature) _buf -> _int))
(define-libgit2 git_signature_dup
  (_fun (_pointer _signature) _signature -> _int))
(define-libgit2 git_signature_free
  (_fun _signature -> _void))

; status.h

(define _git_stash_flags
  (_bitmask '(GIT_STASH_DEFAULT = 0
              GIT_STASH_KEEP_INDEX = 1
              GIT_STASH_INCLUDE_UNTRACKED = 2
              GIT_STASH_INCLUDE_IGNORED = 4)))

(define-libgit2 git_stash_save
  (_fun _oid _repository _signature _string _uint32 -> _int))

(define _git_stash_apply_flags
  (_bitmask '(GIT_STASH_APPLY_DEFAULT = 0
              GIT_STASH_APPLY_REINSTATE_INDEX = 1)))

(define _git_stash_apply_progress_t
  (_enum '(GIT_STASH_APPLY_PROGRESS_NONE
           GIT_STASH_APPLY_PROGRESS_LOADING_STASH
           GIT_STASH_APPLY_PROGRESS_ANALYZE_INDEX
           GIT_STASH_APPLY_PROGRESS_ANALYZE_MODIFIED
           GIT_STASH_APPLY_PROGRESS_ANALYZE_UNTRACKED
           GIT_STASH_APPLY_PROGRESS_CHECKOUT_UNTRACKED
           GIT_STASH_APPLY_PROGRESS_CHECKOUT_MODIFIED
           GIT_STASH_APPLY_PROGRESS_DONE)))

(define _git_stash_apply_progress_cb
  (_fun _git_stash_apply_progress_t (_pointer _void) -> _int))

(define-cstruct _git_stash_apply_opts
  ([version _uint]
   [flags _git_stash_apply_flags]
   [checkout_options _git_checkout_opts]
   [progress_cb _git_stash_apply_progress_cb]
   [progress_payload (_pointer _void)]))

(define-libgit2 git_stash_apply_init_options
  (_fun _git_stash_apply_opts-pointer _uint -> _int))
(define-libgit2 git_stash_apply
  (_fun _repository _size _git_stash_apply_opts-pointer -> _int))
(define _git_stash_cb
  (_fun _size _string _oid (_pointer _void) -> _int))
(define-libgit2 git_stash_foreach
  (_fun _repository _git_stash_cb (_pointer _void) -> _int))
(define-libgit2 git_stash_drop
  (_fun _repository _size -> _int))
(define-libgit2 git_stash_pop
  (_fun _repository _size _git_stash_apply_opts-pointer -> _int))

; submodule.h

(define _git_submodule_status_t
  (_bitmask '(GIT_SUBMODULE_STATUS_IN_HEAD = (arithmetic-shift 1 0)
              GIT_SUBMODULE_STATUS_IN_INDEX = (arithmetic-shift 1 1)
              GIT_SUBMODULE_STATUS_IN_CONFIG = (arithmetic-shift 1 2)
              GIT_SUBMODULE_STATUS_IN_WD = (arithmetic-shift 1 3)
              GIT_SUBMODULE_STATUS_INDEX_ADDED = (arithmetic-shift 1 4)
              GIT_SUBMODULE_STATUS_INDEX_DELETED = (arithmetic-shift 1 5)
              GIT_SUBMODULE_STATUS_INDEX_MODIFIED = (arithmetic-shift 1 6)
              GIT_SUBMODULE_STATUS_WD_UNITIALIZED = (arithmetic-shift 1 7)
              GIT_SUBMODULE_STATUS_WD_ADDED = (arithmetic-shift 1 8)
              GIT_SUBMODULE_STATUS_WD_DELETED = (arithmetic-shift 1 9)
              GIT_SUBMODULE_STATUS_WD_MODIFIED = (arithmetic-shift 1 10)
              GIT_SUBMODULE_STATUS_WD_INDEX_MODIFIED = (arithmetic-shift 1 11)
              GIT_SUBMODULE_STATUS_WD_WD_MODIFIED = (arithmetic-shift 1 12)
              GIT_SUBMODULE_STATUS_WD_UNTRACKED = (arithmetic-shift 1 13))))

(define _git_submodule_cb
  (_fun _submodule _string (_pointer _void) -> _int))

(define-cstruct _git_submodule_update_opts
  ([version _uint]
   [checkout_opts _git_checkout_opts]
   [fetch_opts _git_fetch_opts]
   [allow_fetch _int]))

(define-libgit2 git_submodule_update_init_options
  (_fun _git_submodule_update_opts-pointer _uint -> _int))
(define-libgit2 git_submodule_update
  (_fun _submodule _int _git_submodule_update_opts-pointer -> _int))
(define-libgit2 git_submodule_lookup
  (_fun (_pointer _submodule) _repository _string -> _int))
(define-libgit2 git_submodule_free
  (_fun _submodule -> _void))
(define-libgit2 git_submodule_foreach
  (_fun _repository _git_submodule_cb (_pointer _void) -> _int))
(define-libgit2 git_submodule_add_setup
  (_fun (_pointer _submodule) _repository _string _string _int -> _int))
(define-libgit2 git_submodule_add_finalize
  (_fun _submodule -> _int))
(define-libgit2 git_submodule_add_to_index
  (_fun _submodule -> _int))
(define-libgit2 git_submodule_owner
  (_fun _submodule -> _repository))
(define-libgit2 git_submodule_name
  (_fun _submodule -> _string))
(define-libgit2 git_submodule_path
  (_fun _submodule -> _string))
(define-libgit2 git_submodule_url
  (_fun _submodule -> _string))
(define-libgit2 git_submodule_resolve_url
  (_fun _buf _repository _string -> _int))
(define-libgit2 git_submodule_branch
  (_fun _submodule -> _string))
(define-libgit2 git_submodule_set_branch
  (_fun _repository _string _string -> _int))
(define-libgit2 git_submodule_set_url
  (_fun _repository _string _string -> _int))
(define-libgit2 git_submodule_index_id
  (_fun _submodule -> _oid))
(define-libgit2 git_submodule_head_id
  (_fun _submodule -> _oid))
(define-libgit2 git_submodule_wd_id
  (_fun _submodule -> _oid))
(define-libgit2 git_submodule_ignore
  (_fun _repository _string _git_submodule_ignore_t -> _int))
(define-libgit2 git_submodule_update_strategy
  (_fun _submodule -> _git_submodule_update_t))
(define-libgit2 git_submodule_set_update
  (_fun _repository _string _git_submodule_update_t -> _int))
(define-libgit2 git_submodule_fetch_recurse_submodules
  (_fun _submodule -> _git_submodule_recurse_t))
(define-libgit2 git_submodule_set_fetch_recurse_submodules
  (_fun _repository _string _git_submodule_recurse_t -> _int))
(define-libgit2 git_submodule_init
  (_fun _submodule _int -> _int))
(define-libgit2 git_submodule_repo_init
  (_fun (_pointer _repository) _submodule _int -> _int))
(define-libgit2 git_submodule_sync
  (_fun _submodule -> _int))
(define-libgit2 git_submodule_open
  (_fun (_pointer _repository) _submodule -> _int))
(define-libgit2 git_submodule_reload
  (_fun _submodule _int -> _int))
(define-libgit2 git_submodule_status
  (_fun (_pointer _uint) _repository _string _git_submodule_ignore_t -> _int))
(define-libgit2 git_submodule_location
  (_fun (_pointer _uint) _submodule -> _int))

; tag.h

(define-libgit2 git_tag_lookup
  (_fun (_pointer _tag) _repository _oid -> _int))
(define-libgit2 git_tag_lookup_prefix
  (_fun (_pointer _tag) _repository _oid _size -> _int))
(define-libgit2 git_tag_free
  (_fun _tag -> _void))
(define-libgit2 git_tag_id
  (_fun _tag -> _oid))
(define-libgit2 git_tag_owner
  (_fun _tag -> _repository))
(define-libgit2 git_tag_target
  (_fun (_pointer _object) _tag -> _int))
(define-libgit2 git_tag_target_id
  (_fun _tag -> _oid))
(define-libgit2 git_tag_target_type
  (_fun _tag -> _git_otype))
(define-libgit2 git_tag_name
  (_fun _tag -> _string))
(define-libgit2 git_tag_tagger
  (_fun _tag -> _signature))
(define-libgit2 git_tag_message
  (_fun _tag -> _string))
(define-libgit2 git_tag_create
  (_fun _oid _repository _string _object _signature _string _int -> _int))
(define-libgit2 git_tag_annotation_create
  (_fun _oid _repository _string _object _signature _string -> _int))
(define-libgit2 git_tag_create_frombuffer
  (_fun _oid _repository _string _int -> _int))
(define-libgit2 git_tag_create_lightweight
  (_fun _oid _repository _string _object _int -> _int))
(define-libgit2 git_tag_delete
  (_fun _repository _string))
(define-libgit2 git_tag_list
  (_fun _strarray _repository -> _int))
(define-libgit2 git_tag_list_match
  (_fun _strarray _string _repository -> _int))

(define _git_tag_foreach_cb
  (_fun _string _oid (_pointer _void) -> _int))

(define-libgit2 git_tag_foreach
  (_fun _repository _git_tag_foreach_cb (_pointer _void) -> _int))
(define-libgit2 git_tag_peel
  (_fun (_pointer _object) _tag -> _int))
(define-libgit2 git_tag_dup
  (_fun (_pointer _tag) _tag -> _int))

; trace.h

(define _git_trace_level_t
  (_enum '(GIT_TRACE_NONE
           GIT_TRACE_FATAL
           GIT_TRACE_ERROR
           GIT_TRACE_WARN
           GIT_TRACE_INFO
           GIT_TRACE_DEBUG
           GIT_TRACE_TRACE)))

(define _git_trace_callback
  (_fun _git_trace_level_t _string -> _void))
(define-libgit2 git_trace_set
  (_fun _git_trace_level_t _git_trace_callback -> _int))

; transaction.h

(define-libgit2 git_transaction_new
  (_fun (_pointer _transaction) _repository -> _int))
(define-libgti2 git_transaction_lock_ref
  (_fun _transaction _string -> _int))
(define-libgit2 git_transaction_set_target
  (_fun _transaction _string _oid _signature _string -> _int))
(define-libgit2 git_transaction_set_symbolic_target
  (_fun _transaction _string _string _signature _string -> _int))
(define-libgit2 git_transaction_set_reflog
  (_fun _transaction _string _reflog -> _int))
(define-libgit2 git_transaction_remove
  (_fun _transaction _string -> _int))
(define-libgit2 git_transaction_commit
  (_fun _transaction -> _int))
(define-libgit2 git_transaction_free
  (_fun _transaction -> _void))

; tree.h

(define-libgit2 git_tree_lookup
  (_fun (_pointer _tree) _repository _oid -> _int))
(define-libgit2 git_tree_lookup_prefix
  (_fun (_pointer _tree) _repository _oid _size -> _int))
(define-libgit2 git_tree_free
  (_fun _tree -> _void))
(define-libgit2 git_tree_id
  (_fun _tree -> _oid))
(define-libgit2 git_tree_owner
  (_fun _tree -> _repository))
(define-libgit2 git_tree_entrycount
  (_fun _tree -> _size))
(define-libgit2 git_tree_entry_byname
  (_fun _tree _strign -> _tree_entry))
(define-libgit2 git_tree_entry_byindex
  (_fun _tree _size -> _tree_entry))
(define-libgit2 git_tree_entry_byid
  (_fun _tree _oid -> _tree_entry))
(define-libgit2 git_tree_entry_bypath
  (_fun (_pointer _tree_entry) _tree _string -> _int))
(define-libgit2 git_tree_dup
  (_fun (_pointer _tree_entry) _tree_entry -> _int))
(define-libgit2 git_tree_etnry_free
  (_fun (_pointer _tree_entry) -> _void))
(define-libgit2 git_tree_entry_name
  (_fun _tree_entry -> _string))
(define-libgit2 git_tree_entry_id
  (_fun _tree_entry -> _oid))
(define-libgit2 git_tree_entry_type
  (_fun _tree_entry -> _git_otype))
(define-libgit2 git_tree_entry_filemode_raw
  (_fun _tree_entry -> _git_filemode_t ))
(define-libgit2 git_tree_entry_cmp
  (_fun _tree_entry _tree_entry -> _int))
(define-libgit2 git_tree_entry_to_object
  (_fun (_pointer _object) _repository _tree_entry -> _int))
(define-libgit2 git_treebuilder_new
  (_fun (_pointer _treebuilder) _repository _tree -> _int))
(define-libgit2 git_treebuilder_clear
  (_fun _treebuilder -> _void))
(define-libgit2 git_treebuilder_entrycount
  (_fun _treebuilder -> uint))
(define-libgit2 git_treebuilder_free
  (_fun _treebuilder -> _void))
(define-libgit2 git_treebuilder_get
  (_fun _treebuilder _string -> _tree_entry))
(define-libgit2 git_treebuilder_insert
  (_fun (_pointer _tree_entry) _treebuilder _string _oid _git_filemode_t -> _int))
(define-libgit2 git_treebuilder_remove
  (_fun _treebuilder _string -> _int))

(define _git_treebuilder_filter_cb
  (_fun _tree_entry (_pointer _void) -> _int))
(define-libgit2 _git_treebuilder_filter
  (_fun _treebuilder _git_treebuilder_filter_cb (_pointer _void) -> _int))
(define-libgit2 git_treebuidler_write
  (_fun _oid _treebuilder -> _int))
(define-libgit2 git_treebuilder_write_with_buffer
  (_fun _treebuilder _buf))

(define _git_treewalk_cb
  (_fun _string _tree_entry (_pointer _void) -> _int))

(define _git_treewalk_mode
  (_enum '(GIT_TREEWALK_PRE
           GIT_TREEWALK_POST)))

(define-libgit2 git_tree_walk
  (_fun _tree _git_treewalk_mode _git_treewalk_cb (_pointer _void)))
(define-libgit2 _git_tree_dup
  (_fun (_pointer _tree) _tree -> _int))

(define _git_tree_update_t
  (_enum '(GIT_TREE_UPDATE_UPSERT
           GIT_TREE_UPDATE_REMOVE)))

(define-cstruct _git_tree_update
  ([action _git_tree_update_t]
   [id _oid]
   [filemode _git_filemode_t]
   [path _string]))

(define-libgit2 git_tree_create_updated
  (_fun _oid _repository _tree _size _git_tree_update-pointer -> _int))



