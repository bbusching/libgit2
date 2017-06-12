#lang scribble/manual

@(require (for-label racket))

@title{Blame}

@defmodule[libgit2/include/blame]


@defproc[(git_blame_buffer
          [reference blame?]
          [buffer string?]
          [buffer_len size_t])
         blame?]{
 Get blame data for a file that has been modified in memory. The reference parameter is a pre-calculated blame for the in-odb history of the file. This means that once a file blame is completed (which can be expensive), updating the buffer blame is very fast.

 Lines that differ between the buffer and the committed version are marked as having a zero OID for their final_commit_id.

}

@defproc[(git_blame_file
          [repo repository?]
          [path string?]
          [options (or/c blame_options? #f)])
         blame?]{
 Get the blame for a single file.

}

@defproc[(git_blame_free
          [blame blame?])
         void?]{
 Free memory allocated by git_blame_file or git_blame_buffer.

}

@defproc[(git_blame_get_hunk_byindex
          [blame blame?]
          [index uint32_t])
         (or/c git_blame_hunk? #f)]{
 Gets the blame hunk at the given index.

 Returns @racket[#f] on error.
}

@defproc[(git_blame_get_hunk_byline
          [blame blame?]
          [lineno size_t])
         integer?]{
 Gets the hunk that relates to the given line number in the newest commit.

 Returns @racket[#f] on error.
}

@defproc[(git_blame_get_hunk_count
          [blame blame?])
         exact-positive-integer?]{
 Gets the number of hunks that exist in the blame structure.

}

@defproc[(git_blame_init_options
          [opts blame_options?]
          [int unsigned])
         integer?]{
 Initializes a git_blame_options with default values. Equivalent to creating an instance with GIT_BLAME_OPTIONS_INIT.
}
