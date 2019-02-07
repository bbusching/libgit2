#lang scribble/manual

@(require (for-label racket))

@title{Strarray}

@defmodule[libgit2/include/strarray]


@defproc[(git_strarray_copy
          [tgt strarray?]
          [src strarray?])
         integer?]{
 Copy a string array object from source to target.

 Note: target is overwritten and hence should be empty, otherwise its contents are leaked. Call git_strarray_free() if necessary.

}

@defproc[(git_strarray_free
          [array strarray?])
         void?]{
 Close a string array object

 This method should be called on git_strarray objects where the strings array is allocated and contains allocated strings, such as what you would get from git_strarray_copy(). Not doing so, will result in a memory leak.

 This does not free the git_strarray itself, since the library will never allocate that object directly itself (it is more commonly embedded inside another struct or created on the stack).
}
