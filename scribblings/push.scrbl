#lang scribble/manual

@(require (for-label racket))

@title{Push}

@defmodule[libgit2/include/push]


@defproc[(git_push_init_options
          [opts git_push_opts?]
          [version integer?])
         integer?]{
 Initializes a git_push_options with default values. Equivalent to creating an instance with GIT_PUSH_OPTIONS_INIT.
}
