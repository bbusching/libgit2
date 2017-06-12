#lang scribble/manual

@(require (for-label racket))

@title{Fetch}

@defmodule[libgit2/include/fetch]


@defproc[(git_fetch_init_options
          [opts git_fetch_opts?]
          [version integer?])
         integer?]{
 Initializes a git_fetch_options with default values. Equivalent to creating an instance with GIT_FETCH_OPTIONS_INIT.
}
