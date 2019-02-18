#lang scribble/manual

@(require (for-label racket))

@title{Cherrypick}

@defmodule[libgit2/include/cherrypick]


@defproc[(git_cherrypick
          [repo repository?]
          [commit commit?]
          [cherrypick_options (or/c git_cherrypick_options? #f)])
         integer?]{
 Cherry-pick the given commit, producing changes in the index and working directory.

 Passing @racket[#f] for cherrypick_options will use default checkout options.
}

@defproc[(git_cherrypick_commit
          [repo repository?]
          [cherrypick_commit commit?]
          [our_commit commit?]
          [int unsigned]
          [merge_options (or/c git_merge_options? #f)])
         index?]{
 Cherry-picks the given commit against the given "our" commit, producing an index that reflects the result of the cherry-pick.

 The returned index must be freed explicitly with git_index_free.

 Passing @racket[#f] for opts will use default merge options.
}

@defproc[(git_cherrypick_init_options
          [opts cherrypick_options?]
          [int unsigned])
         integer?]{
 Initializes a git_cherrypick_options with default values. Equivalent to creating an instance with GIT_CHERRYPICK_OPTIONS_INIT.
}
