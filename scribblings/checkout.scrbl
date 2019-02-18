#lang scribble/manual

@(require (for-label racket))

@title{Checkout}

@defmodule[libgit2/include/checkout]


@defproc[(git_checkout_head
          [repo repository?]
          [opts (or/c git_checkout_opts? #f)])
         integer?]{
 Updates files in the index and the working tree to match the content of the commit pointed at by HEAD.

 Note that this is not the correct mechanism used to switch branches; do not change your HEAD and then call this method, that would leave you with checkout conflicts since your working directory would then appear to be dirty. Instead, checkout the target of the branch and then update HEAD using git_repository_set_head to point to the branch you checked out.

 Passing @racket[#f] for opts will use default checkout options.
}

@defproc[(git_checkout_index
          [repo repository?]
          [index index?]
          [opts (or/c git_checkout_opts? #f)])
         integer?]{
 Updates files in the working tree to match the content of the index.

 Passing @racket[#f] for opts will use default checkout options.
}

@defproc[(git_checkout_init_options
          [opts git_checkout_opts?]
          [int unsigned])
         integer?]{
 Initializes a git_checkout_options with default values. Equivalent to creating an instance with GIT_CHECKOUT_OPTIONS_INIT.

}

@defproc[(git_checkout_tree
          [repo repository?]
          [treeish object?]
          [opts (or/c git_checkout_options? #f)])
         integer?]{
 Updates files in the index and working tree to match the content of the tree pointed at by the treeish.

 Passing @racket[#f] for opts will use default checkout options.
}
