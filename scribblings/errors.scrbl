#lang scribble/manual

@(require (for-label racket))

@title{Errors}

@defmodule[libgit2/include/errors]


@defproc[(giterr_clear)
         void?]{
Clear the last library error that occurred for this thread.

}

@defproc[(giterr_last)
         error?]{
Return the last git_error object that was generated for the current thread or NULL if no error has occurred.

}

@defproc[(giterr_set_oom)
         void?]{
Set the error message to a special value for memory allocation failure.

The normal giterr_set_str() function attempts to strdup() the string that is passed in. This is not a good idea when the error in question is a memory allocation failure. That circumstance has a special setter function that sets the error string to a known and statically allocated internal value.

}

@defproc[(giterr_set_str
          [error_class integer?]
          [message string?])
         void?]{
Set the error message string for this thread.

This function is public so that custom ODB backends and the like can relay an error message through libgit2. Most regular users of libgit2 will never need to call this function -- actually, calling it in most circumstances (for example, calling from within a callback function) will just end up having the value overwritten by libgit2 internals.

This error message is stored in thread-local storage and only applies to the particular thread that this libgit2 call is made from.
}
