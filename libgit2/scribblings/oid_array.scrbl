#lang scribble/manual

@(require (for-label racket))

@title{Oid Array}

@defmodule[libgit2/include/oid_array]


@defproc[(git_oidarray_free
          [array oidarray?])
         void?]{
 Free the OID array

 This method must (and must only) be called on git_oidarray objects where the array is allocated by the library. Not doing so, will result in a memory leak.

 This does not free the git_oidarray itself, since the library will never allocate that object directly itself (it is more commonly embedded inside another struct or created on the stack).
}
