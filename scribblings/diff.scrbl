
#lang scribble/manual

@(require (for-label racket))

@title{Diff}

@defmodule[libgit2/include/diff]


@defproc[(git_diff_blob_to_buffer
          [old_blob (or/c blob? #f)]
          [old_as_path (or/c string? #f)]
          [buffer (or/c string? #f)]
          [buffer_len integer?]
          [buffer_as_path (or/c string? #f)]
          [options (or/c git_diff_opts? #f)]
          [file_cb (or/c git_diff_file_cb #f)]
          [binary_cb (or/c git_diff_binary_cb #f)]
          [hunk_cb (or/c git_diff_hunk_cb #f)]
          [line_cb (or/c git_diff_line_cb #f)]
          [payload bytes?])
         integer?]{
 Directly run a diff between a blob and a buffer.

 As with git_diff_blobs, comparing a blob and buffer lacks some context, so the git_diff_file parameters to the callbacks will be faked a la the rules for git_diff_blobs().

 Passing NULL for old_blob will be treated as an empty blob (i.e. the file_cb will be invoked with GIT_DELTA_ADDED and the diff will be the entire content of the buffer added). Passing NULL to the buffer will do the reverse, with GIT_DELTA_REMOVED and blob content removed.

}

@defproc[(git_diff_blobs
          [old_blob (or/c blob? #f)]
          [old_as_path (or/c string? #f)]
          [new_blob (or/c blob? #f)]
          [new_as_path (or/c string? #f)]
          [options (or/c git_diff_opts? #f)]
          [file_cb (or/c git_diff_file_cb #f)]
          [binary_cb (or/c git_diff_binary_cb #f)]
          [hunk_cb (or/c git_diff_hunk_cb #f)]
          [line_cb (or/c git_diff_line_cb #f)]
          [payload bytes?])
         integer?]{
 Directly run a diff on two blobs.

 Compared to a file, a blob lacks some contextual information. As such, the git_diff_file given to the callback will have some fake data; i.e. mode will be 0 and path will be NULL.

 NULL is allowed for either old_blob or new_blob and will be treated as an empty blob, with the oid set to NULL in the git_diff_file data. Passing NULL for both blobs is a noop; no callbacks will be made at all.

 We do run a binary content check on the blob content and if either blob looks like binary data, the git_diff_delta binary attribute will be set to 1 and no call to the hunk_cb nor line_cb will be made (unless you pass GIT_DIFF_FORCE_TEXT of course).

}

@defproc[(git_diff_buffers
          [old_buffer (or/c bytes? #f)]
          [old_len integer?]
          [old_as_path (or/c string? #f)]
          [new_buffer (or/c bytes? #f)]
          [new_len integer?]
          [new_as_path (or/c string? #f)]
          [options (or/c git_diff_opts? #f)]
          [file_cb (or/c git_diff_file_cb #f)]
          [binary_cb (or/c git_diff_binary_cb #f)]
          [hunk_cb (or/c git_diff_hunk_cb #f)]
          [line_cb (or/c git_diff_line_cb #f)]
          [payload bytes?])
         integer?]{
 Directly run a diff between two buffers.

 Even more than with git_diff_blobs, comparing two buffer lacks context, so the git_diff_file parameters to the callbacks will be faked a la the rules for git_diff_blobs().

}

@defproc[(git_diff_commit_as_email
          [out buf?]
          [repo repository?]
          [commit commit?]
          [patch_no integer?]
          [total_patches integer?]
          [flags _git_diff_format_email_flags_t]
          [diff_opts (or/c git_diff_opts? #f)])
         integer?]{
 Create an e-mail ready patch for a commit.

 Does not support creating patches for merge commits (yet).

}

@defproc[(git_diff_find_init_options
          [opts git_diff_find_options?]
          [int unsigned])
         integer?]{
 Initializes a git_diff_find_options with default values. Equivalent to creating an instance with GIT_DIFF_FIND_OPTIONS_INIT.

}

@defproc[(git_diff_find_similar
          [diff diff?]
          [options (or/c git_diff_find_options? #f)])
         integer?]{
 Transform a diff marking file renames, copies, etc.

 This modifies a diff in place, replacing old entries that look like renames or copies with new entries reflecting those changes. This also will, if requested, break modified files into add/remove pairs if the amount of change is above a threshold.

}

@defproc[(git_diff_foreach
          [diff diff?]
          [file_cb git_diff_file_cb]
          [binary_cb git_diff_binary_cb]
          [hunk_cb git_diff_hunk_cb]
          [line_cb git_diff_line_cb]
          [payload bytes?])
         integer?]{
 Loop over all deltas in a diff issuing callbacks.

 This will iterate through all of the files described in a diff. You should provide a file callback to learn about each file.

 The "hunk" and "line" callbacks are optional, and the text diff of the files will only be calculated if they are not NULL. Of course, these callbacks will not be invoked for binary files on the diff or for files whose only changed is a file mode change.

 Returning a non-zero value from any of the callbacks will terminate the iteration and return the value to the user.

}

@defproc[(git_diff_format_email
          [out buf?]
          [diff diff?]
          [opts (or/c git_diff_format_email_opts? #f)])
         integer?]{
 Create an e-mail ready patch from a diff.

}

@defproc[(git_diff_format_email_init_options
          [opts git_diff_format_email_options?]
          [int unsigned])
         integer?]{
 Initializes a git_diff_format_email_options with default values.

 Equivalent to creating an instance with GIT_DIFF_FORMAT_EMAIL_OPTIONS_INIT.

}

@defproc[(git_diff_free
          [diff diff?])
         void?]{
 Deallocate a diff.

}

@defproc[(git_diff_from_buffer
          [content string?]
          [content_len size_t])
         diff?]{
 Read the contents of a git patch file into a git_diff object.

 The diff object produced is similar to the one that would be produced if you actually produced it computationally by comparing two trees, however there may be subtle differences. For example, a patch file likely contains abbreviated object IDs, so the object IDs in a git_diff_delta produced by this function will also be abbreviated.

 This function will only read patch files created by a git implementation, it will not read unified diffs produced by the diff program, nor any other types of patch files.

}

@defproc[(git_diff_get_delta
          [diff diff?]
          [idx integer?])
         (or/c git_diff_detlta? #f)]{
 Return the diff delta for an entry in the diff list.

 The git_diff_delta pointer points to internal data and you do not have to release it when you are done with it. It will go away when the * git_diff (or any associated git_patch) goes away.

 Note that the flags on the delta related to whether it has binary content or not may not be set if there are no attributes set for the file and there has been no reason to load the file data at this point. For now, if you need those flags to be up to date, your only option is to either use git_diff_foreach or create a git_patch.

}

@defproc[(git_diff_get_stats
          [diff diff?])
         diff_stats?]{
 Accumulate diff statistics for all patches.

}

@defproc[(git_diff_index_to_index
          [repo repository?]
          [old_index index?]
          [new_index index?]
          [opts (or/c git_diff_opts? #f)])
         diff?]{
 Create a diff with the difference between two index objects.

 The first index will be used for the "old_file" side of the delta and the second index will be used for the "new_file" side of the delta.

}

@defproc[(git_diff_index_to_workdir
          [repo repository?]
          [index index?]
          [opts (or/c git_diff_opts? #f)])
         diff?]{
 Create a diff between the repository index and the workdir directory.

 This matches the git diff command. See the note below on git_diff_tree_to_workdir for a discussion of the difference between git diff and git diff HEAD and how to emulate a git diff <treeish> using libgit2.

 The index will be used for the "old_file" side of the delta, and the working directory will be used for the "new_file" side of the delta.

 If you pass NULL for the index, then the existing index of the repo will be used. In this case, the index will be refreshed from disk (if it has changed) before the diff is generated.

}

@defproc[(git_diff_init_options
          [opts git_diff_options?]
          [int unsigned])
         integer?]{
 Initializes a git_diff_options with default values. Equivalent to creating an instance with GIT_DIFF_OPTIONS_INIT.

}

@defproc[(git_diff_is_sorted_icase
          [diff diff?])
         boolean?]{
 Check if deltas are sorted case sensitively or insensitively.

}

@defproc[(git_diff_merge
          [onto diff?]
          [from diff?])
         integer?]{
 Merge one diff into another.

 This merges items from the "from" list into the "onto" list. The resulting diff will have all items that appear in either list. If an item appears in both lists, then it will be "merged" to appear as if the old version was from the "onto" list and the new version is from the "from" list (with the exception that if the item has a pending DELETE in the middle, then it will show as deleted).

}

@defproc[(git_diff_num_deltas
          [diff diff?])
         integer?]{
 Query how many diff records are there in a diff.

}

@defproc[(git_diff_num_deltas_of_type
          [diff diff?]
          [type git_delta_t])
         integer?]{
 Query how many diff deltas are there in a diff filtered by type.

 This works just like git_diff_entrycount() with an extra parameter that is a git_delta_t and returns just the count of how many deltas match that particular type.

}

@defproc[(git_diff_print
          [diff diff?]
          [format git_diff_format_t]
          [print_cb git_diff_line_cb]
          [payload bytes?])
         integer?]{
 Iterate over a diff generating formatted text output.

 Returning a non-zero value from the callbacks will terminate the iteration and return the non-zero value to the caller.

 git_diff_print_callback__to_buf(const git_diff_delta *delta, const git_diff_hunk *hunk, const git_diff_line *line, void *payload)

 Diff print callback that writes to a git_buf.

 This function is provided not for you to call it directly, but instead so you can use it as a function pointer to the git_diff_print or git_patch_print APIs. When using those APIs, you specify a callback to actually handle the diff and/or patch data.

 Use this callback to easily write that data to a git_buf buffer. You must pass a git_buf * value as the payload to the git_diff_print and/or git_patch_print function. The data will be appended to the buffer (after any existing content).

 git_diff_print_callback__to_file_handle(const git_diff_delta *delta, const git_diff_hunk *hunk, const git_diff_line *line, void *payload)

 Diff print callback that writes to stdio FILE handle.

 This function is provided not for you to call it directly, but instead so you can use it as a function pointer to the git_diff_print or git_patch_print APIs. When using those APIs, you specify a callback to actually handle the diff and/or patch data.

 Use this callback to easily write that data to a stdio FILE handle. You must pass a FILE * value (such as stdout or stderr or the return value from fopen()) as the payload to the git_diff_print and/or git_patch_print function. If you pass NULL, this will write data to stdout.

}

@defproc[(git_diff_stats_deletions
          [stats diff_stats?])
         integer?]{
 Get the total number of deletions in a diff

}

@defproc[(git_diff_stats_files_changed
          [stats diff_stats?])
         integer?]{
 Get the total number of files changed in a diff

}

@defproc[(git_diff_stats_free
          [stats diff_stats?])
         void?]{
 Deallocate a git_diff_stats.

}

@defproc[(git_diff_stats_insertions
          [stats diff_stats?])
         integer?]{
 Get the total number of insertions in a diff

}

@defproc[(git_diff_stats_to_buf
          [out buf?]
          [stats diff_stats?]
          [format git_diff_stats_format_t]
          [width integer?])
         integer?]{
 Print diff statistics to a git_buf.

}

@defproc[(git_diff_status_char
          [status git_delta_t])
         char?]{
 Look up the single character abbreviation for a delta status code.

 When you run git diff --name-status it uses single letter codes in the output such as 'A' for added, 'D' for deleted, 'M' for modified, etc. This function converts a git_delta_t value into these letters for your own purposes. GIT_DELTA_UNTRACKED will return a space (i.e. ' ').

}

@defproc[(git_diff_to_buf
          [out buf?]
          [diff diff?]
          [format git_diff_format_t])
         integer?]{
 Produce the complete formatted text output from a diff into a buffer.

}

@defproc[(git_diff_tree_to_index
          [repo repository?]
          [old_tree (or/c tree? #f)]
          [index (or/c index? #f)]
          [opts (or/c git_diff_opts? #f)])
         diff?]{
 Create a diff between a tree and repository index.

 This is equivalent to git diff --cached <treeish> or if you pass the HEAD tree, then like git diff --cached.

 The tree you pass will be used for the "old_file" side of the delta, and the index will be used for the "new_file" side of the delta.

 If you pass NULL for the index, then the existing index of the repo will be used. In this case, the index will be refreshed from disk (if it has changed) before the diff is generated.

}

@defproc[(git_diff_tree_to_tree
          [repo repository?]
          [old_tree (or/c tree? #f)]
          [new_tree (or/c tree? #f)]
          [opts (or/c git_diff_opts? #f)])
         diff?]{
 Create a diff with the difference between two tree objects.

 This is equivalent to git diff <old-tree> <new-tree>

 The first tree will be used for the "old_file" side of the delta and the second tree will be used for the "new_file" side of the delta. You can pass NULL to indicate an empty tree, although it is an error to pass NULL for both the old_tree and new_tree.

}

@defproc[(git_diff_tree_to_workdir
          [repo repository?]
          [old_tree (or/c tree? #f)]
          [opts (or/c git_diff_options? #f)])
         diff?]{
 Create a diff between a tree and the working directory.

 The tree you provide will be used for the "old_file" side of the delta, and the working directory will be used for the "new_file" side.

 This is not the same as git diff <treeish> or git diff-index <treeish>. Those commands use information from the index, whereas this function strictly returns the differences between the tree and the files in the working directory, regardless of the state of the index. Use git_diff_tree_to_workdir_with_index to emulate those commands.

 To see difference between this and git_diff_tree_to_workdir_with_index, consider the example of a staged file deletion where the file has then been put back into the working dir and further modified. The tree-to-workdir diff for that file is 'modified', but git diff would show status 'deleted' since there is a staged delete.

}

@defproc[(git_diff_tree_to_workdir_with_index
          [repo repository?]
          [old_tree (or/c tree? #f)]
          [opts (or/c git_diff_opts? #f)])
         diff?]{
 Create a diff between a tree and the working directory using index data to account for staged deletes, tracked files, etc.

 This emulates git diff <tree> by diffing the tree to the index and the index to the working directory and blending the results into a single diff that includes staged deleted, etc.
}
