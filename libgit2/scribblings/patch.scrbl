#lang scribble/manual

@(require (for-label racket))

@title{Patch}

@defmodule[libgit2/include/patch]


@defproc[(git_patch_free
          [patch patch?])
         void?]{
 Free a git_patch object.

}

@defproc[(git_patch_from_blob_and_buffer
          [old_blob (or/c blob? #f)]
          [old_as_path (or/c string? #f)]
          [buffer (or/c bytes? #f)]
          [buffer_len integer?]
          [buffer_as_path (or/c bytes? #f)]
          [opts (or/c git_diff_options? #f)])
         (or/c patch? #f)]{
 Directly generate a patch from the difference between a blob and a buffer.

 This is just like git_diff_blob_to_buffer() except it generates a patch object for the difference instead of directly making callbacks. You can use the standard git_patch accessor functions to read the patch data, and you must call git_patch_free() on the patch when done.

}

@defproc[(git_patch_from_blobs
          [old_blob (or/c blob? #f)]
          [old_as_path (or/c string? #f)]
          [new_blob (or/c blob? #f)]
          [new_as_path (or/c string? #f)]
          [opts (or/c git_diff_options? #f)])
         patch?]{
 Directly generate a patch from the difference between two blobs.

 This is just like git_diff_blobs() except it generates a patch object for the difference instead of directly making callbacks. You can use the standard git_patch accessor functions to read the patch data, and you must call git_patch_free() on the patch when done.

}

@defproc[(git_patch_from_buffers
          [old_buffer (or/c bytes? #f)]
          [old_len integer?]
          [old_as_path (or/c string? #f)]
          [new_buffer (or/c bytes? #f)]
          [new_len integer?]
          [new_as_path (or/c string? #f)]
          [opts (or/c git_diff_options? #f)])
         patch?]{
 Directly generate a patch from the difference between two buffers.

 This is just like git_diff_buffers() except it generates a patch object for the difference instead of directly making callbacks. You can use the standard git_patch accessor functions to read the patch data, and you must call git_patch_free() on the patch when done.

}

@defproc[(git_patch_from_diff
          [diff diff?]
          [idx integer?])
         patch?]{
 Return a patch for an entry in the diff list.

 The git_patch is a newly created object contains the text diffs for the delta. You have to call git_patch_free() when you are done with it. You can use the patch object to loop over all the hunks and lines in the diff of the one delta.

 For an unchanged file or a binary file, no git_patch will be created, the output will be set to NULL, and the binary flag will be set true in the git_diff_delta structure.

 It is okay to pass NULL for either of the output parameters; if you pass NULL for the git_patch, then the text diff will not be calculated.

}

@defproc[(git_patch_get_delta
          [patch patch?])
         git_diff_delta?]{
 Get the delta associated with a patch. This delta points to internal data and you do not have to release it when you are done with it.

}

@defproc[(git_patch_get_hunk
          [patch patch?]
          [hunk_idx size_t])
         any]{
 Get the information about a hunk in a patch

 Given a patch and a hunk index into the patch, this returns detailed information about that hunk. Any of the output pointers can be passed as NULL if you don't care about that particular piece of information.

 Returns @racket[(values (out : git_diff_hunk?)
                         (lines : integer?))]. See @secref["values" #:doc '(lib "scribblings/reference/reference.scrbl")]
}

@defproc[(git_patch_get_line_in_hunk
          [patch patch?]
          [hunk_idx integer?]
          [line_of_hunk integer?])
         git_diff_line?]{
 Get data about a line in a hunk of a patch.

 Given a patch, a hunk index, and a line index in the hunk, this will return a lot of details about that line. If you pass a hunk index larger than the number of hunks or a line index larger than the number of lines in the hunk, this will return -1.

}

@defproc[(git_patch_line_stats
          [patch patch?])
         any]{
 Get line counts of each type in a patch.

 This helps imitate a diff --numstat type of output. For that purpose, you only need the total_additions and total_deletions values, but we include the total_context line count in case you want the total number of lines of diff output that will be generated.

 All outputs are optional. Pass NULL if you don't need a particular count.

 Returns @racket[(values (context : integer?)
                         (additions : integer?)
                         (deletions : integer?))]. See @secref["values" #:doc '(lib "scribblings/reference/reference.scrbl")]
}

@defproc[(git_patch_num_hunks
          [patch patch?])
         integer?]{
 Get the number of hunks in a patch

}

@defproc[(git_patch_num_lines_in_hunk
          [patch patch?]
          [hunk_idx integer?])
         integer?]{
 Get the number of lines in a hunk.

}

@defproc[(git_patch_print
          [patch patch?]
          [print_cb git_diff_line_cb]
          [payload bytes?])
         integer?]{
 Serialize the patch to text via callback.

 Returning a non-zero value from the callback will terminate the iteration and return that value to the caller.

}

@defproc[(git_patch_size
          [patch patch?]
          [include_context boolean?]
          [include_hunk_headers boolean?]
          [include_file_headers boolean?])
         integer?]{
 Look up size of patch diff data in bytes

 This returns the raw size of the patch data. This only includes the actual data from the lines of the diff, not the file or hunk headers.

 If you pass include_context as true (non-zero), this will be the size of all of the diff output; if you pass it as false (zero), this will only include the actual changed lines (as if context_lines was 0).

}

@defproc[(git_patch_to_buf
          [out buf?]
          [patch patch?])
         integer?]{
 Get the content of a patch as a single diff text.
}
