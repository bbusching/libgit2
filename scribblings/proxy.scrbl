#lang scribble/manual

@(require (for-label racket))

@title{Proxy}

@defmodule[libgit2/include/proxy]


@defproc[(git_proxy_init_options
          [opts git_proxy_opts?]
          [version integer?])
         integer?]{
 Initialize a proxy options structure
}
