#lang scribble/manual

@(require (for-label racket))

@title{Stash}

@defmodule[libgit2/include/stash]


@defproc[(git_stash_apply
          [repo repository?]
          [index integer?]
          [options git_stash_apply_opts?])
         integer?]{
 Apply a single stashed state from the stash list.

 If local changes in the working directory conflict with changes in the stash then GIT_EMERGECONFLICT will be returned. In this case, the index will always remain unmodified and all files in the working directory will remain unmodified. However, if you are restoring untracked files or ignored files and there is a conflict when applying the modified files, then those files will remain in the working directory.

 If passing the GIT_STASH_APPLY_REINSTATE_INDEX flag and there would be conflicts when reinstating the index, the function will return GIT_EMERGECONFLICT and both the working directory and index will be left unmodified.

 Note that a minimum checkout strategy of GIT_CHECKOUT_SAFE is implied.

}

@defproc[(git_stash_apply_init_options
          [opts git_stash_apply_opts?]
          [version integer?])
         integer?]{
 Initializes a git_stash_apply_options with default values. Equivalent to creating an instance with GIT_STASH_APPLY_OPTIONS_INIT.

}

@defproc[(git_stash_drop
          [repo repository?]
          [index integer?])
         integer?]{
 Remove a single stashed state from the stash list.

}

@defproc[(git_stash_foreach
          [repo repository?]
          [callback git_stash_cb]
          [payload bytes?])
         integer?]{
 Loop over all the stashed states and issue a callback for each one.

 If the callback returns a non-zero value, this will stop looping.

}

@defproc[(git_stash_pop
          [repo repository?]
          [index integer?]
          [options stash_apply_options?])
         integer?]{
 Apply a single stashed state from the stash list and remove it from the list if successful.
}
