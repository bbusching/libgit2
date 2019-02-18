#lang scribble/manual

@(require (for-label racket))

@title{Revert}

@defmodule[libgit2/include/revert]


@defproc[(git_revert
          [repo repository?]
          [commit commit?]
          [given_opts git_revert_opts?])
         integer?]{
 Reverts the given commit, producing changes in the index and working directory.

}

@defproc[(git_revert_commit
          [repo repository?]
          [revert_commit commit?]
          [our_commit commit?]
          [mainline integer?]
          [merge_options merge_options?])
         index?]{
 Reverts the given commit against the given "our" commit, producing an index that reflects the result of the revert.

 The returned index must be freed explicitly with git_index_free.

}

@defproc[(git_revert_init_options
          [opts git_revert_options?]
          [version integer?])
         integer?]{
 Initializes a git_revert_options with default values. Equivalent to creating an instance with GIT_REVERT_OPTIONS_INIT.
}
