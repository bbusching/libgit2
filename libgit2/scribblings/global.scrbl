#lang scribble/manual

@(require (for-label racket))

@title{Global}

@defmodule[libgit2/include/global]


@defproc[(git_libgit2_init)
         integer?]{
Init the global state

This function must the called before any other libgit2 function in order to set up global state and threading.

This function may be called multiple times - it will return the number of times the initialization has been called (including this one) that have not subsequently been shutdown.

}

@defproc[(git_libgit2_shutdown)
         integer?]{
Shutdown the global state

Clean up the global state and threading context after calling it as many times as git_libgit2_init() was called - it will return the number of remainining initializations that have not been shutdown (after this one).
}
