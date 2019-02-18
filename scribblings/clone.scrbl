#lang scribble/manual

@(require (for-label racket))

@title{Clone}

@defmodule[libgit2/include/clone]


@defproc[(git_clone
          [url string?]
          [local_path string?]
          [options (or/c git_clone_options? #f)])
         repository?]{
 Clone a remote repository.

 By default this creates its repository and initial remote to match git's defaults. You can use the options in the callback to customize how these are created.

 Passing @racket[#f] for options will use default clone options.
}

@defproc[(git_clone_init_options
          [opts clone_options?]
          [int unsigned])
         integer?]{
 Initializes a git_clone_options with default values. Equivalent to creating an instance with GIT_CLONE_OPTIONS_INIT.
}
