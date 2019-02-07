#lang scribble/manual

@(require (for-label racket))

@title{Reset}

@defmodule[libgit2/include/reset]


@defproc[(git_reset
          [repo repository?]
          [target object?]
          [reset_type git_reset_t]
          [checkout_opts git_checkout_opts?])
         integer?]{
 Sets the current head to the specified commit oid and optionally resets the index and working tree to match.

 SOFT reset means the Head will be moved to the commit.

 MIXED reset will trigger a SOFT reset, plus the index will be replaced with the content of the commit tree.

 HARD reset will trigger a MIXED reset and the working directory will be replaced with the content of the index. (Untracked and ignored files will be left alone, however.)

 TODO: Implement remaining kinds of resets.

}

@defproc[(git_reset_default
          [repo repository?]
          [target (or/c object? #f)]
          [pathspecs strarray?])
         integer?]{
 Updates some entries in the index from the target commit tree.

 The scope of the updated entries is determined by the paths being passed in the pathspec parameters.

 Passing a NULL target will result in removing entries in the index matching the provided pathspecs.

}

@defproc[(git_reset_from_annotated
          [repo repository?]
          [commit annotated_commit?]
          [reset_type git_reset_t]
          [checkout_opts git_checkout_options?])
         integer?]{
 Sets the current head to the specified commit oid and optionally resets the index and working tree to match.

 This behaves like git_reset() but takes an annotated commit, which lets you specify which extended sha syntax string was specified by a user, allowing for more exact reflog messages.

 See the documentation for git_reset().
}
